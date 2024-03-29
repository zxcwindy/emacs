;;; zxc-http.el --- HTTP client using the url library

;; Author: zhengxc
;; Keywords: http,server

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

(require 'impatient-mode)
(require 'cl-lib)

(defun httpd--filter (proc chunk)
  "Runs each time client makes a request.
   重写支持汉字url路径"
  (with-current-buffer (process-get proc :request-buffer)
    (setf (point) (point-max))
    (insert chunk)
    (let ((request (process-get proc :request)))
      (unless request
	(when (setf request (httpd-parse))
	  (delete-region (point-min) (point))
	  (process-put proc :request request)))
      (when request
	(let ((content-length (cadr (assoc "Content-Length" request))))
	  (when (or (null content-length)
		    (= (buffer-size) (string-to-number content-length)))
	    (let* ((content (buffer-string))
		   (uri (cl-cadar request))
		   (parsed-uri (httpd-parse-uri (concat uri)))
		   (uri-path (httpd-unhex (nth 0 parsed-uri)))
		   (uri-query (append (nth 1 parsed-uri)
				      (httpd-parse-args content)))
		   (servlet (httpd-get-servlet uri-path)))
	      (erase-buffer)
	      (process-put proc :request nil)
	      (setf request (nreverse (cons (list "Content" content)
					    (nreverse request))))
	      (httpd-log `(request (date ,(httpd-date-string))
			    (address ,(car (process-contact proc)))
			    (get ,uri-path)
			    ,(cons 'headers request)))
	      (if (null servlet)
		  (httpd--error-safe proc 404)
		(condition-case error-case
		    (funcall servlet proc uri-path uri-query request)
		  (error (httpd--error-safe proc 500 error-case))))
	      (when (httpd--connection-close-p request)
		(process-send-eof proc)))))))))


;;;###autoload
(defun zxc-httpd-start ()
  "start http server"
  (interactive)
  (unless (process-status "httpd")
    (let ((httpd-port 9991))
      (setq httpd-host (format-network-address (car (network-interface-info "wlp0s20f3")) t))
      ;; (setq httpd-host "0.0.0.0")
      (httpd-start)
      (httpd-def-file-servlet bootstrap "/home/david/git/bootstrap")
      (httpd-def-file-servlet jquery "/home/david/git/jquery")
      (httpd-def-file-servlet js "/home/david/svn/DMP/BASELINE/DMP-DP-DIP/03 代码/core/lib")
      (message "server started..."))))

(defun httpd-send-directory (proc path uri-path)
  "redefine Serve a file listing to the client. If PROC is T use the
`httpd-current-proc' as the process."
  (httpd-discard-buffer)
  (let ((title (concat "Directory listing for "
		       (url-insert-entities-in-string uri-path))))
    (if (equal "/" (substring uri-path -1))
	(with-temp-buffer
	  (httpd-log `(directory ,path))
	  (set-buffer-multibyte t)
	  (insert "<!DOCTYPE html>\n")
	  (insert "<html>\n<head><meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\" /><title>" title "</title></head>\n")
	  (insert "<body>\n<h2>" title "</h2>\n<hr/>\n<ul>")
	  (dolist (file (directory-files path))
	    (unless (eq ?. (aref file 0))
	      (let* ((full (expand-file-name file path))
		     (tail (if (file-directory-p full) "/" ""))
		     (f  file)
		     (l file))
		(insert (format "<li><a href=\"%s%s\">%s%s</a></li>\n"
				l tail f tail)))))
	  (insert "</ul>\n<hr/>\n</body>\n</html>")
	  (httpd-send-header proc "text/html;charset=utf-8" 200))
      (httpd-redirect proc (concat uri-path "/")))))


(defun zxc-httpd-set-root ()
  "当前buffer的文件夹为根路径，如果buffer没有关联文件则设置默认文件夹"
  (let ((root (cond ((buffer-file-name) (file-name-directory (buffer-file-name)))
		    ((eq major-mode 'dired-mode) (dired-current-directory))
		    (t "/home/david/tmp"))))
    (eval `(httpd-def-file-servlet my ,root))
    (message (cl-concatenate 'string "http://" httpd-host  ":9991/my relocate to " root ))))

(defun zxc-httpd-imp ()
  "为当前buffer提供2个视图"
  (interactive)
  (zxc-httpd-start)
  (if (not impatient-mode)
      (progn
	(impatient-mode)
	(message "start..."))
    (impatient-mode -1)
    (message "stop...")))

(defun httpd/imp/json (proc path query req)
  "返回json视图"
  (let* ((parts (cdr (split-string path "/")))
	 (buffer-name (nth 2 parts))
	 (file (httpd-clean-path (mapconcat 'identity (nthcdr 2 parts) "/")))
	 (buffer (get-buffer buffer-name))
	 (buffer-file (buffer-file-name buffer))
	 (buffer-dir (and buffer-file (file-name-directory buffer-file))))
    (message file)
    (cond
     ((equal (file-name-directory path) "/imp/json/")
      (httpd-redirect proc (concat path "/")))
     ((not (imp-buffer-enabled-p buffer)) (imp--private proc buffer-name))
     (t
      (with-httpd-buffer proc "application/json;charset=utf-8"
	(insert-buffer-substring buffer))))))

(defun zxc-httpd-server ()
  (interactive)
  (zxc-httpd-start)
  (zxc-httpd-set-root)
  (browse-url-generic (cl-concatenate 'string "http:/" httpd-host ":9991/my")))

;; (global-set-key [f10] #'zxc-httpd-imp)
(global-set-key [f10] 'zxc-httpd-server)

(provide 'zxc-httpd)
