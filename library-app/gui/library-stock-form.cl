;;; Code for the form named :library-stock-form of class library-stock-dialog.
;;; The inspector may add event-handler starter code here,
;;; and you may add other code for this form as well.
;;; The code for recreating the window is auto-generated into 
;;; the *.bil file having the same name as this *.cl file.

(in-package :common-graphics-user)

(defclass library-stock-dialog (dialog)
  ())


;;; =====================================
;;; initialize window function
;;; =====================================

(defmethod initialize-instance :after ((dialog library-stock-dialog) &key)
  ;; function body
  (let* (
    (book-item-list (find-component :book-list dialog))
    (book-ref-list (find-component :book-ref-list dialog))
    (book-items (oo:to-list-string-summary (bis:find-all 'stock:BookItem)))
    (book-refs (oo:to-list-string-summary (bis:find-all 'resources:BookReference)))
    )
  
  (setf (range book-item-list) book-items)
  (setf (value book-item-list) (first book-items))
  (setf (range book-ref-list) book-refs)
  (setf (value book-ref-list) (first book-refs))
  )

) ;; end function


;;; =====================================
;;; On-Change event
;;; =====================================

(defun stock-book-list-on-change (widget new-value old-value)
  ;; function body
  (declare (ignorable widget new-value old-value))
  (let* ((dialog (parent widget))
    (state-field (find-component :state-field dialog))
    (available-field (find-component :available-field dialog))
    (title-field (find-component :title-field dialog))
    (author-field (find-component :author-field dialog))
    (type-field (find-component :type-field dialog))
    (book-item (oo:from-string-summary 'stock:BookItem new-value))
    )

    (setf (value state-field) (stock:get-state book-item))
    (setf (value available-field) (borrowing-system:isBookItemAvailable book-item))
    (setf (value title-field) (resources:get-title (stock:get-book-ref book-item)))
    (setf (value author-field) (resources:get-author (stock:get-book-ref book-item)))
    (setf (value type-field) (resources:get-type (stock:get-book-ref book-item)))
  )
t) ;; end function

(defun stock-book-ref-list-on-change (widget new-value old-value)
  ;; function body
  (declare (ignorable widget new-value old-value))
  (let* ((dialog (parent widget))
    (book-ref-details-field (find-component :book-ref-details-field dialog))
    (book-count-field (find-component :book-count-field dialog))
    (delivery-time-field (find-component :delivery-time-field dialog))
    (book-ref (oo:from-string-summary 'resources:BookReference new-value))
    )

    (setf (value book-ref-details-field) (oo:to-string-details book-ref))
    (setf (value book-count-field) (length (stock:findAllBookItemsFromBook book-ref)))
    (setf (value delivery-time-field) (format nil "~A minutes" (stock:estimateDeliveryTime book-ref)))
  )

t) ;; end function


;;; =====================================
;;; Button On-Click event
;;; =====================================

(defun stock-order-button-on-click (dialog widget)
  ;; function body
  (declare (ignorable dialog widget))
  (let* (
    (book-ref (oo:from-string-summary 'resources:BookReference (value (find-component :book-ref-list dialog))))
    )

  (stock:orderBookitem book-ref)
  )

t) ;; end function
