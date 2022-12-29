(require 'lsp-mode)
(require 'web-mode)
(require 'lsp-java)
(require 'company-tabnine)
;; (require 'lsp-java-boot)

(define-key lsp-mode-map (kbd "C-c C-l") lsp-command-map)

;;; memory/garbage.
(setq gc-cons-threshold 100000000)

;;; Increase the amount of data which Emacs reads from the process#
(setq read-process-output-max (* 3 1024 1024)) ;; 3mb
;; (setq lsp-keep-workspace-alive nil)

(setq lsp-log-io nil
      lsp-auto-guess-root t)

(add-hook 'web-mode-hook #'lsp)

(define-key web-mode-map (kbd "C-c f") #'(lambda ()
					   "fix 格式化卡顿问题"
					   (interactive)
					   (lsp-disconnect)
					   (indent-whole)
					   (lsp)))
(add-hook 'js2-mode-hook #'lsp)
(add-hook 'typescript-mode-hook #'lsp)
(add-hook 'python-mode-hook #'lsp)

;;; lsp-workspace-restart
;; (setq lsp-java-vmargs
;;       (append lsp-java-vmargs (list "-javaagent:/opt/sts-4.15.1.RELEASE/lombok.jar")))

(setq lsp-java-vmargs (list "-XX:+UseParallelGC" "-XX:GCTimeRatio=4" "-XX:AdaptiveSizePolicyWeight=90" "-Dsun.zip.disableMemoryMapping=true" "-Xmx4G" "-Xms512m" "-javaagent:/opt/sts-4.15.1.RELEASE/lombok.jar"))

(cl-defun zxc-lsp-find-java-descriptor ()
  "查找当前方法的签名"
  (let ((loc (lsp-request "textDocument/definition"
			  (append (lsp--text-document-position-params) nil))))
    (if (seq-empty-p loc)
	(lsp--error "Not found for: %s" (or (thing-at-point 'symbol t) ""))
      (let* ((tmp-data (lsp--locations-to-xref-items loc))
	     (methon-name (replace-regexp-in-string " .* " "\\\\(.*\\\\)" (string-trim (substring-no-properties (xref-item-summary (car tmp-data)) 1 (string-match "(" (xref-item-summary (car tmp-data)))))) )
	     (file-path (xref-location-group (xref-item-location (car tmp-data))))
	     (class-name (replace-regexp-in-string "\\.home.*.cache\\."  ""  (string-replace "/" "." (string-replace ".java" "" (replace-regexp-in-string ".*java/" "" file-path)))))
	     (class-path (if (s-starts-with-p "com.kun" class-name)
			     (replace-regexp-in-string "src.*" "target/classes" file-path)
			   "."))
	     (javap-cmd (concat "javap -s -p -cp " class-path " " class-name "| sed -n \"/" methon-name "/,+1 p\"")))
	(with-current-buffer (get-buffer-create "*jni*")
	  (erase-buffer)
	  (message javap-cmd)
	  (call-process "/bin/bash" nil "*jni*" nil "-c" javap-cmd)
	  (switch-to-buffer "*jni*")
	  (sleep-for 0.8)
	  (search-forward "descriptor: ")
	  (copy-region-as-kill (point) (line-end-position)))))))




;; (add-to-list 'company-backends '(company-tabnine :with company-capf))

;; (add-hook 'java-mode-hook #'(lambda ()
;;			      (lsp)
;;			      (set (make-local-variable 'company-backends)
;;				   '((company-capf
;;				      company-tabnine
;;				      company-files)))))
(add-hook 'java-mode-hook #'lsp)

(add-hook 'nxml-mode-hook #'(lambda ()
			      (lsp)
			      (sleep-for 0.5)
			      (setq-local company-backends
					  '((company-capf :with zxc-company-pom-backend)))))

;; (add-hook 'nxml-mode-hook #'(lambda ()
;;			      (lsp)
;;			      (setq company-backends '((company-capf :with zxc-company-pom-backend)))))

;; Trigger completion immediately.
(setq company-idle-delay 0)

;; Number the candidates (use M-1, M-2 etc to select completions).
(setq company-show-quick-access t)

;;; 样例代码
;; (set (make-local-variable 'company-backends)
;;        '((company-capf
;;           :with
;;           company-tabnine
;;           company-yasnippet
;;           company-files
;;           company-dabbrev-code)))

;;; ~/.emacs.d/workspace
;; (setq lsp-java-workspace-dir "/home/david/workspace/4.0/")


;; to enable the lenses
(add-hook 'java-mode-hook #'lsp)
;; (add-hook 'lsp-mode-hook #'lsp-lens-mode)
;; (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)

;; (setq lsp-java-errors-incomplete-classpath-severity "error")

;; https://emacs-lsp.github.io/lsp-java/

;; (setq lsp-java-configuration-runtimes '[(:name "JavaSE-1.8"
;;                         :path "/home/kyoncho/jdk1.8.0_201.jdk/")
;;                     (:name "JavaSE-11"
;;                         :path "/home/kyoncho/jdk-11.0.1.jdk/"
;;                         :default t)])

;; current VSCode defaults
;; (setq lsp-java-vmargs '("-XX:+UseParallelGC" "-XX:GCTimeRatio=4" "-XX:AdaptiveSizePolicyWeight=90" "-Dsun.zip.disableMemoryMapping=true" "-Xmx2G" "-Xms100m"))

(defun zxc-lsp-location-maven-path ()
  "快速打开maven对应的本地路径"
  (save-excursion
    (let* ((start-pos (progn (search-backward "<dependency>")
			     (point)))
	   (end-pos (progn (search-forward "</dependency>")
			   (point)))
	   (mvn-xml (xml-parse-region start-pos end-pos))
	   (group-id nil)
	   (artifact-id nil)
	   (version nil))
      (cl-loop for temp-list in (car mvn-xml)
	       do (when (and temp-list (eq (type-of temp-list) 'cons))
		    (cond ((eq (nth 0 temp-list) 'groupId)
			   (setf group-id (nth 2 temp-list)))
			  ((eq (nth 0 temp-list) 'artifactId)
			   (setf artifact-id (nth 2 temp-list)))
			  ((eq (nth 0 temp-list) 'version)
			   (setf version (nth 2 temp-list))))))
      (find-file (concat "/home/david/.m2/repository/" (s-replace "." "/" group-id) "/"
			 (concat artifact-id "/" (if (and version
							  (not (s-contains? "$" version)))
						     version
						   "")))))))

(add-hook 'go-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;;;

(define-key lsp-mode-map (kbd "C-c C-l p") #'(lambda ()
					       (interactive)
					       (cond ((eq major-mode 'java-mode)
						      (zxc-lsp-find-java-descriptor))
						     ((eq major-mode 'nxml-mode)
						      (zxc-lsp-location-maven-path)))))
;;;  添加java注释 type /** | */ and invoke M-x company-complete with cursor at |.
(define-key lsp-mode-map (kbd "C-c C-l !") #'(lambda ()
					       (interactive)
					       (lsp-execute-code-action-by-kind "quickfix")))


(provide 'zxc-lsp)
