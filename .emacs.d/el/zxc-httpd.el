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

;;;###autoload
(defun zxc-httpd-start ()
  "start http server"
  (interactive)
  (unless (process-status "httpd")
    (let ((httpd-port 9991))
      (httpd-start)
      (httpd-def-file-servlet bootstrap "/home/david/git/bootstrap")
      (httpd-def-file-servlet jquery "/home/david/git/jquery")
      (httpd-def-file-servlet js "/home/david/svn/DMP/BASELINE/DMP-DP-DIP/03 代码/core/lib")
      (message "server started..."))))


(defmacro zxc-httpd-set-root ()
  "当前buffer的文件夹为根路径，如果buffer没有关联文件则设置默认文件夹"
  (let ((root (cond ((buffer-file-name) (file-name-directory (buffer-file-name)))
		    (t "/home/david/tmp"))))
    `(httpd-def-file-servlet my ,root)))

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
      (with-httpd-buffer proc "application/json"
	(insert-buffer-substring buffer))))))


(global-set-key [f10] #'zxc-httpd-imp)
(global-set-key [M-f10] #'(lambda ()
			    (interactive)
			    (zxc-httpd-start)
			    (zxc-httpd-set-root)))

(provide 'zxc-httpd)
