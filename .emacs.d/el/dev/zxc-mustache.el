(require 'mustache)
(require 'zxc-util)


(defun zxc-mustache-json-to-sql ()
  "将json转为sql"
  (interactive)
  (zxc-util-get-region-or-paragraph-string))
