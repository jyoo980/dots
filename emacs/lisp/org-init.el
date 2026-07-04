;; TAB cycles headings in org buffers (evil normal state)
(with-eval-after-load 'org
  (evil-define-key 'normal org-mode-map (kbd "TAB") #'org-cycle))

;; Task progress keywords and colours
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "BLOCKED" "|" "DONE")))

(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "black" :weight bold))
        ("IN-PROGRESS" . "orange")
        ("BLOCKED" . "red")
        ("DONE" . "green")))

;; Set up org-agenda-files
(setq org-agenda-files '("~/.org/"))

(defun my/count-org-todos ()
  "Count not-done TODO entries across `org-agenda-files'.
Reports a per-file breakdown and a total in the echo area."
  (interactive)
  (let ((total 0)
        (breakdown nil))
    (dolist (file (org-agenda-files))
      (if (not (file-readable-p file))
          (push (format "%s: unreadable" (file-name-nondirectory file))
                breakdown)
        (with-current-buffer (find-file-noselect file)
          (let ((n (length (org-map-entries t "/!" 'file))))
            (setq total (+ total n))
            (push (format "%s: %d" (file-name-nondirectory file) n)
                  breakdown)))))
    (message "TODOs — %s — total: %d"
             (string-join (nreverse breakdown) ", ")
             total)
    total))

(provide 'org-init)
