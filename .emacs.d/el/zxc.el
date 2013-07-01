;; zxc.el --- my util tools collection

;; Author: zhengxc
;; Keywords: util tools

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
(require 'cl)
(require 'zxc-util)
(require 'zxc-http)

;;;; Minor Mode Definition

(defvar zxc-mode-map (make-sparse-keymap)
  "Keymap for the zxc minor mode.")

(define-minor-mode zxc-mode
  "Minor mode for Zxc"
  :lighter " Zxc")

(defvar host "http://localhost:8080")
(defvar db-meta "service/dbMeta" "dbmeta uri")
(defvar db-name "db2" "database name")

(define-key zxc-mode-map (kbd  "C-; cs") #'insert-sql-format)

(defun get-table-meta (db-name table-name)
  (http-get-json (concat-string-by-backslash host db-meta db-name table-name)))

(defun insert-sql-format ()
"insert sql statment with table name"
  (interactive)
  (let ((table-name (filter-buffer-substring (point) (mark))))
    (insert "select " (mapconcat #'(lambda(col)
				     (plist-get col :colName))
				 (plist-get (get-table-meta db-name table-name) :colsList) ",")
	    " from ")))


(provide 'zxc)
