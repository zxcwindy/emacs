(require 'helm-config)

(helm-mode 0)

(setq helm-split-window-inside-p t
      helm-move-to-line-cycle-in-source t)

(global-set-key (kbd "C-x r b") 'helm-bookmarks)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c k") 'helm-show-kill-ring)

(provide 'zxc-helm)
