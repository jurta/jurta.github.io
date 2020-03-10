;;; sndtr.el --- Edit transcripts of audio files in Emacs

;; Copyright (C) 2000, 2001, 2006  Juri Linkov <juri@jurta.org>

;; Author: Juri Linkov <juri@jurta.org>
;; Keywords: sound, transcription

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This package allows transcribing audio files in Emacs.  It puts the
;; transcription text files in sndtr-mode, starts the `snd' sound editing
;; program in the external process, and allows adding new transcriptions and
;; playing selected text from the transcription file using `snd' functions.
;;
;; To run the `snd' process you need `inf-snd.el', `ilisp-snd.el' or
;; a simple function:
;;
;;   (defun run-snd ()
;;     (interactive)
;;     (run-scheme "snd -notebook" "snd"))
;;
;; Also you could put in .emacs:
;;
;;   (autoload 'sndtr-mode "sndtr" "Major mode for editing Snd transcripts." t)
;;   (add-to-list 'auto-mode-alist '("\\.trs\\'" . sndtr-mode))
;;
;; Transcription text files have the following format:
;;
;;   -*- mode: sndtr; sndtr-file: "~/000721T.wav"; -*-
;;   1 19710114 19727109 5 T : Text
;;   [...]
;;
;; where `sndtr-file' is the name of the associated audio file, and fields
;; of every transcription line have the following meanings:
;;
;; 1. level
;; 2. start of the recorded region
;; 3. end of the recorded region
;; 4. quality
;; 5. actor
;; 6 (after colon). transcribed text

;;; Code:

(defgroup sndtr nil
  "Snd transcription mode."
  :group 'tools)

(defcustom sndtr-open-function "view-sound"
  "Snd open function (`open-sound' or `view-sound')."
  :group 'sndtr
  :type 'string)

