;;; zxc-http.el --- HTTP client using the url library

;; Author: zhengxc
;; Keywords: http,client,get,post

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

(require 'http-post-simple)
(require 'http-get-simple)
(require 'json)

(defvar http-data nil "response text")

(defun http-method (url method)
  "GET or POST method for http request,returning the response head,status code,data"
  (if (string= (upcase method) "POST")
      (http-post-simple url nil)
    (http-get-simple url nil)))

(defun http-json-2-lisp (lst)
  "when the response status is 200 and it's data is a json string,
convert a json string to plist object"
  (multiple-value-bind (data head status) lst
    (if (= status 200)
	(condition-case err
	    (let ((json-object-type 'plist)
		  (json-array-type 'list))
	      (setf http-data (json-read-from-string (decode-coding-string data 'utf-8))))
	  (json-readtable-error
	   (message "返回的不是正确的json字符串")))
      (minibuffer-message status))))

(defun http-get-json (url)
  "GET method"
  (http-json-2-lisp (http-method url "GET")))


(defun http-post-json (url)
  "POST method"
  (http-json-2-lisp (http-method url "POST")))


(provide 'zxc-http)
;; zxc-http.el ends here
