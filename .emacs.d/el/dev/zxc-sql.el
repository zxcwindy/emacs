;;; zxc-sql.el --- indentation of SQL statements

(require 'sql)

(defun zxc-sql-get-region-or-paragraph-point ()
  "获取当前选中区域或者当前段落的开始点和结束点"
  (if (region-active-p)
      (list (region-beginning) (region-end))
    (let ((start (save-excursion
		   (backward-paragraph)
		   (point)))
	  (end (save-excursion
		 (forward-paragraph)
		 (point))))
      (list start end))))


(defun zxc-sql-indent-line ()
  "Indent current line in an SQL statement."
  (interactive)
  (let* ((pos (zxc-sql-get-region-or-paragraph-point))
	 (start (nth 0 pos))
	 (end (nth 1 pos)))
    (shell-command-on-region start end "sqlformat -T -O --indent '    '" nil t)
    (newline)))

(add-hook 'sql-mode-hook
	  (function (lambda ()
		      (define-key sql-mode-map "\C-cf" 'zxc-sql-indent-line))))

(provide 'zxc-sql)
