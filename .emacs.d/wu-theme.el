(deftheme wu)

(custom-theme-set-faces
 'wu
 '(default ((t (:family "Liberation Mono" :background "#161616" :foreground "burlywood3"))))

 ;; build in syntax
 '(font-lock-builtin-face ((t (:foreground "#DAB98F"))))
 '(font-lock-comment-face ((t (:foreground "gray50"))))
 '(font-lock-string-face ((t (:foreground "SeaGreen4"))))
 '(font-lock-keyword-face ((t (:foreground "DarkGoldenrod3"))))
 '(font-lock-function-name-face ((t (:foreground "burlywood3"))))
 '(font-lock-comment-face ((t (:foreground "gray50"))))
 '(font-lock-doc-face ((t (:foreground "dark cyan"))))
 '(font-lock-constant-face ((t (:foreground "burlywood3"))))
 '(font-lock-variable-name-face ((t (:foreground "burlywood3"))))
 '(font-lock-type-face ((t (:foreground "burlywood3"))))
 '(font-lock-preprocessor-face ((t (:foreground "#cd5555"))))
 '(font-lock-warning-face ((t (:foreground "#FF0000" :weight bold))))

 ;; compile
 '(compilation-info ((t (:foreground "SeaGreen3" :weight bold))))


 ;; org mode
 '(org-level-1 ((t (:foreground "#c1cdcd" :weight bold))))
 '(org-level-2 ((t (:foreground "#8b8378"))))

 ;; highlight
 '(highlight ((t (:background "blue4"))))
 '(region ((t (:background "MistyRose2"))))

 ;; company
 '(company-preview ((t (:foreground "darkgray" :underline t))))
 '(company-preview-common ((t (:inherit company-preview))))
 '(company-tooltip ((t (:background "lightgray" :foreground "black"))))
 '(company-tooltip-selection ((t (:background "steelblue" :foreground "white"))))
 '(company-tooltip-common ((((type x)) (:inherit company-tooltip :weight bold))
			   (t (:inherit company-tooltip))))
 '(company-tooltip-common-selection ((((type x)) (:inherit company-tooltip-selection :weight bold))
				     (t (:inherit company-tooltip-selection))))
 '(company-scrollbar-bg ((t (:background "#121212"))))
 '(company-scrollbar-fg ((t (:background "#121212"))))
 '(eldoc-highlight-function-argument ((t (:inherit bold :foreground "#00ee76" :underline t :weight bold))))
 ;; whitespace-mode for 80 columns
 '(whitespace-line ((t (:foreground "IndianRed4"))))
 ;; show-paren-mode
 '(show-paren-match-face (( t (:background "firebrick3"))))
 ;; window spliter color
 '(vertical-border (( t (:foreground "seashell4"))))
 ;; version control
 '(diff-added (( t (:foreground "#2aa198"))) 'now)
 '(diff-removed (( t (:foreground "#cd5555"))) 'now)
)

(provide-theme 'wu)
