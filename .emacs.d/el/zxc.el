(provide 'zxc)
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
