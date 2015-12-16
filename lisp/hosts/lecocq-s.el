;;; lecocq-s.el --- Emacs configuration - lecocq-s host

;; Time-stamp: <2015-12-16 13:18:29>
;; Copyright (C) 2015 Pierre Lecocq

;;; Commentary:

;;; Code:

;; Stolen from http://emacs.stackexchange.com/a/85/56
(defun etags-file-of-tag (&optional relative)
"Redefine the function responsible of path computing."
  (save-excursion
    (re-search-backward "\f\n\\([^\n]+\\),[0-9]*\n")
    (let ((str (convert-standard-filename
                (buffer-substring (match-beginning 1) (match-end 1)))))
      (if relative
      str
        (let ((basedir (file-truename default-directory)))
          (if (file-remote-p basedir)
              (with-parsed-tramp-file-name basedir nil
                (expand-file-name (apply 'tramp-make-tramp-file-name
                                         (list method user host str hop))))
            (expand-file-name str basedir)))))))

(load-file "~/src/projects-tags/projects-tags.el")

(require 'projects-tags)

(setq projects-tags-verbose t)

(setq projects-tags-bin "xargs ctags -e -R -a")

(setq projects-tags-alist `(("fotolia" . ((root . ,(-secret-path-ftl "/www/fotolia"))
                                          (directories . (,(-secret-path-ftl "/www/fotolia/include/Fotolia")
                                                          ,(-secret-path-ftl "/www/fotolia/app/controllers")
                                                          ,(-secret-path-ftl "/www/fotolia/app/controllersV4")))
                                         (files . ("*.php"))))))

;;; lecocq-s.el ends here