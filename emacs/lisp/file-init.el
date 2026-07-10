;;; file-init.el --- Initialization for files -*- lexical-binding: t; -*-

(define-skeleton my/elisp-header
  "A standard Emacs Lisp file header with a lexical-binding cookie."
  "Summary: "
  ";;; " (file-name-nondirectory (buffer-file-name))
  " --- " str
  " -*- lexical-binding: t; -*-\n\n")

(provide 'file-init)
