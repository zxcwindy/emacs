(require 'multiple-cursors)

;; (defun mc/mark-all-prev-like-this ()
;;   "找到前面所有的相同区域"
;;   (interactive)
;;   (unless (region-active-p)
;;     (error "Mark a region to match first."))
;;   (mc/remove-fake-cursors)
;;   (let ((master (point))
;;         (case-fold-search nil)
;;         (point-first (< (point) (mark)))
;;         (re (regexp-opt (mc/region-strings) mc/enclose-search-term)))
;;     (mc/save-excursion
;;      (save-restriction
;;        (narrow-to-region (point-min) master)
;;        (goto-char 0)
;;        (while (search-forward-regexp re nil t)
;; 	 (push-mark (match-beginning 0))
;; 	 (when point-first (exchange-point-and-mark))
;; 	 (unless (= master (point))
;; 	   (mc/create-fake-cursor-at-point))
;; 	 (when point-first (exchange-point-and-mark))))
;;       (if (> (mc/num-cursors) 1)
;; 	  (multiple-cursors-mode 1)
;; 	(multiple-cursors-mode 0)))))
;;;###autoload
(defun mc/mark-all-prev-like-this ()
  "找到前面所有的相同区域"
  (interactive)
  (unless (region-active-p)
    (error "Mark a region to match first."))
  (mc/remove-fake-cursors)
  (let ((master (point))
        (case-fold-search nil)
        (point-first (< (point) (mark)))
        (re (regexp-opt (mc/region-strings) mc/enclose-search-term)))
    (mc/save-excursion
     (goto-char 0)
     (while (and (search-forward-regexp re nil t) (< (point) master))
       (push-mark (match-beginning 0))
       (when point-first (exchange-point-and-mark))
       (unless (= master (point))
         (mc/create-fake-cursor-at-point))
       (when point-first (exchange-point-and-mark)))))
  (if (> (mc/num-cursors) 1)
      (multiple-cursors-mode 1)
    (multiple--mode 0)))

;;;###autoload
(defun mc/mark-all-next-like-this ()
  "找到后面所有的相同区域"
  (interactive)
  (unless (region-active-p)
    (error "Mark a region to match first."))
  (mc/remove-fake-cursors)
  (let ((master (point))
        (case-fold-search nil)
        (point-first (< (point) (mark)))
        (re (regexp-opt (mc/region-strings) mc/enclose-search-term)))
    (mc/save-excursion
     (goto-char master)
     (while (search-forward-regexp re nil t)
       (push-mark (match-beginning 0))
       (when point-first (exchange-point-and-mark))
       (unless (= master (point))
         (mc/create-fake-cursor-at-point))
       (when point-first (exchange-point-and-mark)))))
  (if (> (mc/num-cursors) 1)
      (multiple-cursors-mode 1)
    (multiple-cursors-mode 0)))

(provide 'el-mutiple-cursors)

