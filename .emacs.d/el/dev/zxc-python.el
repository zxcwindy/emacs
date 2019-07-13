(require 'python)
(elpy-enable)  
(setq elpy-rpc-python-command "python3.5")
(setq elpy-rpc-backend "jedi")
(setq jfedi:complete-on-dot t)
(setq python-shell-interpreter "python3")

;;; 禁用ac
(defadvice auto-complete-mode (around disable-auto-complete-for-python)
  (unless (eq major-mode 'python-mode) ad-do-it))

(ad-activate 'auto-complete-mode)

(provide 'zxc-python)
