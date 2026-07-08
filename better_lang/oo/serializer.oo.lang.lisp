(cl:in-package :de.h-da.lop.lang.oo)


;; generic functions to override by defmethod by a class
;; it is not necessary to override all of them, only the ones we want use.
(defgeneric to-string-summary (obj))
(defgeneric to-string-details (obj))
(defgeneric from-string-summary (target-class str))


;; standard functions that need non-list generic function linked to be override
(defun to-list-string-summary (obj-lst)
  "Takes a list of objects and returns a list where each element are the object has been
   converted via the overrided to-string-summary method"

  (if (null obj-lst) nil ;; break point
      (cons (to-string-summary (car obj-lst))
            (to-list-string-summary (cdr obj-lst)) ;; recursif call
      )
  ) 
  
) ;; end function

(defun to-list-string-details (obj-lst &optional (separator "-----------------------"))
  "Takes a list of objects and returns a string where each object has been
   converted via the overrided to-string-details method"

  (if (null obj-lst) "" ;; break point
      (format nil "~A~%~%~A~%~A"
              (to-string-details (car obj-lst))
              separator
              (to-list-string-details (cdr obj-lst) separator)
      )
  )
  
) ;; end function

(defun from-list-string-summary (target-class str-lst)
  "Takes a list of strings and returns a list where each element is the
   re-converted object via the overrided from-string-summary method"

  (if (null str-lst) nil ;; break point
      (cons (from-string-summary target-class (car str-lst))
            (from-list-string-summary target-class (cdr str-lst)) ;; recursif call
      )
  ) 
  
) ;; end function
