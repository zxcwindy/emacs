(add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-application-framework/")

(require 'eaf)
;; (require 'eaf-file-sender)
;; (require 'eaf-image-viewer)
;; (require 'eaf-mindmap)
;; (require 'eaf-airshare)
(require 'eaf-browser)

;; (define-key eaf-mode-map (kbd "C-o") 'helm-buffers-list)

(setq eaf-browser-continue-where-left-off t)
(setq eaf-browser-dark-mode nil)

;; (global-set-key (kbd "<f2> o") 'eaf-open-browser)


(provide 'zxc-eaf)
