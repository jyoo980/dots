;;; python-init.el --- Python development setup -*- lexical-binding: t; -*-

;; pet (Python Executable Tracker) auto-detects the right virtualenv per
;; project (poetry/pyenv/uv) and sets buffer-local interpreter/tool paths,
;; so eglot and the REPL use the project's environment.

(use-package pet
  :config
  ;; -10 depth so pet runs before eglot/other hooks and resolves paths first.
  (add-hook 'python-base-mode-hook 'pet-mode -10))

;; Register basedpyright with eglot. Prepended, so it takes priority over
;; eglot's built-in pyright/pylsp entries. The eglot-ensure hook for python
;; already lives in init.el, so it is not repeated here.
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode)
                 . ("basedpyright-langserver" "--stdio"))))

(provide 'python-init)

;;; python-init.el ends here
