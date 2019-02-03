;; zxc.el --- my util tools collection

;; Author: zhengxc
;; Keywords: util tools

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
(require 'cl)

(defstruct format-type split-char type-name)

(defvar sql-format (make-format-type :split-char "_" :type-name "sql"))
(defvar lisp-format (make-format-type :split-char "-" :type-name "lisp"))
(defvar java-format (make-format-type :type-name "java"))

(defun get-format-type (str)
  "根据字符串格式判断格式类型"
  (cond ((string-match-p (format-type-split-char sql-format) str) sql-format)
	((string-match-p (format-type-split-char lisp-format) str) lisp-format)
	(t java-format)))

(defun get-target-format-type ()
  "根据当前模式获得目标格式类型"
  (cond ((equal major-mode 'sql-mode) sql-format)
	((or (equal major-mode 'lisp-interaction-mode)
	     (equal major-mode 'lisp-mode)
	     (equal major-mode 'emacs-lisp-mode))
	 lisp-format)
	(t java-format)))

(defun upcasep (index str)
  (and (>= (get-byte index str) (get-byte 0 "A"))
       (< (get-byte index str) (get-byte 0 "a"))))

(defun search-upper-position (str)
  "search all position of uppcase characters
return the positions list "
  (let ((result '(0))
	(count (length str)))
    (dotimes (position count result)
      (if (upcasep position str)
	  (push position result)))
    (reverse (push count result))))

(defun split-string-upper (str)
  "split string by uppcase character,hold the split character"
  (let* ((positions (search-upper-position str))
	 (length (length positions))
	 (result ()))
    (dotimes (index length)
      (if (< (+ index 1) length)
	  (push (substring str (nth index positions) (nth (+ index 1) positions)) result)))
    (nreverse result)))


(defun convert-format ()
  "convert code format"
  (let* ((str (filter-buffer-substring (point) (mark) t))
	 (source (get-format-type str))
	 (target (get-target-format-type)))
    (if (equal (format-type-type-name source) (format-type-type-name target))
	str
      (let (strs)
	(if (equal (format-type-type-name source) (format-type-type-name java-format))
	    (setf strs (split-string-upper str))
	  (setf strs (split-string str ( format-type-split-char source))))
	(cond ((equal (format-type-type-name target) (format-type-type-name java-format))
	       (concatenate 'string (downcase (car strs))
			    (mapconcat #'capitalize
				       (cdr strs) "")))
	      (t (mapconcat #'downcase
			    strs (format-type-split-char target))))))))

(defun concat-string-by-backslash (&rest strs)
  (mapconcat #'(lambda (str)
		 str)
	     strs "/"))

(defun sexpr-xml (sexpr result)
  "convert sexpr to xml"
  (let ((tag (car sexpr)))
    (setf result (concat result (format "<%s>" tag)))
    (dolist (o (cdr sexpr))
      (cond ((atom o)
	     (setf result (concat result (format "%s" o))))
	    ((consp o)
	     (setf result (sexpr-xml o result)))))
    (setf result (concat result (format "</%s>" tag)))))

(defun zxc-util-convert-table-to-sql (str)
  "|  KEY   |                 VALUE                  |  PARENT  |ROW_NUM|
+--------+----------------------------------------+----------+-------+
| 21103  |            舟山岱山移动公司            |   部门   |   1   |
|10035578|          新鸿迅普陀特约代理点          |非授权网点|   2   |
|10209732|            314吴兴凤凰铁通             |非授权网点|   3   |
|10230037|    城区分局-三江街道-三星-学英通讯     |非授权网点|   4   |"
  (interactive "s输入分隔符：")
  (let ((begin-point (if (region-active-p)
			  (region-beginning)
			(point-min)))
	 (end-point (if (region-active-p)
			(region-end)
		      (point-max)))
	 (split-char (if (eq nil str)
			 "\|"
		       str)))
    (goto-char begin-point)
    (let* ((head-str (buffer-substring-no-properties begin-point (line-end-position)))
	   (head (cdr (split-string head-str split-char)))
	   (insert-str (s-concat "insert into PressCtrlH ("
				 (mapconcat (lambda (x)
					      (s-trim x)) (subseq head 0 (- (length head) 1)) ",")
				 ") values")))
      (line-move 2)
      (back-to-indentation)
      (let* ((data-str (buffer-substring-no-properties (line-beginning-position) end-point))
	     (data-str-list (split-string data-str "\n" t)))
	(kill-region begin-point end-point)
	(dolist (str data-str-list)
	  (insert (s-concat "
" insert-str "(" (mapconcat #'zxc-util-deal-sql-data
			    (subseq (cdr (split-string str split-char)) 0 (- (length head) 1)) ",") ");")))))))

(defun zxc-util-deal-sql-data (x)
  "处理拼接SQL数据字段的方式"
  (s-concat "'" (s-trim x) "'"))

(defun zxc-util-get-region-or-paragraph-string ()
  "获取当前选中区域或者当前段落的文字内容"
  (if (region-active-p)
      (buffer-substring-no-properties (region-beginning) (region-end))
    (let ((start (save-excursion
		   (backward-paragraph)
		   (point)))
	  (end (save-excursion
		 (forward-paragraph)
		 (point))))
      (buffer-substring-no-properties start end))))


(provide 'zxc-util)
