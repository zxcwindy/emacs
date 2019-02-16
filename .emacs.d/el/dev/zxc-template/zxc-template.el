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

;;;###autoload
(defun zxc-template-list-view ()
  "Display components in the `js cp' in another buffer."
  (interactive)
  (if (eq major-mode 'zxc-template-mode)
      (error "Already viewing the js cp mode")
    (progn
      (setq zxc-template-list nil)
      (cond ((eq major-mode 'web-mode) (setq zxc-template-list zxc-template-js-ui-list))
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

(provide 'zxc-template)
