(require 'projectile)
(require 'zxc-action)
;;; https://docs.projectile.mx/projectile/projects.html
(setq projectile-mode-line-prefix " ")

(defun projectile-default-mode-line ()
  "Report project name and type in the modeline."
  (let ((project-name (projectile-project-name))
	(project-type (projectile-project-type)))
    (format "%s[%s]"
	    projectile-mode-line-prefix
	    (or project-name "-"))))

;; (setq projectile-project-search-path '("~/workspace/4.0/"))

(defun zxc-projectile-run-async-shell-command-in-root-and-save-history (command &optional output-buffer error-buffer)
  "Invoke `async-shell-command' in the project's root."
  (interactive (list (read-shell-command "Async shell command: ")))
  (let ((command-path (s-concat (projectile-acquire-root) "._command"))
	(his-commands nil))
    (if (file-exists-p command-path)
	(progn
	  (setf his-commands (read-lines command-path))
	  (unless (-contains-p his-commands command)
	    (f-append-text (s-concat command "\n") 'utf-8 command-path)))
      (f-append-text (s-concat command "\n") 'utf-8 command-path)))
  (projectile-run-async-shell-command-in-root command output-buffer error-buffer))

(defun zxc-projectile-run-async-shell-command-in-root-with-history ()
  "Invoke `shell-command' with history command in the project's root."
  (interactive)
  (let ((command-path (s-concat (projectile-acquire-root) "._command"))
	(his-commands nil)
	(default-commands "mvn clean compile\nmvn clean package\n"))
    (if (file-exists-p command-path)
	(setf his-commands (read-lines command-path))
      (progn
	(f-append-text default-commands 'utf-8 command-path)
	(setf his-commands (split-string default-commands "\n" t))))
    (zxc-action-render "*project-run*" his-commands 'zxc-project-run-shell-command 2)))

(defun zxc-project-run-shell-command ()
  (interactive)
  (let ((short-cut (this-command-keys)))
    (setf zxc-action-current-index (cl-position short-cut zxc-action-keys :test 'equal))
    (projectile-run-async-shell-command-in-root (nth zxc-action-current-index zxc-action-current-data-list))
    (zxc-action-quit)
    (ace-window "*Async Shell Command*")))

(define-key projectile-command-map (kbd "&") #'zxc-projectile-run-async-shell-command-in-root-and-save-history)
(define-key projectile-command-map (kbd "!") #'zxc-projectile-run-async-shell-command-in-root-with-history)

(provide 'zxc-projectile)
