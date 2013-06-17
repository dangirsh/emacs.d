;;
;; Look and feel
;;

(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(global-font-lock-mode t)
(transient-mark-mode t)
(set-face-background 'highlight "#333")
(set-face-foreground 'highlight nil)
(global-hl-line-mode t)
(line-number-mode t)
(column-number-mode t)
(display-time)
(set-frame-font "Monospace 11")

;;
;; X mode
;;

(defun transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))

(defun xMode ()
  (message "Setting up X mode ...")

  ;; (require 'color-theme)
  ;; (color-theme-initialize)
  ;; (color-theme-charcoal-black)

  (custom-set-variables '(custom-enabled-themes (quote (deeper-blue))))

  (global-linum-mode t)

  (transparency 95)
)

(if window-system
    (xMode))

(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;;
;; Org-mode
;;

;; Strike done tasks
(setq org-fontify-done-headline t)
(custom-set-faces
 '(org-done ((t (:foreground "PaleGreen"
                             :weight normal
                             :strike-through t))))
 '(org-headline-done
   ((((class color) (min-colors 16) (background dark))
     (:foreground "Grey55" :strike-through t)))))
