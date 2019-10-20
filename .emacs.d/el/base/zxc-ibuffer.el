(require 'ibuffer)

(setq ibuffer-saved-filter-groups
      (quote (("default"
	       ("shell" (or
			 (mode . shell-mode)))
	       ("web" (or
		       (mode . web-mode)
		       (mode . js2-mode)
		       (mode . js-mode)
		       (mode . css-mode)))
	       ("zip" (or
		       (name . ".*\.jar$")
		       (name . ".*\.tar\.gz$")
		       (name . "*\.zip$")
		       (name . "*\.tgz$")))
	       ;; ("perl" (mode . cperl-mode))
	       ;; ("erc" (mode . erc-mode))
	       ;; ("planner" (or
	       ;; 		   (name . "^\\*Calendar\\*$")
	       ;; 		   (name . "^diary$")
	       ;; 		   (mode . muse-mode)))
	       ("emacs" (or
			 (name . "^\\*scratch\\*$")
			 (name . "^\\*Messages\\*$")
			 (mode . emacs-lisp-mode)))
	       ;; ("gnus" (or
	       ;; 		(mode . message-mode)
	       ;; 		(mode . bbdb-mode)
	       ;; 		(mode . mail-mode)
	       ;; 		(mode . gnus-group-mode)
	       ;; 		(mode . gnus-summary-mode)
	       ;; 		(mode . gnus-article-mode)
	       ;; 		(name . "^\\.bbdb$")
	       ;; 		(name . "^\\.newsrc-dribble")))
	       ("dired" (mode . dired-mode))))))

(add-hook 'ibuffer-mode-hook
	  (lambda ()
	    (ibuffer-switch-to-saved-filter-groups "default")))

(define-ibuffer-column size-h
  (:name "Size" :inline t)
  (cond
   ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1024000.0)))
   ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1024.0)))
   (t (format "%8d" (buffer-size)))))

;; Modify the default ibuffer-formats
(setq ibuffer-formats
      '((mark modified read-only " "
	      (name 18 18 :left :elide)
	      " "
	      (size-h 9 -1 :right)
	      " "
	      (mode 16 16 :left :elide)
	      " "
	      filename-and-process)))

(provide 'zxc-ibuffer)
