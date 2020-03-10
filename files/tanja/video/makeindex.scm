(define tile-width 48)
(define tile-height 64)

(define dirs '("000927" "001003" "001004" "001008" "001010"
               "001011" "001012" "001016" "001019" "001025"
               "001103" "001108" "001121" "001122" "001123"
               "001128" "001219" "010111" "010116" "010125"
               "010207" "010208" "010209" "010214" "010218"
               "010222" "010302" "010311" "010312" "010314"
               "010315" "010421" "010423" "010429" "010505"
               "010510" "010517" "010609" "010611" "010614"
               "010617" "010620" "010621" "010623"))

(define files '("00" "01" "02" "03" "04" "05" "06" "07"
                "08" "09" "10" "11" "12" "13" "14" "15"))

(define (place-image file-name drawable dest-x dest-y)
  (let* ((orig-img (car (gimp-file-load 1 file-name file-name)))
         (orig-layer (car (gimp-image-active-drawable orig-img)))
         (orig-height (car (gimp-drawable-height orig-layer)))
         (orig-width (car (gimp-drawable-width orig-layer))))
    (gimp-image-scale orig-img tile-height tile-width)
    (gimp-rotate orig-layer FALSE (* 3.1415 1.5))
    (gimp-edit-copy orig-layer)
    (let ((floating-sel (car (gimp-edit-paste drawable FALSE))))
      (gimp-layer-set-offsets floating-sel dest-x dest-y)
      (gimp-floating-sel-anchor floating-sel))
    (gimp-image-delete orig-img)))

(define (fill-rows drawable dirs y)
  (fill-columns drawable (car dirs) files 0 y)
  (if (not (null? (cdr dirs)))
      (fill-rows drawable (cdr dirs) (+ y tile-height))))

(define (fill-columns drawable dir files x y)
  (place-image (string-append "/home/juri/home/" dir "/" (car files) ".jpg") drawable x y)
  (if (not (null? (cdr files)))
      (fill-columns drawable dir (cdr files) (+ x tile-width) y)))

(define (script-fu-make-index r)
  (let* ((width (* tile-width (length files)))
	 (height (* tile-height (length dirs)))
         (img (car (gimp-image-new width height RGB)))
         (drawable (car (gimp-layer-new img width height RGB_IMAGE "Index Layer" 100 NORMAL)))
         (old-fg (car (gimp-palette-get-foreground)))
	 (old-bg (car (gimp-palette-get-background))))
    (gimp-image-undo-disable img)
    (gimp-image-add-layer img drawable 0)
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-palette-set-background '(255 255 255))
    (gimp-edit-fill drawable)

    (fill-rows drawable dirs 0)

    (gimp-selection-none img)
    (gimp-palette-set-background old-bg)
    (gimp-palette-set-foreground old-fg)
    (gimp-image-undo-enable img)
    (gimp-display-new img)))

(script-fu-register "script-fu-make-index"
		    "<Toolbox>/Xtns/Script-Fu/My/Make Index..."
		    "Create index image"
		    "Juri Linkov"
		    "Juri Linkov"
		    "2001"
		    ""
                    SF-VALUE "Redis (in salats)" "100")
