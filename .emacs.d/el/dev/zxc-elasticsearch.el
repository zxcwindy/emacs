;; zxc-elasticsearch.el --- elasticsearch

;; Author: zhengxc
;; Keywords: elasticsearch

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

(require 'es-mode)

(defun es--execute-region ()
  "Submits the active region as a query to the specified
endpoint. If the region is not active, the whole buffer is
used. Uses the params if it can find them or alternativly the
vars."
  (let* ((beg (if (region-active-p) (region-beginning) (point-min)))
         (end (if (region-active-p) (region-end) (point-max)))
         (url-request-extra-headers
          '(("Content-Type" . "application/json; charset=UTF-8")))
         (params (or (es--find-params)
                     `(,(es-get-request-method) . ,(es-get-url))))
         (url (es--munge-url (cdr params)))
         (url-request-method (car params))
         (url-request-data (encode-coding-string
                            (buffer-substring-no-properties beg end) 'utf-8))
         (result-buffer-name (if (zerop es--query-number)
                                 (format "*ES: %s*" (buffer-name))
                               (format "*ES: %s [%d]*"
                                       (buffer-name)
                                       es--query-number))))
    (when (es--warn-on-delete-yes-or-no-p)
      (message "Issuing %s against %s" url-request-method url)
      (url-retrieve url 'es-result--handle-response (list result-buffer-name))
      (setq es-results-buffer (get-buffer-create result-buffer-name))
      (save-selected-window
        ;; We want 2 buffers next to each other if it's not already visible, so
        ;; delete other buffers
        (when (not (get-buffer-window es-results-buffer))
          (delete-other-windows)
	  (let ((split-height-threshold nil)
		(split-width-threshold 0))
	    (view-buffer-other-window es-results-buffer)))))))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((elasticsearch . t)))

(provide 'zxc-elasticsearch)
