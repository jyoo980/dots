;;; windows.el --- Utilities related to windowing -*- lexical-binding: t; -*-

(defun my/swap-windows ()
  "Swap two windows in a frame."
  (interactive)
  (execute-kbd-macro (kbd "M-x window-swap-states")))

(defalias 'sw #'my/swap-windows)


(provide 'windows)
