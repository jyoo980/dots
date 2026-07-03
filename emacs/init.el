(tool-bar-mode -1)             ; Hide the outdated icons
(scroll-bar-mode -1)           ; Hide the always-visible scrollbar
(setq inhibit-splash-screen t) ; Remove the "Welcome to GNU Emacs" splash screen
(setq use-file-dialog nil)     ; Ask for textual confirmation instead of GUI

;; Local configuration modules live in ~/.emacs.d/lisp/.
;; Add the directory to `load-path' once, then `require' each module by name.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'org-init)
(require 'vterm-init)
