;; yas 所需的变量定义

(setf my-yas-interface (make-hash-table :test 'equal))
(puthash "09054" "ods_dbillcustdetailnew_task_id" my-yas-interface)
(puthash "09004" "ods_dcustowedaynew_task_id" my-yas-interface)
(puthash "09003" "ods_dcustowedetdaynew_task_id" my-yas-interface)
(puthash "09646" "ods_ddsmpordermsgnew_task_id" my-yas-interface)
(puthash "01020" "ods_product_plan_task_id" my-yas-interface)
(puthash "09068" "ods_dconmsgnew_task_id" my-yas-interface)
(puthash "09066" "ods_dconusermsgnew_task_id" my-yas-interface)
(puthash "09095" "ods_dconmsgprenew_task_id" my-yas-interface)
(puthash "d010001" "ods_ur_user_info_task_id" my-yas-interface)
(puthash "d010005" "ods_ur_userbrand_rel_task_id" my-yas-interface)
(puthash "d010016" "ods_pd_usersvcattr_info_task_id" my-yas-interface)

(setf my-yas-mysql-alias-interface (make-hash-table :test 'equal))
(puthash "cq" "3307" my-yas-mysql-alias-interface)
(puthash "ali" "3308" my-yas-mysql-alias-interface)
(puthash "gz" "3309" my-yas-mysql-alias-interface)
(puthash "nj" "3310" my-yas-mysql-alias-interface)
(puthash "sd" "3311" my-yas-mysql-alias-interface)
(puthash "hb" "3312" my-yas-mysql-alias-interface)

(setf shell-host-alias-interface (make-hash-table :test 'equal))
(puthash "137" (list :userName "root" :host "10.1.234.137" :password "10137!)!#&") shell-host-alias-interface)
(puthash "66" (list :userName "david" :host "115.29.53.66" :password "gouhh!@#") shell-host-alias-interface)
(puthash "138" (list :userName "root" :host "10.1.234.138" :password "10138!)!#*") shell-host-alias-interface)
(puthash "33" (list :userName "gbase" :host "10.1.235.33" :password "gbase") shell-host-alias-interface)
(puthash "135" (list :userName "oracle" :host "10.1.234.135" :password "oracle") shell-host-alias-interface)
(puthash "38" (list :userName "shandong" :host "10.1.235.38" :password "shandong") shell-host-alias-interface)

(puthash "dam" "kun_361" zxc-db-ac-alias-db-map)
(puthash "dc" "dam" zxc-db-ac-alias-db-map)
(puthash "dev" "kun_dam_3.6.1_dev" zxc-db-ac-alias-db-map)
(puthash "txpyspider" "pyspider" zxc-db-ac-alias-db-map)
(puthash "370" "kun_dam_3.7.0_dev" zxc-db-ac-alias-db-map)
(puthash "361" "kun_dam_3.6.1_dev" zxc-db-ac-alias-db-map)


(defvar zxc-db-data-result nil
  "返回结果集")

(defvar jj-global-string nil)

(defun zxc-db-data-send (uri object zxc-db-callback)
  "Send object to URL as an HTTP POST request, returning the response
and response headers.
object is an json, eg {key:value} they are encoded using CHARSET,
which defaults to 'utf-8"
  (lexical-let ((zxc-db-callback zxc-db-callback))
    (deferred:$
      (deferred:url-post (format "%s/service/rest/data/%s/%s" zxc-db-host uri "pyspider") object)
      (deferred:nextc it
	(lambda (buf)
	  (let ((data (with-current-buffer buf (buffer-string)))
		(json-object-type 'plist)
		(json-array-type 'list)
		(json-false nil))
	    (kill-buffer buf)
	    (setf zxc-db-data-result (json-read-from-string (decode-coding-string data 'utf-8))))))
      (deferred:nextc it
	(lambda (response)
	  (funcall zxc-db-callback))))))


(defun zxc-db-jj-query ()
  (zxc-db-data-send "query" (list (cons "sql" "select b.jzgs_per jzgs_per, b.ji_jin_code from ji_jin_value b ,(select ji_jin_code,max(id) id from ji_jin_value where ji_jin_code in ('690007','370024') group by ji_jin_code) a where b.id = a.id order by ji_jin_code "))
		    #'(lambda ()
			(let ((error-msg (getf zxc-db-data-result :errorMsg)))
			  (if (null error-msg)
			      (setf jj-global-string (mapconcat (lambda (x)
								  (int-to-string (car x))) (getf zxc-db-data-result :data) "|"))
			    (setf jj-global-string ""))))))
;; sh600585,sh600009,sh601111,sh601066,sz000651,sh601138,sh513100

(defun zxc-db-gp-query ()
  (let ((zxc-db-is-working-time (and (> (string-to-number (format-time-string "%M")) 2)
				     (>= (string-to-number (format-time-string "%H")) 15))))
    (if (not zxc-db-is-working-time)
	(deferred:$
	  ;; =s_sh600248,s_sz300327,s_sh603799,s_sh688660
	  (deferred:url-get "http://qt.gtimg.cn/q=s_sh603799,s_sz000157,s_sz000858,s_sh600276,s_sz002078,s_sz300327,s_sh000001")
	  (deferred:nextc it
	    (lambda (buf)
	      (let ((data (with-current-buffer buf (buffer-string))))
		(kill-buffer buf)
		(setf gp-result (decode-coding-string data 'utf-8)))))
	  (deferred:nextc it
	    (lambda (response)
	      (let* ((response-list (split-string response "\n"))
		     (value-result (mapcar #'(lambda (g)
					       (let* ((row (split-string g "="))
						      (gp-name (nth 0 row))
						      (gp-value (nth 1 row)))
						 (concatenate 'list (list (replace-regexp-in-string "var hq_str_" "" gp-name)) (subseq (split-string (nth 1 (split-string g "=")) "~") 1 6))))
					   (subseq response-list 0 (- (length response-list) 1)))))
		(setq m123 (mapcar #'(lambda (v)
				       (let ((2v (string-to-number (nth 3 v)))
					     (3v (string-to-number (nth 5 v))))
					 (concat (format "%0.2f" 2v)
						 "|"
						 (number-to-string 3v) " ")
					 ;; (cond ((s-contains? (car v) "sh600585,sz000725,sh601318,sh601088")
					 ;;	  (concat (format "%0.2f" (* (/ (- 3v 2v) 2v ) 100))
					 ;;		  "|"
					 ;;		  (number-to-string 3v) " "))
					 ;;	 ;; ((<  (* (/ (- 3v 2v) 2v ) 100) -3)
					 ;;	 ;;  (concat (format "%0.2f" (* (/ (- 3v 2v) 2v ) 100))
					 ;;	 ;;	  "|"
					 ;;	 ;;	  (number-to-string 3v) " "))
					 ;;	 (t ""))
					 ))
				   value-result))
		;; (with-current-buffer (get-buffer-create "12345")
		;;   (erase-buffer)
		;;   (loop
		;;    for fy in value-result
		;;    do (insert-string (format "%s当前%s,最高%s,最低%s\n" (nth 0 fy) (nth 3 fy) (nth 4 fy) (nth 5 fy)))))
		))))
      (zxc-cancel-db-time))))


;; (setq global-mode-string '("" display-time-string " " jj-global-string))
(setq global-mode-string '("" display-time-string " " m123))
;; (setq zxc-db-jj-query-timer (run-with-timer 0 60 'zxc-db-jj-query))
;;; 被sina屏蔽
;; (setq zxc-db-gp-query-timer (run-with-timer 0 60 'zxc-db-gp-query))

(defun zxc-cancel-db-time ()
  (cancel-timer zxc-db-gp-query-timer)
  (setq m123 ""))


(defun zxc-nginx-conf-notify-callback (event)
  (call-process "/bin/bash" nil "*nginx*" nil "-c" "myresty -s reload"))

(file-notify-add-watch
 "/home/david/opt/openresty-1.11.2.3/nginx/conf/nginx.conf" '(change) 'zxc-nginx-conf-notify-callback)

(provide 'my-yas-var)
