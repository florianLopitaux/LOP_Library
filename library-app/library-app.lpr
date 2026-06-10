(in-package :cg-user)

(define-project :name :library-app
  :modules (list (make-instance 'module :name "users/users.component.lisp")
                 (make-instance 'module :name "users/users.datatype.bis.lisp")
                 (make-instance 'module :name "users/users.entity.bis.lisp")
                 (make-instance 'module :name "users/users.entity-manager.bis.lisp")
                 (make-instance 'module :name "users/users.service.bis.lisp")
                 (make-instance 'module :name "users/users.test.lisp")
		 (make-instance 'module :name "config/config.component.lisp")
                 (make-instance 'module :name "config/config.db.lisp")
                 (make-instance 'module :name "config/config.init.lisp"))
                 
  :projects (list (make-instance 'project-module :name "../better_lang/LOP.lpr"
                                 :show-modules nil))
  :libraries nil
  :editable-files nil
  :distributed-files nil
  :internally-loaded-files nil
  :project-package-name :common-graphics-user
  :main-form nil
  :compilation-unit t
  :concatenate-project-fasls nil
  :verbose nil
  :runtime-modules (list :cg-dde-utils :cg.acache :cg.base :cg.bitmap-pane
                         :cg.bitmap-pane.clipboard :cg.bitmap-stream :cg.button :cg.caret
                         :cg.chart-or-plot :cg.chart-widget :cg.check-box :cg.choice-list
                         :cg.choose-printer :cg.class-grid :cg.class-slot-grid
                         :cg.class-support :cg.clipboard :cg.clipboard-stack
                         :cg.clipboard.pixmap :cg.color-dialog :cg.combo-box
                         :cg.common-control :cg.comtab :cg.cursor-pixmap :cg.curve
                         :cg.dialog-item :cg.directory-dialog :cg.directory-dialog-os
                         :cg.drag-and-drop :cg.drag-and-drop-image :cg.drawable
                         :cg.drawable.clipboard :cg.dropping-outline :cg.edit-in-place
                         :cg.editable-text :cg.file-dialog :cg.fill-texture
                         :cg.find-string-dialog :cg.font-dialog :cg.gesture-emulation
                         :cg.get-pixmap :cg.get-position :cg.graphics-context
                         :cg.grid-widget :cg.grid-widget.drag-and-drop :cg.group-box
                         :cg.header-control :cg.hotspot :cg.html-dialog :cg.html-widget
                         :cg.icon :cg.icon-pixmap :cg.ie :cg.intersect
                         :cg.intersect.posbox :cg.item-list :cg.keyboard-shortcuts
                         :cg.lamp :cg.layout :cg.lettered-menu :cg.lisp-edit-pane
                         :cg.lisp-text :cg.lisp-widget :cg.list-view :cg.mci :cg.menu
                         :cg.menu.tooltip :cg.message-dialog :cg.multi-line-editable-text
                         :cg.multi-line-lisp-text :cg.multi-picture-button
                         :cg.multi-picture-button.drag-and-drop
                         :cg.multi-picture-button.tooltip :cg.nodes :cg.object-editor
                         :cg.object-editor.layout :cg.ocx :cg.os-widget :cg.os-window
                         :cg.outline :cg.outline.drag-and-drop :cg.outline.edit-in-place
                         :cg.palette :cg.paren-matching :cg.picture-widget
                         :cg.picture-widget.palette :cg.pixmap :cg.pixmap-widget
                         :cg.pixmap.file-io :cg.pixmap.printing :cg.pixmap.rotate
                         :cg.plot-widget :cg.printing :cg.progress-indicator
                         :cg.project-window :cg.property :cg.radio-button :cg.rich-edit
                         :cg.rich-edit-pane :cg.rich-edit-pane.clipboard
                         :cg.rich-edit-pane.printing :cg.sample-file-menu
                         :cg.scaling-stream :cg.scroll-bar :cg.scroll-bar-mixin
                         :cg.scrolling-static-text :cg.selected-object :cg.shortcut-menu
                         :cg.split-bar :cg.static-text :cg.status-bar :cg.string-dialog
                         :cg.tab-control :cg.template-string :cg.text-edit-pane
                         :cg.text-edit-pane.file-io :cg.text-edit-pane.mark
                         :cg.text-or-combo :cg.text-widget :cg.timer :cg.toggling-widget
                         :cg.toolbar :cg.tooltip :cg.trackbar :cg.tray
                         :cg.up-down-control :cg.utility-dialog :cg.web-browser
                         :cg.web-browser.dde :cg.wrap-string :cg.yes-no-list
                         :cg.yes-no-string :dde)
  :splash-file-module (make-instance 'build-module :name "")
  :icon-file-module (make-instance 'build-module :name "")
  :include-flags (list :top-level :debugger)
  :build-flags (list :allow-runtime-debug)
  :autoload-warning nil
  :full-recompile-for-runtime-conditionalizations nil
  :include-manifest-file-for-visual-styles t
  :default-command-line-arguments "+M +t \"Console for Debugging\""
  :additional-build-lisp-image-arguments (list :read-init-files nil)
  :old-space-size 256000
  :new-space-size 6144
  :runtime-build-option :standard
  :build-number 0
  :run-with-console nil
  :project-file-version-info nil
  :save-whether-to-show-subproject-modules t
  :utility-file-directory nil
  :on-initialization 'default-init-function
  :default-error-handler-for-delivery 'report-unexpected-error-and-exit
  :on-restart 'do-default-restart
  :cgjs-options (make-instance 'cgjs-options :run-as-web-browser-server nil
                               :start-local-client t
                               :include-modules-for-starting-local-client t
                               :exit-server-on-client-exit t
                               :disallow-running-in-non-default-mode nil
                               :limit-connections-to-same-machine nil
                               :show-cgjs-server-window nil :cgjs-logging nil
                               :confirm-exit t :include-modules-for-cgjs-logging t
                               :browser-server-port nil :max-clients 1 :browser-keychords
                               (list "F11" "Control+Meta+F" "Control+0" "Control+-"
                                     "Control+=" "Control+Shift+-" "Control+Shift+="
                                     "Meta+0" "Meta+-" "Meta+=" "Meta+Shift+-"
                                     "Meta+Shift+=")
                               :title-for-browser-tab "Allegro Common Lisp"
                               :javascript-files-to-import nil :style-options nil))

;; End of Project Definition
