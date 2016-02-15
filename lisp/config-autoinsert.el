;;; config-autoinsert.el --- Emacs config - autoinsert

;; Time-stamp: <2016-02-15 11:54:35>
;; Copyright (C) 2015 Pierre Lecocq

;;; Commentary:

;;; Code:

(require 'autoinsert)

(auto-insert-mode 1)

(auto-insert)

(setq auto-insert-alist
      '(((ruby-mode . "Ruby program") nil
         "#!/usr/bin/env ruby\n\n"
         "# File: " (file-name-nondirectory buffer-file-name) "\n"
         "# Time-stamp: <>\n"
         "# Copyright (C) " (substring (current-time-string) -4) " " (user-full-name) "\n"
         "# Description: " _ "\n\n")
        ((python-mode . "Python program") nil
         "#!/usr/bin/env python\n\n"
         "# File: " (file-name-nondirectory buffer-file-name) "\n"
         "# Time-stamp: <>\n"
         "# Copyright (C) " (substring (current-time-string) -4) " " (user-full-name) "\n"
         "# Description: " _ "\n\n")
        ((lisp-mode . "Lisp program") nil
         ";;;; " (file-name-nondirectory buffer-file-name) "\n\n"
         ";; Time-stamp: <>\n"
         ";; Copyright (C) " (substring (current-time-string) -4) " " (user-full-name) "\n\n")
        ((emacs-lisp-mode . "Emacs lisp program") nil
         ";;; " (file-name-nondirectory buffer-file-name) " --- " _ "\n\n"
         ";; Time-stamp: <>\n"
         ";; Copyright (C) " (substring (current-time-string) -4) " " (user-full-name) "\n\n"
         ";;; Commentary:\n\n"
         ";;; Code:\n\n"
         ";;; " (file-name-nondirectory buffer-file-name) " ends here\n")
        ((c-mode . "C program") nil
         "/*\n"
         " * File: " (file-name-nondirectory buffer-file-name) "\n"
         " * Time-stamp: <>\n"
         " * Copyright (C) " (substring (current-time-string) -4) " " (user-full-name) "\n"
         " * Description: " _ "\n"
         " */\n\n")
        ((sh-mode . "Shell script") nil
         "#!/bin/bash\n\n"
         " # File: " (file-name-nondirectory buffer-file-name) "\n"
         " # Time-stamp: <>\n"
         " # Copyright (C) " (substring (current-time-string) -4) " " (user-full-name) "\n"
         " # Description: " _ "\n\n")))

(provide 'config-autoinsert)

;;; config-autoinsert.el ends here