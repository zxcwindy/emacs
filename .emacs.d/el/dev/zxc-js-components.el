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

(defvar zxc-js-cp-root-directory (concat user-emacs-directory "js-component-snippet") "组件模板数据存放根路径")

(defface zxc-js-cp-face-foreground
  '((((class color)) (:foreground "red"))
    (((background dark)) (:foreground "gray100"))
    (((background light)) (:foreground "gray0"))
    (t (:foreground "gray100")))
  "Face for foreground of js components action key words")

(defcustom zxc-js-cp-details-separator ""
  "The string separating entries in the `separated' style.
See `zxc-js-cp-details-display-style'."
  :type 'string
  :group 'zxc-js-cp)

(defvar zxc-js-cp-action-keys
  (list "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "c" "d" "e" "k" "l" "m" "o" "t" "u" "v" "w" "x" "y" "z")
  "当前模板组件的快捷键")

(defvar zxc-js-cp-details-poses
  nil
  "当前模板组件的起始位置集合")

(defvar zxc-js-cp-details-pos-index
  0
  "模板组件的当前位移")

(defvar zxc-js-cp-details-snippts
  nil
  "当前模板组件集合")

(defvar zxc-js-cp-original-window nil
  "The window configuration to restore for `zxc-js-cp-quit'.")

(defvar zxc-js-cp-original-buffer nil
  "The buffer in which chosen kill ring data will be inserted.
It is probably not a good idea to set this variable directly")


(defvar zxc-js-cp-preview-overlay nil
  "The overlay used to preview what would happen if the user
  inserted the given text.")

(define-derived-mode zxc-js-cp-mode fundamental-mode
  "JSCP"
  "A major mode for browsing js components snippets."
  ;; Later versions of emacs reduced the number of arguments to
  ;; font-lock-defaults, at least version 24 requires 5 arguments
  ;; before setting up buffer local variables.
  (mapc #'(lambda (key)
	    (zxc-js-cp-action-str key 'zxc-js-cp-details)) zxc-js-cp-action-keys)
  (define-key zxc-js-cp-mode-map (kbd "n") 'zxc-js-cp-details-forward)
  (define-key zxc-js-cp-mode-map (kbd "p") 'zxc-js-cp-details-previous)
  (define-key zxc-js-cp-mode-map (kbd "q") 'zxc-js-cp-quit)
  (define-key zxc-js-cp-mode-map (kbd "C-g") 'zxc-js-cp-quit)
  (define-key zxc-js-cp-mode-map (kbd "RET") 'zxc-js-cp-insert-and-quit))

;;;###autoload
(defun zxc-js-cp-list ()
  "Display components in the `js cp' in another buffer."
  (interactive)
  (if (eq major-mode 'zxc-js-cp-mode)
      (error "Already viewing the js cp mode"))
  (let* ((orig-win (selected-window))
	 (orig-buf (window-buffer orig-win))
	 (buf (get-buffer-create "*Js Components*")))
    (setq zxc-js-cp-original-window orig-win
	  zxc-js-cp-original-buffer orig-buf)
    (zxc-js-cp-init buf orig-buf)
    (pop-to-buffer buf)))

(defun zxc-js-cp-details-poses-reset ()
  (setq zxc-js-cp-details-poses (list)))

(defun zxc-js-cp-add-snippts (snippts)
  (let ((beg (point) ))
    (push beg zxc-js-cp-details-poses)
    (insert snippts)))

(defun zxc-js-cp-cleanup-on-exit ()
  (zxc-js-cp-details-poses-reset)
  (setq zxc-js-cp-details-pos-index 0)
  (setq zxc-js-cp-details-snippts nil)
  (zxc-js-cp-clear-preview))

(defun zxc-js-cp-details-forward (&optional arg)
  (interactive "p")
  (let ((min-index 0)
	(max-index (- (length zxc-js-cp-details-poses) 1)))
    (when (and (>= zxc-js-cp-details-pos-index min-index) (<= zxc-js-cp-details-pos-index max-index))
      (incf zxc-js-cp-details-pos-index arg)
      (when (< zxc-js-cp-details-pos-index min-index)
	(setq zxc-js-cp-details-pos-index min-index))
      (when (> zxc-js-cp-details-pos-index max-index)
	(setq zxc-js-cp-details-pos-index max-index))
      (goto-char (nth zxc-js-cp-details-pos-index zxc-js-cp-details-poses)))))

(defun zxc-js-cp-details-previous (&optional arg)
  "Move backward by ARG `snippts' entries."
  (interactive "p")
  (zxc-js-cp-details-forward (- arg)))

(defun zxc-js-cp-details-current-string ()
  (nth zxc-js-cp-details-pos-index zxc-js-cp-details-snippts))

(defun zxc-js-cp-preview-update-text (preview-text)
  "Update `zxc-js-cp-preview-overlay' to show `PREVIEW-TEXT`."
  ;; If preview-text is nil, replacement should be nil too.
  (assert (overlayp zxc-js-cp-preview-overlay))
  (let ((replacement (when preview-text
		       (propertize preview-text 'face 'highlight))))
    (overlay-put zxc-js-cp-preview-overlay
		 'before-string replacement)))


(defun zxc-js-cp-preview-update-by-position (&optional pt)
  "Update `zxc-js-cp-preview-overlay' to match item at PT.
The `zxc-js-cp-details-preview-overlay'
is udpated to preview the text of the selection at PT (or the
current point if not specified)."
  (zxc-js-cp-preview-update-text (zxc-js-cp-details-current-string)))

(defun zxc-js-cp-clear-preview ()
  (when zxc-js-cp-preview-overlay
    (delete-overlay zxc-js-cp-preview-overlay)))

(defun zxc-js-cp-setup-preview-overlay (orig-buf)
  (with-current-buffer orig-buf
    (let* ((will-replace (region-active-p))
	   (start (if will-replace
		      (min (point) (mark))
		    (point)))
	   (end (if will-replace
		    (max (point) (mark))
		  (point))))
      (zxc-js-cp-clear-preview)
      (setq zxc-js-cp-preview-overlay
	    (make-overlay start end orig-buf))
      (overlay-put zxc-js-cp-preview-overlay
		   'invisible t))))

(defun zxc-js-cp-init (buf orig-buf)
  "初始化组件buffer"
  (zxc-js-cp-setup-preview-overlay orig-buf)
  (with-current-buffer buf
    (unwind-protect
	(progn
	  (zxc-js-cp-mode)
	  (page-break-lines-mode)
	  (setq buffer-read-only nil)
	  (erase-buffer)
	  (insert "u、p切换组件模板列表,f、b进行当前组件翻页操作\n")
	  (let ((start (point)))
	    (loop for i from 0 to (length kfvue-list)
		  do (progn
		       (when (and (= (% i 8 ) 0))
			 (insert "\n"))
		       (insert (concat (propertize (nth i zxc-js-cp-action-keys) 'face 'zxc-js-cp-face-foreground) ":" (nth 0 (nth i kfvue-list)) " "))))
	    (align-regexp start (point) "\\(\\s-*\\)\\s-" 1 1 t)))
      (progn
	(setq buffer-read-only t)))))

(defun zxc-js-cp-details ()
  "展现组件模板列表详情"
  (interactive)
  (let* ((short-cut (this-command-keys))
	 (index (cl-position short-cut zxc-js-cp-action-keys :test 'equal)))
    (progn
      (setq buffer-read-only nil)
      (erase-buffer)
      (zxc-js-cp-details-poses-reset)
      (goto-char (point-min))
      (setq zxc-js-cp-details-snippts (cdr (nth index kfvue-list)))
      (setq zxc-js-cp-details-pos-index 0)
      (insert zxc-js-cp-details-separator)
      (dolist (cp-snippts zxc-js-cp-details-snippts)
	(zxc-js-cp-add-snippts cp-snippts)
	(newline)
	(insert zxc-js-cp-details-separator))
      (setq zxc-js-cp-details-poses (reverse zxc-js-cp-details-poses))
      (zxc-js-cp-preview-update-by-position (point-min))
      (add-hook 'post-command-hook
		'zxc-js-cp-preview-update-by-position
		nil t))
    (progn
      (setq buffer-read-only t)
      (goto-char (+ (point-min) 2)))))

(defun zxc-js-cp-action-str (newstr &optional func-or-shortcut)
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
    (define-key zxc-js-cp-mode-map (kbd newstr) func)))

(defun zxc-js-cp-quit ()
  "Take the action specified by `zxc-js-cp-quit-action'."
  (interactive)
  (zxc-js-cp-cleanup-on-exit)
  (kill-buffer (current-buffer))
  (unless (= (count-windows) 1)
    (delete-window)))

(defun zxc-js-cp-insert-and-quit ()
  "insert and  close the *js cp* buffer afterwards."
  (interactive)
  (zxc-js-cp-prepare-to-insert
   t
   (when (and delete-selection-mode
	      (not buffer-read-only)
	      transient-mark-mode mark-active)
     (delete-active-region))
   (insert (zxc-js-cp-details-current-string))))

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

(defmacro zxc-js-cp-prepare-to-insert (quit &rest body)
  "Restore window and buffer ready to insert `kill-ring' item.
Temporarily restore `zxc-js-cp-original-window' and
`zxc-js-cp-original-buffer' then evaluate BODY."
  `(progn
     (with-selected-window zxc-js-cp-original-window
       (with-current-buffer zxc-js-cp-original-buffer
	 (progn ,@body)
	 (unless ,quit
	   (zxc-js-cp-setup-preview-overlay
	    (current-buffer)))))
     (if ,quit
	 (zxc-js-cp-quit)
       (zxc-js-cp-clear-preview))))

(defun zxc-kf-vue-template ()
  (let ((doc-dirs "/home/david/workspace/demo/bmsoft/ued-components/examples/docs/")
	(doc-result-dirs (concat user-emacs-directory "ui-component/kf-vue")))
    (unless (file-exists-p doc-result-dirs)
      (mkdir doc-result-dirs t))
    (dolist (file (directory-files doc-dirs  nil "md$"))
      (with-temp-buffer
	(insert-file-contents (concat doc-dirs file))
	(let (result (list))
	  (ignore-errors
	    (while
		(let ((start-point
		       (progn
			 (zxc-get-search-point "```html")
			 (zxc-get-search-point "<template>")))
		      (end-point
		       (progn
			 (zxc-get-search-point "```")
			 (zxc-get-search-backward-point "</template>"))))
		  (push (s-trim (buffer-substring-no-properties start-point end-point)) result))))
	  (when result
	    (add-to-list 'result (s-replace ".md" "" file))
	    (with-temp-file (expand-file-name (s-replace ".md" ".el" file) doc-result-dirs)
	      (insert "(push " (format "'%S" result) " kfvue-list )"))))))))

(defun zxc-kf-vue-load ()
  (setq kfvue-list nil)
  (dolist (file (directory-files "/home/david/.emacs.d/ui-component/kf-vue/" t "el$"))
    (load-file file)))

(zxc-kf-vue-load)

(provide 'zxc-js-components)
