;;; zxc-service-remote-shell.el --- remote shell websocket

;; Author: zhengxc <david.c.aq@gmail.com>
;; Keywords: remote shell
;; version: 1.0.0

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


(require 'websocket)
(require 'json)

(make-variable-buffer-local
 (defvar zxc-service-remote-shell-ws nil "创建会话的通道"))

(make-variable-buffer-local
 (defvar zxc-service-remote-shell-session-id nil "shell session id"))

(make-variable-buffer-local
 (defvar shell-encoding 'utf-8 "字符集编码"))

(defun zxc-service-remote-shell-conn-init ()
  "创建socket链接"
  (when (websocket-openp zxc-service-remote-shell-ws)
    (websocket-close zxc-service-remote-shell-ws))
  (setf zxc-service-remote-shell-ws
	(websocket-open
	 "ws://localhost:9990/service/rest/shell/remoteshell"
	 :on-message #'zxc-service-remote-shell-message
	 :on-close #'zxc-service-remote-shell-close-message)))

(define-derived-mode remote-shell-repl-mode comint-mode "remote-shell-repl"
  "Provide a REPL into the visiting browser."
  (setq comint-prompt-regexp shell-prompt-pattern
        comint-input-sender 'shell-input-sender
        comint-process-echoes nil
	comint-use-prompt-regexp t
	comint-prompt-read-only nil)
  (unless (comint-check-proc (current-buffer))
    ;; (insert "welcome\n")
    (start-process "remote-shell-repl" (current-buffer) nil)
    (set-process-query-on-exit-flag (get-buffer-process (current-buffer)) nil)
    (goto-char (point-max))
    (set (make-local-variable 'comint-inhibit-carriage-motion) t)
    (setf zxc-service-remote-shell-session-id (number-to-string (random)))
    (zxc-service-remote-shell-conn-init)
    (websocket-send-text zxc-service-remote-shell-ws (json-encode-list (list :type "create" :content (json-encode-list (append host (list :sessionId zxc-service-remote-shell-session-id))))))))


(defun shell-input-sender (_ input)
  "发送命令到服务端，由于服务端会返回当前行的字符串，未避免
重复显示，命令发送后会删除当前行"
  (websocket-send-text zxc-service-remote-shell-ws (json-encode-list (list :type "send" :content (json-encode-list (list :channelName zxc-service-remote-shell-session-id :content input)))))
  (forward-line -1)
  (kill-whole-line))


(defun zxc-service-remote-shell-message (websocket frame)
  "服务器返回消息处理，当和prompt表达式匹配时，去掉换行符"
  (when frame
    (let* ((replay-message (remote-shell-msg-encoding (websocket-frame-payload frame)))
	   (msg (if (s-matches? shell-prompt-pattern replay-message)
		    (s-replace " \n" " " replay-message)
		  replay-message)))
      (comint-output-filter (get-buffer-process (current-buffer))
			    msg))))

(defun zxc-service-remote-shell-close-message (websocket)
  "服务器socket关闭提示"
  (message "服务器连接关闭"))

(defun remote-shell-msg-encoding (msg)
  "服务器编码消息处理"
  (decode-coding-string msg shell-encoding))

(defun zxc-service-remote-shell-interrupt ()
  "终止当前任务"
  (interactive)
  (websocket-send-text zxc-service-remote-shell-ws (json-encode-list (list :type "send" :content (json-encode-list (list :channelName zxc-service-remote-shell-session-id :content ""))))))

;; (defun zxc-service-remote-shell-exit-query ()
;;   "kill buffer时提示"
;;   (when zxc-service-remote-shell-session-id
;;     (yes-or-no-p (format "Buffer `%s' still has clients; kill it? "
;; 			 (buffer-name (current-buffer))))))
;;; 会影响kill-buffer方法，暂时屏蔽
;; (add-hook 'kill-buffer-query-functions 'zxc-service-remote-shell-exit-query)

(defun zxc-service-remote-shell-exit ()
  "关闭远程session会话"
  (when zxc-service-remote-shell-session-id
    (condition-case err
	(websocket-send-text zxc-service-remote-shell-ws (json-encode-list (list :type "exit" :content (json-encode-list (list :channelName zxc-service-remote-shell-session-id :content "exit")))))
      (error err))))

(add-hook 'kill-buffer-hook 'zxc-service-remote-shell-exit)

(add-hook 'remote-shell-repl-mode-hook
	  (lambda ()
	    (local-set-key "\C-c\C-c" 'zxc-service-remote-shell-interrupt)))

(defun start-remote-shell (alias)
  "start remote shell"
  (interactive "sInput host alias: ")
  (let ((host (gethash alias shell-host-alias-interface)))
    (when host
      (switch-to-buffer (get-buffer-create "*remote-shell*"))
      (rename-buffer (concatenate 'string "*" alias "*") t)
      (remote-shell-repl-mode))))

(global-set-key [f9] 'start-remote-shell)

(provide 'zxc-service-remote-shell)
