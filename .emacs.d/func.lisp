
;;rotatef
(defun bad-reverse (lst)
  (let* ((len (length lst))
	 (ilimit (truncate (/ len 2))))
    (do ((i 0 (1+ i))
	 (j (1- len) (1- j)))
	((>= i ilimit))
      (rotatef (nth i lst) (nth j lst)))))

(x-popup-menu '(100 200) (list '1 '2))


(x-popup-menu (if (fboundp 'posn-at-point)
		  (let ((x-y (posn-x-y (posn-at-point (point)))))
		    (list (list (+ (car x-y) 10)
				(+ (cdr x-y) 20))
			  (selected-window)))
		  t)
	      (menu-item ,(purecopy "Hide") ns-do-hide-emacs
			 :help ,(purecopy "Hide Emacs")))

(x-popup-dialog (cons 1 3)
		(list "123" (cons "123" "333")))

(cons 1 3)


(menu-item ,(purecopy "Hide") ns-do-hide-emacs
	   :help ,(purecopy "Hide Emacs"))


(global-set-key (kbd "C-; C-;")
		#'(lambda (start end)
		    (interactive "r")
		    (mapcar #'(lambda (cons)
				(perform-replace (car cons)
						 (cdr cons) nil nil nil nil nil start end ))
			    '(("d_infoplat_group" . "{dim}.DIM_KPI_CHL_PLAT")
			      ("LS_DW_KPI_DAY_${ym}" . "{st}.LS_DW_KPI_DAY_&MTASK_ID")
			      ("kpi_id" . "zb_code")
			      ("group_id" . "chl_id")
			      ("dw_kpi_infoplat_month" . "{st}.kpi_month_&MTASK_ID")
			      ("kpi_value" . "value")
			      ("\"" "")
			      ("from DW_KPI_DAY_${ym}". "from {st}.kpi_daily_&YYYY")
			      ("FROM DW_KPI_DAY_${ym}". "from {st}.kpi_daily_&YYYY")
			      ("'${op_time}'" . "'&YYYY&MM&DD'")
			      ("op_time" . "deal_date")
			      ("input_time" . "deal_time")
			      ("${rKpiId}" . "{resultKpi2}.get(4)")
			      ("$rKpiId" . "{resultKpi2}.get(4)")
			      ("$kpiId" . "{resultKpi2}.get(1)")
			      ("$sumFmt" . "{resultKpi2}.get(5)")
			      ("$sumList" . "{sumList}")
			      ("$fieldList" . "{fieldList}")
			      ("${monthBegin}" . "&YYYY&MM01")))))
