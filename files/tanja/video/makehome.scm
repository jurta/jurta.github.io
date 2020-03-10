;; MyLife.avi

;; to convert exported paths to list for free-select use next script
;; perl -ne '/^TYPE: 1 X: (\d+) Y: (\d+)/&&(print "$1 $2 ")' path00110303

(define input-dir-name "/home/juri/home")

(define create-base-layer
  '((read
     ;; (open-file "00110303.jpg")
     ;; ;; (rect 180 100 300 400)
     ;; (free-select (185 100 185 480 485 480 485 100)) ; path00110303
     (open-file "00110304.jpg")
     (free-select (196 129 196 480 496 480 496 129 )) ; path001103041
     )
    (write
     (new-layer "Background")
     (rotate 270)
     (place 0 0)
     (anchor))
    (read
     (open-file "01070204.jpg")
     (free-select (566 373 569 406 540 406 538 373 ))) ; path010702042
    (write
     (new-layer "Our Room")
     (rotate 270)
     (rotate 0.5)
     (place 53 14)
     (anchor))
    (read
     (open-file "01070204.jpg")
     (free-select (567 419 568 454 541 452 540 419 ))) ; path010702043
    (write
     (new-layer "Big Room")
     (rotate 270)
     (rotate -1)
     (place 99 15)
     (anchor))
    (read
     (open-file "00092715.jpg")
     (free-select (509 283 506 311 533 315 537 286 ))) ; path000927151
    (write
     (new-layer "Kitchen")
     (rotate 270)
     (rotate -8)
     (place 156 11)
     (anchor))
    (read
     (open-file "00110304.jpg")
     (free-select (430 151 431 167 410 167 410 152 ))) ; path001103042
    (write
     (new-layer "Neighbour Window 1 1")
     (rotate 270)
     (brightness-contrast 45 0)
     (place 21 65)
     (anchor))
    (read
     (open-file "00092711.jpg")
     (free-select (433 179 461 185 454 221 425 215 ))) ; path00092711
    (write
     (new-layer "Neighbour Window 1 2")
     (rotate 270)
     (rotate -12)
     (brightness-contrast 45 0)
     (place 44 55)
     (anchor))
    (read
     (open-file "00112809.jpg")
     (free-select (452 160 453 189 428 189 428 161 ))) ; path001128093
    (write
     (new-layer "Neighbour Window 2 1")
     (rotate 270)
     (rotate -1)
     (brightness-contrast 45 0)
     (place 9 18)
     (anchor))
    (read
     (open-file "00101607.jpg")
     (free-select (261 191 252 291 294 295 299 195 ))) ; path0010160701
    (write
     (new-layer "Basement")
     (rotate 270)
     (rotate -2)
     (place -5 97)
     (brightness-contrast 15 0)
     (anchor))
    (read
     (open-file "00110302.jpg")
     (free-select
      (155 407 155 476 492 477 492 420 )) ; path001103021
     ;; (open-file "00110306.jpg")
     ;; (free-select (136 412 130 480 442 480 442 439 )) ; path00110306
     )
    (write
     (new-layer "Other Neighbours")
     (rotate 270)
     ;; (rotate 1)
     (brightness-contrast -22 0)
     (place 337 -7)
     (anchor))
    (read
     (open-file "01061415.jpg")
     (free-select (580 160 576 256 607 259 609 241 638 241 636 193 621 193 621 160 ))) ; path01061415
    (write
     (new-layer "Porch")
     (rotate 270)
     (rotate 1) (rotate -1) ;; smooth
     (brightness-contrast -88 0)
     (color-balance 1 0 -3 0 0)
     (place 100 84)
     (anchor))
    (read
     (open-file "00110315.jpg")
     (free-select (114 345 189 351 192 337 169 336 169 320 118 315 ))) ; path00110315
    (write
     (new-layer "Porch 2")
     (rotate 270)
     (rotate -3)
     (brightness-contrast 12 0)
     (color-balance 1 1 0 0 -12)
     (place 264 78)
     (anchor))
    (read
     (open-file "00110308.jpg")
     (free-select
      (237 415 237 432 280 441 283 419 )
      ;; bad: (237 415 238 431 280 441 283 419 )
      ;; backup: (280 441 283 419 237 415 237 432 )
      )) ; path0011030801
    (write
     (new-layer "Basement 2")
     (rotate 270)
     (rotate -3)
     (place 295 103)
     (anchor))
    (read
     (open-file "00110308.jpg")
     (free-select
      (224 475 279 478 280 450 254 446 227 441 ))) ; path0011030801
    (write
     (new-layer "Basement 3")
     (rotate 270)
     (rotate -3)
     (brightness-contrast 16 0)
     (place 319 104)
     (anchor))
    (read
     (open-file "00101607.jpg")
     (free-select
      (257 203 248 293 265 294 269 235 274 234 277 206 ))) ; path0010160702
    (write
     (new-layer "Road 1")
     (rotate 270)
     (rotate -3)
     (place 98 121) ; 86
     ;; (brightness-contrast 15 0)
     (anchor))
    (read
     (open-file "00101607.jpg")
     (free-select
      (258 205 251 292 265 294 272 208 ))) ; path0010160703
    (write
     (new-layer "Road 2")
     (rotate 270)
     (rotate -3)
     (place 185 128)
     ;; (brightness-contrast 15 0)
     (anchor))
    (read
     (open-file "00101607.jpg")
     (free-select
      (258 205 251 292 265 294 272 208 ))) ; path0010160703
    (write
     (new-layer "Road 3")
     (rotate 270)
     (rotate -3)
     (place 225 129)
     ;; (brightness-contrast 15 0)
     (anchor))
    (read
     (open-file "00101607.jpg")
     (free-select
      (258 205 251 292 265 294 272 208 ))) ; path0010160703
    (write
     (new-layer "Road 4")
     (rotate 270)
     (rotate -3)
     (place 322 132)
     ;; (brightness-contrast 15 0)
     (anchor))
    (read
     (open-file "00092715.jpg")
     (free-select
      (356 4 236 472 279 472 388 12 ))) ; path000927152
    (write
     (new-layer "Border")
     (rotate 270)
     (rotate -9)
     (scale 410 200)
     (place -5 131)
     (anchor))
    (read
     (open-file "00092715.jpg")
     (free-select
      (60 61 60 458 101 470 137 61 )
      ;; (356 4 236 472 279 472 388 12 )
      )) ; path000927153
    (write
     (new-layer "Asphalt")
     (rotate 270)
     (brightness-contrast -29 0)
     (place 0 225)
     (anchor))
    ;; next skin for default skin is from create-layers
