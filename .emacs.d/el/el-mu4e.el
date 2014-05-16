(require 'mu4e)
(require 'org-mu4e)
(require 'smtpmail)

(setq mu4e-maildir "~/.mail/asiainfo"
      mu4e-sent-folder "/Sent"
      mu4e-drafts-folder "/Draft"
      mu4e-trash-folder "/Trash"
      mu4e-get-mail-command "offlineimap"
      mu4e-update-interval 300
      mu4e-view-show-images t
      mu4e-view-image-max-width 800
      mu4e-html2text-command "w3m -dump -T text/html"
      mu4e-view-prefer-html t
      mu4e-headers-auto-update nil)

(setq mu4e-maildir-shortcuts
      '( ("/INBOX" . ?i)
	 ("/Sent"  . ?s)))

(add-to-list 'mu4e-view-actions
	     '("ViewInBrowser" . mu4e-action-view-in-browser) t) 

(setq mu4e-headers-fields
      '((:date . 18)
        (:flags . 6)
        (:maildir . 10)
        (:from-or-to . 20)
        (:subject)))

(setq mail-user-agent 'mu4e-user-agent)

;; Use fancy chars
(setq mu4e-use-fancy-chars nil)

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
 user-full-name "zhengxc"
 message-signature
 (concat
  "郑晓畅 \n"
  "亚信联创科技（成都）有限公司 \n"
  "四川省成都市高新区高朋大道3号东方希望科研楼12层\n"
  "Email: zhengxc@asiainfo-linkage.com\n"
  "Tel: 13668292628"))

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-stream-type nil
      smtpmail-default-smtp-server "mail.asiainfo-linkage.com"
      smtpmail-smtp-server "mail.asiainfo-linkage.com")

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

(defun mu4e-message (frm &rest args)
  )

(provide 'el-mu4e)
