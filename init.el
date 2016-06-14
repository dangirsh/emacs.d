;;; init.el --- Minimal Emacs config file

;; Time-stamp: <2016-06-14 12:06:17>
;; Copyright (C) 2015 Pierre Lecocq
;; Version: <insert a bigint here>

;;; Commentary:
;;
;; A return to a minimal Emacs config
;;
;; This file is made to be used as a fast and standalone minimal config file
;; but can load some extensions from a given directory by creating symlinks
;; from `lisp-available-dir' to `lisp-enabled-dir'.
;;
;; Can be compiled with `pl-compile-config'

;;; Code:

(defvar lisp-dir (expand-file-name (convert-standard-filename "lisp") user-emacs-directory))
(defvar lisp-available-dir (concat (file-name-as-directory lisp-dir) "available"))
(defvar lisp-enabled-dir (concat (file-name-as-directory lisp-dir) "enabled"))
(defvar files-dir (concat (file-name-as-directory lisp-dir) "files"))

(defvar init-file (expand-file-name (concat (file-name-as-directory user-emacs-directory) "init.el")))
(defvar compiled-file (expand-file-name  "~/.emacs.el"))
(defvar byte-compiled-file (concat compiled-file  "c"))

;; Internals

(mapc 'require '(linum paren time-stamp whitespace))

(mapc (lambda (mode) (funcall mode 1))
      '(auto-compression-mode
        column-number-mode
        global-auto-revert-mode
        global-font-lock-mode
        ido-mode
        line-number-mode
        show-paren-mode
        transient-mark-mode
        which-function-mode))

(setq debug-on-error t
      gc-cons-threshold 100000000
      sentence-end-double-space nil
      user-full-name "Pierre Lecocq"
      user-mail-address "pierre.lecocq@gmail.com"
      frame-title-format "Emacs - %b"
      time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S"
      initial-scratch-message (format ";; Emacs - Started on %s\n\n" (current-time-string))
      inhibit-startup-message t
      inhibit-splash-screen t
      case-fold-search t
      kill-whole-line t
      require-final-newline t
      next-line-add-newlines nil
      backup-inhibited t
      make-backup-files nil
      auto-save-default nil
      auto-save-list-file-prefix nil
      vc-follow-symlinks t
      password-cache-expiry nil
      highlight-tabs t
      show-trailing-whitespace t
      whitespace-line-column 80
      whitespace-style '(tabs tab-mark face lines-tail)
      whitespace-global-modes '(not org-mode web-mode)
      uniquify-buffer-name-style 'forward uniquify-separator "/")

(fset 'yes-or-no-p 'y-or-n-p)

(set-language-environment 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Generated files

(setq custom-file (concat (file-name-as-directory files-dir) "pl-custom.el")
      abbrev-file-name (concat (file-name-as-directory files-dir) "pl-abbrev.el")
      bookmark-default-file (concat (file-name-as-directory files-dir) "pl-bookmarks.el")
      nsm-settings-file (concat (file-name-as-directory files-dir) "pl-nsm-settings.el")
      recentf-save-file (concat (file-name-as-directory files-dir) "pl-recentf.el")
      ido-save-directory-list-file (concat (file-name-as-directory files-dir) "pl-ido.el")
      tramp-persistency-file-name (concat (file-name-as-directory files-dir) "pl-tramp.el"))

;; Look'n'feel

(set-background-color "grey13")
(set-foreground-color "grey93")
(set-face-background 'region "grey27")
(set-face-attribute 'fringe nil :background "grey13")

(mapc (lambda (mode) (funcall mode -1))
      '(menu-bar-mode scroll-bar-mode tool-bar-mode tooltip-mode))

(when (display-graphic-p)
  (set-fringe-mode 10)
  (toggle-frame-maximized)
  (setq select-enable-clipboard t))

;; Autoload config

(defun pl-compile-config ()
  (interactive)
  (let ((files (directory-files lisp-enabled-dir t "\\.el")))
    (add-to-list 'files init-file)
    (write-region (format "(message \" ** Loading file %s - Compiled on %s **\")" byte-compiled-file (current-time-string)) nil compiled-file)
    (mapc (lambda (src)
            (with-temp-buffer
              (insert-file-contents src)
              (write-region (buffer-string) nil compiled-file 'append)))
          files))
  (byte-compile-file compiled-file)
  (delete-file compiled-file))

(defun pl-enable-lisp-file ()
  "Enable a lisp file."
  (interactive)
  (unless (file-exists-p lisp-available-dir)
    (error "%s not found" lisp-available-dir))
  (unless (file-exists-p lisp-enabled-dir)
    (error "%s not found" lisp-enabled-dir))
  (let ((file (ido-completing-read "Select a file: " (directory-files lisp-available-dir nil "\\.el"))))
    (shell-command (format "ln -s %s/%s %s/%s" lisp-available-dir file lisp-enabled-dir file))))

(unless (file-exists-p byte-compiled-file)
  (if (file-exists-p lisp-enabled-dir)
      (mapc 'load-file (directory-files lisp-enabled-dir t "\\.el"))
    (warn "No lisp files enabled in %s" lisp-enabled-dir)))

;;; init.el ends here
