;;(eval-when (:compile-toplevel :load-toplevel :execute)
  (format t "~%========================================~%")
  (format t "[CONFIG] INITIALIZE DEV ENVIRONMENT~%")
  (format t "========================================~%")

  (config:dbClearAll)  ;; for previous compilation
  (config:dbSeedAll)

  (format t "~%========================================~%")
  (format t "[CONFIG] DATABASE ENVIRENMENT CREATED !~%")
  (format t "========================================~%")
;;)
