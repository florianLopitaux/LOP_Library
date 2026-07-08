(in-package :stock)


;;; =====================================
;;; SERVICE FUNCTIONS
;;; =====================================

(def-function createBookItem (
    (book-ref :type BookReference :documentation "The reference of this new book copy")
    &key
    (book-state :type eBookCondition :documentation "OPTIONAL, by default :perfect book condition")
  )
  ;; function documentation
  (
    :documentation "Create a new book copy in the storage of the library"
    :examples "(createBookItem #<BookReference[...]* ...>) -> #BookItem[59]* ... :perfect, (createBookItem #<BookReference[...]* ...> :book-state :damage) -> #BookItem[59]* ... :damage"
    :pre (not (equal book-ref nil))
    :post (equal book-ref (get-book-ref :result))
    :result-type BookItem
  )

  ;; function body
  (cond ((equal nil book-state) (make-instance 'BookItem :book-ref book-ref))
        (else (make-instance 'BookItem :book-ref book-ref :state book-state))
  )
) ;; end function


(def-function estimateDeliveryTime (
    (book-ref :type BookReference :documentation "The BookReference instance to estimate the time to order")
  )
  ;; function documentation
  (
    :documentation "Estimate the time to receive a new book item from a BookReference if we order it"
    :examples "(estimateDeliveryTime #<BookReference[...]* ...>) -> 2.5"
    :pre (not (equal book-ref nil))
    :result-type number
  )

  ;; function body
  (+ 1 (* 0.5 (length (findAllBookItemsFromBook book-ref))))

) ;; end function


(def-function orderBookitem (
    (book-ref :type BookReference :documentation "The BookReference instance to order")
  )
  ;; function documentation

  ;; function body

) ;; end function
