(require 'livedown)


(eval-after-load "markdown-mode"
  '(progn
     (define-key markdown-mode-map (kbd "C-c C-v") 'livedown-preview)
     (add-hook 'kill-buffer-hook 'livedown-kill)))

(provide 'zxc-markdown)
