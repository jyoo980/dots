;;; vterm-init.el --- Terminal (vterm) configuration -*- lexical-binding: t; -*-

(use-package vterm-toggle
  :general
  (leader-keys
    "'" '(vterm-toggle :which-key "terminal")))

(with-eval-after-load 'vterm
  (defun my/vterm-clear-all ()
    "⌘K semantics: clear screen and scrollback, like iTerm2."
    (interactive)
    (vterm-clear-scrollback)
    (vterm-clear))          ; sends C-l so the shell redraws its prompt

  (defun my/vterm-isearch ()
    "⌘F semantics: search the scrollback."
    (interactive)
    (vterm-copy-mode 1)     ; freeze the buffer so point can move
    (isearch-backward))

  (define-key vterm-mode-map (kbd "s-k") #'my/vterm-clear-all)
  (define-key vterm-mode-map (kbd "s-v") #'vterm-yank)       ; paste via bracketed paste
  (define-key vterm-mode-map (kbd "s-c") #'kill-ring-save)   ; copy region
  (define-key vterm-mode-map (kbd "s-f") #'my/vterm-isearch)
  (define-key vterm-mode-map (kbd "s-t") #'vterm))

(defun my/startup-vterm-split ()
  "Split frame right, open vterm in the new split"
  (let ((original (selected-window)))
    (select-window (split-window-right))
    (vterm)
    (select-window original))
  (let ((original (selected-window)))
    (select-window (split-window-vertically))
    (find-file "~/.org/misc.org")
    (select-window original)))

(add-hook 'emacs-startup-hook #'my/startup-vterm-split)

(provide 'vterm-init)

