;;; zxc-js-components-snippet.el --- js component snippet

;; Author: zhengxc <david.c.aq@gmail.com>
;; Keywords: js component snippet
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

(require 'zxc-template-js-ui)
(require 'zxc-template-command-tldr)

(define-derived-mode zxc-template-mode fundamental-mode
  "JSCP"
  "A major mode for browsing js components snippets."
  ;; Later versions of emacs reduced the number of arguments to
  ;; font-lock-defaults, at least version 24 requires 5 arguments
  ;; before setting up buffer local variables.
  (mapc #'(lambda (key)
	    (zxc-template-action-str key 'zxc-template-details)) zxc-template-action-keys)
  (define-key zxc-template-mode-map (kbd "n") 'zxc-template-details-forward)
  (define-key zxc-template-mode-map (kbd "p") 'zxc-template-details-previous)
  (define-key zxc-template-mode-map (kbd "f") 'zxc-template-page-forward)
  (define-key zxc-template-mode-map (kbd "b") 'zxc-template-page-previous)
  (define-key zxc-template-mode-map (kbd "q") 'zxc-template-quit)
  (define-key zxc-template-mode-map (kbd "C-g") 'zxc-template-quit)
  (define-key zxc-template-mode-map (kbd "RET") 'zxc-template-insert-and-quit)
  (define-key zxc-template-mode-map (kbd ".") 'zxc-template-change))

(defun zxc-template-load-js ()
  (when (not zxc-template-js-ui-list)
    (zxc-template-load zxc-template-js-ui-list kfvue)
    (zxc-template-load zxc-template-js-ui-list elementui)
    (message "加载js组件完成"))
  (setq zxc-template-list zxc-template-js-ui-list))

(defun zxc-template-load-linux ()
  (when (not zxc-template-command-tldr-list)
    (zxc-template-load zxc-template-command-tldr-list common)
    (zxc-template-load zxc-template-command-tldr-list linux)
    (zxc-template-load zxc-template-command-tldr-list bigdata)
    (message "加载linxu组件完成"))
  (setq zxc-template-list zxc-template-command-tldr-list))


;;;###autoload
(defun zxc-template-list-view ()
  "Display components in the `js cp' in another buffer."
  (interactive)
  (if (eq major-mode 'zxc-template-mode)
      (error "Already viewing the js cp mode")
    (progn
      (setq zxc-template-list nil)
      (cond ((eq major-mode 'web-mode) (zxc-template-load-js))
	    ((eq major-mode 'shell-mode) (zxc-template-load-linux))
	    (t (setq zxc-template-list nil)))
      (if (not zxc-template-list)
	  (message "当前主模式暂无提示")
	(let* ((orig-win (selected-window))
	       (orig-buf (window-buffer orig-win))
	       (buf (get-buffer-create zxc-template-buffer-name)))
	  (setq zxc-template-original-window orig-win
		zxc-template-original-buffer orig-buf)
	  (zxc-template-init buf orig-buf)
	  (pop-to-buffer buf))))))

;;;###autoload
(defun zxc-template-search-view (key)
  "根据名称搜索视图"
  (interactive "s搜索名称：")
  (if (eq major-mode 'zxc-template-mode)
      (error "Already viewing the js cp mode")
    (progn
      (setq zxc-template-list nil)
      (cond ((eq major-mode 'web-mode) (zxc-template-load-js))
	    ((eq major-mode 'shell-mode) (zxc-template-load-linux))
	    (t (setq zxc-template-list nil)))
      (if (not zxc-template-list)
	  (message "当前主模式暂无提示")
	(progn
	  (let ((temp-result (list "*searchResult*")))
	    (dolist (views zxc-template-list temp-result)
	      (loop for i from 1 to (length views)
		    do (if (and (stringp (car (nth i views))) (s-contains? key (car (nth i views))))
			   (add-to-list 'temp-result (nth i views) t))))
	    (setq zxc-template-list  (list temp-result)))
	  (setq zxc-template-current-page 0)
	  (let* ((orig-win (selected-window))
		 (orig-buf (window-buffer orig-win))
		 (buf (get-buffer-create zxc-template-buffer-name)))
	    (setq zxc-template-original-window orig-win
		  zxc-template-original-buffer orig-buf)
	    (zxc-template-init buf orig-buf t)
	    (pop-to-buffer buf)))))))

(provide 'zxc-template)
