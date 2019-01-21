;; export GTK_IM_MODULE="ibus"
;; export QT_IM_MODULE="ibus"
;; export XMODIFIERS="@im=ibus"
;; export XIM="ibus"

(run-with-timer 1 30
		#'(lambda ()
		    (call-process "xmodmap" nil nil nil "/home/david/.emacs.d/el/my.map")))


(require 'ibus)
(defvar el-ibus-status nil "ibus模式启动标示")

(defun el-ibus-on-off ()
  "开启/关闭ibus"
  (interactive)
  ;;(add-hook 'after-init-hook 'ibus-mode-on)
  (if (null el-ibus-status)
      (progn 
	(ibus-mode-on)
	(setf el-ibus-status t))
    (ibus-mode-off)
    (setf el-ibus-status nil)))

(provide 'el-ibus)
