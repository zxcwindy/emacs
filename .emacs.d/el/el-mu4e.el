(require 'mu4e)
(require 'org-mu4e)

(setq mu4e-maildir "/home/asiainfo/.local/share/local-mail"
      mu4e-sent-folder "/发件箱/"
      mu4e-drafts-folder "/草稿/"
      mu4e-trash-folder "/废件夹/"
      mu4e-get-mail-command t ;;mu4e不调用接受邮件命令
      mu4e-view-show-images t
      mu4e-html2text-command "w3m -dump -T text/html"
      mu4e-view-prefer-html t)

(provide 'el-mu4e)