;     (read
;      (open-file "00092715.jpg")
;      (free-select
;       (452 30 367 478 282 463 388 19 )
;       ;; (356 4 236 472 279 472 388 12 )
;       )) ; path000927154
;     (write
;      (new-layer "000927")
;      (rotate 270)
;      (rotate -9)
;      (scale 420 210)
;      (place -7 77)
;      (anchor))
;     (merge-all-layers) ;; save as base.jpg
    ))

(define create-base-layer-2
  '(
    (read (open-file "base.jpg") (select-all))
    (write (new-layer "Background") (place 0 0) (anchor))
    (read
     (open-file "01070204.jpg")
     (free-select
      (487 61 449 474 370 472 422 57 )
      )) ; path010702041
    (write
     (new-layer "010702")
     (rotate 270)
     (rotate -2.5)
     ; (scale% 1.1 1.1)
     ; (brightness-contrast -25 0)
     (place -5 112)
     (anchor)
     ;; read and paste first green tree on the same layer (BAD!!!)
     (read
      (open-file "01062308.jpg")
      (free-select
       (506 259 517 262 537 275 548 272 554 262 555 216 491 214 483 225 )
       )) ;; path010623081
     (paste)
     (rotate 270)
     (brightness-contrast 25 0)
     (place -5 -3)
     (anchor)
     ;; read and paste first part of second green tree on the same layer
     (read
      (open-file "01062111.jpg")
      (free-select
       (385 345 423 348 424 367 434 378 450 387 449 445 344 444 344 427 318 425 314 375 347 377 347 358 323 332 323 326 347 332 363 336 )
       )) ;; path010621111
     (paste)
     (rotate 270)
     (rotate -3)
     (brightness-contrast -69 0)
     (place 177 -27)
     (anchor)
     ;; read and paste second part of second green tree on the same layer (BAD!!!)
     (read
      (open-file "01062306.jpg")
      (free-select
       (453 124 453 135 464 138 471 150 471 151 480 157 472 178 488 187 503 220 559 209 561 79 463 81 460 94 464 105 458 112 )
       )) ;; path01062306bad
     (paste)
     (rotate 270)
     (rotate 3) (rotate -3) ;; smooth
     (brightness-contrast -69 0)
     (place 291 -6)
     (anchor))
    (merge-all-layers) ;; save as base2.jpg
    ))

(define create-layers-0
  '(
    (read (open-file "base2.jpg") (select-all))
    (write (new-layer "Background") (place 0 0) (anchor))
    (write
     (new-layer "010702_1")
     (place 0 0)
     (anchor))
    (write
     (new-layer "010702_2")
     (place 0 0)
     (anchor))
    ))
