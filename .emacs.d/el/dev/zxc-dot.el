(require 'graphviz-dot-mode)

(define-key graphviz-dot-mode-map "\C-cp" #'(lambda ()
					      (interactive)
					      (save-buffer)
					      (compile compile-command)
					      ;; (graphviz-dot-preview)
					      ;; (graphviz-dot-preview)
					      ))
