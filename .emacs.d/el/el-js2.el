(require 'js2-mode)
(require 'js2-refactor)

;;(autoload 'js2-mode "js2" nil t)
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
;;	  (lambda ()
;;	    (define-key css-mode-map "\M-\C-x" 'slime-js-refresh-css)
;;	    (define-key css-mode-map "\C-c\C-r" 'slime-js-embed-css)))
(modify-syntax-entry ?_ "w" js2-mode-syntax-table)

(defun json-format ()
  "格式化json"
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point) "jq ." (buffer-name) t)))

(after-load 'coffee-mode
  (define-key coffee-mode-map (kbd  "C-c C-,") #'coffee-indent-shift-left)
  (define-key coffee-mode-map (kbd  "C-c C-.") #'coffee-indent-shift-right)
  (define-key coffee-mode-map (kbd "C-j") 'coffee-newline-and-indent))

(setq whitespace-action '(auto-cleanup))
(setq whitespace-style '(trailing space-before-tab indentation empty space-after-tab))
(setq global-whitespace-mode t)
(custom-set-variables '(coffee-tab-width 4))
(setq coffee-args-compile '("-c" "-m" ""))

(provide 'el-js2)
