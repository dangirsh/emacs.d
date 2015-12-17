;;; gnus.el --- Gnus init file

;; Time-stamp: <2015-12-17 21:27:47>
;; Copyright (C) 2015 Pierre Lecocq

;;; Commentary:

;;; Install:

;; Create ~/.authinfo.gpg and insert some credentials like:
;;   machine imap.mail.com login me@mail.com password P4$$w0rD

;; ln -s ~/src/emacs.d/gnus.el ~/.gnus
;; chmod 600 ~/.authinfo.gpg

;;; Code:

;; Directories
(setq message-directory "~/.mail/messages/"
      gnus-directory "~/.mail/news/"
      nnfolder-directory "~/.mail/archives")

;; Defaults
(setq-default read-mail-command 'gnus
              gnus-select-method '(nnml "")
              gnus-large-newsgroup 'nil ;; No expiration
              gnus-fetch-old-headers t ;; Load read messages
              mm-text-html-renderer 'w3m
              gnus-inhibit-images nil
              gnus-read-newsrc-file nil
              gnus-topic-display-empty-topics nil
              gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references
              gnus-thread-sort-functions '(gnus-thread-sort-by-most-recent-date)
              gnus-parameters '(("nnimap.*"
                                 (display . 300) ;; (display . all)
                                 (gnus-use-scoring nil)
                                 (expiry-wait . 5)))

              gnus-posting-styles '((".*" (signature (concat "\n\n" (user-full-name) "\n"))))

              gnus-user-date-format-alist '(((gnus-seconds-today) . "Today, %H:%M")
                                            ((+ 86400 (gnus-seconds-today)) . "Yesterday, %H:%M")
                                            (604800 . "%A %H:%M")
                                            ((gnus-seconds-month) . "%A %d")
                                            ((gnus-seconds-year) . "%d %B")
                                            (t . "%d/%m/%Y %H:%M"))

              ;; gnus-group-line-format " %S [%5y] | %-10s | %G\n"
              gnus-group-line-format " %S %3y: %G\n"
              gnus-summary-line-format " %R%U%z %4k | %(%~(pad-right 16)&user-date; | %-25,25f | %B%s%)\n")

;; Vars
(setq message-citation-line-function 'message-insert-formatted-citation-line
      message-citation-line-format "\nOn %a, %b %d %Y, %f wrote:\n"
      mm-discouraged-alternatives '("text/html" "text/richtext")
      gnus-ignored-mime-types '("text/x-vcard")
      starttls-use-gnutls t
      ;; starttls-extra-arguments '("--insecure")
      starttls-gnutls-program "gnutls-cli")

;; Wrap 72 cols. Because.
(unless (boundp 'message-fill-column)
  (add-hook 'message-mode-hook
            (lambda ()
              (setq fill-column 72)
              (turn-on-auto-fill))))

;; Auto-refresh
(gnus-demon-add-handler 'gnus-demon-scan-news 1 nil)

;; Topics
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
(setq gnus-topic-topology '(("Gnus" visible nil nil)
                            (("Gmail" visible nil nil))
                            (("Qsdfgh" visible nil nil))
                            (("misc" visible nil nil)))
      gnus-topic-alist '(("Gmail"
                          "nnimap+Gmail:Cosmo"
                          "nnimap+Gmail:Github"
                          "nnimap+Gmail:INBOX"
                          "nnimap+Gmail:Rugby"
                          "nnimap+Gmail:Security"
                          "nnimap+Gmail:Emacs")
                         ("Qsdfgh"
                          "nnimap+Qsdfgh:Debug"
                          "nnimap+Qsdfgh:INBOX"
                          "nnimap+Qsdfgh:Misc"
                          "nnimap+Qsdfgh:Trash")
                         ("misc"
                          "nndraft:drafts")))

;; PGP
(setq epg-debug t ;;  *epg-debug*" buffer
      mml2015-use 'epg
      mml2015-verbose t
      mml2015-encrypt-to-self t
      mml2015-always-trust nil
      mml2015-cache-passphrase t
      mml2015-passphrase-cache-expiry '36000
      mml2015-sign-with-sender t
      gnus-message-replyencrypt t
      gnus-message-replysign t
      gnus-message-replysignencrypted t
      gnus-treat-x-pgp-sig t
      mm-verify-option 'always
      mm-decrypt-option 'always
      mm-sign-option nil ;; mm-sign-option 'guided
      gnus-buttonized-mime-types '("multipart/alternative"
                                   "multipart/encrypted"
                                   "multipart/signed"))

(defadvice mml2015-sign (after mml2015-sign-rename (cont) act)
  (save-excursion
    (search-backward "Content-Type: application/pgp-signature")
    (goto-char (point-at-eol))
    (insert "; name=\"signature.asc\"; description=\"Digital signature\"")))

(add-hook 'message-send-hook
          (lambda ()
            (mml-secure-message-sign-pgpmime)))

;; Layout
(gnus-add-configuration
 '(article
   (horizontal 1.0
               (vertical 55 (group 1.0))
               (vertical 1.0
                         (summary 0.16 point)
                         (article 1.0)))))
(gnus-add-configuration
 '(summary
   (horizontal 1.0
               (vertical 55 (group 1.0))
               (vertical 1.0 (summary 1.0 point)))))

;; Split
(setq nnimap-split-inbox '("INBOX")
      nnimap-split-predicate "UNDELETED"
      nnimap-split-crosspost nil
      nnmail-split-methods '(("Emacs" "^.*emacs-devel@gnu.org")
                             ("Github" "^From:.*notifications@github.com")
                             ("Security" "^.*fulldisclosure@seclists.org")
                             ("Security" "^.*debian-security@lists.debian.org")
                             ("Rugby" "^From:.*quatrequarts.*@gmail.com")
                             ("Cosmo" "^From:.*@cosmoligne.com")
                             ("Inbox" "")))

;; IMAP
(setq gnus-secondary-select-methods `((nnimap "Qsdfgh"
                                              (nnimap-stream ssl)
                                              (nnimap-address ,(-secret-gnus-imap "server1"))
                                              (nnimap-inbox "INBOX")
                                              (nnimap-split-methods default)
                                              (nnimap-expunge-on-close 'always)
                                              (nnir-search-engine imap))
                                      (nnimap "Gmail"
                                              (nnimap-stream ssl)
                                              (nnimap-address ,(-secret-gnus-imap "server2"))
                                              (nnimap-server-port 993)
                                              (nnimap-inbox "INBOX")
                                              (nnimap-split-methods default)
                                              (nnimap-expunge-on-close 'always)
                                              (nnir-search-engine imap))))

;; SMTP
(defun set-smtp-server (name domain)
  (let ((addr (-secret-gnus-addr name))
        (server (-secret-gnus-smtp name)))
    (setq user-mail-address addr
          message-send-mail-function 'smtpmail-send-it
          smtpmail-starttls-credentials `((,server 25 nil nil))
          smtpmail-auth-credentials `((,server 25 ,addr nil))
          smtpmail-default-smtp-server server
          smtpmail-smtp-server server
          smtpmail-smtp-service 25
          smtpmail-local-domain domain)))

(add-hook 'message-mode-hook
          '(lambda ()
             (cond
              ((string-match "Qsdfgh" gnus-newsgroup-name) (set-smtp-server "server1" "qsdfgh.com"))
              ((string-match "Gmail" gnus-newsgroup-name) (set-smtp-server "server2" "gmail.com"))
              ((t (error "No SMTP server to select"))))))

;;; gnus.el ends here
