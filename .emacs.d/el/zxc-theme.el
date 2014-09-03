;;;外观&主题
(require 'color-theme-sanityinc-solarized)
(require 'color-theme-sanityinc-tomorrow)
(require 'theme-changer)

(if (string< (format-time-string "%H%M") "1800")
    (color-theme-sanityinc-solarized-light)
  (load-theme 'misterioso))

(setq calendar-location-name "Dallas, TX")
(setq calendar-longitude -120.2)
(setq calendar-latitude 30.3)

;; (setq theme-changer-mode "color-theme")
;;(change-theme 'sanityinc-solarized-light 'misterioso)

(provide 'zxc-theme)
