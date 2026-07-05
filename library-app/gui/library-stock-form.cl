;;; Code for the form named :library-stock-form of class library-stock-dialog.
;;; The inspector may add event-handler starter code here,
;;; and you may add other code for this form as well.
;;; The code for recreating the window is auto-generated into 
;;; the *.bil file having the same name as this *.cl file.

(in-package :common-graphics-user)

(defclass library-stock-dialog (dialog)
  ())


(defmethod initialize-instance :after ((dialog library-stock-dialog) &key)
  ;; function body
  (let* (
    (book-item-list (find-component :book-list dialog))
    (book-items (stock:getAllBookItemsStringFormat))
    )
  
  (setf (range book-item-list) book-items)
  )

) ;; end function


(defun stock-book-list-on-change (widget new-value old-value)
  (declare (ignorable widget new-value old-value))
  (let* ((dialog (parent widget))
    (state-field (find-component :state-field dialog))
    (available-field (find-component :available-field dialog))
    (title-field (find-component :title-field dialog))
    (author-field (find-component :author-field dialog))
    (type-field (find-component :type-field dialog))
    (book-item (stock:getBookItemByStringFormat new-value))
    )

    (setf (value state-field) (stock:get-state book-item))
    (setf (value available-field) (borrowing-system:isBookItemAvailable book-item))
    (setf (value title-field) (resources:get-title (stock:get-book-ref book-item)))
    (setf (value author-field) (resources:get-author (stock:get-book-ref book-item)))
    (setf (value type-field) (resources:get-type (stock:get-book-ref book-item)))
  )
t) ;; end function
