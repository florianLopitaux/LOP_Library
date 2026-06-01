;;;-*- Mode: Lisp; Package: LISP-UNIT -*-

#|
Copyright (c) 2004-2005 Christopher K. Riesbeck

Permission is hereby granted, free of charge, to any person obtaining 
a copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included 
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
OTHER DEALINGS IN THE SOFTWARE.
|#


;;; A test suite package, modelled after JUnit.
;;; Author: Chris Riesbeck
;;; 
;;; Update history:
;;;
;;; 04/07/06 added ~<...~> to remaining error output forms [CKR]
;;; 04/06/06 added ~<...~> to compact error output better [CKR]
;;; 04/06/06 fixed RUN-TESTS to get tests dynamically (bug reported
;;;          by Daniel Edward Burke) [CKR]
;;; 02/08/06 added newlines to error output [CKR]
;;; 12/30/05 renamed ASSERT-PREDICATE to ASSERT-EQUALITY [CKR]
;;; 12/29/05 added ASSERT-EQ, ASSERT-EQL, ASSERT-EQUALP [CKR]
;;; 12/22/05 recoded use-debugger to use handler-bind, added option to prompt for debugger, 
;;; 11/07/05 added *use-debugger* and assert-predicate [DFB]
;;; 09/18/05 replaced Academic Free License with MIT Licence [CKR]
;;; 08/30/05 added license notice [CKR]
;;; 06/28/05 changed RUN-TESTS to compile code at run time, not expand time [CKR]
;;; 02/21/05 removed length check from SET-EQUAL [CKR]
;;; 02/17/05 added RUN-ALL-TESTS [CKR]
;;; 01/18/05 added ASSERT-EQUAL back in [CKR]
;;; 01/17/05 much clean up, added WITH-TEST-LISTENER [CKR] 
;;; 01/15/05 replaced ASSERT-EQUAL etc. with ASSERT-TRUE and ASSERT-FALSE [CKR]
;;; 01/04/05 changed COLLECT-RESULTS to echo output on *STANDARD-OUTPuT* [CKR]
;;; 01/04/05 added optional package argument to REMOVE-ALL-TESTS [CKR]
;;; 01/04/05 changed OUTPUT-OK-P to trim spaces and returns [CKR]
;;; 01/04/05 changed OUTPUT-OK-P to not check output except when asked to [CKR]
;;; 12/03/04 merged REMOVE-TEST into REMOVE-TESTS [CKR]
;;; 12/03/04 removed ability to pass forms to RUN-TESTS [CKR]
;;; 12/03/04 refactored RUN-TESTS expansion into RUN-TEST-THUNKS [CKR]
;;; 12/02/04 changed to group tests under packages [CKR]
;;; 11/30/04 changed assertions to put expected value first, like JUnit [CKR]
;;; 11/30/04 improved error handling and summarization [CKR]
;;; 11/30/04 generalized RUN-TESTS, removed RUN-TEST [CKR]
;;; 02/27/04 fixed ASSERT-PRINTS not ignoring value [CKR]
;;; 02/07/04 fixed ASSERT-EXPANDS failure message [CKR]
;;; 02/07/04 added ASSERT-NULL, ASSERT-NOT-NULL [CKR]
;;; 01/31/04 added error handling and totalling to RUN-TESTS [CKR]
;;; 01/31/04 made RUN-TEST/RUN-TESTS macros [CKR]
;;; 01/29/04 fixed ASSERT-EXPANDS quote bug [CKR]
;;; 01/28/04 major changes from BUG-FINDER to be more like JUnit [CKR]


#|
How to use
----------

1. Read the documentation in lisp-unit.html.

2. Make a file of def-test's. See exercise-tests.lisp for many
examples. If you want, start your test file with (REMOVE-TESTS) to
clear any previously defined tests.

2. Load this file.

2. (use-package :lisp-unit)

3. Load your code file and your file of tests.

4. Test your code with (RUN-TESTS test-name1 test-name2 ...) -- no quotes! --
or simply (RUN-TESTS) to run all defined tests.

A summary of how many tests passed and failed will be printed,
with details on the failures.

Note: Nothing is compiled until RUN-TESTS is expanded. Redefining
functions or even macros does not require reloading any tests.

For more information, see lisp-unit.html. 

|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(cl:defpackage #:lisp-unit
  (:nicknames :test)
  (:use #:common-lisp)
  (:export #:def-test #:run-all-tests #:run-tests
           #:assert-eq #:assert-eql #:assert-equal #:assert-equalp
           #:assert-error #:assert-expands #:assert-false 
           #:assert-equality #:assert-prints #:assert-true
           #:get-test-code #:get-tests
           #:remove-all-tests #:remove-tests
           #:logically-equal #:set-equal
           #:use-debugger
           #:with-test-listener
           
           #:test-all  ;;; from test extensios
           )
  )

