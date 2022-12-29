(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(auth-source-save-behavior nil)
 '(beacon-color "#dc322f")
 '(case-fold-search t)
 '(coffee-tab-width 4)
 '(custom-safe-themes
   '("4b137a22ad4b2796afbeee80afb9ef0fab18c2440689249ebfcf7621914eb90a" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" default))
 '(delete-by-moving-to-trash t)
 '(desktop-globals-to-save '(desktop-missing-file-warning))
 '(desktop-path '("~/.emacs.d/"))
 '(display-time-mode t)
 '(ecb-options-version "2.40")
 '(fci-rule-color "#eee8d5")
 '(frame-background-mode 'dark)
 '(js-indent-level 2)
 '(js2-idle-timer-delay 2.5)
 '(linum-format 'dynamic)
 '(lsp-auto-guess-root t)
 '(make-backup-files nil)
 '(minimap-dedicated-window t)
 '(minimap-window-location 'right)
 '(org-agenda-files nil)
 '(org-todo-keywords '((sequence "TODO" "DOING" "DONE")))
 '(outline-minor-mode-prefix (kbd "C-;"))
 '(package-selected-packages
   '(mu4e-alert polymode ov company-tabnine orderless helm-lsp exec-path-from-shell typescript-mode ox-hugo json-mode org-roam-timestamps org-modern org-download bash-completion valign gnu-elpa-keyring-update flymake-shellcheck go-mode lsp-java helm-org-rifle editorconfig org-mind-map tide delight treemacs-projectile treemacs company-lsp lsp-ui lsp-mode helm helm-core ztree zenburn-theme yaml-mode whitespace-cleanup-mode websocket web-mode vue-mode vlf tramp-hdfs tle time-ext theme-changer sudo-edit subatomic-enhanced-theme ssh smex slime shell-here scss-mode sass-mode rainbow-mode rainbow-delimiters projectile php-mode peek-mode paredit page-break-lines oauth2 nginx-mode n4js multi-web-mode move-text minimap magit lua-mode look-mode logstash-conf less-css-mode js2-refactor js-doc js-comint jquery-doc ipcalc impatient-mode hive groovy-mode graphviz-dot-mode gradle-mode google-maps fullscreen-mode flymake-jslint flycheck-package expand-region ess-R-data-view es-mode erlang ensime elpy docker dired-details csv-mode crontab-mode concurrent color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized color-theme archive-rpm apache-mode anything angular-snippets ag ac-js2 ac-emmet))
 '(recentf-max-saved-items 400)
 '(safe-local-variable-values
   '((encoding . utf-8)
     (checkdoc-minor-mode . t)
     (Base . 10)
     (Syntax . ANSI-Common-Lisp)
     (require-final-newline . t)))
 '(session-use-package t nil (session))
 '(size-indication-mode t)
 '(sr-speedbar-right-side nil)
 '(tool-bar-mode nil)
 '(truncate-partial-width-windows nil)
 '(undo-outer-limit 52428800)
 '(url-show-status nil)
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   '((20 . "#dc322f")
     (40 . "#cb4b16")
     (60 . "#b58900")
     (80 . "#859900")
     (100 . "#2aa198")
     (120 . "#268bd2")
     (140 . "#d33682")
     (160 . "#6c71c4")
     (180 . "#dc322f")
     (200 . "#cb4b16")
     (220 . "#b58900")
     (240 . "#859900")
     (260 . "#2aa198")
     (280 . "#268bd2")
     (300 . "#d33682")
     (320 . "#6c71c4")
     (340 . "#dc322f")
     (360 . "#cb4b16")))
 '(vc-annotate-very-old-color nil)
 '(w3m-home-page "http://10.95.239.158:8080/log.html")
 '(warning-suppress-log-types '((lsp-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0))))
 '(ctbl:face-cell-select ((t (:background "cyan"))))
 '(ctbl:face-row-select ((t (:background "light gray"))))
 '(ediff-current-diff-A ((t (:background "#553333" :foreground "white"))))
 '(ediff-current-diff-B ((t (:background "#335533" :foreground "white"))))
 '(ediff-current-diff-C ((t (:background "#888833" :foreground "white"))))
 '(magit-blame-highlight ((t (:foreground "white" :background "grey60"))))
 '(magit-diff-context-highlight ((t (:background "cornsilk" :foreground "grey70"))))
 '(region ((t (:foreground "#AA8E16" :inverse-video t))))
 '(smerge-refined-added ((t (:inherit smerge-refined-change :background "#22aa22" :foreground "white"))))
 '(smerge-refined-removed ((t (:inherit smerge-refined-change :background "#aa2222" :foreground "white"))))
 '(web-mode-html-attr-equal-face ((t (:foreground "#657B83"))))
 '(web-mode-html-attr-name-face ((t (:foreground "#6c71c4"))))
 '(web-mode-html-attr-value-face ((t (:foreground "#2aa198"))))
 '(web-mode-html-tag-bracket-face ((t (:foreground "#657B83"))))
 '(web-mode-html-tag-face ((t (:foreground "#b58900")))))

