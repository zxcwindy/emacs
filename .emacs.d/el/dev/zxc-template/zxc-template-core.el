;;; zxc-js-components-snippet.el --- js component snippet

;; Author: zhengxc <david.c.aq@gmail.com>
;; Keywords: js component snippet
;; version: 1.0.0

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as1
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.

;; You should have received a copy of the GNU General Public
;; License along with this program; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA

;;; Commentary:

(defgroup zxc-template nil
  "A package for browsing and inserting the items in `zxc-template'."
  :group 'comm)

(defgroup zxc-js-components nil
  "A package for browsing and inserting the items in `zxc-js-components'."
  :group 'comm)

(defvar zxc-template-root-directory (concat user-emacs-directory "js-component-snippet") "组件模板数据存放根路径")

(defface zxc-template-face-foreground
  '((((class color)) (:foreground "red"))
    (((background dark)) (:foreground "gray100"))
    (((background light)) (:foreground "gray0"))
    (t (:foreground "gray100")))
  "Face for foreground of js components action key words")

(defcustom zxc-template-details-separator "\n"
  "The string separating entries in the `separated' style.
See `zxc-template-details-display-style'."
  :type 'string
  :group 'zxc-js-components)

(defvar zxc-template-action-keys
  (list "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "c" "d" "e" "k" "l" "m" "o" "t" "u" "v" "w" "x" "y" "z")
  "当前模板组件的快捷键")

(defvar zxc-template-details-poses
  nil
  "当前模板组件的起始位置集合")

(defvar zxc-template-details-pos-index
  0
  "模板组件的当前位移")

(defvar zxc-template-details-snippts
  nil
  "当前模板组件集合")

(defvar zxc-template-page-size
  24
  "page size")

(defvar zxc-template-current-page
  0
  "current page")

(defconst zxc-template-buffer-name "*Zxc Template*" "buffer name")

(defvar zxc-template-list nil "当前模板组集合")
;; (make-variable-buffer-local 'zxc-template-list)

(defvar zxc-template-list-index 0 "当前模板组索引位置")
;; (make-variable-buffer-local 'zxc-template-list-index)

(defvar zxc-template-original-window nil
  "The window configuration to restore for `zxc-template-quit'.")

(defvar zxc-template-original-buffer nil
  "The buffer in which chosen kill ring data will be inserted.
It is probably not a good idea to set this variable directly")


(defvar zxc-template-preview-overlay nil
  "The overlay used to preview what would happen if the user
  inserted the given text.")

(defmacro zxc-template-prepare-to-insert (quit &rest body)
  "Restore window and buffer ready to insert `kill-ring' item.
Temporarily restore `zxc-template-original-window' and
`zxc-template-original-buffer' then evaluate BODY."
  `(progn
     (with-selected-window zxc-template-original-window
       (with-current-buffer zxc-template-original-buffer
	 (progn ,@body)
	 (unless ,quit
	   (zxc-template-setup-preview-overlay
	    (current-buffer)))))
     (if ,quit
	 (zxc-template-quit)
       (zxc-template-clear-preview))))

(defun zxc-template-details-poses-reset ()
  (setq zxc-template-details-poses (list)))

(defun zxc-template-add-snippts (snippts)
  (let ((beg (point) ))
    (push beg zxc-template-details-poses)
    (insert snippts)))

(defun zxc-template-cleanup-on-exit ()
  (zxc-template-details-poses-reset)
  (setq zxc-template-details-pos-index 0)
  (setq zxc-template-details-snippts nil)
  (zxc-template-clear-preview))

(defun zxc-template-details-forward (&optional arg)
  (interactive "p")
  (let ((min-index 0)
	(max-index (- (length zxc-template-details-poses) 1)))
    (when (and (>= zxc-template-details-pos-index min-index) (<= zxc-template-details-pos-index max-index))
      (incf zxc-template-details-pos-index arg)
      (when (< zxc-template-details-pos-index min-index)
	(setq zxc-template-details-pos-index min-index))
      (when (> zxc-template-details-pos-index max-index)
	(setq zxc-template-details-pos-index max-index))
      (goto-char (nth zxc-template-details-pos-index zxc-template-details-poses)))))

(defun zxc-template-details-previous (&optional arg)
  "Move backward by ARG `snippts' entries."
  (interactive "p")
  (zxc-template-details-forward (- arg)))

(defun zxc-template-page-forward (&optional arg)
  "template page forward"
  (interactive "p")
  (when (and (< (* (+ (or arg 1) zxc-template-current-page) zxc-template-page-size) (zxc-template-current-total))
	     (>= zxc-template-current-page 0))
    (incf zxc-template-current-page (or arg 1))
    (when (< zxc-template-current-page 0)
      (setq zxc-template-current-page 0))
    (zxc-template-init (get-buffer zxc-template-buffer-name) zxc-template-original-buffer)))

(defun zxc-template-page-previous (&optional arg)
  "template page previous"
  (interactive "p")
  (zxc-template-page-forward (- arg)))


(defun zxc-template-details-current-string ()
  (nth zxc-template-details-pos-index zxc-template-details-snippts))

(defun zxc-template-preview-update-text (preview-text)
  "Update `zxc-template-preview-overlay' to show `PREVIEW-TEXT`."
  ;; If preview-text is nil, replacement should be nil too.
  (assert (overlayp zxc-template-preview-overlay))
  (let ((replacement (when preview-text
		       (propertize preview-text 'face 'highlight))))
    (overlay-put zxc-template-preview-overlay
		 'before-string replacement)))


(defun zxc-template-preview-update-by-position (&optional pt)
  "Update `zxc-template-preview-overlay' to match item at PT.
The `zxc-template-details-preview-overlay'
is udpated to preview the text of the selection at PT (or the
current point if not specified)."
  (zxc-template-preview-update-text (zxc-template-details-current-string)))

(defun zxc-template-clear-preview ()
  (when zxc-template-preview-overlay
    (delete-overlay zxc-template-preview-overlay)))

(defun zxc-template-setup-preview-overlay (orig-buf)
  (with-current-buffer orig-buf
    (let* ((will-replace (region-active-p))
	   (start (if will-replace
		      (min (point) (mark))
		    (point)))
	   (end (if will-replace
		    (max (point) (mark))
		  (point))))
      (zxc-template-clear-preview)
      (setq zxc-template-preview-overlay
	    (make-overlay start end orig-buf))
      (overlay-put zxc-template-preview-overlay
		   'invisible t))))

(defun zxc-template-current (&optional index)
  "返回当前模板集合中选中的模板分类集合"
  (cdr (nth (or index zxc-template-list-index)
	    zxc-template-list)))

(defun zxc-template-current-name (&optional index)
  "返回当前模板集合中选中的模板分类名称"
  (car (nth (or index zxc-template-list-index)
	    zxc-template-list)))

(defun zxc-template-current-total (&optional index)
  "返回当前模板集合中选中的模板分类totalnum"
  (length (cdr (nth (or index zxc-template-list-index)
		    zxc-template-list))))

(defun zxc-template-change ()
  "切换模板，刷新展现列表"
  (interactive)
  (incf zxc-template-list-index)
  (when (> zxc-template-list-index (- (length zxc-template-list) 1))
    (setq zxc-template-list-index 0))
  (zxc-template-init (get-buffer zxc-template-buffer-name) zxc-template-original-buffer))


(defun zxc-template-init (buf orig-buf)
  "初始化组件buffer"
  (zxc-template-setup-preview-overlay orig-buf)
  (with-current-buffer buf
    (unwind-protect
	(progn
	  (zxc-template-mode)
	  (page-break-lines-mode)
	  (setq buffer-read-only nil)
	  (erase-buffer)
	  (let* ((template (zxc-template-current))
		(from-num (* zxc-template-current-page zxc-template-page-size))
		(end-num (min (* (+ zxc-template-current-page 1) zxc-template-page-size) (length template))))
	    (insert (zxc-template-current-name) " totalnum: " (format "%d" (zxc-template-current-total)) (format " from %d to %d" from-num end-num))
	    (insert "\n\n")
	    (let ((start (point)))
	      (loop for i
		    from from-num
		    to end-num
		    do (progn
			 (when (nth 0 (nth i template))
			   (when (and (= (% i 8) 0) (/= i 0))
			     (insert "\n"))
			   (insert (concat (propertize (nth i zxc-template-action-keys) 'face 'zxc-template-face-foreground) ":" (nth 0 (nth i template)) " ")))))
	      (align-regexp start (point) "\\(\\s-*\\)\\s-" 1 1 t))))
      (progn
	(setq buffer-read-only t)))))

(defun zxc-template-details ()
  "展现组件模板列表详情"
  (interactive)
  (let* ((short-cut (this-command-keys))
	 (index (cl-position short-cut zxc-template-action-keys :test 'equal))
	 (template (zxc-template-current)))
    (progn
      (setq buffer-read-only nil)
      (erase-buffer)
      (zxc-template-details-poses-reset)
      (goto-char (point-min))
      (setq zxc-template-details-snippts (cdr (nth index template)))
      (setq zxc-template-details-pos-index 0)
      (insert zxc-template-details-separator)
      (dolist (cp-snippts zxc-template-details-snippts)
	(zxc-template-add-snippts cp-snippts)
	(newline)
	(insert zxc-template-details-separator))
      (setq zxc-template-details-poses (reverse zxc-template-details-poses))
      (zxc-template-preview-update-by-position (point-min))
      (add-hook 'post-command-hook
		'zxc-template-preview-update-by-position
		nil t))
    (progn
      (setq buffer-read-only t)
      (goto-char (+ (point-min) 2)))))

(defun zxc-template-action-str (newstr &optional func-or-shortcut)
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
    (define-key zxc-template-mode-map (kbd newstr) func)))

(defun zxc-template-quit ()
  "Take the action specified by `zxc-template-quit-action'."
  (interactive)
  (zxc-template-cleanup-on-exit)
  (kill-buffer (current-buffer))
  (unless (= (count-windows) 1)
    (delete-window)))

(defun zxc-template-insert-and-quit ()
  "insert and  close the *js cp* buffer afterwards."
  (interactive)
  (zxc-template-prepare-to-insert
   t
   (when (and delete-selection-mode
	      (not buffer-read-only)
	      transient-mark-mode mark-active)
     (delete-active-region))
   (insert (zxc-template-details-current-string))))

(defun browse-kill-ring-do-insert (buf pt quit)
  (let ((str (browse-kill-ring-current-string buf pt)))
    (setq kill-ring-yank-pointer
	  (browse-kill-ring-current-kill-ring-yank-pointer buf pt))
    (browse-kill-ring-prepare-to-insert
     quit
     (when browse-kill-ring-this-buffer-replace-yanked-text
       (delete-region (mark) (point)))
     (when (and delete-selection-mode
		(not buffer-read-only)
		transient-mark-mode mark-active)
       (delete-active-region))
     (browse-kill-ring-insert-and-highlight str))))

(defmacro zxc-template-load (catalog-var-name template-name)
  `(progn
     (setq ,template-name nil)
     (dolist (file (directory-files (concat zxc-template-root-directory "/" (symbol-name ',template-name)) t "el$"))
       (load-file file))
     (add-to-list ',catalog-var-name
		  (cons (s-upcase (symbol-name ',template-name)) ,template-name)
		  t)
     (message "load %s template" (symbol-name ',template-name))))

;; (zxc-kf-vue-template "/home/david/workspace/demo/bmsoft/ued-components/examples/docs/" "kfvue")


(provide 'zxc-template-core)
