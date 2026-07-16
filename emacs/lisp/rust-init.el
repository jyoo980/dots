;;; rust-init.el --- Rust development setup -*- lexical-binding: t; -*-

;; Use the built-in tree-sitter mode for Rust. It ships with Emacs 30 but
;; is not wired into auto-mode-alist and needs its grammar compiled once.

;; Register the grammar source and build it if it isn't installed yet.
;; Requires a C compiler (clang, already present via the Xcode CLT).
;; treesit must be loaded first — it owns `treesit-language-source-alist'.
(require 'treesit)
(add-to-list 'treesit-language-source-alist
             '(rust "https://github.com/tree-sitter/tree-sitter-rust"))
(unless (treesit-language-available-p 'rust)
  (treesit-install-language-grammar 'rust))

;; Open .rs files in rust-ts-mode and start rust-analyzer for every one.
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))

;; A standalone .rs file (no Cargo.toml up the tree) has no workspace, so
;; rust-analyzer reports "Failed to discover workspace" and gives nothing.
;; Its `linkedProjects' option accepts bare .rs paths and treats each as a
;; standalone project — that unlocks std + in-file completion. Crucially,
;; workspace discovery happens at *initialization*, so linkedProjects must
;; ride in :initializationOptions (post-init didChangeConfiguration is too
;; late). The server entry is therefore a function: eglot calls it in the
;; buffer being connected, and it builds the options for that directory.
;;
;; Eglot shares one server across all project-less files in a directory, so
;; we link every .rs file present at server start, remember that set, and
;; restart the server when a file it doesn't know about is opened.
(defvar my/rust--linked-files (make-hash-table :test #'equal)
  "Directory → list of .rs files linked when its standalone server started.")

(defun my/rust--standalone-p ()
  "Non-nil if this buffer visits a .rs file outside any Cargo project."
  (and buffer-file-name
       (not (locate-dominating-file buffer-file-name "Cargo.toml"))))

(defun my/rust-analyzer-contact (_interactive)
  "Return the rust-analyzer contact for the current buffer.
For files outside any Cargo project, link all .rs files in the
directory as standalone projects so rust-analyzer analyzes them."
  `("rust-analyzer"
    :initializationOptions
    (:procMacro (:enable t)
     :cargo (:buildScripts (:enable t) :features "all")
     ;; Standalone files are treated as cargo scripts, and check-on-save
     ;; would run `cargo check -Zscript' — nightly-only, so it fails loudly
     ;; on stable every save. Disable it; rust-analyzer's own in-process
     ;; diagnostics still apply. Cargo projects keep full check-on-save.
     ,@(when (my/rust--standalone-p)
         (let* ((dir (expand-file-name default-directory))
                ;; cons in case this buffer's file is new and unsaved,
                ;; so the glob wouldn't see it yet.
                (files (delete-dups
                        (cons (expand-file-name buffer-file-name)
                              (directory-files dir t "\\.rs\\'")))))
           (puthash dir files my/rust--linked-files)
           `(:linkedProjects ,(vconcat (mapcar #'file-local-name files))
             :checkOnSave :json-false))))))

(defun my/rust-eglot-setup ()
  "Start eglot, restarting the directory's server if this file isn't linked."
  (when (my/rust--standalone-p)
    (let ((server (and (fboundp 'eglot-current-server) (eglot-current-server)))
          (file (expand-file-name buffer-file-name)))
      (when (and server
                 (not (member file (gethash (file-name-directory file)
                                            my/rust--linked-files))))
        ;; The running server predates this file, and linkedProjects can't
        ;; be extended after initialization — shut it down so the fresh
        ;; connect below re-globs the directory. Siblings re-attach.
        (eglot-shutdown server))))
  (eglot-ensure))

(add-hook 'rust-ts-mode-hook #'my/rust-eglot-setup)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((rust-ts-mode rust-mode) . my/rust-analyzer-contact)))

(provide 'rust-init)

;;; rust-init.el ends here
