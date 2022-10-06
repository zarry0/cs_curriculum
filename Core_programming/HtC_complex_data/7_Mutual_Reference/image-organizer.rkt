;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname image-organizer) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; image-organizer-starter.rkt

;
; PROBLEM:
;
; Complete the design of a hierarchical image organizer.  The information and data
; for this problem are similar to the file system example in the fs-starter.rkt file. 
; But there are some key differences:
;   - this data is designed to keep a hierchical collection of images
;   - in this data a directory keeps its sub-directories in a separate list from
;     the images it contains
;   - as a consequence data and images are two clearly separate types
;  
; Start by carefully reviewing the partial data definitions below.
;


;; =================
;; Constants:

(define SIZE 14)
(define COLOR "black")
(define VSPACE (rectangle 1 10 "solid" "white"))
(define HSPACE (rectangle 10 1 "solid" "white"))
(define MTTREE (rectangle 20 10 "solid" "white"))

;; =================
;; Data definitions:

(define-struct dir (name sub-dirs images))
;; Dir is (make-dir String ListOfDir ListOfImage)
;; interp. An directory in the organizer, with a name, a list
;;         of sub-dirs and a list of images.

;; ListOfDir is one of:
;;  - empty
;;  - (cons Dir ListOfDir)
;; interp. A list of directories, this represents the sub-directories of
;;         a directory.

;; ListOfImage is one of:
;;  - empty
;;  - (cons Image ListOfImage)
;; interp. a list of images, this represents the sub-images of a directory.
;; NOTE: Image is a primitive type, but ListOfImage is not.

(define I1 (square 10 "solid" "red"))
(define I2 (square 10 "solid" "green"))
(define I3 (rectangle 13 14 "solid" "blue"))
(define D0 (make-dir "D0" empty empty))
(define D4 (make-dir "D4" empty (list I1 I2)))
(define D5 (make-dir "D5" empty (list I3)))
(define D6 (make-dir "D6" (list D4 D5) empty))

;
; PART A:
;
; Annotate the type comments with reference arrows and label each one to say 
; whether it is a reference, self-reference or mutual-reference.
;


;; Dir is (make-dir String ListOfDir ListOfImage)

;; ListOfDir is one of:
;;  - empty
;;  - (cons Dir ListOfDir)

;; Dir & ListOfDir form a Mutual Reference:
;;     * Dir references ListOfDir
;;     * ListOfDir references Dir

;; ListOfDir also is self-referential: (rest lod) is ListOfDir

;; ListOfImage is one of:
;;  - empty
;;  - (cons Image ListOfImage)

;; ListOfImage is self-referential: (rest loi) is ListOfImage


;
; PART B:
;
; Write out the templates for Dir, ListOfDir and ListOfImage. Identify for each 
; call to a template function which arrow from part A it corresponds to.
;

#;
(define (fn-for-dir d)
  (... (dir-name d)                   ;String
       (fn-for-lod (dir-sub-dirs d))  ;MUTUAL-REFERENCE
       (fn-for-loi (dir-images d))))  ;ListOfImage
#;
(define (fn-for-lod lod)
  (cond [(empty? lod) (...)]
        [else
         (... (fn-for-dir (first lod))       ;MUTUAL-REFERENCE
              (fn-for-lod (rest  lod)))]))   ;SELF-REFERENCE
#;
(define (fn-for-loi loi)
  (cond [(empty? loi) (...)]
        [else
         (... (first loi)                  ;Image
              (fn-for-loi (rest loi)))]))  ;SELF-REFERENCE


;; =================
;; Functions:
  
;
; PROBLEM B:
;
; Design a function to calculate the total size (width * height) of all the images 
; in a directory and its sub-directories.
;

;; Dir -> Number
;; ListOfDir -> Number 
;; produces the total size (width * height) of all the images in a dir and its sub-dirs
(check-expect (total-size--dir D0) 0)
(check-expect (total-size--lod empty) 0)
(check-expect (total-size--dir D5) (* (image-width I3) (image-height I3)))
(check-expect (total-size--dir D4) (+ (* (image-width I1) (image-height I1))
                                      (* (image-width I2) (image-height I2))))
(check-expect (total-size--lod (list D5 D4)) (+ (+ (* (image-width I1) (image-height I1))
                                                   (* (image-width I2) (image-height I2)))
                                                (* (image-width I3) (image-height I3))))
(check-expect (total-size--dir D6) (+ (+ (* (image-width I1) (image-height I1))
                                         (* (image-width I2) (image-height I2)))
                                      (* (image-width I3) (image-height I3))))

;(define (total-size--dir d) 0)   ;stubs
;(define (total-size--lod lod) 0) 


(define (total-size--dir d)
  (+ (total-size--lod (dir-sub-dirs d)) 
     (calc-size (dir-images d)))) 

(define (total-size--lod lod)
  (cond [(empty? lod) 0]
        [else
         (+ (total-size--dir (first lod))      
            (total-size--lod (rest  lod)))]))

;; ListOfImage -> Number
;; produces the sum of all the sizes (width * height) of the images in the list
(check-expect (calc-size empty) 0)
(check-expect (calc-size (list I1)) (* (image-width I1) (image-height I1)))
(check-expect (calc-size (list I1 I2)) (+ (* (image-width I1) (image-height I1))
                                          (* (image-width I2) (image-height I2))))

;(define (calc-size loi) 0)  ;stub

(define (calc-size loi)
  (cond [(empty? loi) 0]
        [else
         (+ (img-area (first loi))                  
            (calc-size (rest loi)))]))

;; Image -> Number
;; produces the area of the image (width * height)
(check-expect (img-area I1) (* (image-width I1) (image-height I1)))

;(define (img-area img) 0)  ;stub

(define (img-area img)
  (* (image-width img) (image-height img)))


;
;PROBLEM C:
;
;Design a function to produce rendering of a directory with its images. Keep it 
;simple and be sure to spend the first 10 minutes of your work with paper and 
;pencil!
;


;; Dir -> Image
;; ListOfDir -> Image ??
;; produces a simple rendering of a directory and its contents
(check-expect (render--dir D0) (above (text "D0" SIZE COLOR) VSPACE HSPACE))
(check-expect (render--lod empty) empty-image)
(check-expect (render--dir D5) (above (text "D5" SIZE COLOR)
                                      VSPACE
                                      (beside HSPACE I3 HSPACE)))
(check-expect (render--dir D4) (above (text "D4" SIZE COLOR)
                                      VSPACE
                                      (beside HSPACE I1 HSPACE I2 HSPACE)))
(check-expect (render--lod (list D4 D5)) (beside (render--dir D4)
                                                 HSPACE
                                                 (render--dir D5) HSPACE))
(check-expect (render--dir D6) (above (text "D6" SIZE COLOR)
                                      VSPACE
                                      (beside (render--dir D4)
                                              HSPACE
                                              (render--dir D5) HSPACE HSPACE)))

;(define (render--dir d) empty-image)   ;stubs
;(define (render--lod lod) empty-image)


(define (render--dir d)
  (above (text (dir-name d) SIZE COLOR)
         VSPACE
         (beside (render--lod (dir-sub-dirs d))
                 HSPACE
                 (render-images (dir-images d)))))

(define (render--lod lod)
  (cond [(empty? lod) empty-image]
        [else
         (beside (render--dir (first lod))
                 HSPACE
                 (render--lod (rest  lod)))])) 

(define (render-images loi)
  (cond [(empty? loi) empty-image]
        [else
         (beside (first loi)
                 HSPACE
                 (render-images (rest loi)))]))
