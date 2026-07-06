(tool-bar-mode -1)             ; Hide the outdated icons
(scroll-bar-mode -1)           ; Hide the always-visible scrollbar
(setq inhibit-splash-screen t) ; Remove the "Welcome to GNU Emacs" splash screen
(setq use-file-dialog nil)     ; Ask for textual confirmation instead of GUI
(setq-default fill-column 80)  ; Columns should be set to 80

;; Local configuration modules live in ~/.emacs.d/lisp, which might include subdirectories.
;; Add the directory to `load-path' once, then `require' each module by name.

(let ((config-dir (expand-file-name "lisp" user-emacs-directory)))
  ; Add any top-level config files in the root of the directory.
  (add-to-list 'load-path config-dir)
  (dolist (dir (directory-files config-dir t "\\`[^.]"))
    (when (file-directory-p dir)
      (add-to-list 'load-path dir))))

;; Hooks
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(require 'env-init)
(require 'completion-init)
(require 'org-init)
(require 'vterm-init)
(require 'windows)
(require 'python-init)
