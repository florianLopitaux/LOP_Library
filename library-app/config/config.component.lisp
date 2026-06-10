(bis:def-component ::de.h-da.lop.library-app.config
  (:nicknames :config)
  (:documentation "Package that contains configuration tools for the project")
  (:languages :functional :oo :bis)    ;;; delete languages not used here
  (:import

   )
  (:export
    dbClear
    dbClearAll

    dbSeedCustomer
    dbSeedAll

    resetAfterTest
    resetAllAfterTest
   )
  )
