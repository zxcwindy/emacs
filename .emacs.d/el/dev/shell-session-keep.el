;;; shell-session-keep.el --- keep session

;; Author: zhengxc
;; Email: david.c.aq@gmail.com
;; Keywords: shell session

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

;;   (require 'shell-session-keep)
;;
;; Usage:
;; (shell-session-keep) ;;only call once time
;; (setf shell-session-keep-filter-names (list "158" "118" "134"))

(require 'comint)
(require 's)

(defvar shell-session-keep-timer nil "keep session timer")

(defvar shell-session-keep-filter-names nil "buffer names which will be keeping")

(defun shell-session-keep-send-input ()
  "comint new line to process in buffer"
  (mapcar #'(lambda (buffer)
	      (unless (eq (current-buffer) buffer)
		(comint-simple-send (get-buffer-process buffer) "")))
	  (shell-session-keep-filter shell-session-keep-filter-names)))

(defun shell-session-keep-filter (names)
  "filter buffers which contains names"
  (let (filter-buffers)
    (mapc #'(lambda (buffer)
	      (when (some #'(lambda (buf-name)
			      (and (string= "shell-mode"
					    (buffer-local-value 'major-mode buffer))
				   (s-contains?  buf-name (buffer-name buffer))))
			  names)
		(push buffer filter-buffers)))
	  (buffer-list))
    filter-buffers))

(defun shell-session-keep ()
  "to start session keeping"
  (shell-session-keep-stop)
  (setf shell-session-keep-timer
	(run-with-timer 20 120
			'shell-session-keep-send-input)))

(defun shell-session-keep-stop ()
  "stop keeping session timer"
  (when shell-session-keep-timer
    (setf shell-session-keep-timer (cancel-timer shell-session-keep-timer))))

(provide 'shell-session-keep)
