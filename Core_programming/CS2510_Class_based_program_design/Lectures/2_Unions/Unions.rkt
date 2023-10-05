#lang racket

;; IStation is one of
;;  - T Stop
;;  - Commuter Station

;; T Stop is (make-tstop String String Number)
(define-struct tstop (name line price))

;; Commuter Station is (make-commstation String String Boolean)
(define-struct commstation (name line express))

;; Examples
(define harvard (make-tstop "Harvard" "red" 1.25))
(define kenmore (make-tstop "Kenmore" "green" 1.25))
(define riverside (make-tstop "Riverside" "green" 2.50))
(define backbay (make-commstation "Back Bay" "Framingham" true))
(define wnewton (make-commstation "West Newton" "Framingham" false))
(define wellhills (make-commstation "Wellesley Hills" "Worcester" false))