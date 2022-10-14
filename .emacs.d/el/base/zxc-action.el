(defvar zxc-action-keys
  (list "a" "s" "d" "f" "j" "k" "l" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0")
  "快捷键")

(defvar-local zxc-action-current-index 0
  "选中的action位置")

(defvar-local zxc-action-current-data-list nil
  "data数据")

(define-derived-mode zxc-action-mode fundamental-mode
  "action"
  "A major mode for operator action."
  (define-key zxc-action-mode-map (kbd "q") 'zxc-action-quit)
  (define-key zxc-action-mode-map (kbd "C-g") 'zxc-action-quit))

(defun zxc-action-registr-str (newstr func)
  (define-key zxc-action-mode-map (kbd newstr) func))

(defun zxc-action-render (buffer-name data-list callback col-num)
  (with-current-buffer (get-buffer-create buffer-name)
    (let* ((short-cut (this-command-keys)))
      (progn
	(zxc-action-mode)
	(setq-local zxc-action-current-data-list data-list)
	(mapc #'(lambda (key)
		  (zxc-action-registr-str key callback)) zxc-action-keys)
	(page-break-lines-mode)
	(setq buffer-read-only nil)
	(erase-buffer)
	(goto-char (point-min))
	(insert "\n")
	(cl-loop for index from 0 below (length zxc-action-current-data-list)
		 do (progn
		      (insert (propertize (nth index zxc-action-keys) 'face '(font-lock-warning-face :height 1.5)) ": " (nth index zxc-action-current-data-list) "\t")
		      (when (= (% (+ index 1) col-num) 0)
			(insert "\n"))))
	(setq buffer-read-only t)
	(pop-to-buffer buffer-name)))))

(defun zxc-action-quit ()
  "关闭提示界面"
  (interactive)
  (kill-buffer (current-buffer))
  (unless (= (count-windows) 1)
    (delete-window)))

;;; (zxc-action-render "*test*" (list "123" "345") 'tmp-func 2)
;; (defun tmp-func ()
;;   (interactive)
;;   (let ((short-cut (this-command-keys)))
;;     (setf zxc-action-current-index (cl-position short-cut zxc-action-keys :test 'equal))
;;     (message (nth zxc-action-current-index zxc-action-current-data-list))))

(provide 'zxc-action)
