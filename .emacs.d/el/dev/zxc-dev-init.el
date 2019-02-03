(require 'projectile)
(eval-after-load "projectile"
  '(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(require 'zxc-magit)

(require 'zxc-service-remote-shell)

(eval-after-load "emmet-mode"
  '(define-key emmet-mode-keymap (kbd "C-j") 'electric-newline-and-maybe-indent))

(provide 'zxc-dev-init)
