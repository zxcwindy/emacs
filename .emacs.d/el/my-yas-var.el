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

(provide 'my-yas-var)
