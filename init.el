;;; init.el --- Emacs init file

;; Time-stamp: <2016-02-24 10:01:47>
;; Copyright (C) 2015 Pierre Lecocq

;;; Commentary:

;;; Install:

;; ln -s ~/src/emacs.d ~/.emacs.d

;;; Code:

;; Directories
(defvar root-dir        "~/src/emacs.d/") ;; (file-name-as-directory (file-truename (file-name-directory load-file-name)))
(defvar lisp-dir        (concat root-dir "lisp/"))
(defvar vendor-dir      (concat root-dir "vendor/"))
(defvar packages-dir    (concat root-dir "packages/"))

(unless (file-exists-p vendor-dir)
  (make-directory vendor-dir t))

;; Add some config directories to load-path
(add-to-list 'load-path lisp-dir)
(add-to-list 'load-path vendor-dir)

;; Secret file
(let ((secret-file (concat vendor-dir "secret.el")))
  (if (file-exists-p secret-file)
      (require 'secret)
    (error "%s not found.  Please copy and adapt it from %ssecret.el-sample" secret-file lisp-dir)))

;; Early requires
(require 'config-bootstrap)
(require 'config-theme)
(require 'config-looknfeel)
(require 'config-modeline)

;; Standard requires
(require 'config-autoinsert)
(require 'config-bookmark)
(require 'config-completion)
(require 'config-encrypt)
(require 'config-execute)
(require 'config-ffip)
(require 'config-filetypes)
;; (require 'config-ido)
(require 'config-indent)
(require 'config-lisp)
(require 'config-locale)
(require 'config-newsticker)
(require 'config-recentf)
(require 'config-ruby)
(require 'config-shell)
(require 'config-spelling)
(require 'config-swiper)
(require 'config-text)
(require 'config-web)

;; Late requires
(require 'config-hooks)
(require 'config-functions)
(require 'config-keybindings)

;; Load host and version specific file at the end to eventually override defaults
(let ((host-file (concat lisp-dir (pl-clean-system-name) ".el"))
      (version-file (concat lisp-dir (number-to-string emacs-major-version) ".el")))
  (load host-file 'noerror)
  (load version-file 'noerror))

;;; init.el ends here
