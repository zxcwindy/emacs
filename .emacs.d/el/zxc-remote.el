;;; tramp password policy
(setq password-cache-expiry nil)

(require 'drkm-fav)
(setq drkm-fav:favourite-directories-alist
      '(("aiods" . "/aiods@10.109.1.8:/export/home/aiods")
	("aiapp" . "/aiapp@10.109.1.8:/export/home/aiapp")))

(provide 'zxc-remote)
