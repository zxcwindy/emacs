;;; zxc-company-pom.el --- company-mode completion backend for pom.xml -*- lexical-binding: t -*-
;;; https://www.bilibili.com/video/BV1yP4y177xj/?spm_id_from=pageDriver&vd_source=03ca8b5445c9a9ce79021e56f39c5567
;;; (setq completion-styles '(orderless))
(require 'company)
(require 'cl-lib)

(defun zxc-pom-parse (str)
  "输出./szjw/portal-api/1.5/portal-api-1.5.pom
输出-> com.squareup.okio:okio:1.13.0"
  (let* ((str-list (split-string str "/"))
	 (str-length (length str-list))
	 (version-index (- str-length 2))
	 (artifactid-index (- str-length 3))
	 (groupid-index (- str-length 4)))
    (s-join ":" (list (s-join "." (cl-subseq str-list 1 artifactid-index))
		      (nth artifactid-index str-list)
		      (nth version-index str-list)))))

(defun zxc-pom-template (str)
  "将com.squareup.okio:okio:1.13.0格式化为xml节点"
  (let* ((pom-strs (split-string str ":"))
	 (group-id (nth 0 pom-strs))
	 (artifact-id (nth 1 pom-strs))
	 (version-id (nth 2 pom-strs)))
    (format "<dependency>
		<groupId>%s</groupId>
		<artifactId>%s</artifactId>
		<version>%s</version>
	    </dependency>" group-id artifact-id version-id)))


;;; 更新时处理，pom-list需要reverse排序 sort -rn pom-list
(defun read-lines (filePath)
  "Return a list of lines of a file at filePath."
  (with-temp-buffer
    (insert-file-contents filePath)
    (split-string (buffer-string) "\n" t)))

;; (with-temp-file "~/.emacs.d/el/dev/zxc-company-pom-file.el"
;;   (insert "(setq zxc-company-pom-list " (format "'%S" (read-lines "/home/david/tmp/pom-list-sort") ) ")"))

(load-file "~/.emacs.d/el/dev/zxc-company-pom-file.elc")

(setq zxc-company-pom-candidates (mapcar 'zxc-pom-parse zxc-company-pom-list))

(modify-syntax-entry ?_ "w" nxml-mode-syntax-table)
(modify-syntax-entry ?. "w" nxml-mode-syntax-table)
(modify-syntax-entry ?: "w" nxml-mode-syntax-table)

(defun zxc-company-pom-predicate (prefix)
  (seq-filter (lambda (elt) (string-match-p prefix elt))
	      zxc-company-pom-candidates))

(defun zxc-company-pom-backend (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'zxc-company-pom-backend))
    (prefix (and (eq major-mode 'nxml-mode)
		 (company-grab-symbol)))
    (candidates (zxc-company-pom-predicate arg))
    (sorted t)
    (duplicates t)
    (post-completion
     (let ((end-point (point))
	   (start-point (- (point) (length arg))))
       (replace-string arg (zxc-pom-template arg) t start-point end-point)))))

(add-to-list 'company-backends 'zxc-company-pom-backend)

(provide 'zxc-company-pom)
