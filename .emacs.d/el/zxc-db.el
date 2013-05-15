(provide 'zxc-db)
;;sql-comint
(defvar rgi '('mysql '("rgi --user=root --host=localhost -D rgi --port= 3306")))

(defun zxc-conn (alias)
  (apply #'sql-comint alias))
