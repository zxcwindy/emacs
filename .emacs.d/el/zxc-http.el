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

(defun http-method (url method &optional fields)
  "GET or POST method for http request,returning the response head,status code,data"
  (if (string= (upcase method) "POST")
      (http-post-simple url fields)
    (http-get-simple url fields)))

(defun http-json-2-lisp (lst)
  "when the response status is 200 and it's data is a json string,
convert a json string to plist object"
  (multiple-value-bind (data head status) lst
    (setf data (decode-coding-string data 'utf-8))
    (if (= status 200)
	(condition-case err
	    (let ((json-object-type 'plist)
		  (json-array-type 'list)
		  (json-false nil))
	      (setf http-data (json-read-from-string data)))
	  (json-readtable-error
	   (message "返回的不是正确的json字符串:%s" data)))
      (minibuffer-message status))))

(defun http-get (url &optional fields)
  "GET method"
  (http-json-2-lisp (http-method url "GET" fields)))


(defun http-post (url &optional fields)
  "POST method"
  (http-json-2-lisp (http-method url "POST" fields)))

(defun ajax-post (url object)
  "ajax post method"
  (http-json-2-lisp (http-post-ajax-simple url object)))

(defun http-post-ajax-simple (url object &optional charset)
  "Send object to URL as an HTTP POST request, returning the response
and response headers.
object is an json, eg {key:value} they are encoded using CHARSET,
which defaults to 'utf-8"
  (http-post-simple-internal
   url
   (json-encode object)
   charset
   `(("Content-Type"
      .
      ,(http-post-content-type
        "application/json"
        (or charset 'utf-8))))))


(provide 'zxc-http)
;; zxc-http.el ends here