(define create-layers-1
  '(
    (read (open-file "base.jpg") (select-all))
    (write (new-layer "Background") (place 0 0) (anchor))
    (read (open-file "base2.jpg") (select-all))
    (write
     (new-layer "010702")
     (place 0 0)
     (anchor))
    (read
     (open-file "00092715.jpg")
     (free-select
      (452 30 367 478 282 463 388 19 )
      ;; (356 4 236 472 279 472 388 12 )
      )) ; path000927154
    (write
     (new-layer "000927")
     (rotate 270)
     (rotate -9)
     (scale 420 210)
     (place -7 77)
     (anchor)
     ;; read and paste first part of tree on the same layer
     (read
      (open-file "00092715.jpg")
      (free-select
       (481 312 505 321 515 342 551 362 569 376 560 477 467 458 471 443 448 437 445 411 455 413 459 366 468 312 )
       )) ;; path000927155
     (paste)
     (rotate 270)
     (rotate -8)
     (brightness-contrast -25 0)
     (place 182 -43)
     (anchor)
     ;; read and paste second part of tree on the same layer
     (read
      (open-file "00092709.jpg")
      (free-select
       (506 354 484 453 367 426 390 333 361 326 363 318 388 325 )
       )) ;; path000927091
     (paste)
     (rotate 270)
     (rotate -10)
     (brightness-contrast -45 0)
     (place 292 -31)
     (anchor))
    (read
     (open-file "00101012.jpg")
     (free-select
      (363 119 298 114 289 293 317 294 341 305 364 304 )
      ;; (363 119 298 114 289 293 364 304 )
      )) ; path001010123
    (write
     (new-layer "001010")
     (rotate 270)
     (rotate 2)
     (brightness-contrast -44 0)
     (place 223 145)
     (anchor)
     (paste)
     (rotate 270)
     (rotate 2)
     (brightness-contrast -44 0)
     (place 153 141)
     (anchor)
     (paste)
     (rotate 270)
     (rotate 2)
     (scale 179 72)
     (brightness-contrast -44 0)
     (place -10 136)
     (anchor)
     ;; read and paste road on the same layer
     (read
      (open-file "00101012.jpg")
      (free-select
       (236 138 204 379 128 419 136 153 167 23 226 30 202 123 )
       )) ;; path001010124
     (paste)
     (rotate 270)
     (rotate -2.5)
     (brightness-contrast -69 0)
     (place 45 225)
     (anchor)
     (paste)
     (rotate 270)
     (rotate -2.5)
     (place -155 208)
     (anchor))
    (read
     (open-file "00101207.jpg")
     (free-select
      (269 152 263 304 198 295 210 136 240 137 260 145 )
      ;; (269 147 263 304 198 295 210 136 )
      )) ; path00101207
    (write
     (new-layer "001012")
     (rotate 270)
     (brightness-contrast -77 0)
     (place -20 137)
     (anchor)
     (paste)
     (rotate 270)
     (scale% 1.1 1.1)
     (brightness-contrast -77 0)
     (place 128 143)
     (anchor)
     (paste)
     (rotate 270)
     (scale% 1.2 1.2)
     (brightness-contrast -77 0)
     (place 297 149)
     (anchor)
     ;; read and paste part of road on the same layer
     (read
      (open-file "00101012.jpg")
      (free-select
       (236 138 204 379 128 419 136 153 167 23 226 30 202 123 )
       )) ;; path001010125
     (paste)
     (rotate 270)
     (rotate -2.5)
     (brightness-contrast -69 0)
     (place 45 225)
     (anchor)
     (paste)
     (rotate 270)
     (rotate -2.5)
     (place -155 208)
     (anchor)
     ;; read and paste more road on the same layer
     (read
      (open-file "00101012.jpg")
      (free-select
       (261 143 265 153 261 160 257 168 262 194 256 206 262 221 251 229 255 239 253 250 246 262 252 271 254 284 250 296 248 305 254 314 252 326 246 334 244 342 243 350 247 358 244 368 241 381 246 388 242 405 239 415 220 416 205 414 234 140 )
       )) ;; path001010127
     (paste)
     (rotate 270)
     (rotate 1) (rotate -1) ;; smooth
     (brightness-contrast -69 0)
     (place 165 228)
     (anchor)
     (paste)
     (rotate 270)
     (rotate 1) (rotate -1) ;; smooth
     (place -29 212)
     (anchor))
    (read
     (open-file "00102505.jpg")
     (free-select
      (162 112 129 452 195 455 220 119 202 123 181 121 )
      ;; (162 112 129 452 195 455 220 119 )
      ;; (214 149 198 446 129 433 157 140 )
      )) ; path00102505
    (write
     (new-layer "001025")
     (rotate 270)
     (rotate -1)
     (scale% 1.05 1.05)
     (brightness-contrast -33 0)
     (place -20 127)
     (anchor)
     (paste)
     (rotate 270)
     (rotate -1)
     (scale% 1.15 1.15)
     (brightness-contrast -33 0)
     (place 147 134)
     (anchor)
     ;; read and paste part of road on the same layer
     (read
      (open-file "00101012.jpg")
      (free-select
       (236 138 204 379 128 419 136 153 167 23 226 30 202 123 )
       )) ;; path001010125
     (paste)
     (rotate 270)
     (rotate -2.5)
     (brightness-contrast -69 0)
     (place 45 225)
     (anchor)
     (paste)
     (rotate 270)
     (rotate -2.5)
     (place -155 208)
     (anchor)
     ;; read and paste more road on the same layer
     (read
      (open-file "00101012.jpg")
      (free-select
       (261 143 265 153 266 164 264 178 262 194 262 206 262 221 272 233 272 244 270 251 282 258 277 268 282 277 279 285 279 295 273 304 267 314 269 326 264 332 266 343 267 352 267 367 265 395 265 415 254 419 241 409 220 416 205 414 234 140 )
       )) ;; path001010128
     (paste)
     (rotate 270)
     (rotate 1) (rotate -1) ;; smooth
     (brightness-contrast -69 0)
     (place 165 211)
     (anchor)
     (paste)
     (rotate 270)
     (rotate 1) (rotate -1) ;; smooth
     (place -29 195)
     (anchor))
    (read
     (open-file "00110302.jpg")
     (free-select
      (344 127 337 378 268 365 288 122 )
      )) ; path001103022
    (write
     (new-layer "001103")
     (rotate 270)
     (place -20 139)
     (anchor)
     (paste)
     (rotate 270)
     (scale% 1.1 1.1)
     (place 147 146)
     (anchor)
     ;; read and paste road on the same layer
     (read
      (open-file "00110302.jpg")
      (free-select
       (289 56 260 460 162 461 153 50 )
       )) ;; path001103023
     (paste)
     (rotate 270)
     (rotate 0.33)
     (place -11 195)
     (anchor))
    ))