(defcustom sndtr-selection-left-margin "0.2"
  "Snd selection left margin."
  :group 'sndtr
  :type 'string)

(defcustom sndtr-selection-to-window-size-ratio "3.5"
  "Snd selection to window size ratio."
  :group 'sndtr
  :type 'string)

(defcustom sndtr-default-line-format "1 %s 5 T : " ;"1 %s : "
  "Default line format of the transcription file.
The parameter %s is replaced with the start and end of the recorded region."
  :group 'sndtr
  :type 'string)

(defcustom sndtr-buffer "*snd*"
  "Snd process buffer name (e.g. *scheme* or *snd*)."
  :group 'snd
  :type 'string)

(defvar sndtr-file nil
  "Audio file name. It can be set by file variables.")

(defvar sndtr-sound-index nil
  "Snd sound index.")

(or (boundp 'scheme-mode-map)
    (require 'scheme))

(or (boundp 'comint-send-string)
    (require 'comint))

(defvar sndtr-mode-map nil
  "Local keymap for sndtr-mode buffers.")

(or sndtr-mode-map
    (let ((map (make-keymap)))
      (define-key map [(tab)]               'sndtr-play-selection-or-region)
      (define-key map [(control g)]         'sndtr-play-stop) ; while (play_in_progress?) not implemented
      (define-key map [(control z) (z) (s)] 'sndtr-save-selection-or-region)
      (define-key map [(control z) (z) (l)] 'sndtr-load-file)
      (define-key map [(control z) (z) (i)] 'sndtr-insert-pos)
      (define-key map [(control z) (z) (c)] 'sndtr-scale-selection-to)
      (setq sndtr-mode-map map)))

(defun sndtr-mode ()
  "Manage transcriptions of audio files and play them in the snd editor."
   (interactive)
   (kill-all-local-variables)
   (use-local-map sndtr-mode-map)
   (setq major-mode 'sndtr-mode)
   (setq mode-name "SndTr")
   (make-local-variable 'sndtr-file)
   (make-local-variable 'sndtr-sound-index)
   (run-hooks 'sndtr-mode-hook))

(defun sndtr-check-snd ()
  "Check if the snd process is running.
Prior to playing or saving (or otherwise processing) an audio file,
this function can be called to ensure that snd is started."
  (if (not (comint-check-proc sndtr-buffer))
      (save-excursion
        (run-snd)
        (comint-send-string
         (get-buffer-process sndtr-buffer)
         (concat
          "(begin (load \"/usr/share/snd/extensions.scm\"))\n"))
        (comint-send-string
         (get-buffer-process sndtr-buffer)
         (concat
          "(begin (load \"/usr/share/snd/fix-optargs.scm\") (load \"/usr/share/snd/extensions.scm\"))\n"))))
  (if (not (comint-check-proc sndtr-buffer))
      (error "Can't start snd process")))

(defun sndtr-check-snd-file ()
  "Check if the audio file is loaded.
Prior to playing or saving (or otherwise processing) an audio file,
this function can be called to ensure that audio file is loaded."
  (sndtr-check-snd)
  (if (not sndtr-sound-index)
      (if (y-or-n-p "Load audio file into snd process? ")
          ;; then this will ask user what file to load
          (call-interactively 'sndtr-load-file)
        ;; else assume that user loaded audio file directly from snd,
        ;; so ask user for sound index
        (setq sndtr-sound-index (read-from-minibuffer "Enter snd sound index: ")))))

(defun sndtr-load-file (filename)
  (interactive
   (let* ((default (or sndtr-file
                       (and (fboundp 'ffap-guesser) (ffap-guesser))
                       "default.wav"))
          (value (read-from-minibuffer
                  "Load snd audio from file: " default)))
     (list (if (equal value "") default value))))
  (sndtr-check-snd)
  (let* ((proc (sndtr-proc))
         (m (marker-position (process-mark proc))))
    (comint-send-string
     proc
     (concat
      "(" sndtr-open-function " \"" filename "\")\n"))
    (accept-process-output proc)
    (let ((index (save-excursion
                   (set-buffer sndtr-buffer)
                   (or (and (goto-char m)
                            (looking-at "[0-9]+")
                            (match-string 0))
                       "0"))))
      (setq sndtr-sound-index index))))

(defun sndtr-proc ()
  (sndtr-check-snd)
  (get-buffer-process sndtr-buffer))

(defun sndtr-play-selection ()
  (interactive)
;; 2006-04-26 DO NOT CHECK:
;;  (sndtr-check-snd-file)
  (save-excursion
    (beginning-of-line)
    (if (looking-at "[0-9] 0*\\([0-9]+\\) 0*\\([0-9]+\\)")
        (comint-send-string
         (sndtr-proc)
         (concat
          "(begin (make-selection " (match-string 1) " " (match-string 2) " " sndtr-sound-index ")"
          "(my-position-selection-on-left " sndtr-sound-index " " sndtr-selection-left-margin " " sndtr-selection-to-window-size-ratio ")"
          "(play-selection))\n"))
;;; 2006-04-26 TRY TO USE SOX:
;;;         (shell-command (format "play %s trim %ss %ss"
;;;                                sndtr-file (match-string 1)
;;;                                (number-to-string (- (string-to-number (match-string 2))
;;;                                                     (string-to-number (match-string 1))))))
      )))

(defun sndtr-play-stop ()
  ;; TODO: move this code to "play" functions, when (play_in_progress?)
  ;; will be available in Scheme, i.e. (if (play_in_progress?) (stop-playing) (play))
  (interactive)
  (sndtr-check-snd)
  (save-excursion
    (beginning-of-line)
    (if (looking-at "[0-9] 0*\\([0-9]+\\) 0*\\([0-9]+\\)")
        (comint-send-string
           (sndtr-proc)
           (concat
            "(stop-playing)\n")))))

(defun sndtr-insert-pos ()
  (interactive)
  (let* ((proc (sndtr-proc))
         (m (marker-position (process-mark proc)))
         (str
          (save-excursion
            (comint-send-string
             proc
             (concat
              "(format #f \"~8,48D ~8,48D\" (selection-position " sndtr-sound-index ")"
              "(+ (selection-position " sndtr-sound-index ") (selection-length " sndtr-sound-index ")))\n"))
            (accept-process-output proc)
            (set-buffer sndtr-buffer)
;;;           (buffer-substring
;;;            m
;;;            ;; (marker-position (process-mark proc))
;;;            ;; (progn (forward-line 1) (beginning-of-line) (- (point) 1))
;;;            (point-max)
;;;            )
            (or (and (goto-char m)
                     (looking-at "\"\\(.*\\)\"")
                     (match-string 1))
                "?")
            )))
    (insert (format sndtr-default-line-format str))))

(defun sndtr-scale-selection-to (scale)
  (interactive
   (list (read-from-minibuffer "Scale selection to: ")))
  (save-excursion
    (beginning-of-line)
    (if (looking-at "[0-9] 0*\\([0-9]+\\) 0*\\([0-9]+\\)")
        (comint-send-string
         (sndtr-proc)
         (concat
          "(scale-selection-to "
          scale
          ")\n")))))

(defun sndtr-save-selection (filename)
  (interactive
   (let* ((default (concat (or (and (looking-at ".* : \\(.*\\)")
                                    (match-string 1))
                            "default")
                           ".wav"))
          (value (read-from-minibuffer
                  "Save selection to file: " default)))
     (list (if (equal value "") default value))))
  (save-excursion
    (beginning-of-line)
    (if (looking-at "[0-9] 0*\\([0-9]+\\) 0*\\([0-9]+\\)")
        (let* ((selection-position (match-string 1))
               (selection-length
                (number-to-string (- (string-to-number (match-string 2))
                                     (string-to-number selection-position)))))
           (comint-send-string
            (sndtr-proc)
            (concat
             "(begin (set! (selection-position " sndtr-sound-index ") " selection-position ")"
             "(set! (selection-length " sndtr-sound-index ") " selection-length ")"
             "(my-position-selection-on-left " sndtr-sound-index " " sndtr-selection-left-margin " " sndtr-selection-to-window-size-ratio ")"
             "(save-selection \"" filename "\" mus-riff mus-ubyte 22050 ""))\n"))
;;; 2006-04-26 TRY TO USE SOX:
;;;         (shell-command (format "sox %s %s trim %ss %ss"
;;;                                sndtr-file
;;;                                (concat "~/" filename)
;;;                                selection-position
;;;                                selection-length))
        ))))

(defun sndtr-play-emacs-region (beg end)
  (interactive "r")
  (if (> beg end) (let (mid) (setq mid beg beg end end mid)))
  (save-excursion
    (save-restriction
      (let ((selections))
        (narrow-to-region beg end)
        (goto-char beg)
        (if (and (looking-at "^\\*+ \\(.*\\.wav\\)")
                 (file-exists-p (format "~/%s" (match-string 1))))
            (shell-command (format "play ~/%s" (match-string 1)))
          (while (not (eobp))
            (if (looking-at "[0-9] 0*\\([0-9]+\\) 0*\\([0-9]+\\)")
                (setq selections
                      (cons
                       (let* ((selection-position (string-to-number (match-string 1)))
                              (selection-length (- (string-to-number (match-string 2))
                                                 selection-position)))
                         (list selection-position selection-length)) selections)))
            (forward-line 1))

        (comint-send-string
         (sndtr-proc)
         (format "(my-play-emacs-region %s '%s)\n" sndtr-sound-index (nreverse selections)))

;;; 2006-04-26 TRY TO USE SOX:
;;;         (mapc
;;;          (lambda (s)
;;;            (shell-command (format "play %s trim %ss %ss"
;;;                                   sndtr-file (car s) (cadr s))))
;;;          (nreverse selections))

;;         (shell-command (concat "play " sndtr-file " "
;;                                (mapconcat
;;                                 (lambda (s)
;;                                   (format "trim %ss %ss" (car s) (cadr s)))
;;                                 selections " ")))

        )
        ))))

(defun sndtr-play-selection-or-region ()
  (interactive)
  (if (not (and transient-mark-mode mark-active))
      (if (not (looking-at "*"))
          (sndtr-play-selection)
        (sndtr-play-emacs-region
         (point)
         (save-excursion (- (search-forward "\n\n") 1))))
    (call-interactively 'sndtr-play-emacs-region)))

(defun sndtr-save-emacs-region (beg end filename)
  (interactive "r\nFSave selection to file")
  (if (> beg end) (let (mid) (setq mid beg beg end end mid)))
  (save-excursion
    (save-restriction
      (let ((selections))
        (narrow-to-region beg end)
        (goto-char beg)
        (if (and (null filename) (looking-at "^\\*+ \\(.*\\.wav\\)"))
            (setq filename (match-string 1)))
        (while (not (eobp))
          (if (looking-at "[0-9] 0*\\([0-9]+\\) 0*\\([0-9]+\\)")
              (setq selections
                    (cons
                     (let* ((selection-position (string-to-number (match-string 1)))
                            (selection-length (- (string-to-number (match-string 2))
                                                 selection-position)))
                       (list selection-position selection-length
                             (make-temp-file "snd" nil ".wav")))
                     selections)))
          (forward-line 1))

         (comint-send-string
          (sndtr-proc)
          (format "(my-save-emacs-region %s \"%s\" '%s)\n"
                  sndtr-sound-index filename (nreverse selections)))

;;; 2006-04-26 TRY TO USE SOX:
;;;         (mapc
;;;          (lambda (s)
;;;            (shell-command (format "sox %s %s trim %ss %ss"
;;;                                   sndtr-file (caddr s) (car s) (cadr s))))
;;;          selections)

;;;         (shell-command (concat "sox " (mapconcat
;;;                                        (lambda (s) (format "%s" (caddr s)))
;;;                                        (nreverse selections) " ")
;;;                                " ~/" filename))

        ))))

(defun sndtr-save-selection-or-region ()
  (interactive)
  (if (not (and transient-mark-mode mark-active))
      (if (not (looking-at "*"))
          (call-interactively 'sndtr-save-selection)
        (sndtr-save-emacs-region
         (point)
         (save-excursion (- (search-forward "\n\n") 1))
         (if (looking-at "* \\([^ \n]+\\)") (concat "\"" (match-string 1) ".wav\""))))
    (call-interactively 'sndtr-save-emacs-region)))

(defun sndtr-number-dec ()
  (interactive)
  ;; can't use save-excursion, because when two characters are replaced
  ;; then save-excursion returns point one character right
  (let ((p (point)))
    (forward-char 1)
    (if (re-search-backward "[^0][0-9]*")
        (replace-match (number-to-string (- (string-to-number (match-string 0)) 1))))
    (goto-char p)))

(defun sndtr-number-inc ()
  (interactive)
  ;; can't use save-excursion, because when two characters are replaced
  ;; then save-excursion returns point one character to the right
  (let ((p (point)))
    (forward-char 1)
    (if (re-search-backward "[^9][0-9]*")
        (replace-match (number-to-string (+ (string-to-number (match-string 0)) 1))))
    (goto-char p)))

;; BAD because additional undo points and no prefix arguments
(defmacro sndtr-set-key (key test-function call-function)
  "Assign keybindings directly to function."
  (` (define-key sndtr-mode-map (, key)
       '(lambda ()
          (interactive)
          (if (, test-function)
              (, call-function)
            (call-interactively
             (or
              (lookup-key sndtr-mode-map (this-command-keys))
              (lookup-key scheme-mode-map (this-command-keys))
              (lookup-key global-map (this-command-keys)))))))))
(sndtr-set-key [(meta down)] (looking-at "[0-9]") (sndtr-number-dec))
(sndtr-set-key [(meta up)] (looking-at "[0-9]") (sndtr-number-inc))

;;; BAD: (sndtr-set-key " " (or (bolp) (looking-at "[0-9]")) (sndtr-play-selection))
;;; BAD: (sndtr-set-key "i" (bolp) (sndtr-insert-pos))
;;; BAD: (sndtr-set-key "i" (bolp) (progn (sndtr-insert-pos) (sndtr-play-selection)))
;;; BAD: (sndtr-set-key "s" (bolp) (call-interactively 'sndtr-save-selection))
;;; BAD: (sndtr-set-key "c" (bolp) (call-interactively 'sndtr-scale-selection-to))

;;; (define-key sndtr-mode-map "\C-cr" 'sndtr-play-selection) ;; old
;;; (define-key sndtr-mode-map "\C-ci" 'sndtr-insert-pos) ;; old

;;; (if (looking-at "1 \\([0-9]+\\) \\([0-9]+\\)")
;;;     (message (format "%s %s" (match-string 1) (match-string 2))))

;;; (define-key sndtr-mode-map
;;;   " "
;;;   '(lambda ()
;;;      (interactive)
;;;      (if (bolp)
;;;        (sndtr-play-selection)
;;;        ;; (insert " ")
;;;        (call-interactively (or
;;;                           (lookup-key scheme-mode-map (this-command-keys))
;;;                           (lookup-key global-map (this-command-keys))))
;;;        ;; (message (format "[%s]" (lookup-key global-map (this-command-keys))))
;;;        ;; (message (format "[%s]" (this-command-keys)))
;;;        )))
;;; (define-key sndtr-mode-map "i" '(lambda ()
;;;                               (interactive)
;;;                               (if (bolp)
;;;                                   (sndtr-insert-pos)
;;;                                 (insert "i"))))

;;; (global-set-key "\C-ci" 'sndtr-insert-pos)
;;; (global-set-key "\C-cr" 'sndtr-play-selection)

(provide 'sndtr)
;;; sndtr.el ends here
