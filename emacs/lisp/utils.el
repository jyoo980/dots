(defun my/pretty-print-hash (hash)
  "Pretty-prints a hashmap to a human-readable format."
  (let (parts)
    (maphash (lambda (k v) (push (format "%s: %d" k v) parts)) hash)
    (message "%s" (string-join (nreverse parts) "\n"))))

(defun my/hash-to-alist (hash)
  "Return an alist comprising key-value pairs from hash"
  (let (alist)
    (maphash (lambda (k v) (push `(,k . ,v) alist) hash))
    alist))

(defun my/sort-alist (alist)
  "Return the alist sorted by key"
  (sort alist (lambda (a b) (string< (car a) (car b)))))

(provide 'utils)

