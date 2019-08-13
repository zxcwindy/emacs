(require 'js2-mode)
(require 'js2-refactor)
(require 'jquery-doc)
(require 'js-doc)
(require 'js)
;; (require 'flymake-jslint)


;;(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;swank.js
;;(global-set-key [f6] 'slime-js-reload)
(add-hook 'js2-mode-hook
	  (lambda ()
	    ;; (slime-js-minor-mode 1)
	    (ac-js2-mode)
	    (js2-refactor-mode)
	    (jquery-doc-setup)
	    (global-set-key (kbd "C-; C-a") 'js2-mode-show-all)
	    (global-set-key (kbd "C-; C-d") 'js2-mode-hide-element)
	    (global-set-key (kbd "C-; C-s") 'js2-mode-show-element)
	    (global-set-key (kbd "C-; C-q") 'js2-mode-toggle-hide-functions)
	    (local-set-key "\C-c\C-c" 'js-send-last-sexp)
	    (local-set-key "\C-c\C-r" 'js-send-region)
	    (local-set-key "\C-cb" 'js-send-buffer)
	    (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
	    (local-set-key "\C-cl" 'node-load-file)
	    (define-key js2-mode-map "\C-ci" 'js-doc-insert-function-doc)
	    (define-key js2-mode-map "@" 'js-doc-insert-tag)
	    (setq js2-strict-missing-semi-warning nil)))

;; (add-hook 'js-mode-hook 'flymake-jslint-load)
;; (add-hook 'js2-mode-hook 'ac-js2-mode)
;; (add-hook 'js2-mode-hook 'js2-refactor-mode)
;; (add-hook 'js2-mode-hook 'jquery-doc-setup)

;; (add-hook 'js2-mode-hook 'zxc-paredit-nonlisp-mode)

;; (add-hook 'css-mode-hook
;;	  (lambda ()
;;	    (define-key css-mode-map "\M-\C-x" 'slime-js-refresh-css)
;;	    (define-key css-mode-map "\C-c\C-r" 'slime-js-embed-css)))
(modify-syntax-entry ?_ "w" js2-mode-syntax-table)
;; (modify-syntax-entry ?. "w" js2-mode-syntax-table)
(modify-syntax-entry ?_ "w" js-mode-syntax-table)
;; (modify-syntax-entry ?. "w" js-mode-syntax-table)

(defun json-format ()
  "格式化json"
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point) "jq ." (buffer-name) t)))

(after-load 'coffee-mode
  (define-key coffee-mode-map (kbd  "C-c C-,") #'coffee-indent-shift-left)
  (define-key coffee-mode-map (kbd  "C-c C-.") #'coffee-indent-shift-right)
  (define-key coffee-mode-map (kbd "C-j") 'coffee-newline-and-indent))

(setq whitespace-action '(auto-cleanup))
(setq whitespace-style '(trailing space-before-tab indentation empty space-after-tab))

(custom-set-variables '(coffee-tab-width 4))
(setq coffee-args-compile '("-c" "-b" ""))

(setq coffee-source-dir "")
(setq coffee-output-dir "")

(defvar el-coffee-dir '(("" . "") ("" . "")))

(defun coffee-compile-file ()
  "Compiles and saves the current file to disk in a file of the same
base name, with extension `.js'.  Subsequent runs will overwrite the
file.

If there are compilation errors, point is moved to the first
See `coffee-compile-jump-to-error'."
  (interactive)
  (let* ((input (buffer-file-name))
	 (basename (s-concat coffee-output-dir (s-replace coffee-source-dir "" (file-name-sans-extension input))))
	 (output (when (string-match-p "\\.js\\'" basename) ;; for Rails '.js.coffee' file
		   basename))
	 (compile-cmd (coffee-command-compile input output))
	 (compiler-output (shell-command-to-string compile-cmd)))
    (if (string= compiler-output "")
	(let ((file-name (coffee-compiled-file-name (buffer-file-name))))
	  (message "Compiled and saved %s" (or output (concat basename ".js")))
	  (coffee-revert-buffer-compiled-file file-name))
      (let* ((msg (car (split-string compiler-output "[\n\r]+")))
	     (line (when (string-match "on line \\([0-9]+\\)" msg)
		     (string-to-number (match-string 1 msg)))))
	(message msg)
	(when (and coffee-compile-jump-to-error line (> line 0))
	  (goto-char (point-min))
	  (forward-line (1- line)))))))

(defun coffee-command-compile (input &optional output)
  "Run `coffee-command' to compile FILE-NAME to file with default
.js output file, or optionally to OUTPUT-FILE-NAME."
  (let* ((full-file-name (expand-file-name input))
	 (output-file (s-concat coffee-output-dir (s-replace coffee-source-dir "" (coffee-compiled-file-name full-file-name))))
	 (output-dir (file-name-directory output-file)))
    (unless (file-directory-p output-dir)
      (make-directory output-dir t))
    (format "%s %s -o %s %s"
	    (shell-quote-argument coffee-command)
	    (coffee-command-compile-arg-as-string output)
	    (shell-quote-argument output-dir)
	    (shell-quote-argument full-file-name))))

;; (defun zxc-paredit-nonlisp ()
;;   "Turn on paredit mode for non-lisps."
;;   (interactive)
;;   (set (make-local-variable 'paredit-space-for-delimiter-predicates)
;;        '((lambda (endp delimiter) nil))))


(define-minor-mode zxc-paredit-nonlisp-mode
  "非lisp的paredit模式"
  :lighter " NLParedit"
  ;; If we're enabling paredit-mode, the prefix to this code that
  ;; DEFINE-MINOR-MODE inserts will have already set PAREDIT-MODE to
  ;; true.  If this is the case, then first check the parentheses, and
  ;; if there are any imbalanced ones we must inhibit the activation of
  ;; paredit mode.  We skip the check, though, if the user supplied a
  ;; prefix argument interactively.
  (set (make-local-variable 'paredit-space-for-delimiter-predicates)
       '((lambda (endp delimiter) nil)))
  (paredit-mode 1))

(provide 'el-js2)
