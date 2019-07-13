;;; zxc-template-command-tldr.el --- js ui template

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

(defcustom zxc-template-command-tldr-list nil
  "The string separating entries in the `separated' style.
See `zxc-js-cp-details-display-style'."
  :type 'list
  :group 'zxc-template)

(defun zxc-template-command-tldr-extra (tldr)
  "从tldr帮助文档中提取模板信息
- Transfer file from local to remote host:

`rsync {{path/to/file}} {{remote_host_name}}:{{remote_host_location}}`
提取
Transfer file from local to remote host:
rsync {{path/to/file}} {{remote_host_name}}:{{remote_host_location}}"
  (list :info tldr :value (s-replace-all '(("`" . "")) (car (s-match "^`.*`$" tldr)))))

(defun zxc-template-command-tldr-make (dir template-name)
  "create common,linux template"
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
		       (zxc-get-regexp-search-point "^- "))
		      (end-point
		       (zxc-get-regexp-search-point "`$")))
		  (push (zxc-template-command-tldr-extra (buffer-substring-no-properties start-point end-point)) result))))
	  (when result
	    (add-to-list 'result (s-replace ".md" "" file))
	    (with-temp-file (expand-file-name (s-replace ".md" ".el" file) doc-result-dirs)
	      (insert "(push " (format "'%S" result) " " template-name ")"))))))))

;; (zxc-template-command-tldr-make "/home/david/git/tldr/pages/common/" "common")
;; (zxc-template-command-tldr-make "/home/david/git/tldr/pages/linux/" "linux")
(zxc-template-command-tldr-make "/home/david/git/tldr/pages/bigdata/" "bigdata")

(setq zxc-template-command-tldr-list nil)

(provide 'zxc-template-command-tldr)
