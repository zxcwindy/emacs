;;email client
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)

(require 'mew-w3m)

;; Optional setup (Read Mail menu):
(setq read-mail-command 'mew)

;; Optional setup (e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)

(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))

(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))

(setq mew-pop-delete nil) 

(setq mew-config-alist
      '(("default"
	 ("name"         .  "zhengxc")
	 ("user"         .  "zhengxc")
	 ("smtp-server"  .  "smtp.asiainfo-linkage.com")
	 ("smtp-port"    .  "25")
	 ("pop-server"   .  "mail.asiainfo-linkage.com")
	 ("pop-port"     .  "110")
	 ("smtp-user"    .  "sample")
	 ("pop-user"     .  "zhengxc")
	 ("mail-domain"  .  "asiainfo-linkage.com")
	 ("mailbox-type" .  pop)
	 ("pop-auth"     .  pass)
	 ("smtp-auth-list" . ("PLAIN" "LOGIN" "CRAM-MD5"))
	 )))

(provide 'zxc-email)
