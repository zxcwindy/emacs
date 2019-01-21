(require 'projectile)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(require 'zxc-magit)

(require 'zxc-service-remote-shell)

(message "load zxc-dev-init")

(provide 'zxc-dev-init)
