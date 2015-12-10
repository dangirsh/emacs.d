;;; init.el --- Emacs init file

;; Time-stamp: <2015-12-09 01:09:44>
;; Copyright (C) 2015 Pierre Lecocq

;;; Commentary:

;;; Code:

;; Set directories paths (note: trailing slash is mandatory)
(defvar config-dir
  (file-name-as-directory (file-truename (file-name-directory load-file-name))))

(defvar config-dir-files
  (concat config-dir "lisp/files/"))

(defvar config-dir-hosts
  (concat config-dir "lisp/hosts/"))

(defvar config-dir-versions
  (concat config-dir "lisp/versions/"))

(defvar config-dir-modules
  (concat config-dir "lisp/modules/"))

(defvar config-dir-packages
  (concat config-dir "lisp/packages/"))

(unless (file-exists-p config-dir-files)
  (make-directory config-dir-files))

;; Add some config directories to load-path
(add-to-list 'load-path config-dir-hosts)
(add-to-list 'load-path config-dir-modules)

;; Early requires
(require 'init-bootstrap)
(require 'init-looknfeel)

;; Standard requires
(require 'init-autoinsert)
(require 'init-bookmark)
(require 'init-completion)
(require 'init-elfeed)
(require 'init-erc)
(require 'init-filetypes)
(require 'init-ido)
(require 'init-indent)
(require 'init-lisp)
(require 'init-locale)
(require 'init-recentf)
(require 'init-ruby)
(require 'init-shell)
(require 'init-spelling)
(require 'init-text)
(require 'init-web)

;; Late requires
(require 'init-hooks)
(require 'init-functions)
(require 'init-keybindings)

;; Load host and version specific file at the end to eventually override defaults
(when (file-exists-p host-file)
  (load host-file 'noerror))

(when (file-exists-p version-file)
  (load version-file 'noerror))

;;; init.el ends here
