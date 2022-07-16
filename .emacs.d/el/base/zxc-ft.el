;;; zxc-ft --- quick access to files by tags

;; Copyright (C) 2020-2020.

;; Author: zhengxc <zh_xi_ch@126.com>
;; Keywords: file, tags, tools

;; create table tags_(
;;    id int auto_increment primary key,
;;;   short_name char(2) ,
;;    tag_name varchar(64),
;;    p_id int,
;;;   level_ int default 1
;; );

;; create table files_(
;;    id int auto_increment primary key,
;;    file_name varchar(128),
;;    file_path varchar(2048),
;;    update_time int
;; );

;; create table tag_file (
;;      tag_id int ,
;;      file_id int
;; );

;; create index tag_file_tag_id on tag_file (tag_id);
;; create index tag_file_file_id on tag_file (file_id);

(require 'wid-edit)

(defvar zxc-ft-buffer nil
  "The buffer displaying the file tags.")

(defvar zxc-ft-query-url "http://localhost:9990/service/rest/data/query/tag"
  "查询后台服务地址")

(defvar zxc-ft-exec-url "http://localhost:9990/service/rest/data/exec/tag"
  "更新后台服务地址")

(defvar zxc-ft-tag-widget nil "标签选择展现的input")

(defvar zxc-ft-action-keys
  (list "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"
	"a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
	"A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z")
  "标签的触发键")

(defvar zxc-ft-tags-all (make-hash-table :test 'equal) "所有的标签,为map格式,key为shortName,value为集合")

(defvar zxc-ft-tags-search nil "查询的标签")

(defvar zxc-ft-begin-ol nil "标签拼接起始点")

(defvar zxc-ft-sub-tags-keys
  (nconc (list "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")
	 (loop for i from 0 to 9 collect i))
  "当一个shortName对应多个标签时,按照自然顺序重新排序定义快捷键")

(defvar zxc-ft-is-sub-view nil "是否是子标签视图")

(defvar zxc-ft-sub-tags-tmp nil "临时子标签集合")

(defvar zxc-ft-current-action nil "标签触发操作，nil->查询, t->管理")

(defface zxc-ft-action-face-foreground
  '((((class color)) (:foreground "red"))
    (((background dark)) (:foreground "gray100"))
    (((background light)) (:foreground "gray0"))
    (t (:foreground "gray100")))
  "触发按键的颜色")

(defvar zxc-ft-init-p nil)

(defun zxc-ft (arg)
  "启动文件标签系统"
  (interactive "P")
  (if (null arg)
      (progn
	(zxc-ft-init)
	(switch-to-buffer zxc-ft-buffer))
    (zxc-ft-create-new-tag)))


(define-derived-mode zxc-ft-mode fundamental-mode "FT"
  "用标签重新组织文件"
  (page-break-lines-mode)
  (mapc #'(lambda (key)
	    (zxc-mode-action-str zxc-ft-mode-map key 'zxc-ft-tag-choose)) zxc-ft-action-keys)
  (define-key zxc-ft-mode-map (kbd "<backspace>") 'zxc-ft-reset-main-view)
  (define-key zxc-ft-mode-map (kbd "RET") 'zxc-ft-tag-action))

(defun zxc-ft-init ()
  "初始化展现"
  (setq zxc-ft-buffer (get-buffer-create "*ft*"))
  (set-buffer zxc-ft-buffer)
  (clrhash zxc-ft-tags-all)
  (setq zxc-ft-tags-search nil)
  (setq zxc-ft-is-sub-view nil)
  (setq zxc-ft-tags-search nil)
  (setq zxc-ft-current-action nil)
  (zxc-ft-main-view)
  (zxc-ft-mode))

(defun zxc-ft-main-view ()
  (with-current-buffer zxc-ft-buffer
    (let ((inhibit-read-only t))
      (erase-buffer))
    (let ((top-tags (zxc-ft-get-top-tags)))
      (remove-overlays)
      (insert "\n\t\t")
      (setq zxc-ft-tag-widget (widget-create
			       'editable-field
			       :size 100
			       :format "当前选择的标签: %v "))
      (insert "\n\n")
      (setq zxc-ft-begin-ol (make-overlay (point) (point)))
      (zxc-ft-view-create-all-tags top-tags))
    (widget-setup)))

(defun zxc-ft-view-create-all-tags (top-tags)
  "创建所有的标签分类展现"
  (loop for tag in top-tags
	do (progn (insert "[" (zxc-get-action-key (nth 1 tag)) "]" " " (nth 2 tag) "\n\n")
		  (let ((child-tags (zxc-ft-get-child-tags (nth 0 tag)))
			(start-point (point)))
		    (loop for i from 0 to (- (length child-tags) 1)
			  do (progn
			       (when (and (= (% i 8) 0) (/= i 0))
				 (insert "\n"))
			       (insert "[" (zxc-get-action-key (nth 1 (nth i child-tags))) "]" (nth 2 (nth i child-tags)) "\t")))
		    (align-regexp start-point (point) "\\(\\s-*\\)\\s-" 1 1 t))
		  (insert "\n\n"))))

(defun zxc-ft-view-create-sub-tags (tags)
  "创建相同shortName的标签视图"
  (let ((inhibit-read-only t))
    (delete-region (overlay-start zxc-ft-begin-ol) (point-max))
    (goto-char (point-max))
    (loop for i from 0 to (- (length tags) 1)
	  do (progn
	       (when (and (= (% i 8) 0) (/= i 0))
		 (insert "\n"))
	       (insert "[" (zxc-get-action-key (nth i zxc-ft-sub-tags-keys)) "]" (nth 2 (nth i tags)) "\t")))
    (align-regexp (overlay-start zxc-ft-begin-ol) (point) "\\(\\s-*\\)\\s-" 1 1 t)))

(defun zxc-ft-reset-main-view (arg)
  "返回展现所有标签的主视图"
  (interactive "P")
  (if (or (null zxc-ft-current-action) (null arg))
      (when zxc-ft-is-sub-view
	(let ((inhibit-read-only t))
	  (delete-region (overlay-start zxc-ft-begin-ol) (point-max))
	  (clrhash zxc-ft-tags-all)
	  (goto-char (point-max))
	  (zxc-ft-view-create-all-tags (zxc-ft-get-top-tags))
	  (setq zxc-ft-sub-tags-tmp nil)
	  (setq zxc-ft-is-sub-view nil)
	  (goto-char (point-min))))
    (delete-window)))

(defun zxc-ft-get-top-tags ()
  "获取所有的标签组,level为0"
  (let ((temp-tags (zxc-ft-query-data '((sql . "select id,short_name,tag_name from tags_ where level_=0")))))
    (zxc-ft-add-tags temp-tags)
    temp-tags))

(defun zxc-ft-get-child-tags (pid)
  "获取父级标签的子标签"
  (let ((temp-tags (zxc-ft-query-data (list (cons 'sql (concat "select id,short_name,tag_name from tags_ where p_id=" (int-to-string pid)))))))
    (zxc-ft-add-tags temp-tags)
    temp-tags))

(defun zxc-ft-query-data (param)
  "标签的数据查询服务,param为cons参数"
  (getf (http-post zxc-ft-query-url
		   param)
	:data))

(defun zxc-ft-exec-data (sql)
  "标签的数据查询服务,param为cons参数"
  (http-post zxc-ft-exec-url
	     (list (cons 'sql sql))))

(defun zxc-get-action-key (key-str)
  "获取带有颜色的action字符串"
  (propertize key-str 'face 'zxc-template-face-foreground))

(defun zxc-ft-add-tags (tags)
  "将标签按照shortname和集合的方式存放到map中"
  (loop for tag in tags
	do (puthash (nth 1 tag) (cons tag (gethash (nth 1 tag) zxc-ft-tags-all)) zxc-ft-tags-all)))

(defun zxc-ft-build-query (tag)
  "构建标签查询条件,在查询中不存在时再添加，如果存在就取消"
  (if (not (member tag zxc-ft-tags-search))
      (setq zxc-ft-tags-search (cons tag zxc-ft-tags-search))
    (setq zxc-ft-tags-search (delete tag zxc-ft-tags-search)))
  (zxc-ft-widget-update)
  (goto-char (point-min)))

(defun zxc-ft-widget-update ()
  (widget-value-set zxc-ft-tag-widget "")
  (widget-value-set zxc-ft-tag-widget
		    (mapconcat #'(lambda (temp-tag)
				   (nth 2 temp-tag))
			       zxc-ft-tags-search
			       " + ")))

(defun zxc-ft-tag-choose ()
  "根据选择的按键进行标签选择,输出到input中"
  (interactive)
  (let ((short-cut (this-command-keys)))
    (if zxc-ft-is-sub-view
	(let* ((t-index (-elem-index short-cut zxc-ft-sub-tags-keys))
	       (tag (nth t-index zxc-ft-sub-tags-tmp)))
	  (if tag
	      (zxc-ft-build-query tag)
	    (message "没有对应的标签")))
      (let ((tags (gethash short-cut zxc-ft-tags-all)))
	(if tags
	    (if (= (length tags) 1)
		(zxc-ft-build-query (nth 0 tags))
	      (progn (setq zxc-ft-sub-tags-tmp tags)
		     (setq zxc-ft-is-sub-view t)
		     (zxc-ft-view-create-sub-tags zxc-ft-sub-tags-tmp)))
	  (message "没有对应的标签"))))))

(defun zxc-ft-tag-action ()
  "在zxc-ft-mode下触发时进行查询，在dired中触发时进行标签的管理"
  (interactive)
  (if (null zxc-ft-current-action)
      (zxc-ft-tag-query)
    (zxc-ft-dired-make-tags)))

(defun zxc-ft-tag-query ()
  "根据标签查询文件"
  (if zxc-ft-tags-search
      (let ((buffer-name (format "*ft result %s*" (widget-value zxc-ft-tag-widget))))
	(with-current-buffer (get-buffer-create buffer-name)
	  (zxc-ft-result-mode)
	  (let ((results (zxc-ft-query-data (list
					     (cons 'sql
						   (format
						    "select a.id,a.file_name,a.file_path,'n/a' update_time from files_ a,(select file_id from tag_file where tag_id in (%s) group by file_id having count(1) = %s )b where a.id = b.file_id"
						    (mapconcat #'(lambda (tag) (int-to-string (nth 0 tag))) zxc-ft-tags-search ",")
						    (length zxc-ft-tags-search)))
					     (cons 'limit "1000")))))
	    (setq tabulated-list-entries
		  (zxc-ft-result-2-entries results)
		  zxc-ft-tags-search nil)
	    (widget-value-set zxc-ft-tag-widget "")
	    (tabulated-list-print t)))
	(goto-char (point-max))
	(switch-to-buffer buffer-name))
    (message "请先选择标签")))

(defun zxc-ft-result-2-entries (results)
  (mapcar #'(lambda (r)
	      (list (nth 0 r) `[,(nth 1 r) ,(nth 2 r) ,(nth 3 r)]))
	  results))




(define-derived-mode zxc-ft-result-mode tabulated-list-mode "FT Result"
  "搜索结果展示模型"
  (define-key zxc-ft-result-mode-map (kbd "RET") 'zxc-ft-result-view-open)
  (setq tabulated-list-format
	`[("文件名" 85)
	  ("路径" 55 nil)
	  ("更新时间" 5 nil)
	  ])
  (setq tabulated-list-padding 3)
  (setq tabulated-list-sort-key (cons "更新时间" nil))
  (tabulated-list-init-header))

(defun zxc-ft-result-view-open ()
  "open file with current line"
  (interactive)
  (find-file (concat (aref (tabulated-list-get-entry) 1) "/" (aref (tabulated-list-get-entry) 0))))


(defun zxc-ft-create-new-tag ()
  "创建新的标签."
  (switch-to-buffer "*ft add tag*")
  (kill-all-local-variables)
  (set (make-local-variable 'short-name) nil)
  (set (make-local-variable 'tag-name) nil)
  (set (make-local-variable 'tag-pid) nil)
  (let ((inhibit-read-only t))
    (erase-buffer))
  (remove-overlays)
  (widget-create 'editable-field
		 :size 13
		 :format "短名称: %v "
		 :notify (lambda (widget &rest ignore)
			   (setf short-name (widget-value widget))))
  (widget-create 'editable-field
		 :size 13
		 :format "全名称: %v "
		 :notify (lambda (widget &rest ignore)
			   (setf tag-name (widget-value widget))))
  (widget-insert "\n")
  (apply 'widget-create
	 'menu-choice
	 :tag "选择父节点"
	 :value nil
	 :notify (lambda (widget &rest ignore)
		   (setq tag-pid (widget-value widget)))
	 '(item :tag "没有父节点" :value nil)
	 (mapcar (lambda (label) (list 'item :tag (nth 2 label) :value (nth 0 label)))
		 (zxc-ft-query-data '((sql . "select id,short_name,tag_name from tags_ where level_=0")))))
  (widget-insert "\n")
  (widget-create 'push-button
		 :notify (lambda (&rest ignore)
			   (if (and short-name tag-name)
			       (progn
				 (if (null tag-pid)
				     (zxc-ft-exec-data (format "insert into tags_ (short_name,tag_name,level_) values ('%s','%s',0) " short-name tag-name))
				   (zxc-ft-exec-data (format "insert into tags_ (short_name,tag_name,p_id,level_) values ('%s','%s',%d, 1) " short-name tag-name tag-pid)))
				 (message "标签 %s-%s 创建成功" short-name tag-name))
			     (message "短名称和全名称必须填写")))
		 "保存")
  (widget-insert " ")
  (widget-insert "\n")
  (use-local-map widget-keymap)
  (widget-setup))


;;; dired mode 扩展

(make-local-variable 'zxc-ft-dired-file-pos )

(defun zxc-ft-dired-list-tags ()
  "展现当前文件夹下所有文件的所有标签"
  (interactive)
  (save-excursion
    (remove-overlays)
    (set 'zxc-ft-dired-file-pos (make-hash-table :test 'equal))
    (let ((results (zxc-ft-query-data (list (cons 'sql (format "select b.tag_id,b.file_id,c.tag_name,a.file_name from (select id,FILE_NAME from FILES_ where FILE_PATH = '%s') a, tag_file b , tags_ c where a.id = b.file_id and c.id = b.tag_id" (substring (dired-current-directory) 0 -1)))))))
      (zxc-ft-dired-show-tags results))))

(defun zxc-ft-dired-show-tags (tag-infos)
  "tag-infos是一个二维数组，每一行包含顺序为标签ID、文件ID，标签名称、文件名称"
  (loop for tag-info in tag-infos
	do (let* ((file-name (nth 3 tag-info))
		  (pos (or (gethash file-name zxc-ft-dired-file-pos)
			   (progn
			     (goto-char (point-min))
			     (search-forward (nth 3 tag-info) nil t)))))
	     (when pos
	       (let ((ol (or (car (overlays-in pos pos)) (make-overlay pos pos))))
		 (puthash file-name pos zxc-ft-dired-file-pos)
		 (overlay-put ol 'after-string (propertize (concat (overlay-get ol 'after-string)  " " (nth 2 tag-info)) 'face 'font-lock-doc-face)))))))

(defun zxc-ft-dired-mark-tags ()
  "给当前文件夹中选中的文件加上标签"
  (interactive)
  (save-excursion
    (when (not (buffer-live-p zxc-ft-buffer))
      (zxc-ft-init)))
  (setq zxc-ft-current-action t)
  (save-excursion
    (setq  zxc-ft-tags-search (zxc-ft-query-data (list (cons 'sql (format "select a.id,a.short_name,a.tag_name from tags_ a ,(select tag_id from files_ b ,tag_file c where file_name = '%s' and file_path = '%s' and c.file_id = b.id) d where a.id = d.tag_id" (f-filename (dired-get-file-for-visit)) (substring (dired-current-directory) 0 -1))))))
    (zxc-ft-widget-update)
    (display-buffer zxc-ft-buffer)
    (switch-window)
    (goto-char (point-min))))

(defun zxc-ft-dired-make-tags ()
  "更新标签"
  (switch-window)
  (let* ((file-path (substring (dired-current-directory) 0 -1))
	 (file-name (f-filename (dired-get-file-for-visit)))
	 (file-info (zxc-ft-query-file-info file-path file-name))
	 (file-id nil))
    (if file-info
	(setf file-id (nth 0 (car file-info)))
      (progn
	(zxc-ft-exec-data (format "insert into files_ (file_name,file_path) values ('%s','%s')" file-name file-path))
	(setf file-id (nth 0 (car (zxc-ft-query-file-info file-path file-name))))))
    (zxc-ft-exec-data (format "delete from tag_file where file_id = %d" file-id))
    (mapc #'(lambda (tag)
	      (zxc-ft-exec-data (format "insert into tag_file (tag_id,file_id) values (%d,%d)" (nth 0 tag) file-id)))
	  zxc-ft-tags-search)
    (delete-window (get-buffer-window zxc-ft-buffer))
    (setq zxc-ft-current-action nil))
  (zxc-ft-dired-list-tags))

(defun zxc-ft-query-file-info (file-path file-name)
  (zxc-ft-query-data (list (cons 'sql (format "select id,file_name,file_path from files_ where file_path = '%s' and file_name = '%s'" file-path  file-name)))))

(defun zxc-ft-dired-revert-buffer ()
  "清除标签，刷新buffer"
  (interactive)
  (remove-overlays)
  (revert-buffer))

(add-hook 'dired-mode-hook #'(lambda ()
			       (define-key dired-mode-map (kbd "b") 'zxc-ft-dired-list-tags)
			       (define-key dired-mode-map (kbd "g") 'zxc-ft-dired-revert-buffer)
			       (define-key dired-mode-map (kbd "e") 'zxc-ft-dired-mark-tags)))

(provide 'zxc-ft)
