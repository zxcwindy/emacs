;; (defmacro zxc-bootstrap-doc-with-temp-buffer-as-string (&rest body)
;;   "Evaluate BODY inside a temp buffer and return the buffer string."
;;   (declare (indent 0))
;;   `(with-temp-buffer
;;      ,@body
;;      (buffer-substring-no-properties (point-min) (point-max))))

;; (defun zxc-bootstrap-doc-insert (buffer class-name)
;;   (let ((class-desc (gethash class-name zxc-bootstrap-doc-hash)))
;;     (with-current-buffer buffer
;;       (erase-buffer)
;;       (font-lock-mode -1)
;;       (insert class-desc))))


(defconst zxc-bootstrap-doc-prefix-dot-re
  "\\(\\.\\)"
  "Regexp to match jQuery function call.")

(defconst zxc-bootstrap-doc-prefix-class-re
  "class=\"\\(.*\\)"
  "Regexp to match jQuery function call.")

;; auto-complete
(defun zxc-bootstrap-doc-documentation (class-name)
  "Return the documentation for METHOD as String."
  (let ((class-name (substring-no-properties class-name)))
    ;; (zxc-bootstrap-doc-with-temp-buffer-as-string
    ;;  (zxc-bootstrap-doc-insert (current-buffer) class-name))
    (gethash class-name zxc-bootstrap-doc-hash)))

;;;###autoload
(defun zxc-bootstrap-doc-ac-prefix ()
  (if (or (re-search-backward zxc-bootstrap-doc-prefix-dot-re nil t)
	  (re-search-backward zxc-bootstrap-doc-prefix-class-re nil t))
      (match-beginning 1)
    (ac-prefix-default)))

;;;###autoload
(defvar ac-source-zxc-bootstrap-dot
  '((candidates . zxc-bootstrap-doc-css)
    (symbol . "class")
    (document . zxc-bootstrap-doc-documentation)
    (prefix . "\\(\\.\\).*")
    (cache)))
;;;###autoload
(defvar ac-source-zxc-bootstrap-class
  '((candidates . zxc-bootstrap-doc-css)
    (symbol . "class")
    (document . zxc-bootstrap-doc-documentation)
    (prefix . "class=\"\\(.*\\)")
    (cache)))
;; (defvar ac-source-zxc-bootstrap
;;   '((candidates . zxc-bootstrap-doc-css)
;;     (symbol . "class")
;;     (document . zxc-bootstrap-doc-documentation)
;;     (prefix . zxc-bootstrap-doc-ac-prefix)
;;     (cache)))

;; company-mode

(defvar company-zxc-bootstrap-modes '(html-mode))

;;;###autoload
(defun company-zxc-bootstrap (command &optional arg &rest ignore)
  "`company-mode' completion back-end using `zxc-bootstrap-doc'."
  (interactive (list 'interactive))
  (case command
    (interactive (company-begin-backend 'company-zxc-bootstrap))
    (prefix (when (memq major-mode company-zxc-bootstrap-modes)
              (or (company-grab-line zxc-bootstrap-doc-prefix-re 1)
                  (company-grab-symbol))))
    (candidates (all-completions arg zxc-bootstrap-doc-methods))
    (duplicates t)
    (doc-buffer (let* ((inhibit-read-only t)
                       (buf (company-doc-buffer)))
                  (zxc-bootstrap-doc-insert buf arg)
                  buf))))

;; common

(defun zxc-bootstrap-doc-setup ()
  (when (boundp 'ac-sources)
    (pushnew 'ac-source-zxc-bootstrap-dot ac-sources)
    (pushnew 'ac-source-zxc-bootstrap-class ac-sources))
  (when (boundp 'company-backends)
    (pushnew 'company-zxc-bootstrap company-backends)))

(provide 'zxc-bootstrap-doc)
