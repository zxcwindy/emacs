(require 'indent-guide)
;;; 显示延迟时间
(setq indent-guide-delay 0.1)
;;; 显示当前方法缩进
(setq indent-guide-recursive t)

(dolist (hook '(js2-mode-hook
		js-mode-hook
		json-mode-hook
		lisp-interaction-mode-hook
		emacs-lisp-mode-hook
		java-mode))
  (add-hook hook 'indent-guide-mode))

(provide 'zxc-indent)
