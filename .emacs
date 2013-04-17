(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(desktop-save t)
 '(js2-idle-timer-delay 2.5)
 '(make-backup-files nil)
 '(outline-minor-mode-prefix (kbd "C-;"))
 '(safe-local-variable-values (quote ((Base . 10) (Syntax . ANSI-Common-Lisp) (require-final-newline . t))))
 '(send-mail-function (quote mailclient-send-it))
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(truncate-partial-width-windows nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "宋体" :foundry "unknown" :slant normal :weight normal :height 158 :width normal)))))
;;------------
;;用服务的方式启动
(server-start)

;;加载插件位置
(mapcar #'(lambda (path)
	    (add-to-list 'load-path path))
	'("~/.emacs.d/el"
	  "~/.emacs.d/slime"
	  "~/.emacs.d/swank-js"
	  ))

(require 'slime)
(slime-setup)
(global-set-key "\C-hj" 'slime-hyperspec-lookup)
(setq common-lisp-hyperspec-root "/home/asiainfo/api/HyperSpec-7-0/HyperSpec/")

;;swank-js
(require 'slime-js)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(require 'yasnippet)
(yas-global-mode 1)

(setq inferior-lisp-program "/usr/local/bin/sbcl")
;; (setq inferior-lisp-program "/usr/bin/lispworks-personal-6-1-1-x86-linux")

;;js2-mode
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(require 'session)
(add-hook 'after-init-hook 'session-initialize)


;;paredit
(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code."
  t)

;;paredit-hook
(defun my-paredit-mode ()
  (enable-paredit-mode)
  (global-set-key (kbd "C-; C-f") 'paredit-forward)
  (global-set-key (kbd "C-; C-b") 'paredit-backward))
;; (mapcar #'(lambda (x)
;; 	    (add-hook x 'my-paredit-mode))
;; 	'('comint-mode-hook 'lisp-mode-hook))

(desktop-read)

(require 'tabbar)
(tabbar-mode 1)

(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(require 'ido)
(ido-mode t)

;;swank.js
(global-set-key [f6] 'slime-js-reload)
(add-hook 'js2-mode-hook
	  (lambda ()
	    (slime-js-minor-mode 1)
	    (global-set-key (kbd "C-; C-a") 'js2-mode-show-all)
	    (global-set-key (kbd "C-; C-d") 'js2-mode-hide-element)
	    (global-set-key (kbd "C-; C-s") 'js2-mode-show-element)
	    (global-set-key (kbd "C-; C-q") 'js2-mode-toggle-hide-functions)))

(add-hook 'css-mode-hook
	  (lambda ()
	    (define-key css-mode-map "\M-\C-x" 'slime-js-refresh-css)
	    (define-key css-mode-map "\C-c\C-r" 'slime-js-embed-css)))

(add-hook 'sql-interactive-mode-hook 'toggle-truncate-lines)

;;-----------
;;自定义快捷键
(global-set-key [C-f6] 'set-mark-command)
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
(global-set-key (kbd "C-h C-v") 'scroll-other-window)
(global-set-key [f5] 'speedbar)
(global-set-key (kbd "C-x C-; m") 'browse-url-at-point)

;;sql-model-hook
(add-hook 'sql-interactive-mode-hook
	  (function (lambda ()
		      (setq comint-output-filter-functions 'comint-truncate-buffer))))

(require 'js2-refactor)
(js2r-add-keybindings-with-prefix  "C-c m")

;;w3m
;;(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)

(defun get-browse (url  &rest args)
  (if (let ((list '(lisp-interaction-mode lisp-mode)))
	(do* ((lt list (cdr lt))
	      (mode-1 (car lt) (car lt))
	      (mode major-mode))
	    ((or (equal lt nil)
		 (equal mode mode-1))
	     (equal mode mode-1))))
      (w3m-browse-url url args)
    (browse-url-firefox url args)))

(setq browse-url-browser-function #'get-browse)

(setq w3m-use-cookies t)
(setq w3m-coding-system 'utf-8
      w3m-file-coding-system 'utf-8
      w3m-file-name-coding-system 'utf-8
      w3m-input-coding-system 'utf-8
      w3m-output-coding-system 'utf-8
      w3m-terminal-coding-system 'utf-8)
;;-----------------------
;;开启大小写转换和y/n回答
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(fset 'yes-or-no-p 'y-or-n-p)
;;各种配置
(display-time-mode 1)
(pending-delete-mode)

;;------------------
;;关闭边框
(tool-bar-mode -1)
;;(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-linum-mode t)
(auto-image-file-mode t)
;;--------------

;;org模式换行
(add-hook 'org-mode-hook 'turn-on-auto-fill)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;;支持emacs和外部程序的粘贴 
;;(setq x-select-enable-clipboard t)

;;为文本模式打开outline
(add-hook 'text-mode-hook 'my-out-line)
(defun my-out-line()
  (outline-minor-mode t)
  )

;;-------------------
;;修改字体
(set-default-font"-outline-宋体-normal-normal-normal-*-22-*-*-*-p-*-iso8859-1")
;;光标靠近鼠标指针时，让鼠标指针自动让开
(mouse-avoidance-mode 'animate)
;;------------------
;;防止页面滚动时跳动， scroll-margin 3 可以在靠近屏幕边沿
;;3行时就开始滚动，可以很好的看到上下文
(setq scroll-margin 1)
(setq kill-ring-max 200)

;;-----------------------
;;临时记号
;;有时你需要跳到另一个文件进行一些操作，然后很快的跳回来。你当然可以 使用 bookmark或者寄存器。
;;但是这些实在是太慢了。你多想拥有vi那样的 ma, mb, 'a, 'b 的操作。现在你可以用几行 elisp 达到类似的目的
(defun zxc-point-to-register()
  (interactive)
  (point-to-register 0))

(defun zxc-point-to-jump()
  (interactive)
  (ska-point-to-register)
  (point-to-register 2)
  (if (equal (get-register 0) (get-register 2) )
      (jump-to-register 1)
    (set-register 1 (get-register 2))
    (jump-to-register 0)
    )
  )
;; (global-set-key (kbd "C-,") 'ska-point-to-register)
(defun ska-point-to-register()
  "Store cursorposition _fast_ in a register.
Use ska-jump-to-register to jump back to the stored
position."
  (interactive)
  (setq zmacs-region-stays t)
  (point-to-register 8))

(defun ska-jump-to-register()
  "Switches between current cursorposition and position
that was stored with ska-point-to-register."
  (interactive)
  (setq zmacs-region-stays t)
  (let ((tmp (point-marker)))
    (jump-to-register 8)
    (set-register 8 tmp)))

;;选中复制单词
(defun zxc-copy-word-at-point ()
  (interactive)
  (backward-char)
  (forward-word)
  (let ((end (point)))
    (backward-word)
    (copy-region-as-kill end (point)))
  (message "copy success"))

;;复制当前行
(defun zxc-copy-line-at-point ()
  (interactive)
  (move-beginning-of-line 1)
  (let ((end (point)))
    (move-end-of-line 1)
    (copy-region-as-kill end (point)))
  (message "copy sentence success"))
;;选中单词
;; (defun mark-word-at-point()
;;   (interactive)
;;   (forward-char)
;;   (backward-word)
;;   (mark-word)
;;   )

;;替换后一个单词
(defun zxc-delete-and-yank()
  (interactive)
  (backward-char)
  (forward-word)
  (backward-word)
  (yank)
  (kill-word 1))

;;删除当前所在的单词
(defun zxc-delete-current-word()
  (interactive)
  (backward-word)
  (kill-word 1))

;;自定义关闭按键
(defun myclose(str)
  (interactive "sAre you sure to kill this emacs process:y(es)/n(o)")
  (if (string= str "y") (save-buffers-kill-terminal))
  )
(define-key global-map (kbd "C-x C-c") 'myclose)
;;背景颜色
(set-background-color "#CCE8CF")

;; 最大化
(defun my-maximized ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  )
;; 启动emacs时窗口最大化
(my-maximized)

;;自定义forward-word
;; (defun zxc-forward-word ()
;;   (interactive)
;;   (forward-char)
;;   (forward-word)
;;   (backward-char)
;;   )

;;全屏
(defun my-fullscreen ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(2 "_NET_WM_STATE_FULLSCREEN" 0))
  )

;;zen coding
(require 'zencoding-mode)
(add-hook 'sgml-mode-hook 'zencoding-mode) ;; Auto-start on any markup modes
(add-hook 'nxml-mode-hook 'zencoding-mode) ;; Auto-start on any markup modes
(setq auto-mode-alist (cons '(".jsp$" . html-mode) auto-mode-alist))
;;format
(defun indent-whole ()
  (interactive)
  (indent-region (point-min) (point-max))
  (message "format successfully"))
(global-set-key (kbd "C-c f")  'indent-whole)
;;字符串分割
(modify-syntax-entry ?_ "w")
(modify-syntax-entry ?- "w")

;; todo list
(put 'scroll-left 'disabled nil)
(put 'narrow-to-region 'disabled nil)
