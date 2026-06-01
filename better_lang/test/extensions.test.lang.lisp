(in-package :test)


(defmacro test-all ()
  (let* ((current-package *package*)
         (packages (list-all-packages))
         (code (loop for pck in packages collect  
                     `(progn
                        (in-package ,(make-symbol (package-name pck)))
                        (when (get-tests)  ; there are tests avaialable
                          (format t "~%~%Executing tests in ~a ~%" ,(package-name pck))
                          (run-tests)
                          )
                        )
                     )
               )
         )
    `(progn 
       ,@code
       (in-package ,(make-symbol (package-name current-package)))
       (format t "~%")
       )
    )
  )

