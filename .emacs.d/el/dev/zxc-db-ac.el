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
(require 'company)

(defvar zxc-db-ac-tablename-url "%s/service/rest/dbMeta/%s/%s" "host,alias,tablename service url")

(make-variable-buffer-local
 (defvar zxc-db-ac-db-alias "1" "数据库别名"))

(defvar zxc-db-ac-table-name-candidates nil "tablename candidates")

(defvar zxc-db-ac-default-sources ac-sources "default ac sources")

(defvar zxc-db-ac-source
  '((candidates . zxc-db-ac-tablename-candidates)
    ;; (symbol . "a")
    ;; (cache)
    )
  "table name candidates")

(defvar zxc-db-ac-alias-db-map (make-hash-table :test 'equal))


(defun zxc-db-ac-set-db-alias (alias)
  "database alias"
  (interactive "s输入数据库别名：")
  (setf zxc-mode-lighter (format "Zxc[%s]" alias))
  (setf zxc-db-ac-db-alias alias))

(defun zxc-db-ac-get-tables ()
  "get table list from server
return json format [{tableSchema:\"schema\",tableName:\"tablename\"},...]
"
  (deferred:$
    (deferred:url-get (format zxc-db-ac-tablename-url zxc-db-host zxc-db-ac-db-alias (zxc-db-ac-previous-word)))
    (deferred:nextc it
      (lambda (buf)
	(let ((data (with-current-buffer buf (buffer-string)))
	      (json-object-type 'plist)
	      (json-array-type 'list)
	      (json-false nil))
	  (kill-buffer buf)
	  (condition-case error
	      (json-read-from-string data)
	    (error "error data : %s" error)))))
    (deferred:nextc it
      (lambda (result)
	(when (> (length result) 0)
	  (setf zxc-db-ac-table-name-candidates result))))))

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

(defun zxc-db-tablename-candidates (prefix)
  "company backbend"
  (mapcar #'(lambda (item)
	      (string-replace
	       (concat (gethash zxc-db-ac-db-alias zxc-db-ac-alias-db-map zxc-db-ac-db-alias) ".") "" item))
	  (http-get (format zxc-db-ac-tablename-url zxc-db-host zxc-db-ac-db-alias
			    (concat (gethash zxc-db-ac-db-alias zxc-db-ac-alias-db-map zxc-db-ac-db-alias) "." prefix)))))

(defun zxc-db-ac-toggle ()
  "toggle ac db sources"
  (interactive)
  (if (equal ac-sources '(zxc-db-ac-source))
      (progn (setq ac-sources zxc-db-ac-default-sources)
	     (message "复位ac"))
    (setq ac-sources '(zxc-db-ac-source))
    (auto-complete-mode t)
    (message "启用db-ac")))

(defun zxc-company-sql-backend (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'zxc-company-sql-backend))
    (prefix (and (eq major-mode 'sql-mode)
		 (company-grab-symbol)))
    (candidates (zxc-db-tablename-candidates arg))
    (sorted t)
    (duplicates t)))

(add-to-list 'company-backends 'zxc-company-sql-backend)

(add-hook 'sql-mode-hook #'(lambda ()
			     (company-mode)
			     (set (make-local-variable 'company-backends)
				  '((company-capf
				     zxc-company-sql-backend
				     company-yasnippet)))
))

(provide 'zxc-db-ac)
