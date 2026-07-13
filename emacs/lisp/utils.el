;;; utils.el --- utility functions -*- lexical-binding: t; -*-
;;; Commentary:
;; Utility functions used in my Emacs configuration files.

;;; Code:

(defun my/pretty-print-hash (hash)
  "Pretty-prints HASH to a human-readable format."
  (let (parts)
    (maphash (lambda (k v) (push (format "%s: %d" k v) parts)) hash)
    (message "%s" (string-join (nreverse parts) "\n"))))

(defun my/hash-to-alist (hash)
  "Return an alist comprising key-value pairs from HASH."
  (let (alist)
    (maphash (lambda (k v) (push `(,k . ,v) alist)) hash)
    alist))

(defun my/sort-alist (alist)
  "Return ALIST sorted by key."
  (sort alist (lambda (a b) (string< (car a) (car b)))))

(defun my/alist-common-cars (alist blist)
  "Return the common cars (i.e., first elements) of from ALIST and BLIST."
  (delete-dups
   (append (mapcar #'car alist)
           (mapcar #'car blist))))

(provide 'utils)

;;; utils.el ends here
