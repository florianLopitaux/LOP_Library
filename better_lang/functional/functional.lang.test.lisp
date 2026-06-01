(in-package :de.h-da.lop.lang.lop-test)




(def-function defined-via-def-function ((x :type number :documentation "1st param") 
                                              (y :documentation "2nd param")   
                                              &optional
                                              z)
  (:documentation "test for def-function macro"
    :result-type list
    :result-documentation "a list containing x and y"
    :pre (> x 0)
    :pre "this is difficult to express in code"
    :post (> (length :result) 2) 
    :examples "(defined-via-def-function 3 4) --> (3 4 nil)"
    :error "XError if ... happens"
    :error "YError if ... happens"
    )
  ;  (declare (type number z))
  
  (list x y z)
  )



(def-function defined-via-def-function ((x :type number) 'special-value  &optional z)
  (list x "SPECIAL-VALUE-DISPATCH" z)
  )

 
           


(def-function defined-via-def-function ((x :type number) 42  &optional z)
  (list x "THE ANSWER TO ALL QUESTIONS" z)
  )

(cl:defun defined-via-defun (x y &optional z)
  "test for def-function macro

Parameters:
x: number - nominator
y - denominator
result: list - a list containing x and y

Pre-conditions:
(> x 0)
this is difficult to express in code

Post conditions:
(listp defined-via-defun)

Examples:
(bar 3 4) --> (3 4)

"
  (check-type x number)
  (assert (> x 0) nil "Pre-condition failed")
  (list x y z)
  )


(def-function defined-via-defun-2 (x)
  (declare (type number x))
  "classic documentation string"
  
  x
  )

(def-test def-function-test
  (assert-equal (defined-via-defun 3 4) (defined-via-def-function 3 4))
  (assert-equal (defined-via-defun 3 "four") (defined-via-def-function 3 "four"))
  (assert-equal (defined-via-defun 3 "four" 5) (defined-via-def-function 3 "four" 5))
  (assert-equal (defined-via-defun 3 "SPECIAL-VALUE-DISPATCH" 5) (defined-via-def-function 3 'special-value 5))
  (assert-equal (defined-via-defun 3 "THE ANSWER TO ALL QUESTIONS" 5) (defined-via-def-function 3 42 5))
  (assert-equal 'Type-Error (handler-case (defined-via-def-function "three" "four") (error () 'Type-Error)))
  (assert-equal 'Precondition-Error (handler-case (defined-via-def-function -1 4) (simple-error () 'Precondition-Error)))
  (assert-true (string> (documentation 'defined-via-def-function 'function) ""))
  )




(def-class bank-account ()
  (customer-name
   balance))

(def-class checking-account (bank-account)
  (credit-limit))


(def-class savings-account (bank-account)
  (interest-rate))

(def-class money-market-account 
  (checking-account savings-account) 
  ())


(def-function withdraw ((account :type bank-account) amount)
  (set-balance (- (get-balance account) amount) account))

(def-function deposit ((account :type bank-account) amount)
  (set-balance (+ (get-balance account) amount) account))


(def-function withdraw ((account :type savings-account) amount)
  (if (> amount (get-balance account))
    (error "Account overdrawn")
    (call-next-method)))

(def-function withdraw  ((account :type bank-account) 42)
  (print "The answer to all questions, universe, and everything")
  (call-next-method))

(def-function withdraw :before ((account :type savings-account) amount)
  (if (> amount (get-balance account))
      (error "Account overdrawn")))

(def-function withdraw :after  ((account :type bank-account) 42)
  (print "The answer to all questions, universe, and everything"))


(def-function transfer ((from :type bank-account) (to :type bank-account) amount)
  (withdraw from amount)
  (deposit to amount))

(def-test method-test
    (let ((check (make-instance 'checking-account :balance 100))
          (savings (make-instance 'savings-account :balance 100))
          (market (make-instance 'money-market-account :balance 100)))
      (assert-equal 100 (get-balance check))
      (withdraw check 150)
      (assert-equal -50 (get-balance check))
      (assert-error 'error (withdraw savings 150))))


(def-test get-all-test
  (assert-equal '(1 6) (get-all '(:x 1 :y 2 :z 3 :y 4 :y 5 :x 6) :x))  
  (assert-equal '(2 4 5) (get-all '(:x 1 :y 2 :z 3 :y 4 :y 5 :x 6) :y))  
  (assert-equal '(3) (get-all '(:x 1 :y 2 :z 3 :y 4 :y 5 :x 6) :z))  
  (assert-equal '() (get-all '(:x 1 :y 2 :z 3 :y 4 :y 5 :x 6) :a))  
  )





<test for string utilities>

(def-test starts-with-test 
  (assert-true (starts-with "Hello World!" "Hello"))
  (assert-true (starts-with "Hello World!" ""))
  (assert-true (starts-with "Hello World!" "Hello World!"))
  (assert-false (starts-with "Hello World!" "World!"))
  (assert-false (starts-with "Hello World!" "Hello World!!"))
  (assert-false (starts-with "" "Hello World!"))
  )


<tests for Smalltalk style iteration functions>

(def-test collect-test
  (assert-equal '(0 1 2 3) (collect '1+ '(-1 0 1 2) ))
  )



(def-test select-test
    (assert-equal '(2 4 6) (select 'is-even '(1 2 3 4 5 6) ))
    )

(def-test detect-test
    (assert-equal 2 (detect 'is-even '(1 2 3 4 5 6) ))    
    )

(def-test inject-test
    (assert-equal 21 (inject (lambda (x y) (+ x y)) '(1 2 3 4 5 6) 0 ))    
    )
  
(def-test reduce-test
    (assert-equal 21 (reduce (lambda (x y) (+ x y)) '(1 2 3 4 5 6) :initial-value 0 ))    
    )
  
  

(def-test is-number-test
  (assert-true (is-number 3))
  (assert-true (is-number 3.14))
  (assert-false (is-number '(a b c)))
  )




(def-function factorial (1)
  1
  )

(def-function factorial (n)
  (:documentation "factorial function n! = 1*2*...*n"
                  :pre (> n 0)
                  :examples "factorial (5) --> 120"
  )
  (* n (factorial (- n 1)))
  )





(def-test member-recursive-test
    (assert-equal t (functional::member-recursive 1 '(1 2))) 
    (assert-equal nil (functional::member-recursive 3 '(1 2))) 
    (assert-equal t (functional::member-recursive 1 '((1 2)))) 
    (assert-equal t (functional::member-recursive 1 '((1) 2))) 
    (assert-equal t (functional::member-recursive 2 '(1 (2)))) 
    (assert-equal nil (functional::member-recursive 3 '(1 (2)))) 
)                  
  




