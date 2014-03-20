;; zxc.el --- my util tools collection

;; Author: zhengxc
;; Keywords: tools

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
(require 'zxc-comet)
(require 'zxc-db)

;;;; Minor Mode Definition

(defvar zxc-mode-map (make-sparse-keymap)
  "Keymap for the zxc minor mode.")

(define-minor-mode zxc-mode
  "Minor mode for Zxc"
  :lighter " Zxc")

(defvar zxc-host "http://localhost:9990")
(defvar db-meta "service/rest/dbMeta" "dbmeta uri")
(defvar db-name "db2" "database name")

(define-key zxc-mode-map (kbd  "C-; cs") #'insert-sql-format)
(define-key zxc-mode-map (kbd  "C-; cf") #'code-format)
(define-key zxc-mode-map (kbd  "C-; ch") #'comet-set-url)
(define-key zxc-mode-map (kbd  "C-; cu") #'comet-subscribe)
(define-key zxc-mode-map (kbd  "C-; cc") #'comet-publish-paragraph)
(define-key zxc-mode-map (kbd  "C-; cr") #'comet-publish-region)
(define-key zxc-mode-map (kbd  "C-; cx") #'comet-publish-html)
;; (define-key zxc-mode-map (kbd  "C-; dl") #'dpt-login)
;; (define-key zxc-mode-map (kbd  "C-; de") #'dpt-send-region-exec)
;; (define-key zxc-mode-map (kbd  "C-; ds") #'dpt-send-region-query)
(define-key zxc-mode-map (kbd  "C-; dl") #'zxc-db-login)
(define-key zxc-mode-map (kbd  "C-; de") #'zxc-db-send-region-exec)
(define-key zxc-mode-map (kbd  "C-; ds") #'zxc-db-send-region-query)
(define-key zxc-mode-map (kbd  "C-; aa") #'zxc-db-ac-set-db-alias)
(define-key zxc-mode-map (kbd  "C-; ac") #'zxc-db-ac-toggle)

(defun get-table-meta (db-name table-name)
  (http-get (concat-string-by-backslash zxc-host db-meta db-name table-name)))

(defun insert-sql-format (beg end)
  "insert sql statment with table name"
  (interactive "r")
  (let* ((table-name (filter-buffer-substring beg end))
	 (table-meta (get-table-meta db-name table-name))
	 (cols-list (plist-get table-meta :colsList)))
    (when (> (length cols-list) 0)
      (when (region-active-p)
	(kill-region (region-beginning) (region-end)))
      (insert "select " (mapconcat #'(lambda(col)
				       (plist-get col :colName))
				   cols-list    ",")
	      " from " table-name))))

(defun code-format ()
  (interactive)
  (insert (convert-format)))


(provide 'zxc)
