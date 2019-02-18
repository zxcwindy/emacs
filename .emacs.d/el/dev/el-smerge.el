(require 'smerge-mode)

(define-key smerge-mode-map "N" 'smerge-next)
(define-key smerge-mode-map "P" 'smerge-prev)
(define-key smerge-mode-map "R" 'smerge-resolve)
(define-key smerge-mode-map "A" 'smerge-keep-all)
(define-key smerge-mode-map "B" 'smerge-keep-base)
(define-key smerge-mode-map "L" 'smerge-keep-lower)
(define-key smerge-mode-map "U" 'smerge-keep-upper)

(provide 'el-smerge)
