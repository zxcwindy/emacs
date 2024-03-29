;;; openwith.el --- Open files with external programs

;; Copyright (C) 2007  Markus Triska

;; Author: Markus Triska <markus.triska@gmx.at>
;; Keywords: files, processes

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This lets you associate external applications with files so that
;; you can open them via C-x C-f, with RET in dired, etc.

;; Copy openwith.el to your load-path and add to your .emacs:

;;    (require 'openwith)
;;    (openwith-mode t)

;; To customize associations etc., use:

;;    M-x customize-group RET openwith RET

;;; Code:

(defconst openwith-version "0.8f")

(defgroup openwith nil
  "Associate external applications with file name patterns."
  :group 'files
  :group 'processes)

(defcustom openwith-associations
  '(;; ("\\.pdf\\'" "acroread" (file))
    ("\\.pdf\\'" "wpspdf" (file))
    ;; ("\\.class\\'" "jad" ("-p" file))
    ("\\.mp3\\'" "xmms" (file))
    ("\\.chm\\'" "kchmviewer" (file))
    ;; ("\\.\\(?:xls\\|doc\\|ods\\)\\'" "et" (file))
    ("\\.\\(?:mpe?g\\|avi\\|wmv\\|mp4\\|webm\\|mkv\\|MOV\\)\\'" "vlc" ("--config=/home/david/snap/vlc/common/vlcrc" file))
    ;; ("\\.\\(?:jp?g\\|png\\)\\'" "display" (file))
    ;; ("\\.\\(?:xlsx?\\|docx?\\|ods\\|odt\\|doc\\)\\'" "soffice" (file))
    ("\\.xlsx?\\'" "et" (file))
    ("\\.\\(?:doc\\|docx\\)\\'" "wps" (file))
    ("\\.pptx?\\'" "wpp" (file))
    )
  "Associations of file patterns to external programs.
File pattern is a regular expression describing the files to
associate with a program. The program arguments are a list of
strings and symbols and are passed to the program on invocation,
where the symbol 'file' is replaced by the file to be opened."
  :group 'openwith
  :type '(repeat (list (regexp :tag "Files")
		       (string :tag "Program")
		       (sexp :tag "Parameters"))))

(defcustom openwith-confirm-invocation nil
  "Ask for confirmation before invoking external programs."
  :group 'openwith
  :type 'boolean)

(defun format-file-name (file)
  (car (last (split-string file "/" ))))

(defun openwith-file-handler (operation &rest args)
  "Open file with external program, if an association is configured."
  (when (and openwith-mode (not (buffer-modified-p)) (zerop (buffer-size)))
    (let ((assocs openwith-associations)
	  (file (car args))
	  oa)
      ;; do not use `dolist' here, since some packages (like cl)
      ;; temporarily unbind it
      (while assocs
	(setq oa (car assocs)
	      assocs (cdr assocs))
	(when (save-match-data (string-match (car oa) file))
	  (let ((params (mapcar (lambda (x) (if (eq x 'file) file x))
				(nth 2 oa))))
	    (when (or (not openwith-confirm-invocation)
		      (y-or-n-p (format "%s %s? " (cadr oa)
					(mapconcat #'identity params " "))))
	      (if (equal (cadr oa) "jad")
		  (let* ((filename (format-file-name file))
			 (temp-buffer-name (concatenate 'string "*" filename "*")))
		    (apply #'call-process "jad" nil temp-buffer-name nil params )
		    (switch-to-buffer temp-buffer-name)
		    (java-mode)
		    (kill-buffer filename))
		(progn
		  (apply #'start-process "openwith-process" nil (cadr oa) params)
		  (kill-buffer nil)
		  ;; inhibit further actions
		  (error "Opened %s in external program"
			 (file-name-nondirectory file))))))))))
  ;; when no association was found, relay the operation to other handlers
  (let ((inhibit-file-name-handlers
	 (cons 'openwith-file-handler
	       (and (eq inhibit-file-name-operation operation)
		    inhibit-file-name-handlers)))
	(inhibit-file-name-operation operation))
    (apply operation args)))

;;;###autoload
(define-minor-mode openwith-mode
  "Automatically open files with external programs."
  :lighter ""
  :global t
  (if openwith-mode
      (progn
	;; register `openwith-file-handler' for all files
	(put 'openwith-file-handler 'safe-magic t)
	(put 'openwith-file-handler 'operations '(insert-file-contents))
	(add-to-list 'file-name-handler-alist '("" . openwith-file-handler)))
    (setq file-name-handler-alist
	  (delete '("" . openwith-file-handler) file-name-handler-alist))))

(provide 'openwith)

;;; openwith.el ends here