(define create-layers-2
  '(
    (read (open-file "base.jpg") (select-all))
    (write (new-layer "Background") (place 0 0) (anchor))
    (read
     (open-file "00110302.jpg")
     (free-select
      (344 127 337 378 268 365 288 122 )
      )) ; path001103022
    (write
     (new-layer "001103")
     (rotate 270)
     (place -20 139)
     (anchor)
     (paste)
     (rotate 270)
     (scale% 1.1 1.1)
     (place 147 146)
     (anchor)
     ;; read and paste road on the same layer
     (read
      (open-file "00110302.jpg")
      (free-select
       (289 56 260 460 162 461 153 50 )
       )) ;; path001103023
     (paste)
     (rotate 270)
     (rotate 0.33)
     (place -11 195)
     (anchor))
    (read
     (open-file "00112104.jpg")
     (free-select
      (147 114 148 348 173 344 195 353 223 342 256 349 290 343 324 349 313 230 311 120 282 115 254 117 216 123 189 111 172 124 )
      ;; (255 132 259 300 322 306 310 136 )
      )) ; path001121043
    (write
     (new-layer "001121")
     (rotate 270)
     (rotate 6)
     (place -17 123)
     (anchor)
     (paste)
     (rotate 270)
     (rotate 6)
     (brightness-contrast -45 0)
     (place 199 131)
     (anchor)
     (paste)
     (rotate 270)
     (rotate 6)
     (brightness-contrast -25 0)
     (place 186 139)
     (anchor))
    (read
     (open-file "00112215.jpg")
     (free-select
      (321 176 287 471 117 451 171 101 204 119 220 141 249 147 265 154 290 160 309 165 318 170 )
      ;; (321 176 287 471 216 458 268 154 )
      )) ; path001122152
    (write
     (new-layer "001122")
     (rotate 270)
     (rotate -5)
     (place -70 114)
     (anchor)
     (paste)
     (rotate 270)
     (rotate -5)
;      (scale% 1.2 1.2) (place 147 112)
     (brightness-contrast -45 0)
     (place 97 124)
     (anchor))
    (read
     (open-file "00112809.jpg")
     (free-select
      (323 471 178 466 193 49 335 49 )
      ;; (323 471 253 466 289 45 335 49 )
      )) ; path001128092
    (write
     (new-layer "001128")
     (rotate 270)
     (scale% 1.2 1.2)
     (place 0 138)
     (anchor))
    (read
     (open-file "00121905.jpg")
     (free-select
      (307 6 289 402 269 396 255 402 231 406 126 410 132 4 263 10 282 6 295 14 )
      ;; (307 6 289 402 269 396 255 402 231 406 209 410 246 4 263 10 282 6 295 14 )
      )) ; path001219052
    (write
     (new-layer "001219")
     (rotate 270)
     (rotate -1)
     (scale% 1.1 1.1)
     (brightness-contrast -45 0)
     (place 171 136)
     (anchor)
     (paste)
     (rotate 270)
     (rotate -1)
     (place -17 128)
     (anchor))
    (read
     (open-file "01011101.jpg")
     (free-select
      (243 47 220 480 410 480 427 72 )
      )) ; path010111012
    (write
     (new-layer "010111")
     (rotate 270)
     (rotate -1)
     (place -35 121) ;; (place -23 121)
     (anchor))
    ))
