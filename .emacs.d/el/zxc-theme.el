;;;外观&主题
(require 'color-theme-sanityinc-solarized)
(require 'color-theme-sanityinc-tomorrow)

(if (string< (format-time-string "%H%M") "1900")
    (color-theme-sanityinc-solarized-light)
  (load-theme 'misterioso))

(provide 'zxc-theme)
