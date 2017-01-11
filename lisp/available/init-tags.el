;;; init-tags.el --- Tags

;; Time-stamp: <2016-12-14 18:02:45>
;; Copyright (C) 2016 Pierre Lecocq

;;; Commentary:

;;; Code:

(defvar tags-bin-path "/usr/local/bin/ctags")

(defvar tags-options-by-mode '((c-mode .            ((files . ".c.h")))
                               (common-lisp-mode .  ((files . ".cl")))
                               (emacs-lisp-mode .   ((files . ".el")))
                               (ruby-mode .         ((files . ".rb")))
                               (python-mode .       ((files . ".py")))
                               (php-mode .          ((files . ".php.css.js")))))

;; Can be overridden with a .tags-options file at the root directory of the project

(defun pl-compile-tags (directory)
  "Compile etags for a given DIRECTORY."
  (interactive "DRoot directory: ")
  (let* ((dir (expand-file-name (file-name-as-directory directory)))
         (dir-local (replace-regexp-in-string "/[^/]+:[^/]+:/" "/" dir))
         (config-file (concat dir "/.tags-options"))
         (file (concat dir "/TAGS"))
         (options nil))
    (when (file-readable-p config-file)
      (load-file config-file))
    (setq options (assoc major-mode tags-options-by-mode))
    (if options
        (let ((files-path (cdr (assoc 'path options)))
              (files-types (cdr (assoc 'files options))))
          (unless files-path
            (setq files-path "."))
          (cd dir)
          (compile (format "%s -e -h \"%s\" -R %s" tags-bin-path files-types files-path))
          (setq tags-file-name file)
          (visit-tags-table file))
      (warn "No tag options for mode %s" major-mode))))

(provide 'init-tags)

;;; init-tags.el ends here