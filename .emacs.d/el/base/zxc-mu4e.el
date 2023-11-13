(require 'mu4e)
(require 'smtpmail)
(require 'mm-util)
(require 'mu4e-alert)

;;; 如何写邮件
;; https://www.djcbsoftware.nl/code/mu/mu4e/Writing-messages.html
;;; 参考配置
;; https://github.com/munen/emacs.d#mu4e
;;; 插入图片disposition=inline
;; <#part type="image/png" filename="~/Pictures/2048.png" disposition=inline>
;; <#/part>

(setq mu4e-sent-folder   "/Bmsoft/sent"
      mu4e-drafts-folder "/Bmsoft/drafts"
      mu4e-trash-folder  "/Bmsoft/trash"
      mu4e-refile-folder "/Bmsoft/Archive"
      ;; sync email from imap server
      mu4e-get-mail-command "offlineimap"
      mu4e-update-interval 1200
      mu4e-compose-signature-auto-include t)

;; (setq mu4e-views-default-view-method "html")

(with-eval-after-load "mm-decode"
  (add-to-list 'mm-discouraged-alternatives "text/html")
  (add-to-list 'mm-discouraged-alternatives "text/richtext"))

(setq mu4e-maildir-shortcuts
      '(("/Bmsoft/INBOX"             . ?i)
	("/Bmsoft/drafts"             . ?d)
	("/Bmsoft/sent"             . ?s)
	("/Bmsoft/trash"             . ?t)))

(setq mu4e-headers-fields
      '((:date . 18)
	(:flags . 6)
	;; (:maildir . 10)
	(:from-or-to . 20)
	(:subject)))

(setq
 user-mail-address "zhengxiaochang@bmsoft.com.cn"
 user-full-name "郑晓畅"
 message-signature
 (concat
  "郑晓畅|大数据产品部|北明软件有限公司 \n"
  "Mobile ：13668292628|TEL:028-62108598 \n"
  "E-mail：zhengxiaochang@bmsoft.com.cn \n"
  "网址：www.bmsoft.com.cn \n"
  "总部地址：北京市石景山区永引渠南路18号互联网+文化创业园 \n"
  "成都地址：四川省成都市高新区蜀锦路88号1栋二单位楚峰国际中心4202室"))




(setq message-send-mail-function 'smtpmail-send-it
      starttls-use-gnutls t
      smtpmail-default-smtp-server "smtp.263.net"
      smtpmail-smtp-server "smtp.263.net"
      smtpmail-smtp-service 25
      smtpmail-local-domain "ng.org.cn"
      smtpmail-smtp-user "zhengxiaochang@bmsoft.com.cn"
      smtpmail-debug-info t
      mu4e-compose-signature message-signature)

;;; C-c RET C-a
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)
;;; disable openwith
(add-to-list 'mm-inhibit-file-name-handlers 'openwith-file-handler)
;;; 增加提示
(add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)

(provide 'zxc-mu4e)
