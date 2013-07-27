;;paredit
(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code."
  t)

;;paredit-hook
(defun my-paredit-mode ()
  (enable-paredit-mode)
  (global-set-key (kbd "C-; C-f") 'paredit-forward)
  (global-set-key (kbd "C-; C-b") 'paredit-backward))
(mapcar #'(lambda (x)
	    (add-hook x 'my-paredit-mode))
	'(comint-mode-hook lisp-mode-hook emacs-lisp-mode-hook lisp-interaction-mode-hook))

(provide 'el-paredit)
