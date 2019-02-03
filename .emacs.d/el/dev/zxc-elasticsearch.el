;; zxc-elasticsearch.el --- elasticsearch

;; Author: zhengxc
;; Keywords: elasticsearch

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

(require 'es-mode)

(make-variable-buffer-local
 (defvar zxc-es-endpoint-url "http://localhost:9200/"
   "es默认地址"))

(make-variable-buffer-local
 (defvar zxc-es-request-method "GET"
   "默认请求方式"))



(defun zxc-es--execute-string (request-url request-data)
  "Submits the active region as a query to the specified
endpoint. If the region is not active, the whole buffer is
used. Uses the params if it can find them or alternativly the
vars."
  (let* ((url request-url)
	 (url-request-method zxc-es-request-method))
    (let* ((result-buffer-name (if (zerop es--query-number)
				  (format "*ES: %s*" (buffer-name))
				(format "*ES: %s [%d]*"
					(buffer-name)
					es--query-number))))
      (when (es--warn-on-delete-yes-or-no-p url-request-method)
	(let* ((results-buffer (get-buffer-create result-buffer-name)))
	  (message "Issuing %s against %s" url-request-method url)
	  (request
	   url
	   :type url-request-method
	   :parser 'buffer-string
	   :headers es-default-headers
	   :data (let* ((utf-raw (encode-coding-string request-data 'utf-8))
			(utf-trimmed (string-trim utf-raw)))
		   (if (string= "" utf-trimmed)
		       utf-trimmed
		     utf-raw))
	   :timeout 600 ;; timeout of 10 minutes
	   :complete (cl-function
		      (lambda (&key data response error-thrown &allow-other-keys)
			(let ((utf-data (decode-coding-string data 'utf-8)))
			  (with-current-buffer (if (zerop es--query-number)
						   (format "*ES: %s*" (buffer-name))
						 (format "*ES: %s [%d]*"
							 (buffer-name)
							 es--query-number))
			    (es-result--handle-response utf-data response error-thrown))))))
	  (setq es-results-buffer results-buffer)
	  (display-buffer-in-side-window es-results-buffer '((side . right) (window-width . 0.5)))
	  ;; (es--maybe-show-results-buffer es-results-buffer)
	  )))))

(defun es--execute-string (request-data)
  "Submits the active region as a query to the specified
endpoint. If the region is not active, the whole buffer is
used. Uses the params if it can find them or alternativly the
vars."
  (let* ((params (or (es--find-params)
		     `(,(es-get-request-method) . ,(es-get-url))))
	 (url (es--munge-url (cdr params)))
	 (url-request-method (car params)))
    (let ((result-buffer-name (if (zerop es--query-number)
				  (format "*ES: %s*" (buffer-name))
				(format "*ES: %s [%d]*"
					(buffer-name)
					es--query-number))))
      (when (es--warn-on-delete-yes-or-no-p url-request-method)
	(let ((results-buffer (get-buffer-create result-buffer-name)))
	  (message "Issuing %s against %s" url-request-method url)
	  (request
	   url
	   :type url-request-method
	   :parser 'buffer-string
	   :headers es-default-headers
	   :data (let* ((utf-raw (encode-coding-string request-data 'utf-8))
			(utf-trimmed (string-trim utf-raw)))
		   (if (string= "" utf-trimmed)
		       utf-trimmed
		     utf-raw))
	   :timeout 600 ;; timeout of 10 minutes
	   :complete (cl-function
		      (lambda (&key data response error-thrown &allow-other-keys)
			(let ((utf-data (decode-coding-string data 'utf-8)))
			  (with-current-buffer results-buffer
			    (es-result--handle-response utf-data response error-thrown))))))
	  (setq es-results-buffer results-buffer)
	  (display-buffer-in-side-window es-results-buffer '((side . right) (window-width . 0.5)))
	  ;; (es--maybe-show-results-buffer es-results-buffer)
	  )))))

(defun zxc-es--list (type)
  "查找_cat相关信息"
  (zxc-es--execute-string (es--munge-url (concat zxc-es-endpoint-url "_cat/" type "?v")) ""))

(defun zxc-es--list-indexes ()
  "列出index信息"
  (interactive)
  (zxc-es--list "indices"))

(defun zxc-es--list-nodes ()
  "列出node信息"
  (interactive)
  (zxc-es--list "nodes"))

(defun zxc-es--query-sql ()
  "查询sql"
  (interactive)
  (zxc-es--execute-string (es--munge-url (concat zxc-es-endpoint-url "_sql?sql="
						 (s-replace-regexp "[ |\n]" "%20" (s-trim (zxc-util-get-region-or-paragraph-string))))) ""))


(org-babel-do-load-languages
 'org-babel-load-languages
 '((elasticsearch . t)))

(provide 'zxc-elasticsearch)
