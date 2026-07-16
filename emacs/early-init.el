(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(ns-transparent-titlebar . t) default-frame-alist)
(push '(ns-appearance . dark) default-frame-alist)

(defvar bootstrap-version)
(let ((bootstrap-file
    (expand-file-name
      "straight/repos/straight.el/bootstrap.el"
      (or (bound-and-true-p straight-base-dir)
        user-emacs-directory)))
    (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
       'silent 'inhibit-cookies)
    (goto-char (point-max))
    (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq package-enable-at-startup nil)
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(setq use-package-always-defer t)

(use-package gcmh
  :demand
  :config
  (gcmh-mode 1))


(use-package emacs
  :init
  (setq initial-scratch-message nil)
  (defun display-startup-echo-area-message ()
    (message ""))
  (defalias 'yes-or-no-p 'y-or-n-p)
  (set-charset-priority 'unicode)
  (setq locale-coding-system 'utf-8
        coding-system-for-read 'utf-8
        coding-system-for-write 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix))
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 2)
  (set-face-attribute 'default nil
    :font "PragmataPro Mono Liga"
    :height 160))


(use-package evil
  :demand ; No lazy loading
  :config
  (evil-mode 1))

(use-package nerd-icons)

;; modus-alabaster builds on modus-themes 5.x APIs; Emacs 30's built-in
;; copy is 4.4, so install the current release (straight puts its build
;; dir ahead of the built-in on load-path, so 5.x wins the require).
(use-package modus-themes)

;; Both paths are required: `load-theme' finds the *-theme.el files via
;; `custom-theme-load-path' (it does NOT search `load-path'), while the
;; modus-alabaster library those files require resolves via `load-path'.
(add-to-list 'load-path "~/.emacs.d/modus-alabaster/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/modus-alabaster/")
(load-theme 'modus-alabaster-light t)

; (use-package doom-themes
;   :demand
;   :config
;   (load-theme 'modus-operandi t))

(use-package which-key
  :demand
  :init
  (setq which-key-idle-delay 0.5)
  :config
  (which-key-mode))

(use-package ivy
  :config
  (ivy-mode))

(use-package general
  :demand
  :config
  (general-evil-setup)

  (general-create-definer leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  (leader-keys
    "x" '(execute-extended-command :which-key "execute command")
    "r" '(restart-emacs :which-key "restart emacs")
    "i" '((lambda () (interactive) (find-file user-init-file)) :which-key "open init file")

    ;; Buffer
    "b" '(:ignore t :which-key "buffer")
    ;; Don't show an error because SPC b ESC is undefined, just abort
    "b <escape>" '(keyboard-escape-quit :which-key t)
    "bd"  'kill-current-buffer
  ))


(use-package transpose-frame
  :general
  (leader-keys
    "w" '(:ignore t :which-key "window")
    "w <escape>" '(keyboard-escape-quit :which-key t)
    "w t" '(transpose-frame :which-key "transpose split")
    "w r" '(rotate-frame-clockwise :which-key "rotate windows")))

(use-package magit
  :general
  (leader-keys
    "g" '(:ignore t :which-key "git")
    "g <escape>" '(keyboard-escape-quit :which-key t)
    "g g" '(magit-status :which-key "status")
    "g l" '(magit-log :which-key "log"))
  (general-nmap
    "<escape>" #'transient-quit-one))

(use-package diff-hl
  :demand
  :init
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  :config
  (global-diff-hl-mode))

(use-package pdf-tools
  :straight t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (setq pdf-view-use-scaling t
        pdf-view-use-imagemagick nil))

(use-package eglot
  :straight nil          ; built-in — don't let straight try to fetch it
  :hook ((c-mode c-ts-mode python-mode python-ts-mode) . eglot-ensure))
;; Rust's eglot startup is project-gated in lisp/rust-init.el.

(use-package ghostel
  :ensure t)

(use-package claude-code-ide
  :straight (:type git :host github :repo "manzaltu/claude-code-ide.el")
  :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (setq claude-code-ide-terminal-backend 'ghostel)
  (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools

(use-package markdown-mode
  :ensure t)

;; Ugly hack for getting columns to show when editing Markdown files
(add-hook 'markdown-mode-hook (lambda ()
                                (setq fill-column 100)
                                (display-fill-column-indicator-mode 1)))

