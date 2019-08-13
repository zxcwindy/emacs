(require 'dired)
(require 'dired-details)
;;(dired-details-install)



(defun dired-back-to-top ()
  (interactive)
  (goto-char (point-min))
  (dired-next-line 4))

(define-key dired-mode-map
  (vector 'remap 'beginning-of-buffer) 'dired-back-to-top)

(defun dired-jump-to-bottom ()
  (interactive)
  (goto-char (point-max))
  (dired-next-line -1))

(define-key dired-mode-map
  (vector 'remap 'end-of-buffer) 'dired-jump-to-bottom)

(make-variable-buffer-local
 (defvar zxc-dired-queue-index 0 "当前目录排序索引"))

(defclass zxc-cycle-queue ()
  ((list-strs :initarg :list-strs)
   (current-str :initform ""
		:reader get-zxc-dired-current-str)))

(cl-defmethod  zxc-dired-get-current-str ((instance zxc-cycle-queue))
  (let ((max-length (length (slot-value instance 'list-strs))))
    (setf zxc-dired-queue-index
	  (if (= (+ zxc-dired-queue-index 1) max-length)
	      0
	    (+ zxc-dired-queue-index 1)))
    (nth zxc-dired-queue-index (slot-value instance 'list-strs))))

(setq zxc-dired-sort-queue (zxc-cycle-queue :list-strs (list "-Al -1 " "-Al -t" "-Al -X" "-Al -S")))

(defun zxc-dired-sort ()
  (interactive)
  (dired-sort-other (zxc-dired-get-current-str zxc-dired-sort-queue) ))

(setf dired-listing-switches (purecopy "-alh"))
(add-hook 'dired-mode-hook #'(lambda ()
			       (define-key dired-mode-map (kbd "C-o") nil)
			       (define-key dired-mode-map (kbd "s") 'zxc-dired-sort)))
(provide 'el-dired)
