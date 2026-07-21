(defun my/prog-mode-setup ()
  (display-line-numbers-mode 1)
  (setq fill-column 100)
  (display-fill-column-indicator-mode 1))

;; M-x eglot-rename does not save modified buffers; which is problematic when you run compile
;; commands (since they run on the unsaved buffers). This advice makes sure a global save occurs.
(defun my/elgot-rename-actions (&rest args)
  (message "eglot-rename successful")
  (save-some-buffers t))

(advice-add 'eglot-rename :after #'my/eglot-rename-actions)

(provide 'prog-mode-init)
 
