;;; completion-init.el --- In-buffer completion UI -*- lexical-binding: t; -*-

;; corfu renders completion-at-point (e.g. eglot's) as a popup at point.
;; cape adds extra completion sources. Global so all prog modes benefit.

(use-package corfu
  :demand
  :init
  (setq corfu-auto t
        corfu-auto-delay 0.1
        corfu-auto-prefix 2
        corfu-cycle t)
  :config
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package cape
  :demand
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;; TAB indents, or completes when already at the right indentation.
(setq tab-always-indent 'complete)

(provide 'completion-init)

;;; completion-init.el ends here
