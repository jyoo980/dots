;;; term-init.el --- Terminal configuration -*- lexical-binding: t; -*-

;; Ghostel is a vterm-style terminal powered by libghostty's VT engine.
;; It's a superset of vterm, so the mappings below are near 1:1. The main
;; differences: keys bind into `ghostel-semi-char-mode-map' (the default
;; input mode) rather than a single mode-map, and `ghostel-send-key' takes
;; a comma-separated modifier string ("ctrl") instead of positional flags.

(defun my/ghostel-toggle ()
  "Show a Ghostel terminal, or hide it if it's the current buffer.
Stand-in for the old `vterm-toggle' behavior."
  (interactive)
  (if (eq major-mode 'ghostel-mode)
      (if (one-window-p) (bury-buffer) (delete-window))
    (ghostel)))

(use-package ghostel
  :general
  (leader-keys
    "'" '(my/ghostel-toggle :which-key "terminal")))

;; Evil is on globally, so a Ghostel buffer would otherwise open in normal
;; state, where the buffer is read-only and `C-r' is `evil-redo' (hence the
;; "buffer is read-only" error). Emacs state lets evil step aside so every
;; key reaches Ghostel and the shell — C-r reverse-i-search, C-c C-j, etc.
(with-eval-after-load 'evil
  (evil-set-initial-state 'ghostel-mode 'emacs))

(with-eval-after-load 'ghostel
  (defun my/ghostel-clear-all ()
    "⌘K semantics: clear screen and scrollback, like iTerm2."
    (interactive)
    (ghostel-clear-scrollback)
    (ghostel-clear))          ; sends C-l so the shell redraws its prompt

  (defun my/ghostel-isearch ()
    "⌘F semantics: search the scrollback."
    (interactive)
    (ghostel-copy-mode)     ; freeze the buffer so point can move
    (isearch-backward))

  (define-key ghostel-semi-char-mode-map (kbd "s-k") #'my/ghostel-clear-all)
  (define-key ghostel-semi-char-mode-map (kbd "s-v") #'ghostel-yank)       ; paste via bracketed paste
  (define-key ghostel-semi-char-mode-map (kbd "s-c") #'kill-ring-save)     ; copy region
  (define-key ghostel-semi-char-mode-map (kbd "s-f") #'my/ghostel-isearch)
  (define-key ghostel-semi-char-mode-map (kbd "s-t") #'ghostel))

(defun my/startup-ghostel-split ()
  "Split frame right, open ghostel in the new split"
  (let ((original (selected-window)))
    (select-window (split-window-right))
    (ghostel)
    (select-window original))
  (let ((original (selected-window)))
    (select-window (split-window-vertically))
    (find-file "~/.org/misc.org")))

(add-hook 'emacs-startup-hook #'my/startup-ghostel-split)

(defun my/ghostel-docker-detach ()
  "Send C-p C-q to the terminal (Docker detach)"
  (interactive)
  (ghostel-send-key "p" "ctrl")
  (ghostel-send-key "q" "ctrl"))
(defalias 'ddt #'my/ghostel-docker-detach)

(defun my/ghostel-tmux-detach ()
  "Send C-b d to the terminal (tmux detach)"
  (interactive)
  (ghostel-send-key "b" "ctrl")
  (ghostel-send-key "d"))
(defalias 'tdt #'my/ghostel-tmux-detach)

(provide 'term-init)
