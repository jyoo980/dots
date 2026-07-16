(tool-bar-mode -1)             ; Hide the outdated icons
(scroll-bar-mode -1)           ; Hide the always-visible scrollbar
(setq inhibit-splash-screen t) ; Remove the "Welcome to GNU Emacs" splash screen
(setq use-file-dialog nil)     ; Ask for textual confirmation instead of GUI
(setq-default fill-column 80)  ; Columns should be set to 80


(defvar my/autosave-dir (expand-file-name "autosave/" user-emacs-directory))
(make-directory my/autosave-dir t)
(setq
   auto-save-list-file-prefix my/autosave-dir
   auto-save-file-name-transforms `((".*" ,my/autosave-dir t))
   backup-directory-alist `((".*" ,my/autosave-dir t))
   lock-file-name-transforms `((".*" ,my/autosave-dir t)))

(setq pdf-info-epdfinfo-program
      (expand-file-name "straight/repos/pdf-tools/server/epdfinfo" user-emacs-directory))

;; Local configuration modules live in ~/.emacs.d/lisp, which might include subdirectories.
;; Add the directory to `load-path' once, then `require' each module by name.

(let ((config-dir (expand-file-name "lisp" user-emacs-directory)))
  ; Add any top-level config files in the root of the directory.
  (add-to-list 'load-path config-dir)
  (dolist (dir (directory-files config-dir t "\\`[^.]"))
    (when (file-directory-p dir)
      (add-to-list 'load-path dir))))

(require 'prog-mode-init)
(require 'env-init)
(require 'completion-init)
(require 'org-init)
(require 'term-init)
(require 'python-init)
(require 'rust-init)
(require 'file-init)
(require 'autoinsert)

(auto-insert-mode 1)
(setq auto-insert-query nil)
(setq markdown-command "pandoc")

;; Hooks
(add-hook 'prog-mode-hook #'my/prog-mode-setup)
(add-hook 'pdf-view-mode-hook (lambda () (auto-revert-mode 1)))

;; Lists
(add-to-list 'display-buffer-alist
             '("\\*Async Shell Command\\*" display-buffer-no-window))
(add-to-list 'auto-insert-alist
             '((emacs-lisp-mode . "Emacs Lisp header")
               .
               my/elisp-header))
