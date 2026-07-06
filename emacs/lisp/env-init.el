;;; env-init.el --- Import shell environment into GUI Emacs -*- lexical-binding: t; -*-

;; GUI Emacs on macOS does not inherit the shell's PATH, so pyenv shims,
;; ~/.local/bin (basedpyright), homebrew, ruff, pytest, etc. are invisible.
;; exec-path-from-shell copies them in so subprocesses (eglot, pet) resolve.

(use-package exec-path-from-shell
  :demand
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(provide 'env-init)

;;; env-init.el ends here
