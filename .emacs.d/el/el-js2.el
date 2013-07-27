(require 'js2-mode)
(require 'js2-refactor)

(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;swank.js
;;(global-set-key [f6] 'slime-js-reload)
(add-hook 'js2-mode-hook
	  (lambda ()
	    ;; (slime-js-minor-mode 1)
	    (global-set-key (kbd "C-; C-a") 'js2-mode-show-all)
	    (global-set-key (kbd "C-; C-d") 'js2-mode-hide-element)
	    (global-set-key (kbd "C-; C-s") 'js2-mode-show-element)
	    (global-set-key (kbd "C-; C-q") 'js2-mode-toggle-hide-functions)))

;; (add-hook 'css-mode-hook
;; 	  (lambda ()
;; 	    (define-key css-mode-map "\M-\C-x" 'slime-js-refresh-css)
;; 	    (define-key css-mode-map "\C-c\C-r" 'slime-js-embed-css)))

(provide 'el-js2)
