(require 'helm-config)

(helm-mode 1)

(global-set-key (kbd "C-x r b") 'helm-bookmarks)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c k") 'helm-show-kill-ring)

(provide 'zxc-helm)
