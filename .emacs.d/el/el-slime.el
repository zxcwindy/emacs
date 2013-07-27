(require 'slime)
(slime-setup)
(global-set-key "\C-hj" 'slime-hyperspec-lookup)
(setq common-lisp-hyperspec-root "/home/asiainfo/api/HyperSpec-7-0/HyperSpec/")
(setq inferior-lisp-program "/usr/local/bin/sbcl")

(provide 'el-slime)
