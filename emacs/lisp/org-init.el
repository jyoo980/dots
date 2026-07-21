(require 'utils)

(defvar advising-meeting-file "advising.org")

; TAB cycles headings in org buffers (evil normal state)
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

;; Advising meeting notes: `org-capture' (C-c c a) files a dated entry into
;; advising.org under an auto-maintained year/month/day datetree.
(setq org-capture-templates
      (let ((meeting-file (expand-file-name advising-meeting-file (car org-agenda-files))))
        `(("a" "Advising meeting" entry
           (file+olp+datetree ,meeting-file)
           "* Meeting %<%Y-%m-%d>\n** Agenda\n%?\n** Notes\n** Action items\n"))))

(defvar my/org-progress-counts-file
  (expand-file-name "org-progress-counts.eld" (car org-agenda-files))
  "The file in which previous progress item counts are saved.")

(defun my/read-previous-counts ()
  "Read the previously-saved counts alist in 'org-progress-counts.eld', or nil."
  (when (file-readable-p my/org-progress-counts-file)
    (condition-case nil
        (with-temp-buffer
          (insert-file-contents my/org-progress-counts-file)
          (read (current-buffer)))
      (error nil))))

(defun my/count-org-progress-items ()
  "Count entries per TODO state; report counts and diff vs. last run."
  (interactive)
  (let ((prog-counts (make-hash-table :test 'equal)))
    (org-map-entries
     (lambda ()
       (when-let ((state (org-get-todo-state)))
         (puthash state (1+ (gethash state prog-counts 0)) prog-counts)))
     nil
     'agenda)
    (let* ((current-prog-counts (my/sort-alist (my/hash-to-alist prog-counts)))
           (previous-prog-counts (my/read-previous-counts))
           (all-prog-states (my/alist-common-cars current-prog-counts previous-prog-counts))
           (report
            (mapcar
             (lambda (state)
               (let* ((new (or (alist-get state current-prog-counts nil nil #'equal) 0))
                      (old (or (alist-get state previous-prog-counts nil nil #'equal) 0))
                      (delta (- new old)))
                 (format "%s: %d%s" state new
                         (cond ((or (null previous-prog-counts) (zerop delta)) "")
                               (t (format " (previously %d)" old))))))
             (sort all-prog-states #'string<))))
      (with-temp-file my/org-progress-counts-file
        (prin1 current-prog-counts (current-buffer)))
      (message "%s" (string-join report ", "))
      current-prog-counts)))

(defun my/open-progress-report ()
  "Opens the progress-report.txt file in a buffer."
  (interactive)
  (find-file (expand-file-name "progress.txt" (car org-agenda-files))))

(defun my/org-archive-done-tasks ()
  "Archive every DONE entry in the current buffer."
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     ;; Archiving deletes the subtree under point, which shifts every
     ;; following position; restart the scan from where the entry was.
     (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
   "/DONE" 'file))


(provide 'org-init)

