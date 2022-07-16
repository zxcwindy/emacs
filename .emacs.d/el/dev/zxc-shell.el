;;; zxc-shell.el --- shell command

;; Author: zhengxc
;; Email: david.c.aq@gmail.com
;; Keywords: shell command

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

(require 'flymake-shellcheck)

(eval-after-load "shell"
  '(define-key shell-mode-map "\C-a" 'comint-bol-or-process-mark))

(defun zxc-shell-command (command)
  "start shell command"
  (interactive "s输入命令：")
  (let ((buffer-name (concatenate 'string "*" command "*")))
    (if (eq nil (get-buffer buffer-name))
	(progn
	  (shell buffer-name)
	  (comint-simple-send (get-buffer-process (get-buffer buffer-name)) command))
      (shell buffer-name))))

(add-hook 'shell-mode-hook #'(lambda ()
			       (modify-syntax-entry ?. "w" shell-mode-syntax-table)
			       (modify-syntax-entry ?_ "w" shell-mode-syntax-table)
			       (setf ac-sources '(ac-source-dictionary))
			       (setq outline-regexp "bash-4.2\$ ")
			       (outline-minor-mode t)))

(add-hook 'sh-mode-hook 'flymake-shellcheck-load)
(add-hook 'sh-mode-hook 'flymake-mode)

(provide 'zxc-shell)
