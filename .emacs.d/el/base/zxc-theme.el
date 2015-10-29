;;;外观&主题
(require 'color-theme-sanityinc-solarized)
(require 'color-theme-sanityinc-tomorrow)
(require 'misterioso-theme)
(require 'theme-changer)

;; (defun change-theme (day-theme night-theme)
;;   "重定义方法"
;;   (let*
;;       ((now (current-time))

;;        (today-times    (sunrise-sunset-times (today)))
;;        (tomorrow-times (sunrise-sunset-times (tomorrow)))

;;        (sunrise-today (first today-times))
;;        (sunset-today (second today-times))
;;        (sunrise-tomorrow (first tomorrow-times)))

;;     (if (daytime-p sunrise-today sunset-today)
;; 	(progn
;; 	  (funcall day-theme)
;; 	  (run-at-time (+second sunset-today) nil
;; 		       'change-theme day-theme night-theme))

;;       (funcall night-theme)
;;       (if (time-less-p now sunrise-today)
;; 	  (run-at-time (+second sunrise-today) nil
;; 		       'change-theme day-theme night-theme)
;; 	(run-at-time (+second sunrise-tomorrow) nil
;; 		     'change-theme day-theme night-theme)))))

;; (if (string< (format-time-string "%H%M") "1800")
;;     (color-theme-sanityinc-solarized-light)
;;   (load-theme 'misterioso))

;; (setq theme-changer-mode "color-theme")
(defun zxc-theme-change ()
  (interactive)
  (change-theme 'sanityinc-solarized-light 'misterioso))

(provide 'zxc-theme)
