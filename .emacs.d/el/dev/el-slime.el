;;(require 'slime)
(slime-setup)
(global-set-key "\C-hj" 'slime-hyperspec-lookup)
(setq common-lisp-hyperspec-root "/home/david/api/HyperSpec-7-0/HyperSpec/")
(setq inferior-lisp-program "/usr/local/bin/sbcl")
;; (setq inferior-lisp-program "/usr/bin/clisp")

(provide 'el-slime)
