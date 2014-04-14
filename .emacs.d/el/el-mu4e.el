(require 'mu4e)
(require 'org-mu4e)
(require 'smtpmail)

(setq mu4e-maildir "~/.mail/asiainfo"
      mu4e-sent-folder "/Sent"
      mu4e-drafts-folder "/Draft"
      mu4e-trash-folder "/Trash"
      mu4e-get-mail-command "offlineimap"
      mu4e-view-show-images t
      mu4e-html2text-command "w3m -dump -T text/html"
      mu4e-view-prefer-html t)

;; show images
(setq
 mu4e-show-images t
 mu4e-view-show-images t
 mu4e-view-image-max-width 800)

;; Use fancy chars
(setq mu4e-use-fancy-chars t)

;; convert org mode to HTML automatically
(setq org-mu4e-convert-to-html t)

;;gmail
;; (setq
;;  user-mail-address "david.c.aq@gmail.com"
;;  user-full-name "zhengxc")

;; (setq message-send-mail-function 'smtpmail-send-it
;;             smtpmail-stream-type 'starttls
;;             smtpmail-default-smtp-server "smtp.gmail.com"
;;             smtpmail-smtp-server "smtp.gmail.com"
;;             smtpmail-smtp-service 587)

(setq
 user-mail-address "zhengxc@asiainfo-linkage.com"
 user-full-name "zhengxc")

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-stream-type nil
      smtpmail-default-smtp-server "mail.asiainfo-linkage.com"
      smtpmail-smtp-server "mail.asiainfo-linkage.com")

;; (setq mu4e-maildir-shortcuts
;;           '( ("/gmail/INBOX"               . ?i)
;;              ("/gmail/[Gmail].IMPORTANT"   . ?!)
;;              ;; ("/gmail/[Gmail].Sent Mail"   . ?s)
;;              ;; ("/gmail/[Gmail].Trash"       . ?t)
;;              ("/gmail/[Gmail].All Mail"    . ?a)))

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

(provide 'el-mu4e)
