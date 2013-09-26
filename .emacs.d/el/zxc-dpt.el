;;; zxc-dpt.el --- dpt planform util library

;; Author: zhengxc 
;; Keywords: http,sql

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

(defvar dpt-host "http://10.95.239.158:8080"
  "平台地址")

(defvar dpt-user-info-param '((userId "zhengxc")
			      (pwd "123456"))
  "用户名/密码")

(defvar dpt-query-param '((command "init")
			  (start "0")
			  (limit "25")
			  (root "root")
			  (dataSource "DWDB"))
  "查询语句默认参数")

(defvar dpt-exec-param '((command "executeSQL")
			 (dataSource "DWDB"))
  "其他语句默认参数")

(defvar dpt-result nil
  "返回结果集")

(defun dpt-login ()
  "登录"
  (interactive)
  (minibuffer-message (http-post (concat dpt-host "/core/login")
				 dpt-user-info-param)))

(defun dpt-exec-sql (sql-param sql)
  "查询"
  (setf dpt-result (http-post "http://10.95.239.158:8080/core/newrecordService"
			      (append sql-param (list (list 'initSql sql))))))



(defun dpt-create-column ()
  "创建表头"
  (mapcar #'(lambda (meta-info)
	      (make-ctbl:cmodel :title (getf meta-info :header) :align 'center))
	  (getf dpt-result :columnModel)))

(defun dpt-get-data ()
  "格式化返回数据"
  (mapcar #'(lambda (datas)
	      (let (row-data)
		(mapcar #'(lambda (data)
			    (unless (symbolp data)
			      (setf row-data (cons data row-data))))
			datas)
		row-data))
	  (getf dpt-result :root)))

(defun dpt-create-table-buffer ()
  "创建结果表格"
  (let ((cp
	 (ctbl:create-table-component-buffer
	  :width nil :height nil
	  :model
	  (make-ctbl:model
	   :column-model (dpt-create-column)
	   :data (dpt-get-data)))))
    (pop-to-buffer (ctbl:cp-get-buffer cp))))

(defun dpt-send-paragraph ()
  "执行SQL段落"
  (interactive)
  (let ((start (save-excursion
		 (backward-paragraph)
		 (point)))
	(end (save-excursion
	       (forward-paragraph)
	       (point))))
    (dpt-send-region start end)))

(defun dpt-get-buffer-sql ()
  "取得当前SQL语句"
  (if (region-active-p)
      (buffer-substring-no-properties (region-beginning) (region-end))
    (let ((start (save-excursion
		   (backward-paragraph)
		   (point)))
	  (end (save-excursion
		 (forward-paragraph)
		 (point))))
      (buffer-substring-no-properties start end))))

(defun dpt-send-region-query ()
  "查询当前区域SQL"
  (interactive)
  (dpt-exec-sql dpt-query-param (dpt-get-buffer-sql))
  (let ((error-msg (getf dpt-result :errorMsg)))
    (if (null error-msg)
	(dpt-create-table-buffer)
      (with-current-buffer (get-buffer-create "*dpt-log*")
	(insert (concat "\n" error-msg)))
      (pop-to-buffer "*dpt-log*")
      ;; (with-output-to-temp-buffer "*dpt-log*"
      ;; 	(princ error-msg))
      )))

(defun dpt-send-region-exec ()
  "执行当前区域SQL"
  (interactive)
  (dpt-exec-sql dpt-exec-param (dpt-get-buffer-sql))
  (with-current-buffer (get-buffer-create "*dpt-log*")
    (insert (concat "\n" (getf dpt-result :msg))))
  (pop-to-buffer "*dpt-log*")
  ;; (with-output-to-temp-buffer "*dpt-log*"
  ;;   (princ (getf dpt-result :msg)))
  )

(provide 'zxc-dpt)
