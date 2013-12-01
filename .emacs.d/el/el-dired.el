(require 'dired)
(require 'dired-details)
;;(dired-details-install)

(defun dired-back-to-top ()
  (interactive)
  (beginning-of-buffer)
  (dired-next-line 4))

(define-key dired-mode-map
  (vector 'remap 'beginning-of-buffer) 'dired-back-to-top)

(defun dired-jump-to-bottom ()
  (interactive)
  (end-of-buffer)
  (dired-next-line -1))

(define-key dired-mode-map
  (vector 'remap 'end-of-buffer) 'dired-jump-to-bottom)

(setf dired-listing-switches (purecopy "-la"))
(add-hook 'dired-mode-hook #'(lambda ()
			       (define-key dired-mode-map (kbd "C-o") nil)))
(provide 'el-dired)
