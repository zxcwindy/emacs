;;; html 开发扩展

(require 'ac-emmet)
(add-hook 'sgml-mode-hook 'ac-emmet-html-setup)
(add-hook 'css-mode-hook 'ac-emmet-css-setup)

;; (setq web-mode-markup-indent-offset 4)
;; (setq web-mode-css-indent-offset 4)
(setq web-mode-code-indent-offset 4)
(add-to-list 'auto-mode-alist '("\\.vue$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ftl$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.wxml$" . web-mode))

;; (add-hook 'web-mode-hook
;;	  (lambda ()
;;	    (local-set-key "\C-c\C-v" 'browse-url-of-buffer)
;;	    (local-set-key "\C-ci" 'js-doc-insert-function-doc)
;;	    (local-set-key "@" 'js-doc-insert-tag)))

(eval-after-load "web-mode"
  '(progn
     (define-key web-mode-map (kbd "C-c C-v") 'browse-url-of-buffer)
     (define-key web-mode-map (kbd "C-c i") 'js-doc-insert-function-doc)
     (define-key web-mode-map (kbd "@") 'js-doc-insert-tag)
     (define-key web-mode-map (kbd "C-c '") 'web-mode--src-edit)))

(setq web-mode-ac-sources-alist
      '(("php" . (ac-source-yasnippet ac-source-php-auto-yasnippets))
	("html" . (ac-source-emmet-html-aliases ac-source-emmet-html-snippets))
	("vue" . (ac-source-emmet-html-aliases ac-source-emmet-html-snippets))
	("css" . (ac-source-css-property ac-source-emmet-css-snippets))))

(add-hook 'web-mode-before-auto-complete-hooks
	  '(lambda ()
	     (let ((web-mode-cur-language
		    (web-mode-language-at-pos)))
	       (if (string= web-mode-cur-language "php")
		   (yas-activate-extra-mode 'php-mode)
		 (yas-deactivate-extra-mode 'php-mode))
	       (if (string= web-mode-cur-language "css")
		   (setq emmet-use-css-transform t)
		 (setq emmet-use-css-transform nil)))))

(defvar web-mode-src-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-c'" 'web-mode--src-edit-exit)
    (define-key map "\C-c\C-k" 'web-mode--src-edit-abort)
    (define-key map "\C-x\C-s" 'web-mode--src-edit-save)
    map))

(make-variable-buffer-local
 (defvar web-mode-src-content nil
   "(list beg end content)"))

(make-variable-buffer-local
 (defvar web-mode-src-origin-buffer nil
   "origin buffer"))

(define-minor-mode web-mode-src-mode
  "参考orgmode edit special，实现webmode的js2mode集成"
  nil " Js2Web" nil
  (setq-local
   header-line-format
   (substitute-command-keys
    "Edit, then exit with `\\[web-mode--src-edit-exit]' or abort with \
`\\[web-mode--src-edit-abort]'")))

(defun web-mode--src-edit ()
  "编辑当前范围内的js脚本"
  (interactive)
  (let ((orig-buf (current-buffer))
	(buf (get-buffer-create (concat "*" (buffer-name) "~js*"))))
    (web-mode--src-find-js)
    (with-current-buffer buf
      (erase-buffer)
      (insert (nth 2 (buffer-local-value 'web-mode-src-content orig-buf)))
      (js2-mode)
      (web-mode-src-mode)
      (setq web-mode-src-origin-buffer orig-buf)
      (goto-char (point-min))
      (pop-to-buffer buf))))

(defun web-mode--src-find-js ()
  "查找js脚本，返回开始位置、结束位置、内容的list"
  (let* ((beg-tag-pos (search-backward-regexp "<script.*>" nil :no-error))
	 (beg (when beg-tag-pos
		(forward-line)
		(beginning-of-line)
		(point)))
	 (end-tag-pos (when beg
			(search-forward-regexp "</script>" nil :no-error)))
	 (end (when end-tag-pos
		(beginning-of-line)
		(point))))
    (if (and beg end)
	(setq web-mode-src-content (list beg end (buffer-substring-no-properties beg end)))
      (error "未找到js内容"))))

(defun web-mode--src-edit-save ()
  "write back"
  (interactive)
  (let ((edit-code (buffer-string)))
    (with-current-buffer web-mode-src-origin-buffer
      (delete-region (nth 0 web-mode-src-content) (nth 1 web-mode-src-content))
      (goto-char (nth 0 web-mode-src-content))
      (insert edit-code)
      (save-buffer)
      (web-mode--src-find-js))
    (set-buffer-modified-p nil)))

(provide 'zxc-html)
