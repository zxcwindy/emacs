(require 'lsp-mode)
(require 'web-mode)
(require 'lsp-java)
;; (require 'lsp-java-boot)

(define-key lsp-mode-map (kbd "C-c C-l") lsp-command-map)

;;; memory/garbage.
(setq gc-cons-threshold 100000000)

;;; Increase the amount of data which Emacs reads from the process#
(setq read-process-output-max (* 3 1024 1024)) ;; 3mb

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




(add-hook 'java-mode-hook #'lsp)
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


(provide 'zxc-lsp)
