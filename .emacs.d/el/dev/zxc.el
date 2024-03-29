;; zxc.el --- my util tools collection

;; Author: zhengxc
;; Keywords: tools

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

(require 'cl-lib)
(require 'image-mode)
(require 'zxc-util)
(require 'zxc-http)
(require 'zxc-comet)
(require 'zxc-db)
(require 'zxc-shell)
(require 'zxc-elasticsearch)
(require 'zxc-kbd)

;;;; Minor Mode Definition

(defvar zxc-mode-map (make-sparse-keymap)
  "Keymap for the zxc minor mode.")

(make-variable-buffer-local
 (defvar zxc-mode-lighter "Zxc"))

(define-minor-mode zxc-mode
  "Minor mode for Zxc"
  :lighter (" " zxc-mode-lighter))

(defvar zxc-host "http://localhost:9990")
(defvar db-meta "service/rest/dbMeta" "dbmeta uri")
(defvar db-name "db2" "database name")

(setq docker-run-as-root t)

(advice-add 'docker-container-shell-selection :override
	    (lambda (prefix)
	      (interactive "P")
	      (docker-utils-ensure-items)
	      (--each (docker-utils-get-marked-items-ids)
		(docker-with-sudo
		  (docker-container-shell it prefix)))))

;; (defun docker-container-shell-selection (prefix)
;;   "Run `docker-container-shell' on the containers selection forwarding PREFIX."
;;   (interactive "P")
;;   (docker-utils-ensure-items)
;;   (--each (docker-utils-get-marked-items-ids)
;;     (docker-with-sudo
;;       (docker-container-shell it prefix))))

(define-key zxc-mode-map (kbd  "C-; cs") #'zxc-db-get-select-sql)
(define-key zxc-mode-map (kbd  "C-; cf") #'code-format)
(define-key zxc-mode-map (kbd  "C-; cq") #'zxc-util-convert-table-to-sql)
(define-key zxc-mode-map (kbd  "C-; ch") #'comet-set-url)
(define-key zxc-mode-map (kbd  "C-; cu") #'comet-subscribe)
(define-key zxc-mode-map (kbd  "C-; cc") #'comet-publish-paragraph)
(define-key zxc-mode-map (kbd  "C-; cr") #'comet-publish-region)
(define-key zxc-mode-map (kbd  "C-; cx") #'comet-publish-html)
(define-key zxc-mode-map (kbd  "C-; dl") #'zxc-db-login)
(define-key zxc-mode-map (kbd  "C-; de") #'zxc-db-send-region-exec)
(define-key zxc-mode-map (kbd  "C-; dss") #'zxc-db-send-region-query)
(define-key zxc-mode-map (kbd  "C-; dsi") #'zxc-db-send-region-format-insert-sql)
(define-key zxc-mode-map (kbd  "C-; dsd") #'zxc-db-send-region-format-delete-sql)
(define-key zxc-mode-map (kbd  "C-; dsu") #'zxc-db-send-region-format-update-sql)
(define-key zxc-mode-map (kbd  "C-; dt") #'zxc-db-get-table-sql)
(define-key zxc-mode-map (kbd  "C-; aa") #'zxc-db-ac-set-db-alias)
;; (define-key zxc-mode-map (kbd  "C-; ac") #'zxc-db-ac-toggle)
(define-key zxc-mode-map (kbd  "C-; eli") #'zxc-es--list-indexes)
(define-key zxc-mode-map (kbd  "C-; eln") #'zxc-es--list-nodes)
(define-key zxc-mode-map (kbd  "C-; ed") #'zxc-db-send-region-decrypt)
(define-key zxc-mode-map (kbd  "C-; es") #'zxc-es--query-sql)
(define-key zxc-mode-map (kbd  "C-; ul") #'zxc-template-list-view)
(define-key zxc-mode-map (kbd  "C-; us") #'zxc-template-search-view)

(define-key image-mode-map (kbd "i") #'zxc-db-send-image-orc)

(defun code-format ()
  (interactive)
  (cond
   ;; for emacs-lisp-mode
   ((eq major-mode 'emacs-lisp-mode)
    (string-inflection-all-cycle))
   ;; for java
   ((eq major-mode 'java-mode)
    (string-inflection-java-style-cycle))
   ;; for python
   ((eq major-mode 'python-mode)
    (string-inflection-python-style-cycle))
   ((eq major-mode 'sql-mode)
    (string-inflection-sql-style-cycle))
   (t
    ;; default
    (string-inflection-java-style-cycle))))

(mapc #'(lambda (mode-hook)
	  (add-hook mode-hook 'zxc-mode))
      (list 'shell-mode-hook 'js2-mode-hook 'web-mode-hook 'sql-mode-hook 'java-mode-hook))

(defun display-zxc-mode--turn-on ()
  "Turn on `zxc-mode'."
  (unless (minibufferp)
    (zxc-mode)))

;;;###autoload
(define-globalized-minor-mode global-zxc-mode
  zxc-mode display-zxc-mode--turn-on)

(provide 'zxc)
