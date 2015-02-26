;;; init.el --- Emacs Config - Main init file

;;; Commentary:
;; Time-stamp: <2015-02-26 13:34:31 pierre>
;; Copyright (C) 2015 Pierre Lecocq

;; (setq debug-on-error t)

;;; Code:

(setq
 user-full-name "Pierre Lecocq"
 user-mail-address "pierre.lecocq@gmail.com")

;; Generic variables

(setq
 ;; Files and path
 package-user-dir "~/.emacs.d/lisp/vendor"
 custom-file "~/.emacs.d/custom.el"
 bookmark-default-file "~/.emacs.d/bookmarks"
 org-files-dir "~/.emacs.d/org"
 ;; No backups
 backup-inhibited t
 make-backup-files nil
 auto-save-default nil
 ;; Startup buffer
 inhibit-startup-message t
 inhibit-splash-screen t
 initial-scratch-message ";; Scratch buffer\n(setq debug-on-error t)\n\n"
 ;; Frame title
 frame-title-format "Emacs %f"
 ;; Kill the whole line
 kill-whole-line t)

(unless (file-accessible-directory-p package-user-dir)
  (make-directory package-user-dir))

(unless (file-accessible-directory-p org-files-dir)
  (make-directory org-files-dir))

;; Load files

(setq files-to-load
      (list custom-file
            "~/.emacs.d/lisp/config/01-packages.el"
            "~/.emacs.d/lisp/config/02-functions.el"
            "~/.emacs.d/lisp/config/03-autoinsert.el"
            "~/.emacs.d/lisp/config/04-orgmode.el"
            "~/.emacs.d/lisp/config/09-keybindings.el"
            (format "~/.emacs.d/lisp/config/99-%s.el" (downcase (car (split-string system-name "\\."))))))

(dolist (f files-to-load)
  (when (file-exists-p f)
    (load-file f)))

;; Call initialization functions

(setq init-functions
      (list #'pl--init-look-and-feel
            #'pl--init-indentation
            #'pl--init-files-modes
            #'pl--init-hooks))

(dolist (f init-functions)
  (declare-function f "~/.emacs.d/lisp/config/02-functions.el" nil)
  (funcall f))

;;; init.el ends here
