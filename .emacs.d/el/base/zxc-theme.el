;;;外观&主题
(require 'color-theme-sanityinc-solarized)
(require 'theme-changer)

(defun zxc-change-theme (day-theme night-theme)
  (let*
      ((now (current-time))
       
       (today-times    (sunrise-sunset-times (today)))
       (tomorrow-times (sunrise-sunset-times (tomorrow)))
       
       (sunrise-today (first today-times))
       (sunset-today (second today-times))
       (sunrise-tomorrow (first tomorrow-times)))
    
    (if (daytime-p sunrise-today sunset-today)
	(progn
	  (switch-theme night-theme day-theme)
	  (web-mode-html-day-theme)
	  (run-at-time (+second sunset-today) nil
		       'zxc-change-theme day-theme night-theme))

      (switch-theme day-theme night-theme)
      (web-mode-html-night-theme)
      (if (time-less-p now sunrise-today)
	  (run-at-time (+second sunrise-today) nil
		       'zxc-change-theme day-theme night-theme)
	(run-at-time (+second sunrise-tomorrow) nil
		     'zxc-change-theme day-theme night-theme)))))

(defun web-mode-html-night-theme ()
  "晚上的web-mode-html标签颜色设置"
  (custom-set-faces
   '(web-mode-html-tag-face ((t (:foreground "#00EDE1"))))
   '(web-mode-html-tag-bracket-face ((t (:foreground "#D7D8D7"))))
   '(web-mode-html-attr-equal-face ((t (:foreground "#D7D8D7"))))
   '(web-mode-html-attr-name-face ((t (:foreground "#DADA95"))))
   '(web-mode-html-attr-value-face ((t (:foreground "#09D773"))))))

(defun web-mode-html-day-theme ()
  "白天的web-mode-html标签颜色设置"
  (custom-set-faces
   '(web-mode-html-tag-face ((t (:foreground "#b58900"))))
   '(web-mode-html-tag-bracket-face ((t (:foreground "#657B83"))))
   '(web-mode-html-attr-equal-face ((t (:foreground "#657B83"))))
   '(web-mode-html-attr-name-face ((t (:foreground "#6c71c4"))))
   '(web-mode-html-attr-value-face ((t (:foreground "#2aa198"))))))



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
