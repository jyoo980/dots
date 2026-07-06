(defun my/hsplit-parent ()
  "Horizontal split of current window, or curr if no parent."
  (interactive)
  (let ((curr-window-parent (window-parent)))
    (if curr-window-parent
        (split-window curr-window-parent nil t)
      (split-window-horizontally))))

(defalias 'hsw #'my/hsplit-parent)

(provide 'windows)

