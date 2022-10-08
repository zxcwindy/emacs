(require 'zxc-company-pom)
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
;; (global-linum-mode nil)
(global-display-line-numbers-mode t)
(auto-image-file-mode t)
;;--------------

;;org模式换行
(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook 'valign-mode)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;;支持emacs和外部程序的粘贴
;;(setq x-select-enable-clipboard t)

;;为文本模式打开outline
(add-hook 'text-mode-hook 'my-out-line)

;;w3m
;;(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)

;; 使用chrome
;; (defun get-browse (url  &rest args)
;;   (if (let ((list '(lisp-interaction-mode lisp-mode)))
;;	(do* ((lt list (cdr lt))
;;	      (mode-1 (car lt) (car lt))
;;	      (mode major-mode))
;;	    ((or (equal lt nil)
;;		 (equal mode mode-1))
;;	     (equal mode mode-1))))
;;       (w3m-browse-url url args)
;;     (browse-url-firefox url args)))

;; (setq browse-url-browser-function #'get-browse)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "/opt/google/chrome/google-chrome")



(setq w3m-use-cookies t)
(setq w3m-coding-system 'utf-8
      w3m-file-coding-system 'utf-8
      w3m-file-name-coding-system 'utf-8
      w3m-input-coding-system 'utf-8
      w3m-output-coding-system 'utf-8
      w3m-terminal-coding-system 'utf-8)

(defun my-out-line()
  (outline-minor-mode t))

;;-------------------
;;修改字体
;;; slackware字体
;; (set-frame-font "-b&h-Luxi Mono-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")
;;; ubuntu默认字体
;; (set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-13-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-HNYI-阿里巴巴普惠体-normal-normal-normal-*-13-*-*-*-*-0-iso10646-1")

;;; slackware配置
;; (setq zxc-frame-font-default-size "12")
;; (defun zxc-set-font-size (font-size)
;;   "change font size"
;;   (interactive (list (read-string (format "字体大小(%s): " zxc-frame-font-default-size))))
;;   (setf zxc-frame-font-default-size font-size)
;;   (set-frame-font (s-concat "-unknown-DejaVu Sans Mono-normal-normal-normal-*-" zxc-frame-font-default-size "-*-*-*-m-0-iso10646-1")))

;; (zxc-set-font-size zxc-frame-font-default-size)

;;; ubuntu配置
(setq zxc-frame-font-default-size 95)
(set-face-attribute 'default nil :height zxc-frame-font-default-size)
;; 设置字体大小,C-x C-0  , `C-x C-+’ and ‘C-x C--’ (‘text-scale-adjust’)
(defun zxc-set-font-size (font-size)
  "change font size"
  (interactive "n字体50-100:")
  (setf zxc-frame-font-default-size font-size)
  (set-face-attribute 'default nil :height zxc-frame-font-default-size))


;;光标靠近鼠标指针时，让鼠标指针自动让开
(mouse-avoidance-mode 'animate)
;;------------------
;;防止页面滚动时跳动， scroll-margin 3 可以在靠近屏幕边沿
;;3行时就开始滚动，可以很好的看到上下文
(setq scroll-margin 1)
(setq kill-ring-max 1000)

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
    (jump-to-register 0)))

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


(defun zxc-copy-word-at-point ()
  "选中复制单词"
  (interactive)
  (backward-char)
  (forward-word)
  (let ((end (point)))
    (backward-word)
    (kill-ring-save end (point)))
  (message "copy success"))

(defun zxc-copy-line-or-region (beg end)
  "选中时复制选中区域，没有选中复制当前行"
  (interactive (if (use-region-p)
		   (list (region-beginning) (region-end))
		 (list (line-beginning-position)
		       (line-end-position))))
  (kill-ring-save beg end)
  (message "copy sentence success"))

;;选中单词
;; (defun mark-word-at-point()
;;   (interactive)
;;   (forward-char)
;;   (backward-word)
;;   (mark-word)
;;   )


(defun zxc-delete-and-yank()
  "替换后一个单词"
  (interactive)
  (backward-char)
  (forward-word)
  (backward-word)
  (kill-word 1)
  (yank 2))

(defun zxc-delete-current-word()
  "删除当前所在的单词"
  (interactive)
  (backward-word)
  (kill-word 1))

(defun zxc-copy-f-other-t-point(arg)
  "复制指定行或者其他窗口指定行的数据到当前点"
  (interactive "s输入行数(32|a32,46):")
  (let* ((is-other-buffer (s-starts-with-p "a" arg))
	 (beg-line-num (string-to-number (string-replace "a" "" (car (split-string arg ",")))))
	 (end-line-str (cadr (split-string arg ","))))
    (beginning-of-line)
    (save-excursion
      (when is-other-buffer
	(other-window 1))
      (goto-line beg-line-num)
      (let ((beg (line-beginning-position)))
	(when end-line-str
	  (goto-line (string-to-number end-line-str)))
	(let ((end (line-end-position)))
	  (kill-ring-save beg end))))
    (yank)
    (when is-other-buffer
      (other-window 1))))


(defun myclose()
  "自定义关闭按键"
  (interactive)
  (when (y-or-n-p  "Are you sure to kill this emacs process:")
    (save-buffers-kill-terminal)))

(define-key global-map (kbd "C-x C-c") 'myclose)
(global-unset-key (kbd "C-SPC"))
;;背景颜色
;;(set-background-color "#CCE8CF")

;; 最大化
(defun my-maximized ()
  (interactive)
  ;; (x-send-client-message
  ;;  nil 0 nil "_NET_WM_STATE" 32
  ;;  '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  ;; (x-send-client-message
  ;;  nil 0 nil "_NET_WM_STATE" 32
  ;;  '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (toggle-frame-maximized))
;; 启动emacs时窗口最大化
(my-maximized)

;;自定义forward-word
;; (defun zxc-forward-word ()
;;   (interactive)
;;   (forward-char)
;;   (forward-word)
;;   (backward-char)
;;   )

;; (defun my-fullscreen ()
;;   (interactive)
;;   (x-send-client-message
;;    nil 0 nil "_NET_WM_STATE" 32
;;    '(2 "_NET_WM_STATE_FULLSCREEN" 0))
;;   )

;;delete word or kill-region
(defun my-delete-or-kill ()
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))

;;format
(defun indent-whole ()
  (interactive)
  (indent-region (point-min) (point-max))
  (message "format successfully"))

(defun my-mark-paragraph ()
  (interactive)
  (mark-paragraph)
  (unless (= (line-number-at-pos) 1)
    (forward-line)
    (move-beginning-of-line 1)))

;;字符串分割
(defvar text-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?_ "w" st)
    (modify-syntax-entry ?- "w" st)
    st)
  "Syntax table used while in `text-mode'.")

(add-hook 'tcl-mode-hook #'(lambda ()
			     (modify-syntax-entry ?_ "w" tcl-mode-syntax-table)))

(add-hook 'sql-mode-hook #'(lambda ()
			     (modify-syntax-entry ?_ "w" sql-mode-syntax-table)
			     (modify-syntax-entry ?. "w" sql-mode-syntax-table)
			     (sql-highlight-mysql-keywords)
			     (zxc-db-ac-set-db-alias "job")))

(add-hook 'org-mode-hook #'(lambda ()
			     (modify-syntax-entry ?. "w" org-mode-syntax-table)
			     (modify-syntax-entry ?_ "w" org-mode-syntax-table)))

(add-hook 'java-mode-hook #'(lambda ()
			      (modify-syntax-entry ?_ "w" java-mode-syntax-table)))

(add-to-list 'ac-modes 'shell-mode)

(put 'scroll-left 'disabled nil)
(put 'narrow-to-region 'disabled nil)
;; todo list
;; emms

;;alpha
;;(set-frame-parameter (selected-frame) 'alpha '(100 100))
(put 'set-goal-column 'disabled nil)

(add-hook 'sql-interactive-mode-hook 'toggle-truncate-lines)

;;sql-model-hook
(add-hook 'sql-interactive-mode-hook
	  (function (lambda ()
		      (setq comint-output-filter-functions 'comint-truncate-buffer))))

;;; ctable 字体设置
;; (add-hook 'ctbl:table-mode-hook #'(lambda ()
;;				    (setq buffer-face-mode-face '(:family "文泉驿等宽正黑"))
;;				    (buffer-face-mode)))

(setf org-export-preserve-breaks t)

;; t: Adapt indentation for all lines
;; headline-data: Adapt indentation for headline data lines
;; nil: Do not adapt indentation at all
(setq org-adapt-indentation t)

(defun qiang-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
If no region is selected and current line is not blank and we are not at the end of the line,
then comment current line.
Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

;;切换窗口
(global-set-key (kbd "C-x o") 'ace-window)
(setq tab-width 4)
(setq tab-stop-list (number-sequence 4 200 4))

;;; scratch
(autoload 'scratch "scratch" nil t)

;;; smex
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

;;rainbow-delimiters
(dolist (hook '(js2-mode-hook js-mode-hook json-mode-hook lisp-interaction-mode-hook emacs-lisp-mode-hook))
  (add-hook hook 'rainbow-delimiters-mode))

(dolist (hook '(css-mode-hook less-mode))
  (add-hook hook 'rainbow-mode))

(add-hook 'emacs-lisp-mode-hook 'company-mode)
(add-hook 'nxml-mode-hook 'company-mode)


(setq frame-title-format "emacs@%f")

;;; 成都经纬度：东经104.06，北纬30.67
;;; 武汉经纬度：东经114.30，北纬30.60
;;; 济南经纬度：东经117.00，北纬36.40
(setq calendar-time-zone 480)	       ;;GMT+8 (8*60)
(setq calendar-longitude 104.06)        ;;经度，正数东经
(setq calendar-latitude 30.67)          ;;纬度，正数北纬
(setq calendar-location-name "成都")    ;;地名

(setq emmet-preview-default nil)
(global-whitespace-mode t)

(setq ediff-diff-options "-w"
      ediff-window-setup-function #'ediff-setup-windows-plain)

;; 水平分隔window
(setq split-height-threshold 0)
(setq split-width-threshold nil)

;;diff水平分隔
;; (setq ediff-split-window-function 'split-window-horizontally
;;       ediff-window-setup-function 'ediff-setup-windows-plain)

;;; org开启dot编译,如下例子
;; #+BEGIN_SRC dot :file test-dot.png :exports results
;; digraph a{
;;	开始->登录系统->登录校验;
;;	登录校验->登录系统:se [label="校验失败"];
;;	登录校验->进入平台;
;; }
;; #+END_SRC
(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t)))

;;org src 颜色设置
(setq org-src-fontify-natively t)
;;设置执行代码不进行提示
(setq org-confirm-babel-evaluate nil)

(eval-after-load "org"
  '(progn (require 'ox-md)
	  (require 'ox-odt)))

(setq markdown-command "markdown_py")

(defun kill-matching-lines (regexp &optional rstart rend interactive)
  "Kill lines containing matches for REGEXP.

See `flush-lines' or `keep-lines' for behavior of this command.

If the buffer is read-only, Emacs will beep and refrain from deleting
the line, but put the line in the kill ring anyway.  This means that
you can use this command to copy text from a read-only buffer.
\(If the variable `kill-read-only-ok' is non-nil, then this won't
even beep.)"
  (interactive
   (keep-lines-read-args "Kill lines containing match for regexp"))
  (let ((buffer-file-name nil)) ;; HACK for `clone-buffer'
    (with-current-buffer (clone-buffer nil nil)
      (let ((inhibit-read-only t))
	(keep-lines regexp rstart rend interactive)
	(kill-region (or rstart (line-beginning-position))
		     (or rend (point-max))))
      (kill-buffer)))
  (unless (and buffer-read-only kill-read-only-ok)
    ;; Delete lines or make the "Buffer is read-only" error.
    (flush-lines regexp rstart rend interactive)))

(setf password-cache-expiry 2592000)

(add-auto-mode 'conf-mode ".cnf$")
;; (global-auto-revert-mode)

(require 'delight)
(delight '((abbrev-mode nil "abbrev")
	   (projectile-mode " PJ" "projectile")
	   (eldoc-mode nil "eldoc")
	   (paredit-mode nil "Paredit")
	   (lisp-interaction-mode nil "Lisp Interaction")
	   (rainbow-mode)
	   (overwrite-mode " Ov" t)
	   (global-whitespace-mode nil "whitespace")
	   (page-break-lines-mode nil "page-break-lines")
	   (emacs-lisp-mode "Elisp" :major)))


(defun zxc-session-file-filter-before-save-hook ()
  "过滤session保存文件，只保存org文件"
  (let ((result (list))
	(result-his (list)))
    (mapc #'(lambda (file-alist)
	      (when (s-ends-with? "org" (car file-alist))
		(add-to-list 'result file-alist)
		(add-to-list 'result-his (car file-alist))))
	  session-file-alist)
    (setq session-file-alist result)
    (setq file-name-history result-his)))

(add-hook 'session-before-save-hook #'zxc-session-file-filter-before-save-hook)

(setq desktop-files-not-to-save "\\(^/[^/:]*:\\|(ftp)$\\)\\|\\([.]*\\(sh\\|jar\\|html\\|gz\\|el\\|xml\\|json\\|java\\|js\\|war\\|csv\\|ttf\\|log\\|vue\\|css\\|sql\\|conf\\|properties\\)$\\)\\|\\(^~/\\)")

(add-hook 'yas-minor-mode-hook (lambda ()
				 ;;; 当默认tab没有生效时，采用下面的按键绑定
				 (define-key yas-minor-mode-map (kbd "TAB") yas-maybe-expand)))


(defun zxc-mode-action-str (mode-map newstr &optional func-or-shortcut)
  "If FUNC-OR-SHORTCUT is non-nil and if it is a function, call it
when STR is clicked ; if FUNC-OR-SHORTCUT is
a string, execute the corresponding keyboard action when it is
clicked."
  (let ((func (if (functionp func-or-shortcut)
		  func-or-shortcut
		(if (stringp func-or-shortcut)
		    (lexical-let ((macro func-or-shortcut))
		      (lambda()(interactive)
			(execute-kbd-macro macro)))))))
    (define-key mode-map (kbd newstr) func)))

(defun last-index-of (regex str &optional ignore-case)
  "查找字符串最后的位置"
  (let ((start 0)
	(case-fold-search ignore-case)
	idx)
    (while (string-match regex str start)
      (setq idx (match-beginning 0))
      (setq start (match-end 0)))
    idx))

(defun zxc-find-file ()
  "如果当前选中文字，则查找选中文字的路径，否则进行ido查找文件"
  (interactive)
  (if (region-active-p)
      (let ((path (buffer-substring-no-properties (region-beginning) (region-end))))
	(find-file path))
    (ido-find-file)))

(defmacro open-with-file (path func)
  "操作小文件内容,path为文件路径，func为匿名函数或单参数函数 如 (lambad (str) (insert str) )"
  `(loop for str in (with-temp-buffer
		      (insert-file-contents ,path)
		      (split-string (buffer-string) "\n"))
	 do (,func str)))

(defun zxc-navigate-buffer ()
  "访问最近的buffer"
  (interactive)
  (if (eq last-command 'zxc-navigate-buffer)
      (progn
	(cl-incf zxc-navigate-index)
	(switch-to-buffer (nth zxc-navigate-index zxc-navigate-bufferlist)))
    (progn
      (setq zxc-navigate-bufferlist
	    (seq-filter (lambda (elt)
			  (not (string-match "\\(Minibuf\\|Messages\\|Backtrace\\|Help\\)" (buffer-name elt))))
			(buffer-list))
	    zxc-navigate-index 1)
      (switch-to-buffer (nth zxc-navigate-index zxc-navigate-bufferlist)))))

;;; Set auto-save-file-name-transforms to nil to save auto-saved files to the same directory as the original file.
(setq auto-save-file-name-transforms nil)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(provide 'zxc-init)
