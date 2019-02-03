(require 'helm-org-rifle)

(cl-defmacro helm-org-rifle-define-command (name args docstring &key sources input (let nil) (transformer nil))
  "Define interactive helm-org-rifle command, which will run the appropriate hooks.
Helm will be called with vars in LET bound."
  `(cl-defun ,(intern (concat "helm-org-rifle" (when (s-present? name) (concat "-" name)))) ,args
     ,docstring
     (interactive)
     (unwind-protect
         (progn
           (run-hooks 'helm-org-rifle-before-command-hook)
           (let* ((helm-candidate-separator " ")
                  ,(if transformer
                       ;; I wish there were a cleaner way to do this,
                       ;; because if this `if' evaluates to nil, `let' will
                       ;; try to set `nil', which causes an error.  The
                       ;; choices seem to be to a) evaluate to a list and
                       ;; unsplice it (since unsplicing `nil' evaluates to
                       ;; nothing), or b) return an ignored symbol when not
                       ;; true.  Option B is less ugly.
                       `(helm-org-rifle-transformer ,transformer)
                     'ignore)
                  ,@let)
             (helm :sources ,sources :input ,input )))
       (run-hooks 'helm-org-rifle-after-command-hook))))

(helm-org-rifle-define-command
 "" ()
 "This is my rifle.  There are many like it, but this one is mine.

My rifle is my best friend.  It is my life.  I must master it as I
must master my life.

Without me, my rifle is useless.  Without my rifle, I am
useless.  I must fire my rifle true.  I must shoot straighter than
my enemy who is trying to kill me.  I must shoot him before he
shoots me.  I will...

My rifle and I know that what counts in war is not the rounds we
fire, the noise of our burst, nor the smoke we make.  We know that
it is the hits that count.  We will hit...

My rifle is human, even as I, because it is my life.  Thus, I will
learn it as a brother.  I will learn its weaknesses, its strength,
its parts, its accessories, its sights and its barrel.  I will
keep my rifle clean and ready, even as I am clean and ready.  We
will become part of each other.  We will...

Before God, I swear this creed.  My rifle and I are the defenders
of my country.  We are the masters of our enemy.  We are the
saviors of my life.

So be it, until victory is ours and there is no enemy, but
peace!"
 :sources (helm-org-rifle-get-sources-for-open-buffers)
 :input  ((lambda ()
	    (if (region-active-p)
		(buffer-substring-no-properties (region-beginning) (region-end))
	      (word-at-point)))))

(add-to-list 'helm-org-rifle-actions '("select row" . zxc-helm-org-rifle-select-entry-in-buffer))


(defun zxc-helm-org-rifle-select-entry-in-buffer-action ()
  "替换当前光标点单词"
  (interactive)
  (with-helm-alive-p
    (helm-exit-and-execute-action 'zxc-helm-org-rifle-select-entry-in-buffer)))

(defun zxc-helm-org-rifle-select-entry-in-buffer (candidate)
  (-let (((buffer . pos) candidate)
         (original-buffer (current-buffer)))
    (with-current-buffer buffer
      (save-excursion
	(goto-char pos)
	(let* ((end-pos (org-entry-end-position))
	       (temp-str (buffer-substring-no-properties pos end-pos))
	       (search-pos (re-search-forward helm-pattern end-pos)))
	  (goto-char search-pos)
	  (let ((match-content (current-line-contents)))
	    (with-current-buffer original-buffer
	      (let* ((word-pos (bounds-of-thing-at-point 'word))
		    (word-start (car word-pos))
		    (word-end (cdr word-pos)))
		(delete-region word-start word-end)
		(insert (s-trim match-content))))))))))

(global-set-key (kbd "C-.") 'helm-org-rifle)
(define-key helm-org-rifle-map (kbd "<C-return>") 'zxc-helm-org-rifle-select-entry-in-buffer-action)

(provide 'zxc-helm-org-rifle)