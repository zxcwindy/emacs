(require 'polymode)

;;; 参考文档
;;; https://www.masteringemacs.org/article/polymode-multiple-major-modes-how-to-use-sql-python-in-one-buffer
;;; https://polymode.github.io/defining-polymodes/

(define-hostmode poly-nxml-hostmode
  :mode 'nxml-mode)

(define-innermode poly-nxml-sql-innermode
  :mode 'sql-mode
  :head-matcher "<select.*>"
  :tail-matcher "</select>"
  :head-mode 'host
  :tail-mode 'host)

(define-polymode poly-mybaits-mode
  :hostmode 'poly-nxml-hostmode
  :innermodes '(poly-nxml-sql-innermode))

(provide 'zxc-mybaits)
