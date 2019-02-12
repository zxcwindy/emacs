;;; zxc-template-js-ui.el --- js ui template

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

(require 'zxc-template-core)

(defcustom zxc-template-js-ui-list nil
  "The string separating entries in the `separated' style.
See `zxc-js-cp-details-display-style'."
  :type 'list
  :group 'zxc-template)

(defun zxc-get-search-point (str &optional nums)
  (search-forward str)
  (- (point) (or nums 0)))

(defun zxc-get-search-backward-point (str &optional nums)
  (search-backward str)
  (- (point) (or nums 0)))

(defun zxc-kf-vue-template (dir template-name)
  "create kfvue,elementui template"
  (let ((doc-dirs dir)
	(doc-result-dirs (concat zxc-template-root-directory "/" template-name)))
    (unless (file-exists-p doc-result-dirs)
      (mkdir doc-result-dirs t))
    (dolist (file (directory-files doc-dirs  nil "md$"))
      (with-temp-buffer
	(insert-file-contents (concat doc-dirs file))
	(let (result (list))
	  (ignore-errors
	    (while
		(let ((start-point
		       (progn
			 (zxc-get-search-point "```html")
			 (zxc-get-search-point "<template>")))
		      (end-point
		       (progn
			 (zxc-get-search-point "```")
			 (zxc-get-search-backward-point "</template>"))))
		  (push (s-trim (buffer-substring-no-properties start-point end-point)) result))))
	  (when result
	    (add-to-list 'result (s-replace ".md" "" file))
	    (with-temp-file (expand-file-name (s-replace ".md" ".el" file) doc-result-dirs)
	      (insert "(push " (format "'%S" result) " " template-name ")"))))))))


(zxc-template-load zxc-template-js-ui-list kfvue)
(zxc-template-load zxc-template-js-ui-list elementui)
(setq zxc-template-list zxc-template-js-ui-list)

(provide 'zxc-template-js-ui)