(define create-layers-3
  '(
    (read (open-file "base.jpg") (select-all))
    (write (new-layer "Background") (place 0 0) (anchor))
    (read
     (open-file "01011101.jpg")
     (free-select
      (243 47 220 480 410 480 427 72 )
      )) ; path010111012
    (write
     (new-layer "010111")
     (rotate 270)
     (rotate -1)
     (place -35 121) ;; (place -23 121)
     (anchor))
    (read
     (open-file "01011605.jpg")
     (free-select
      (261 89 247 415 306 392 331 395 395 420 407 416 422 414 447 420 452 100 )
      ;; (399 94 380 410 395 420 407 416 422 414 447 420 452 100 )
      ;; (399 94 378 408 395 421 408 415 428 414 448 419 452 100 412 379 )
      ;; (449 420 452 100 399 94 378 408 )
      )) ; path010116052
    (write
     (new-layer "010116")
     (rotate 270)
     (rotate 1)
     (scale% 1.2 1.2)
     (brightness-contrast -77 0)
     (place 125 138)
     (anchor)
     (paste)
     (rotate 270)
     (rotate 1)
     (scale% 1.1 1.1)
     (brightness-contrast -45 0)
     (place -14 132)
     (anchor))
    (read
     (open-file "01012508.jpg")
     (free-select
      (287 172 265 461 235 466 208 450 63 446 84 140 244 172 268 167 )
      ;; (287 172 265 461 235 466 208 450 179 455 220 164 244 172 268 167 )
      ;; (287 172 265 461 179 455 220 164 )
      )) ; path010125082
    (write
     (new-layer "010125")
     (rotate 270)
     (rotate -3)
     (scale% 0.9 0.9)
     (place -35 119)
     (anchor)
     (paste)
     (rotate 270)
     (rotate -3)
     (brightness-contrast -25 0)
     (place 92 121)
     (anchor))
    (read
     (open-file "01020704.jpg")
     (free-select
      (463 105 458 478 293 478 316 97 )
      )) ; path010207041
    (write
     (new-layer "010207")
     (rotate 270)
     ; (rotate -3)
     (scale% 1.2 1.2)
     (brightness-contrast 77 0)
     (place -11 131)
     (anchor))
    (read
     (open-file "01020804.jpg")
     (free-select
      (483 88 486 424 316 429 339 83 )
      )) ; path010208041
    (write
     (new-layer "010208")
     (rotate 270)
     (rotate 3)
     (scale% 1.2 1.2)
     (place -19 127)
     (anchor)
     (paste)
     (rotate 270)
     (rotate 3)
     (scale% 1.2 1.2)
     (place -19 146)
     (anchor))
    (read
     (open-file "01020911.jpg")
     (free-select
      (295 382 128 379 170 6 317 15 )
      )) ; path010209111
    (write
     (new-layer "010209")
     (rotate 270)
     (rotate -1)
     (scale% 1.15 1.1)
     (brightness-contrast 33 0)
     (place -35 127)
     (anchor))
    ))
(define create-layers-4
  '(
    (read (open-file "base.jpg") (select-all))
    (write (new-layer "Background") (place 0 0) (anchor))
    (read
     (open-file "01020911.jpg")
     (free-select
      (295 382 128 379 170 6 317 15 )
      )) ; path010209111
    (write
     (new-layer "010209")
     (rotate 270)
     (rotate -1)
     (scale% 1.15 1.1)
     (brightness-contrast 33 0)
     (place -35 127)
     (anchor))
    (read
     (open-file "01021400.jpg")
     (free-select
      (576 6 536 425 338 406 414 5 )
      )) ; path010214001
    (write
     (new-layer "010214")
     (rotate 270)
     (rotate -3)
     (place -12 114)
     (anchor))
    (read
     (open-file "01021805.jpg")
     (free-select
      (483 36 500 393 332 406 312 21 )
      ;; (483 36 500 393 332 398 347 31 )
      )) ; path010218051
    (write
     (new-layer "010218")
     (rotate 270)
     (rotate 4)
     (scale% 1.15 1)
     (place -47 122)
     (anchor))
    (read
     (open-file "01022207.jpg")
     (free-select
      (258 17 216 465 37 465 64 9 )
      )) ; path010222071
    (write
     (new-layer "010222")
     (rotate 270)
     (rotate -4)
     (place -32 102)
     (anchor))
    (read
     (open-file "01030215.jpg")
     (free-select
      (356 24 359 467 125 460 164 19 )
      )) ; path010302151
    (write
     (new-layer "010302")
     (rotate 270)
     (rotate 2)
     (place -22 127)
     (anchor))
    (read
     (open-file "01031115.jpg")
     (free-select
      (499 150 487 468 209 467 259 127 )
      )) ; path010311151
    (write
     (new-layer "010311")
     (rotate 270)
     (scale% 1.25 1)
     (place -27 135)
     (anchor))
    ))