;;------------
;;加载插件位置
(mapc #'(lambda (path)
	  (add-to-list 'load-path path))
      '("~/.emacs.d/el"
	"~/.emacs.d/el/base"
	"~/.emacs.d/el/dev"
	"~/.emacs.d/el/dev/zxc-template"
	"/opt/mu-1.8.11/share/emacs/site-lisp/mu4e"
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

;;(require 'el-slime)
;;(global-set-key "\C-hj" 'slime-hyperspec-lookup)

(require 'yasnippet)
(yas-global-mode 1)

(require 'auto-complete)

;;(require 'undo-tree)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(require 'auto-complete-config)
;; (ac-config-default)

(require 'el-js2)

(require 'el-js-comint)

(require 'zxc)
(add-hook 'zxc-mode-hook #'comet-disconnect)

(require 'openwith)
(openwith-mode t)

(require 'el-paredit)

(require 'session)
(setq session-save-file "~/.emacs.d/.session")

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


;; (global-set-key (kbd "C-o") 'switch-to-buffer)

(require 'vc-svn)
;;(require 'dsvn)
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
(global-set-key (kbd "C-; x") 'zxc-copy-f-other-t-point)
(global-set-key (kbd "<up>")    'move-text-up)
(global-set-key (kbd "<down>")  'move-text-down)
;; (global-set-key (kbd "<left>")  'tabbar-backward-tab)
;; (global-set-key (kbd "<right>") 'tabbar-forward-tab)
(global-set-key (kbd "C-z") 'shell)
(global-set-key (kbd "C-c ,") 'zxc-point-to-register)
(global-set-key (kbd "C-,") 'zxc-point-to-jump)
(global-set-key (kbd "C-c .") 'ska-jump-to-register)
(global-set-key (kbd "<left>") 'scroll-right)
(global-set-key (kbd "<right>") 'scroll-left)
(global-set-key (kbd "C-h") 'kill-whole-line)
(global-set-key (kbd "C-M-i") 'scroll-other-window-down)
;; (global-set-key (kbd "C-x C-; m") 'browse-url-at-point)
(global-set-key (kbd "ESC M-%") 'query-replace-regexp)
(global-set-key (kbd "C-w") 'my-delete-or-kill)
(global-set-key (kbd "M-h") 'my-mark-paragraph)
(global-set-key (kbd "C-x k") #'(lambda ()
				  (interactive)
				  (kill-buffer (current-buffer))))
(global-set-key (kbd "C-; C-;") 'global-zxc-mode)
(global-set-key (kbd "<f2> m") 'rename-buffer)
(global-set-key (kbd "<f2> c") 'calendar)
(global-set-key (kbd "<f2> p") #'(lambda ()
				   (interactive)
				   (if (eq major-mode 'dired-mode)
				       (kill-new (dired-current-directory))
				     (kill-new (buffer-file-name)))))

(global-set-key (kbd "C-c j") 'join-line)
(global-set-key [f5] #'(lambda ()
			 (interactive)
			 (revert-buffer :noconfirm t)))
(global-set-key (kbd "C-+") 'zxc-set-font-size)

(require 'js2-refactor)
(js2r-add-keybindings-with-prefix  "C-c m")

(require 'zxc-init)
(global-set-key (kbd "C-c f")  'indent-whole)
(global-set-key (kbd "C-x C-f")  'zxc-find-file)
(global-set-key (kbd "C-x C-<f6>")  'pop-global-mark)
(global-set-key "\M-;" 'qiang-comment-dwim-line)
(define-key org-mode-map (kbd "C-'") nil)
(define-key org-mode-map (kbd "C-c SPC") nil)
(add-hook 'shell-mode-hook #'(lambda ()
			       (define-key shell-mode-map (kbd "C-c SPC") nil)
			       (disable-paredit-mode)))

(global-set-key (kbd "C-'") #'(lambda ()
				(interactive)
				(switch-to-buffer (other-buffer))))
(global-set-key (kbd "M-<backspace>") 'zxc-navigate-buffer)

(require 'zxc-db-ac)

;; (require 'magit)
(global-set-key (kbd "C-<backspace>")  'magit-status)
;;(require 'w3m)

;;zen coding
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'nxml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook 'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode)
(setq auto-mode-alist (cons '(".jsp$" . html-mode) auto-mode-alist))

(autoload 'ace-jump-mode "ace-jump-mode" "Emacs quick move minor mode" t)
(autoload 'ace-jump-mode-pop-mark "ace-jump-mode" "Ace jump back:-)" t)
;; (eval-after-load "ace-jump-mode" '(ace-jump-mode-enable-mark-sync))
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
			   (set-frame-parameter (selected-frame) 'alpha '(65 40))
			   (setf is-alpha t))))

;; (require 'browse-kill-ring)
;; (global-set-key (kbd "C-c k") 'browse-kill-ring)

(require 'helm-config)
(global-set-key (kbd "C-c h") 'helm-mini)
;;; auto-rever-tail-mode
;;; follow-mode

(require 'treemacs-projectile)
(require 'zxc-projectile)
(global-set-key [f7] 'docker-containers)

;; (require 'edbi)

(require 'zxc-remote)

(require 'el-ibus)
;; (global-set-key [f12] 'el-ibus-on-off)

;; (require 'el-mu4e)
(require 'zxc-mu4e)
(global-set-key [f12] #'(lambda ()
			  (interactive)
			  (mu4e~headers-jump-to-maildir "/Bmsoft/INBOX")))
(global-set-key (kbd "C-x m") 'mu4e-compose-new)

(require 'shell-here)
(global-set-key (kbd "C-; C-z") #'(lambda ()
				    (interactive)
				    (let ((projectile-require-project-root nil))
				      (shell-here))))

(require 'move-text)

;;; 用ssh config替代
;; (require 'shell-session-keep)
;; (shell-session-keep)
;; (setf shell-session-keep-filter-names (list "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"))

(require 'el-kbd)

(require 'my-yas-var)


(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

;; (require 'page-break-lines)
;; (global-page-break-lines-mode)

(require 'csv-mode)
;;desktop
;;(desktop-read)
(desktop-save-mode 1)

(require 'zxc-httpd)
;; (require 'zxc-cedet-ecb)
(require 'vlf-setup)
(put 'erase-buffer 'disabled nil)

;; (projectile-global-mode)

(mapc (lambda (mode-hook)
	(add-hook mode-hook 'projectile-mode))
      (list 'java-mode-hook 'js-mode-hook 'javascript-mode-hook))

;; (require 'zxc-indent)

(session-initialize)

(require 'zxc-dev-init)
(require 'el-smerge)
(put 'dired-find-alternate-file 'disabled nil)
(require 'zxc-html)
(require 'zxc-elasticsearch)

(require 'n4js)
(setq n4js-cli-program "~/opt/neo4j-community-3.2.2/bin/cypher-shell")
(setq n4js-cli-arguments '("-u" "neo4j" "-p" "md999"))


;; (require 'zxc-python)

(setf es-always-pretty-print t)

(require 'zxc-eaf)
(require 'zxc-ibuffer)
(require 'zxc-template)
(require 'zxc-sql)
(require 'zxc-markdown)
(require 'zxc-ft)
(require 'zxc-proxy)
(require 'zxc-helm)
(require 'zxc-org)
(require 'zxc-lsp)
(global-set-key (kbd "C-; t") 'zxc-ft)

(make-thread #'(lambda () (zxc-shell-command "jetty")))
(make-thread #'(lambda () (zxc-shell-command "gost")))
(make-thread #'mu4e)
;; (add-hook 'kill-emacs-hook #'(lambda () (zxc-shell-command "close-gost-server")))

;; (setq auto-revert-buffer-list-filter
;;       'magit-auto-revert-repository-buffers-p)

;;全屏
;; (fullscreen-mode-fullscreen)

(require 'zxc-quick-marco)
(require 'zxc-mybaits)

(require 'zxc-theme)
;;; The emacs-startup-hook runs later than the after-init-hook
;; (zxc-change-theme 'sanityinc-solarized-light 'zxc-misterioso)
(add-hook 'emacs-startup-hook '(lambda ()
				 ;; (session-initialize)
				 ;; (disable-theme 'sanityinc-solarized-light)
				 ;; (disable-theme 'zxc-misterioso)
				 (zxc-change-theme 'sanityinc-solarized-light 'zxc-misterioso)))
