;;; theme-changer.el --- Sunrise/Sunset Theme Changer for Emacs

;; Copyright (C) 2011-2013 Joshua B. Griffith

;; Author: Joshua B. Griffith <josh.griffith@gmail.com>
;; Contributors: Joe Snikeris, Mike Fisher, Göktuğ Kayaalp
;; URL: https://github.com/hadronzoo/theme-changer
;; Created: 20 Jun 2011
;; Version: 2.1.0
;; Keywords: color-theme, deftheme, solar, sunrise, sunset

;; Permission is hereby granted, free of charge, to any person obtaining
;; a copy of this software and associated documentation files (the
;; "Software"), to deal in the Software without restriction, including
;; without limitation the rights to use, copy, modify, merge, publish,
;; distribute, sublicense, and/or sell copies of the Software, and to
;; permit persons to whom the Software is furnished to do so, subject to
;; the following conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Commentary:

;; Given a location and day/night color themes, this file provides a
;; `change-theme` function that selects the appropriate theme based on
;; whether it is day or night. It will continue to change themes at
;; sunrise and sunset. To install:

;; Set the location:
;;     (setq calendar-location-name "Dallas, TX")
;;     (setq calendar-latitude 32.85)
;;     (setq calendar-longitude -96.85)

;; Specify the day and night themes:
;;     (require 'theme-changer)
;;     (change-theme 'solarized-light 'solarized-dark)

;; You can also pass nil as either of parameters to change-theme, with the
;; effect of not using a theme (or using the default Emacs theme) during that
;; period of the day. For example:

;;     (change-theme nil 'solarized-dark)

;; will result in setting the default Emacs theme during the day, and
;; solarized-dark during the night.

;; You may need to add this file path to your loadpath. For example:
;;     (add-to-list 'load-path "~/.emacs.d/elisp/theme-changer")

;; If you want to use the color-theme package instead of the Emacs 24 color
;; theme facility:
;;     (setq theme-changer-mode "color-theme")
;;     (change-theme 'color-theme-solarized-light 'color-theme-solarized-dark)

;;; Code:

;;;外观&主题
(require 'color-theme-sanityinc-solarized)
(require 'cl-lib)
(require 'solar)

(defvar theme-changer-mode "deftheme"
  "Specify the theme change mode: \"color-theme\" or Emacs 24's
\"deftheme\".")

(defun hour-fraction-to-time (date hour-fraction)
  (let*
      ((now (decode-time (current-time)))

       (month (first   date))
       (day   (second  date))
       (year  (third   date))
       (zone  (ninth   now))

       (frac-hour (cl-truncate hour-fraction))
       (hour (first frac-hour))

       (frac-minutes (cl-truncate (* (second frac-hour) 60)))
       (minute (first frac-minutes))

       (frac-seconds (cl-truncate (* (second frac-minutes) 60)))
       (sec (first frac-seconds)))
    (encode-time sec minute hour day month year zone)))


(defun sunrise-sunset-times (date)
  (let*
      ((l (solar-sunrise-sunset date))
       (sunrise-time (hour-fraction-to-time date (caar l)))
       (sunset-time (hour-fraction-to-time date (caadr l))))
    (list sunrise-time sunset-time)))

(defun daytime-p (sunrise-time sunset-time)
  (let* ((now (current-time)))
    (and (time-less-p sunrise-time now)
	 (time-less-p now sunset-time))))

(defun today () (calendar-current-date))

(defun tomorrow ()
  (calendar-gregorian-from-absolute
   (+ 1 (calendar-absolute-from-gregorian (today)))))

(defun +second (time)
  (time-add time (seconds-to-time 1)))

(defun switch-theme (old new)
  "Change the theme from OLD to NEW, using Emacs 24's built-in
theme facility (\"deftheme\") or color-theme.

If NEW is set to nil, shall switch to default Emacs theme."
  (if (string= theme-changer-mode "deftheme")
      (progn
	(disable-theme old)
	(if new
	    (load-theme new t)))
    (if new
	(apply (symbol-function new) '()))))

(defun change-theme (day-theme night-theme)
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
	  (run-at-time (+second sunset-today) nil
		       'change-theme day-theme night-theme))

      (switch-theme day-theme night-theme)
      (if (time-less-p now sunrise-today)
	  (run-at-time (+second sunrise-today) nil
		       'change-theme day-theme night-theme)
	(run-at-time (+second sunrise-tomorrow) nil
		     'change-theme day-theme night-theme)))))

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
	  (zxc-theme-custom-day-theme)
	  (run-at-time (+second sunset-today) nil
		       'zxc-change-theme day-theme night-theme))

      (switch-theme day-theme night-theme)
      (zxc-theme-custom-night-theme)
      (if (time-less-p now sunrise-today)
	  (run-at-time (+second sunrise-today) nil
			  'zxc-change-theme day-theme night-theme)
	(run-at-time (+second sunrise-tomorrow) nil
			'zxc-change-theme day-theme night-theme)))))

(defun zxc-theme-custom-night-theme ()
  "晚上的theme标签颜色设置"
  (custom-set-faces
   '(web-mode-html-tag-face ((t (:foreground "#00EDE1"))))
   '(web-mode-html-tag-bracket-face ((t (:foreground "#D7D8D7"))))
   '(web-mode-html-attr-equal-face ((t (:foreground "#D7D8D7"))))
   '(web-mode-html-attr-name-face ((t (:foreground "#DADA95"))))
   '(web-mode-html-attr-value-face ((t (:foreground "#09D773"))))
   '(ctbl:face-cell-select ((t (:background "#3a5fcd"))))
   '(ctbl:face-row-select ((t (:background "#8b3a62"))))
   '(magit-section-highlight ((t (:background "DodgerBlue4"))))
   '(region ((t (:background "blue" :foreground "#e1e1e0"))))))

(defun zxc-theme-custom-day-theme ()
  "白天的theme标签颜色设置"
  (custom-set-faces
   '(web-mode-html-tag-face ((t (:foreground "#b58900"))))
   '(web-mode-html-tag-bracket-face ((t (:foreground "#657B83"))))
   '(web-mode-html-attr-equal-face ((t (:foreground "#657B83"))))
   '(web-mode-html-attr-name-face ((t (:foreground "#6c71c4"))))
   '(web-mode-html-attr-value-face ((t (:foreground "#2aa198"))))
   '(magit-blame-highlight ((t (:foreground "white" :background "grey60"))))
   '(ctbl:face-cell-select ((t (:background "cyan"))))
   '(ctbl:face-row-select ((t (:background "light gray"))))
   '(region ((t (:foreground "#AA8E16" :inverse-video t))))))

(provide 'zxc-theme)
