;;; zxc-db.el --- database client

;; Author: zhengxc <david.c.aq@gmail.com>
;; Keywords: database
;; version: 0.1.0

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

(require 'ctable)
(require 'zxc-db-ac)
(require 'zxc-util)

(make-variable-buffer-local
 (defvar zxc-db-host "http://localhost:9990"
   "平台地址"))

(defvar zxc-db-query-param nil "查询语句默认参数")

(defvar zxc-db-exec-param nil "其他语句默认参数")

(defvar zxc-db-get-create-sql-url "%s/service/rest/dbMeta/getCreateSql/%s/%s" "tablename service url")

(defvar zxc-db-result nil
  "返回结果集")

(defvar zxc-db-timer nil
  "timer")

(defun zxc-db-send (uri object zxc-db-callback)
  "Send object to URL as an HTTP POST request, returning the response
and response headers.
object is an json, eg {key:value} they are encoded using CHARSET,
which defaults to 'utf-8"
  (lexical-let ((zxc-db-callback zxc-db-callback))
    (deferred:$
      (deferred:url-post (format "%s/service/rest/data/%s/%s" zxc-db-host uri zxc-db-ac-db-alias) object)
      (deferred:nextc it
	(lambda (buf)
	  (let ((data (with-current-buffer buf (buffer-string)))
		(json-object-type 'plist)
		(json-array-type 'list)
		(json-false nil))
	    (kill-buffer buf)
	    (setf zxc-db-result (json-read-from-string (decode-coding-string data 'utf-8))))))
      (deferred:nextc it
	(lambda (response)
	  (funcall zxc-db-callback))))))

;;temp-func
(defun zxc-db-get (uri zxc-db-callback)
  "Send object to URL as an HTTP GET request, returning the response
and response headers, object is an text."
  (lexical-let ((zxc-db-callback zxc-db-callback))
    (deferred:$
      (deferred:url-get uri)
      (deferred:nextc it
	(lambda (buf)
	  (let ((data (with-current-buffer buf (buffer-string))))
	    (kill-buffer buf)
	    (setf zxc-db-result (decode-coding-string data 'utf-8)))))
      (deferred:nextc it
	(lambda (response)
	  (funcall zxc-db-callback))))))

(defun zxc-db-create-column ()
  "创建表头"
  (mapcar #'(lambda (meta-info)
	      (make-ctbl:cmodel :title (s-replace-regexp ".*\\." "" meta-info) :align 'center :sorter nil))
	  (getf zxc-db-result :metadata)))

(defun zxc-db-create-table-buffer ()
  "创建结果表格"
  (let ((cp
	 (ctbl:create-table-component-buffer
	  :width nil :height nil
	  :model
	  (make-ctbl:model
	   :column-model (zxc-db-create-column)
	   :data (getf zxc-db-result :data))))
	(pre-10-tbl (get-buffer (format "*Table: %d*" (- ctbl:uid 10)))))
    (delete-other-windows)		;fix windows bug
    (display-buffer (ctbl:cp-get-buffer cp))
    (when pre-10-tbl
      (kill-buffer pre-10-tbl))))

(defun zxc-db-create-sql-insert ()
  "根据结果创建insert sql"
  (let* ((tmp-meta (getf zxc-db-result :metadata))
	 (tmp-data (getf zxc-db-result :data))
	 (tmp-tablename (s-replace-regexp "\\..*" "" (nth 0 tmp-meta))))
    (when (> (length tmp-data) 0)
      (insert "\n"))
    (loop for row-data in tmp-data
	  do  (let ((value-str ""))
		(loop for item in row-data
		      do (if (eq 'string (type-of item))
			     (setf value-str (s-concat value-str "'" item "',"))
			   (setf value-str (s-concat value-str (prin1-to-string item) ","))))
		(insert "\ninsert into " tmp-tablename " (" (s-join "," (mapcar #'(lambda (meta)
										    (s-replace-regexp ".*\\." "" meta))
										tmp-meta))
			") values (" (substring value-str 0 (- (length value-str) 1)) ");" )))))



(defun zxc-db-get-table-name ()
  "取得表名"
  (if (region-active-p)
      (buffer-substring-no-properties (region-beginning) (region-end))
    (let ((start (save-excursion
		   (forward-char)
		   (backward-word)
		   (point)))
	  (end (save-excursion
		 (forward-word)
		 (point))))
      (buffer-substring-no-properties start end))))

(defun zxc-db-query-callback ()
  "查询结果回调函数"
  (let ((error-msg (getf zxc-db-result :errorMsg)))
    (if (null error-msg)
	(save-excursion
	  (zxc-db-create-table-buffer))
      (with-current-buffer (get-buffer-create "*zxc-db-log*")
	(goto-char (point-max))
	(insert (concat "\n" error-msg))
	(goto-char (point-max)))
      (display-buffer "*zxc-db-log*"))))

(defun zxc-db-exec-callback ()
  "执行结果回调函数"
  ;; (with-current-buffer (get-buffer-create "*zxc-db-log*")
  ;;   (goto-char (point-max))
  ;;   ;; (insert (concat "\n" (getf zxc-db-result :msg)))
  ;;   (insert (concat "\n" (int-to-string zxc-db-result)))
  ;;   (goto-char (point-max)))
  ;; (display-buffer "*zxc-db-log*")
  (let ((error-msg (getf zxc-db-result :errorMsg)))
    (if (null error-msg)
	(message "更新记录%s" (getf zxc-db-result :result))
      (with-current-buffer (get-buffer-create "*zxc-db-log*")
	(goto-char (point-max))
	(insert (decode-coding-string (concat "\n" error-msg) 'utf-8))
	(goto-char (point-max)))
      (display-buffer "*zxc-db-log*"))))

(defun zxc-db-get-callback ()
  "普通方式结果回调函数"
  (if (region-active-p)
      (delete-region (region-beginning) (region-end))
    (zxc-delete-current-word))
  (save-excursion
    (insert zxc-db-result)))


(defun zxc-db-send-region-query ()
  "查询当前区域SQL"
  (interactive)
  (zxc-db-send "query" (list (cons "sql" (zxc-util-get-region-or-paragraph-string))
			     (cons "limit" "500")) #'zxc-db-query-callback))

(defun zxc-db-send-region-exec ()
  "执行当前区域SQL"
  (interactive)
  (zxc-db-send "exec" (list (cons "sql" (zxc-util-get-region-or-paragraph-string))) #'zxc-db-exec-callback))

(defun zxc-db-get-data (func)
  "get方式获取后台数据"
  (zxc-db-get (format "%s/service/rest/dbMeta/%s/%s/%s" zxc-db-host func zxc-db-ac-db-alias (zxc-db-get-table-name))  #'zxc-db-get-callback))


(defun zxc-db-get-table-sql ()
  "获取建表语句"
  (interactive)
  (zxc-db-get-data "getCreateSql"))

(defun zxc-db-get-select-sql ()
  "获取查询语句"
  (interactive)
  (zxc-db-get-data "getSelectSql"))

(defun zxc-db-send-region-format-insert-sql ()
  "查询当前区域SQL并转化为insert语句"
  (interactive)
  (zxc-db-send "query" (list (cons "sql" (zxc-util-get-region-or-paragraph-string))
			     (cons "limit" "500")) #'zxc-db-create-sql-insert))


(defun zxc-db-send-region-decrypt ()
  "解密当前区域密码内容"
  (interactive)
  (setq-local cur-buf (current-buffer)
	      decrypt-start (region-beginning)
	      decrypt-end (region-end)
	      origin-password (zxc-util-get-region-or-paragraph-string))
  (deferred:$
    (deferred:url-get (format "%s/service/rest/api/crypto/des/decrypt" zxc-db-host) (list (cons "data" origin-password)))
    (deferred:nextc it
      (lambda (buf)
	(let ((data (with-current-buffer buf (buffer-string))))
	  (kill-buffer buf)
	  (with-current-buffer cur-buf
	    (replace-string-in-region origin-password data decrypt-start decrypt-end)))))))


(provide 'zxc-db)
