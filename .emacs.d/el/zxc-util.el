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
	     (equal major-mode 'lisp-mode))
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

(provide 'zxc-util)
