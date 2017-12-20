;;; zxc-magit.el --- magit本地化配置

;; Author: zhengxc
;; Keywords: magit

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

(require 'magit-blame)

(setf magit-blame-heading-format "%H %-20a %C %s")

(defun magit-blame-format-heading (chunk)
  "重写了magit-blame-format-heading方法，将hash
展现缩短为7个字符"
  (with-temp-buffer
    (insert (format-spec
             (concat magit-blame-heading-format "\n")
             `((?H . ,(propertize (or (when (plist-get chunk :hash)
					(substring (plist-get chunk :hash) 0 7)) "")
                                  'face 'magit-blame-hash))
               (?s . ,(propertize (or (plist-get chunk :summary) "")
                                  'face 'magit-blame-summary))
               (?a . ,(propertize (or (plist-get chunk :author) "")
                                  'face 'magit-blame-name))
               (?A . ,(propertize (magit-blame-format-time-string
                                   magit-blame-time-format
                                   (plist-get chunk :author-time)
                                   (plist-get chunk :author-tz))
                                  'face 'magit-blame-date))
               (?c . ,(propertize (or (plist-get chunk :committer) "")
                                  'face 'magit-blame-name))
               (?C . ,(propertize (magit-blame-format-time-string
                                   magit-blame-time-format
                                   (plist-get chunk :committer-time)
                                   (plist-get chunk :committer-tz))
                                  'face 'magit-blame-date)))))
    (goto-char (point-min))
    (while (not (eobp))
      (let ((face (get-text-property (point) 'face))
            (next (or (next-single-property-change (point) 'face)
                      (point-max))))
        (unless face
          (put-text-property (point) next 'face 'magit-blame-heading))
        (goto-char next)))
    (buffer-string)))

(provide 'zxc-magit)