(define create-layers-5
  '(
    (read (open-file "base.jpg") (select-all))
    (write (new-layer "Background") (place 0 0) (anchor))
    (read
     (open-file "01031115.jpg")
     (free-select
      (499 150 487 468 209 467 259 127 )
      )) ; path010311151
    (write
     (new-layer "010311")
     (rotate 270)
     (scale% 1.25 1)
     (place -27 135)
     (anchor))
    (read
     (open-file "01031215.jpg")
     (free-select
      (406 37 391 445 192 441 224 31 )
      ;; (409 37 391 445 192 441 224 31 )
      )) ; path010312151
    (write
     (new-layer "010312")
     (rotate 270)
     (place -7 134)
     (anchor))
    (read
     (open-file "01042106.jpg")
     (free-select
      (447 80 420 479 225 476 283 53 )
      ;; (326 38 331 454 134 453 163 38 )
      )) ; path010421061
    (write
     (new-layer "010421")
     (rotate 270)
     (rotate -1)
     (brightness-contrast 45 0)
     (place -23 129)
     (anchor))
    (read
     (open-file "01031408.jpg")
     (free-select
      (499 39 486 466 251 460 291 30 )
      )) ; path010314081
    (write
     (new-layer "010314")
     (rotate 270)
     (scale% 1.05 1) ;; for right proportion between tree and mirror in water
     (color-balance 1 1 -7 0 0)
     (brightness-contrast -59 0)
     (place -38 134)
     (anchor))
    (read
     (open-file "01031504.jpg")
     (free-select
      (326 38 331 454 132 461 163 38 )
      ;; (326 38 331 454 134 453 163 38 )
      )) ; path010315041
    (write
     (new-layer "010315")
     (rotate 270)
     (rotate 2)
     (place -23 129)
     (anchor))
    (read
     (open-file "01042315.jpg")
     (free-select
      (512 133 551 462 483 461 461 132 )
      ;; (512 133 554 462 483 461 461 132 )
      )) ; path010423151
    (write
     (new-layer "010423")
     (rotate 270)
     (rotate 9)
     (scale% 1.1 1.1)
     (place 37 98)
     (anchor)
     (paste)
     (rotate 270)
     (rotate 9)
     (scale% 1.1 1.1)
     (place -11 96)
     (anchor))
    ))
(define create-layers-6
  '(
    (read (open-file "base.jpg") (select-all))
    (write (new-layer "Background") (place 0 0) (anchor))
    (read
     (open-file "01042315.jpg")
     (free-select
      (512 133 551 462 483 461 461 132 )
      ;; (512 133 554 462 483 461 461 132 )
      )) ; path010423151
    (write
     (new-layer "010423")
     (rotate 270)
     (rotate 9)
     (scale% 1.1 1.1)
     (place 37 98)
     (anchor)
     (paste)
     (rotate 270)
     (rotate 9)
     (scale% 1.1 1.1)
     (place -11 96)
     (anchor))
    (read
     (open-file "01042915.jpg")
     (free-select
      (497 52 502 445 483 446 450 440 425 445 441 51 )
      ;; (497 52 502 445 425 445 441 51 )
      )) ; path010429151
    (write
     (new-layer "010429")
     (rotate 270)
     (rotate 2.5)
     (place 37 137)
     (anchor)
     (paste)
     (rotate 270)
     (rotate 2.5)
     (place -12 134)
     (anchor))
    (read
     (open-file "01050515.jpg")
     (free-select
      (577 59 566 463 486 455 513 53 )
      )) ; path010505151
    (write
     (new-layer "010505")
     (rotate 270)
     (rotate 1)
     (brightness-contrast 45 0)
     (place 37 135)
     (anchor)
     (paste)
     (rotate 270)
     (rotate 1)
     (brightness-contrast 45 0)
     (place -7 132)
     (anchor))
    (read
     (open-file "01051007.jpg")
     (free-select
      (632 18 627 457 543 451 569 16 )
      )) ; path010510071
    (write
     (new-layer "010510")
     (rotate 270)
     (rotate 1.5)
     (brightness-contrast 25 0)
     (place -7 132)
     (anchor)
     ;; read and paste bushes on the same layer
     (read
      (open-file "01051007.jpg")
      (free-select
       (619 206 619 273 560 279 561 208 )
       )) ;; path010510072
     (paste)
     (rotate 270)
     (flip 0)
     (scale% 0.8 0.8)
     (brightness-contrast 25 0)
     (place 195 155)
     (anchor))
    (read (open-file "base2.jpg") (select-all)) ; background from base2.jpg
    (write
     (new-layer "010609")
     (place 0 0)
     (anchor)
     ;; and paste it's skin to this background
     (read
      (open-file "01060915.jpg")
      (free-select
       (269 3 277 365 201 368 208 5 )
       )) ; path010609151
     (paste)
     (rotate 270)
     (rotate 3.5)
     (scale% 1.1 1.1)
     (brightness-contrast -25 0)
     (place -7 121)
     (anchor))
    ))
