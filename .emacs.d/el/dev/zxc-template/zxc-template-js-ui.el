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

(defun zxc-template-vue-extra (html)
  "从elementui和kfcomponents帮助文档中提取模板信息
正则表达式参考方法
`(defun parse-definitions ()
      (let ((dict nil))
	(while (re-search-forward
		(concat \"^\\(.*?\\)\"               ;; a term
			\"\\s-*::\\s-*\"             ;; the separator
			\"\\(.*\\(?:\n.*\\)*?\\)\"   ;; definition: to end of line,
						   ;; then maybe more lines
						   ;; (excludes any trailing \n)
			\"\\(?:\n\\s-*\n\\|\\'\\)\") ;; blank line or EOF
		nil :no-error)
	  (add-to-list 'dict (cons (match-string-no-properties 1)
				   (match-string-no-properties 2))) )
	dict))'
`(s-replace-regexp \"\\(<script>\\|<style>\\)\\(.*\\(?:\n.*\\)*?\\)\\(</script>\\|</style>\\)\" \"\" a)'"
  (let* ((template-str (s-replace-regexp "\\(<script>\\|<style>\\)\\(.*\\(?:\n.*\\)*?\\)\\(</script>\\|</style>\\)" "" html))
	 (trim-result (s-trim template-str)))
    (list :value (if (s-starts-with? "<template>" trim-result)
		     (s-trim (substring trim-result 10 -11))
		   trim-result))))

(defun zxc-template-js-ui-make (dir template-name)
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
		       (zxc-get-search-point "```html"))
		      (end-point
		       (- (zxc-get-search-point "```") 3)))
		  (push (zxc-template-vue-extra (buffer-substring-no-properties start-point end-point)) result))))
	  (when result
	    (add-to-list 'result (s-replace ".md" "" file))
	    (with-temp-file (expand-file-name (s-replace ".md" ".el" file) doc-result-dirs)
	      (insert "(push " (format "'%S" result) " " template-name ")"))))))))

;; (zxc-template-js-ui-make "/home/david/workspace/demo/bmsoft/ued-components/examples/docs/" "kfvue")
;; (zxc-template-js-ui-make "/home/david/git/element/examples/docs/zh-CN/" "elementui")

(setq zxc-template-js-ui-list nil)
(zxc-template-load zxc-template-js-ui-list kfvue)
(zxc-template-load zxc-template-js-ui-list elementui)

(provide 'zxc-template-js-ui)
