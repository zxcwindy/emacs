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

(defvar dpt-datasource "DWDB"
  "数据源别名")

(defvar dpt-query-param `((command . "init")
			  (start . "0")
			  (limit . "100")
			  (root . "root"))
  "查询语句默认参数")

(defvar dpt-exec-param `((command . "executeSQL"))
  "其他语句默认参数")

(defvar dpt-result nil
  "返回结果集")

(defvar dpt-timer nil
  "timer")

(defun dpt-login ()
  "登录"
  (interactive)
  (minibuffer-message (http-post (concat dpt-host "/core/login")
				 dpt-user-info-param))
  (dpt-keep-session))

(defun dpt-keep-session ()
  "保持登录"
  (let ((host dpt-host))
    (when dpt-timer
      (cancel-timer dpt-timer))
    (setf dpt-timer (run-with-timer 300 300
				    #'(lambda ()
					(deferred:$
					  (deferred:url-post-json (concat dpt-host "/core/login")
					    dpt-user-info-param)
					  (deferred:nextc it
					    (lambda (buf)
					      (kill-buffer buf)))))))))


(defun dpt-send (object dpt-callback)
  "Send object to URL as an HTTP POST request, returning the response
and response headers.
object is an json, eg {key:value} they are encoded using CHARSET,
which defaults to 'utf-8"
  (lexical-let ((dpt-callback dpt-callback))
    (deferred:$
      (deferred:url-get (concat dpt-host "/core/newrecordService") object)
      (deferred:nextc it
	(lambda (buf)
	  (let ((data (with-current-buffer buf (buffer-string)))
		(json-object-type 'plist)
		(json-array-type 'list)
		(json-false nil))
	    (kill-buffer buf)
	    (setf dpt-result (json-read-from-string (decode-coding-string data 'utf-8))))))
      (deferred:nextc it
	(lambda (response)
	  (funcall dpt-callback))))))

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
			    (unless (and (symbolp data) data)
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

(defun dpt-query-callback ()
  "查询结果回调函数"
  (let ((error-msg (getf dpt-result :errorMsg)))
    (if (null error-msg)
	(dpt-create-table-buffer)
      (with-current-buffer (get-buffer-create "*dpt-log*")
	(goto-char (point-max))
	(insert (concat "\n" error-msg))
	(goto-char (point-max)))
      (pop-to-buffer "*dpt-log*"))))

(defun dpt-exec-callback ()
  "执行结果回调函数"
  (with-current-buffer (get-buffer-create "*dpt-log*")
    (goto-char (point-max))
    (insert (concat "\n" (getf dpt-result :msg)))
    (goto-char (point-max)))
  (pop-to-buffer "*dpt-log*"))


(defun dpt-send-region-query ()
  "查询当前区域SQL"
  (interactive)
  (dpt-send (append dpt-query-param (list (cons 'dataSource dpt-datasource) (cons 'initSql (dpt-get-buffer-sql)))) #'dpt-query-callback))

(defun dpt-send-region-exec ()
  "执行当前区域SQL"
  (interactive)
  (dpt-send (append dpt-exec-param (list (cons 'dataSource dpt-datasource) (cons 'initSql (dpt-get-buffer-sql)))) #'dpt-exec-callback))

(provide 'zxc-dpt)
