;;; zxc-db-ac.el --- HTTP client using the url library

;; Author: zhengxc <david.c.aq@gmail.com>
;; Keywords: database autocomplete
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

(require 'deferred)

(defvar zxc-db-ac-host "http://10.95.239.158:8080")

(defvar zxc-db-ac-tablename-url "%s/service/rest/dbMeta/%s/%s" "tablename service url")

(defvar zxc-db-ac-get-create-sql-url "%s/service/rest/dbMeta/getCreateSql/%s/%s" "tablename service url")

(defvar zxc-db-ac-db-alias "1" "数据库别名")

(defvar zxc-db-ac-table-name-candidates nil "tablename candidates")

(defvar zxc-db-ac-default-sources ac-sources "default ac sources")

(defvar zxc-db-ac-source
  '((candidates . zxc-db-ac-tablename-candidates)
    ;; (symbol . "a")
    (cache))
  "table name candidates")


(defun zxc-db-ac-set-db-alias (alias)
  "database alias"
  (interactive "s输入数据库别名：")
  (setf zxc-db-ac-db-alias alias))

(defun zxc-db-ac-get-tables ()
  "get table list from server
return json format [{tableSchema:\"schema\",tableName:\"tablename\"},...]
"
  (deferred:$
    (deferred:url-get (format zxc-db-ac-tablename-url zxc-db-ac-host zxc-db-ac-db-alias (zxc-db-ac-previous-word)))
    (deferred:nextc it
      (lambda (buf)
	(let ((data (with-current-buffer buf (buffer-string)))
	      (json-object-type 'plist)
	      (json-array-type 'list)
	      (json-false nil))
	  (kill-buffer buf)
	  (json-read-from-string data))))
    (deferred:nextc it
      (lambda (array)
	(setf zxc-db-ac-table-name-candidates (mapcar #'(lambda (table-info)
							  (format "%s.%s"
								  (plist-get table-info :tableScheam)
								  (plist-get table-info :tableName)))
						      array))))))

(defun zxc-db-ac-previous-word ()
  "get previous word as tablename prefix"
  (let ((start (point)))
    (save-excursion
      (backward-word)
      (when (and (> (- (point) 1) 0)
		 (equal (buffer-substring-no-properties (point) (- (point) 1))  "."))
	(backward-word))
      (buffer-substring-no-properties start (point)))))

(defun zxc-db-ac-tablename-candidates ()
  "get table candidates"
  (zxc-db-ac-get-tables)
  zxc-db-ac-table-name-candidates)

(defun zxc-db-ac-toggle ()
  "toggle ac db sources"
  (interactive)
  (if (equal ac-sources '(zxc-db-ac-source))
      (setq ac-sources zxc-db-ac-default-sources)
    (setq ac-sources '(zxc-db-ac-source))))

(defun dpt-get-create-sql ()
  "获得建表语句"
  (interactive))


(provide 'zxc-db-ac)
