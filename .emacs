(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (misterioso)))
 '(desktop-path (quote ("~/.emacs.d/")))
 '(ecb-options-version "2.40")
 '(js2-idle-timer-delay 2.5)
 '(linum-format (quote dynamic))
 '(make-backup-files nil)
 '(minimap-dedicated-window t)
 '(minimap-window-location (quote right))
 '(outline-minor-mode-prefix (kbd "C-;"))
 '(recentf-max-saved-items 400)
 '(safe-local-variable-values (quote ((Base . 10) (Syntax . ANSI-Common-Lisp) (require-final-newline . t))))
 '(send-mail-function (quote mailclient-send-it))
 ;; '(session-use-package t nil (session))
 '(size-indication-mode t)
 '(sr-speedbar-right-side nil)
 '(tool-bar-mode nil)
 '(truncate-partial-width-windows nil)
 '(url-show-status nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;------------
;;加载插件位置
(mapcar #'(lambda (path)
	    (add-to-list 'load-path path))
	'("~/.emacs.d/el"
	  "~/.emacs.d/slime"
	  "/usr/local/share/emacs/site-lisp/mu4e"
	  ;;"~/.emacs.d/jdee-2.4.1/lisp"
	  ;; "~/.emacs.d/swank-js"
	  ))

;;用服务的方式启动
(require 'el-server)

(require 'el-slime)
(global-set-key "\C-hj" 'slime-hyperspec-lookup)

;;swank-js
;;(require 'slime-js)

(require 'el-package)

(require 'yasnippet)
(yas-global-mode 1)

(require 'auto-complete)
(require 'expand-region)
;;(require 'undo-tree)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(require 'auto-complete-config)
(ac-config-default)

(require 'el-js2)
(add-hook 'js2-mode-hook
	  '(lambda () 
	     (local-set-key "\C-c\C-c" 'js-send-last-sexp)
	     (local-set-key "\C-c\C-r" 'js-send-region)
	     (local-set-key "\C-cb" 'js-send-buffer)
	     (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
	     (local-set-key "\C-cl" 'node-load-file)))

(require 'el-js-comint)

(require 'session)
(setq session-save-file "~/.emacs.d/.session")
(add-hook 'after-init-hook 'session-initialize)

(require 'zxc)
(add-hook 'zxc-mode-hook #'comet-disconnect)

(require 'openwith)
(openwith-mode t)

(require 'el-paredit)

;;desktop
(desktop-save-mode 1)
;;(desktop-read)

;; (require 'tabbar)
;; (tabbar-mode 1)

(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(require 'ido)
(ido-mode t)

(require 'el-dired)

(require 'multiple-cursors)
(global-set-key (kbd "C-c o") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c O") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-x b") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c c r") 'set-rectangular-region-anchor)
(global-set-key (kbd "C-c c c") 'mc/edit-lines)
(global-set-key (kbd "C-c c e") 'mc/edit-ends-of-lines)
(global-set-key (kbd "C-c c a") 'mc/edit-beginnings-of-lines)

(global-set-key (kbd "C-o") 'switch-to-buffer)

(require 'vc-svn)
(require 'dsvn)
(autoload 'svn-status "dsvn" "Run `svn status'." t)
(autoload 'svn-update "dsvn" "Run `svn update'." t)

;;-----------
;;自定义快捷键
(global-set-key [C-f6] 'set-mark-command)
(global-set-key (kbd "C-x C-<f6>") 'pop-global-mark)
(global-set-key [f1] 'help-command)
(global-set-key (kbd "M-RET") 'cua-mode)
(global-set-key (kbd "C-; w") 'zxc-copy-word-at-point)
(global-set-key (kbd "C-; r") 'zxc-copy-line-at-point)
(global-set-key (kbd "C-; y") 'zxc-delete-and-yank)
(global-set-key (kbd "C-; x") 'zxc-delete-current-word)
(global-set-key (kbd "<up>")    'tabbar-backward-group)
(global-set-key (kbd "<down>")  'tabbar-forward-group)
(global-set-key (kbd "<left>")  'tabbar-backward-tab)
(global-set-key (kbd "<right>") 'tabbar-forward-tab)
(global-set-key (kbd "C-z") 'shell)
(global-set-key [f11] 'my-fullscreen)
(global-set-key (kbd "C-,") 'zxc-point-to-register)
(global-set-key (kbd "C-.") 'zxc-point-to-jump)
(global-set-key (kbd "C-c .") 'ska-jump-to-register)
(global-set-key (kbd "S-<left>") 'scroll-right)
(global-set-key (kbd "S-<right>") 'scroll-left)
(global-set-key (kbd "C-h d") 'kill-whole-line)
(global-set-key (kbd "C-M-i") 'scroll-other-window-down)
(global-set-key (kbd "C-x C-; m") 'browse-url-at-point)
(global-set-key (kbd "ESC M-%") 'query-replace-regexp)
(global-set-key (kbd "C-w") 'my-delete-or-kill)
(global-set-key (kbd "M-h") 'my-mark-paragraph)
(global-set-key (kbd "C-x k") #'(lambda ()
				  (interactive)
				  (kill-buffer (current-buffer))))
(global-set-key (kbd "C-; C-;") 'zxc-mode)
(global-set-key (kbd "<f2> m") 'rename-buffer)
(global-set-key (kbd "C-'") #'(lambda ()
				(interactive)
				(switch-to-buffer (other-buffer))))
(global-set-key (kbd "C-c j") 'join-line)
(global-set-key [f5] #'(lambda ()
			 (interactive)
			 (revert-buffer :noconfirm t)))

(require 'js2-refactor)
(js2r-add-keybindings-with-prefix  "C-c m")

(require 'zxc-init)
(global-set-key (kbd "C-c f")  'indent-whole)
(global-set-key (kbd "C-x C-<f6>")  'pop-global-mark)
(define-key org-mode-map (kbd "C-'") nil)
(define-key org-mode-map (kbd "C-c SPC") nil)
(add-hook 'shell-mode-hook #'(lambda ()
			       (define-key shell-mode-map (kbd "C-c SPC") nil)
			       (disable-paredit-mode)))

(require 'magit)
(global-set-key (kbd "C-<backspace>")  'magit-status)
;;(require 'w3m)

;;zen coding
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'nxml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(setq auto-mode-alist (cons '(".jsp$" . html-mode) auto-mode-alist))

(autoload 'ace-jump-mode "ace-jump-mode" "Emacs quick move minor mode" t)
(autoload 'ace-jump-mode-pop-mark "ace-jump-mode" "Ace jump back:-)" t)
(eval-after-load "ace-jump-mode" '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

(autoload 'idomenu "idomenu" nil t)
(define-key global-map (kbd "C-x C-i") 'idomenu)

;;; not very insteresting
;; (require 'ecb)
;; (global-set-key [f7] #'(lambda ()
;; 			 (interactive)
;; 			 (ecb-minor-mode)))
;; (load "jde")
(require 'minimap)
(global-set-key [f6] #'(lambda ()
			 (interactive)
			 (if (null minimap-bufname)
			     (minimap-create)
			   (minimap-kill))))

(require 'browse-kill-ring)
(global-set-key (kbd "C-c k") 'browse-kill-ring)

(require 'helm-config)
(global-set-key (kbd "C-c h") 'helm-mini)
;;; auto-rever-tail-mode
;;; follow-mode

(require 'sr-speedbar)
(global-set-key [f7] 'sr-speedbar-toggle)

(require 'edbi)

(require 'zxc-remote)

(require 'el-ibus)
(global-set-key [f12] 'el-ibus-on-off)

(require 'el-mu4e)

(require 'shell-here)
(global-set-key (kbd "C-c C-z") 'shell-here)

(require 'move-text)
(move-text-default-bindings)

(require 'shell-session-keep)
(shell-session-keep)
(setf shell-session-keep-filter-names (list "158" "118" "134" "166"))

(load-theme 'misterioso)
