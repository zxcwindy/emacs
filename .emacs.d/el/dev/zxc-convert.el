-convert.el --- data structure format convert

;; Author: zhengxc
;; Email: david.c.aq@gmail.com
;; Keywords: data structure convert

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

(require 'xml-parse)

(defvar zxc-convert-lisp-data nil
  "lisp representation")

(defun zxc-convert-xml-lisp (start end)
  "xml convert to lisp"
  (interactive "r")
  (let ((end (unless (region-active-p)
	       (point-max))))
    (setf zxc-convert-lisp-data (save-restriction
				  (narrow-to-region start end)
				  (read-xml)))))

(defun zxc-convert-lisp-xml ()
  "lisp convert to xml"
  (interactive)
  (when zxc-convert-lisp-data
    (insert-xml zxc-convert-lisp-data :depth 4)))

(defun zxc-convert-lisp-json ()
  "lisp convert to json"
  (interactive)
  (when zxc-convert-lisp-data
    (let ((lisp-data (if (listp (car zxc-convert-lisp-data))
			 zxc-convert-lisp-data
		       (cons zxc-convert-lisp-data nil))))
      (insert (json-encode-list lisp-data)))))


;; (defun zxc-convert-lisp-xml ()
;;   "lisp convert to xml"
;;   (interactive)
;;   (insert (json-encode-list (xml-parse-region))))
