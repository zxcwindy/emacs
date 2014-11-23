(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(case-fold-search t)
 '(coffee-tab-width 4)
 '(custom-enabled-themes (quote (sanityinc-solarized-light)))
 '(custom-safe-themes (quote ("d55c0b7612a1c63e5e12f9778b8a59effb87044ab61f1617440e577257f0d851" "3d3515bcc0814b287185d678519172a3927b25ed33d1dc77454503ade606f3a2" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" default)))
 '(desktop-globals-to-save (quote (desktop-missing-file-warning)))
 '(desktop-path (quote ("~/.emacs.d/")))
 '(display-time-mode t)
 '(ecb-options-version "2.40")
 '(js2-idle-timer-delay 2.5)
 '(linum-format (quote dynamic))
 '(make-backup-files nil)
 '(minimap-dedicated-window t)
 '(minimap-window-location (quote right))
 '(org-todo-keywords (quote ((sequence "TODO" "DOING" "DONE"))))
 '(outline-minor-mode-prefix (kbd "C-;"))
 '(recentf-max-saved-items 400)
 '(safe-local-variable-values (quote ((checkdoc-minor-mode . t) (Base . 10) (Syntax . ANSI-Common-Lisp) (require-final-newline . t))))
;; '(session-use-package t nil (session))
 '(size-indication-mode t)
 '(sr-speedbar-right-side nil)
 '(tool-bar-mode nil)
 '(truncate-partial-width-windows nil)
 '(url-show-status nil)
 '(w3m-home-page "http://10.95.239.158:8080/log.html"))
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
	  "~/.emacs.d/el/base"
	  "~/.emacs.d/el/dev"
	  "/usr/share/emacs/site-lisp/mu4e"
	  ;;"~/.emacs.d/jdee-2.4.1/lisp"
	  ;; "~/.emacs.d/swank-js"
	  "~/git/ecb"
	  ))

;;用服务的方式启动
(require 'el-server)

(require 'init-utils)

;;swank-js
;;(require 'slime-js)

(require 'el-package)

(require 'el-slime)
(global-set-key "\C-hj" 'slime-hyperspec-lookup)

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

(require 'el-mutiple-cursors)
(global-set-key (kbd "C-c o") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c O") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c c o") 'mc/mark-all-next-like-this)
(global-set-key (kbd "C-c c O") 'mc/mark-all-prev-like-this)
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
(global-set-key (kbd "M-w") 'zxc-copy-line-or-region)
(global-set-key (kbd "C-; y") 'zxc-delete-and-yank)
(global-set-key (kbd "C-; x") 'zxc-delete-current-word)
(global-set-key (kbd "<up>")    'move-text-up)
(global-set-key (kbd "<down>")  'move-text-down)
;; (global-set-key (kbd "<left>")  'tabbar-backward-tab)
;; (global-set-key (kbd "<right>") 'tabbar-forward-tab)
(global-set-key (kbd "C-z") 'shell)
(global-set-key (kbd "C-,") 'zxc-point-to-register)
(global-set-key (kbd "C-.") 'zxc-point-to-jump)
(global-set-key (kbd "C-c .") 'ska-jump-to-register)
(global-set-key (kbd "<left>") 'scroll-right)
(global-set-key (kbd "<right>") 'scroll-left)
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
(global-set-key (kbd "<f2> c") 'calendar)
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
(global-set-key "\M-;" 'qiang-comment-dwim-line)
(define-key org-mode-map (kbd "C-'") nil)
(define-key org-mode-map (kbd "C-c SPC") nil)
(add-hook 'shell-mode-hook #'(lambda ()
			       (define-key shell-mode-map (kbd "C-c SPC") nil)
			       (disable-paredit-mode)))
(require 'zxc-db-ac)

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
;;			 (interactive)
;;			 (ecb-minor-mode)))
;; (load "jde")
;; (require 'minimap)
;; (global-set-key [f6] #'(lambda ()
;;			 (interactive)
;;			 (if (null minimap-bufname)
;;			     (minimap-create)
;;			   (minimap-kill))))
(defvar is-alpha nil)
(global-set-key [f6] #'(lambda ()
			 (interactive)
			 (if is-alpha
			     (progn
			       (set-frame-parameter (selected-frame) 'alpha '(100 100))
			       (setf is-alpha nil))
			   (set-frame-parameter (selected-frame) 'alpha '(35 40))
			   (setf is-alpha t))))

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
(global-set-key (kbd "M-<backspace>") 'mu4e)

(require 'shell-here)
(global-set-key (kbd "C-c C-z") 'shell-here)

(require 'move-text)

(require 'shell-session-keep)
(shell-session-keep)
(setf shell-session-keep-filter-names (list "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"))

(require 'el-kbd)

(require 'my-yas-var)


(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

;; (require 'page-break-lines)
(global-page-break-lines-mode)

(require 'csv-mode)

(require 'zxc-theme)
(require 'zxc-httpd)
(require 'zxc-cedet-ecb)
