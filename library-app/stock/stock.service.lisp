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
  (first (query ?time
         (is ?ref book-ref)
         (estimate-delivery-time ?ref ?time))
  )

) ;; end function


(def-function orderBookitem (
    (book-ref :type BookReference :documentation "The BookReference instance to order")
  )
  ;; function documentation
  (
    :documentation "Order a new book copy for the library storage from a book reference"
    :examples "(orderNewBookItem #<BookReference[...]* ...>) -> "
    :pre (not (equal book-ref nil))
  )

  ;; function body
  (progn
    ;; ;; simulate delivery
    (format t "~%[INFO] (~A) has been order, it will take ~A minutes to receive it"
      (oo:to-string-summary book-ref) (estimateDeliveryTime book-ref)
    )

    ;; simulate delivery
    (wait-for-first (timer-voucher :minutes (estimateDeliveryTime book-ref)))

    ;; timer ends -> trigger event
    (handle-event (make-instance 'eventBookDelivered :order-book-ref book-ref))
  )

) ;; end function


(def-process processEventBookDelivered (event :type eventBookDelivered)
  ;; process body
  (format t "~%[INFO ~~ 'eventBookDelivered triggered] (~A) delivered, create new book item : ~A"
      (oo:to-string-summary (get-order-book-ref event))
      (oo:to-string-details (createBookItem (get-order-book-ref event)))
  )

) ;; end process


;;; =====================================
;;; PRIVATE (not exported) FUNCTIONS
;;; =====================================

(def-function _computePenaltyDuration (
    (book-ref :type BookReference :documentation "The BookReference instance to use")
  )
  ;; function body
  (reduce '+
    (collect
      (lambda (x) (first 
        (query ?duration
        (is ?state (get-state x))
        (copyPenaltyDuration ?state ?duration)))
      )
      (findAllBookItemsFromBook book-ref)
    )
    :initial-value 0
  )

) ;; end function
