(require 'projectile)

(setq projectile-mode-line-prefix " ")

(defun projectile-default-mode-line ()
  "Report project name and type in the modeline."
  (let ((project-name (projectile-project-name))
	(project-type (projectile-project-type)))
    (format "%s[%s]"
	    projectile-mode-line-prefix
	    (or project-name "-"))))

(provide 'zxc-projectile)
