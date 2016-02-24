;;;外观&主题
(require 'color-theme-sanityinc-solarized)
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
;; 	  (load-theme day-theme t)
;; 	  (run-at-time (+second sunset-today) nil
;; 		       'change-theme day-theme night-theme))

;;       (load-theme night-theme t)
;;       (if (time-less-p now sunrise-today)
;; 	  (run-at-time (+second sunrise-today) nil
;; 		       'change-theme day-theme night-theme)
;; 	(run-at-time (+second sunrise-tomorrow) nil
;; 		     'change-theme day-theme night-theme)))))

;; (disable-theme 'sanityinc-solarized-light)
;; (disable-theme 'zxc-misterioso)
;; (change-theme 'sanityinc-solarized-light 'zxc-misterioso)

(provide 'zxc-theme)