(define create-layers-7
  '(
    (read (open-file "base2.jpg") (select-all))
    (write (new-layer "Background") (place 0 0) (anchor))
    (read
     (open-file "01060915.jpg")
     (free-select
      (269 3 277 365 201 368 208 5 )
      )) ; path010609151
    (write
     (new-layer "010609")
     (rotate 270)
     (rotate 3.5)
     (scale% 1.1 1.1)
     (brightness-contrast -25 0)
     (place -7 121)
     (anchor))
    (read
     (open-file "01070204.jpg")
     (free-select
      (487 61 449 474 370 472 422 57 )
      )) ; path010702041
    (write
     (new-layer "010702")
     (rotate 270)
     (rotate -2.5)
     ; (scale% 1.1 1.1)
     ; (brightness-contrast -25 0)
     (place -5 112)
     (anchor))
    ))

(define (process image actions)
  (if actions
      (let* ((section (car actions)))
        (cond
         ((eq? (car section) 'read)
          (let* ((orig-img) (orig-layer))
            (for-each
             (lambda (action)
               (cond ((eq? (car action) 'open-file)
                      (let* ((file-name (string-append input-dir-name "/" (nth 1 action))))
                        (set! orig-img (car (gimp-file-load 1 file-name file-name)))
                        (set! orig-layer (car (gimp-image-active-drawable orig-img)))))
                     ((eq? (car action) 'free-select)
                      (gimp-free-select orig-img
                                        (length (nth 1 action))
                                        (list->double-array
                                         (nth 1 action))
                                        REPLACE
                                        0
                                        0
                                        0.0))
                     ((eq? (car action) 'select-all)
                      (gimp-selection-all orig-img))))
             (cdr section))
            (let* ((floating-sel (car (gimp-selection-float orig-layer 0 0))))
              (gimp-edit-copy floating-sel))
            ;; (gimp-display-new orig-img)
            (gimp-image-delete orig-img)
            ))
         ((eq? (car section) 'write)
          (let* ((new-layer) (floating-sel))
            (for-each
             (lambda (action)
               (cond ((eq? (car action) 'new-layer)
                      (set! new-layer (car (gimp-layer-new
                                            image
                                            400 ; (car (gimp-drawable-height image))
                                            300 ; (car (gimp-image-width image))
                                            RGBA_IMAGE
                                            (nth 1 action)
                                            100
                                            NORMAL)))
                      (set! floating-sel (car (gimp-edit-paste new-layer FALSE)))
                      (gimp-image-add-layer image new-layer -1)
                      (gimp-selection-none image)
                      (gimp-edit-clear new-layer))
                     ((eq? (car action) 'read) ; write can contain sub-reads
                      (process image (list action)))
                     ((eq? (car action) 'paste)
                      (set! floating-sel (car (gimp-edit-paste new-layer FALSE))))
                     ((eq? (car action) 'rotate)
                      (cond
                       ((eq? (nth 1 action) 90)
                        (plug-in-rotate 1 image floating-sel 1 FALSE))
                       ((eq? (nth 1 action) 180)
                        (plug-in-rotate 1 image floating-sel 2 FALSE))
                       ((eq? (nth 1 action) 270)
                        (plug-in-rotate 1 image floating-sel 3 FALSE))
                       ('else (gimp-rotate floating-sel TRUE (* (/ (nth 1 action) 360) 2 *pi*)))))
                     ((eq? (car action) 'scale)
                      (gimp-scale floating-sel 1 0 0 (nth 1 action) (nth 2 action)))
                     ((eq? (car action) 'scale%)
                      (gimp-scale floating-sel 1 0 0
                                  (* (car (gimp-drawable-width floating-sel)) (nth 1 action))
                                  (* (car (gimp-drawable-height floating-sel)) (nth 2 action))))
                     ((eq? (car action) 'flip)
                      (gimp-flip floating-sel (nth 1 action)))
                     ((eq? (car action) 'brightness-contrast)
                      (gimp-brightness-contrast floating-sel (nth 1 action) (nth 2 action)))
                     ((eq? (car action) 'color-balance)
                      (gimp-color-balance floating-sel (nth 1 action) (nth 2 action) (nth 3 action) (nth 4 action) (nth 5 action)))
                     ((eq? (car action) 'place)
                      (gimp-layer-set-offsets floating-sel (nth 1 action) (nth 2 action)))
                     ((eq? (car action) 'anchor)
                      (gimp-floating-sel-anchor floating-sel))))
             (cdr section))))
         ((eq? (car section) 'merge-all-layers)
          (gimp-image-merge-visible-layers image 0)))
        (process image (cdr actions)))))

(define (list->double-array list)
  (let* ((how-many (length list))
	 (a (cons-array how-many 'double))
	 (count 0))
    (for-each (lambda (e)
		(aset a count e)
		(set! count (+ count 1)))
	      list)
    a))

(define (merge-layers-with-background image)
  (let* ((layers (gimp-image-get-layers image))
         (num-layers (car layers))
	 (layer-array (cadr layers))
         (background-layer (aref layer-array (- num-layers 1)))
         (layer-count 1))
    (while (< layer-count num-layers)
           (let* ((layer (aref layer-array (- layer-count 1)))
                  (name (car (gimp-layer-get-name layer)))
                  (copy (car (gimp-layer-copy background-layer TRUE))))
             (gimp-image-add-layer image copy layer-count)
             (gimp-layer-set-visible copy TRUE)
             (gimp-layer-set-name
              (car (gimp-image-merge-down image layer EXPAND-AS-NECESSARY))
              name)
             (set! layer-count (+ layer-count 1))))
    (gimp-image-remove-layer image background-layer)))

(define (merge-layers-smooth image)
  (let* ((layers (gimp-image-get-layers image))
         (num-layers (car layers))
	 (layer-array (cadr layers))
         (layer-count (- num-layers 1)))
    (while
     (>= layer-count 1)
     (let* ((curr-layer (aref layer-array (- layer-count 1)))
            (next-layer (aref layer-array layer-count))
            (curr-name (car (gimp-layer-get-name curr-layer)))
            (next-name (car (gimp-layer-get-name next-layer)))
            (opacity 10))
       (while
        (< opacity 100)
        (let* ((curr-copy (car (gimp-layer-copy curr-layer TRUE)))
               (next-copy (car (gimp-layer-copy next-layer TRUE))))
          (gimp-image-add-layer image next-copy layer-count)
          ;; (gimp-layer-set-visible next-copy TRUE)
          (gimp-image-add-layer image curr-copy layer-count)
          ;; (gimp-layer-set-visible curr-copy TRUE)
          (gimp-layer-set-opacity curr-copy opacity)
          (gimp-layer-set-name
           (car (gimp-image-merge-down image curr-copy EXPAND-AS-NECESSARY))
           (string-append next-name "_" curr-name "_" (number->string opacity))))
        (set! opacity (+ opacity 10)))
       (set! layer-count (- layer-count 1))))))

(define (rem-layers image substr)
  (let* ((layers (gimp-image-get-layers image))
         (num-layers (car layers))
	 (layer-array (cadr layers))
         (layer-count (- num-layers 1))
         (substr-length (string-length substr)))
    (while
     (>= layer-count 1)
     (let* ((layer (aref layer-array (- layer-count 1)))
            (name (car (gimp-layer-get-name layer))))
       (if (and (> (string-length name) substr-length)
                (equal? (substring name 0 substr-length) substr))
           (gimp-image-remove-layer image layer))
       (set! layer-count (- layer-count 1))))))

(define (dup-layers image dup-name amount)
  (let* ((layers (gimp-image-get-layers image))
         (num-layers (car layers))
	 (layer-array (cadr layers))
         (layer-count (- num-layers 1)))
    (while
     (>= layer-count 1)
     (let* ((layer (aref layer-array (- layer-count 1)))
            (name (car (gimp-layer-get-name layer)))
            (dup-count amount))
       (if (equal? name dup-name)
           (while
            (>= dup-count 1)
            (let* ((copy (car (gimp-layer-copy layer TRUE))))
              (gimp-image-add-layer image copy layer-count)
              (gimp-layer-set-name
               copy
               (string-append name "_" (number->string dup-count))))
            (set! dup-count (- dup-count 1))))
       (set! layer-count (- layer-count 1))))))

(define (script-fu-make-home r)
  (let* ((width 400)                    ; 400 480
	 (height 300)                   ; 300 640
         (img (car (gimp-image-new width height RGB)))
         (old-fg (car (gimp-palette-get-foreground)))
	 (old-bg (car (gimp-palette-get-background))))
    (gimp-image-undo-disable img)
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-palette-set-background '(255 255 255))

;     (process img create-base-layer)
;     (process img create-base-layer-2)

    (process img create-layers-5)
    (merge-layers-with-background img)
    (merge-layers-smooth img)

;     (rem-layers img "001128_")
;     (dup-layers img "001219" 9)

    (gimp-selection-none img)
    (gimp-palette-set-background old-bg)
    (gimp-palette-set-foreground old-fg)
    (gimp-image-undo-enable img)
    (gimp-display-new img)
    (gimp-displays-flush)))

(script-fu-register "script-fu-make-home"
		    "<Toolbox>/Xtns/Script-Fu/My/Make Home..."
		    "Create Home"
		    "Juri Linkov"
		    "Juri Linkov"
		    "2001"
		    ""
                    SF-VALUE "Redis (in salats)" "100")
