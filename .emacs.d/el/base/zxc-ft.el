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
;;    file_path varchar(2048)
;; );

;; create table tag_file (
;;      tags_id int ,
;;      files_id int
;; );

;; create index tag_file_tag_id on tag_file (tags_id);
;; create index tag_file_file_id on tag_file (files_id);


(defvar zxc-ft-buffer nil
  "The buffer displaying the file tags.")

(defvar zxc-ft-url "http://localhost:9990/service/rest/data/query/tag"
  "查询后台服务地址")

(defvar zxc-ft-tag-widget nil "标签选择展现的input")

(defvar zxc-ft-action-keys
  (list "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"
	"a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
	"A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z")
  "标签的触发键")

(defvar zxc-ft-tags-all (make-hash-table :test 'equal) "所有的标签,为map格式,key为shortName,value为集合")

(defvar zxc-ft-tags-search nil "查询的标签")

(defvar zxc-ft-begin-point nil "标签拼接起始点")

(defvar zxc-ft-sub-tags-keys
  (nconc (list "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")
	 (loop for i from 0 to 9 collect i))
  "当一个shortName对应多个标签时,按照自然顺序重新排序定义快捷键")

(defvar zxc-ft-is-sub-view nil "是否是子标签视图")

(defvar zxc-ft-sub-tags-tmp nil "临时子标签集合")

(defface zxc-ft-action-face-foreground
  '((((class color)) (:foreground "red"))
    (((background dark)) (:foreground "gray100"))
    (((background light)) (:foreground "gray0"))
    (t (:foreground "gray100")))
  "触发按键的颜色")

(defun zxc-ft ()
  "启动文件标签系统"
  (interactive)
  (if (not (buffer-live-p zxc-ft-buffer))
      (save-excursion
	(setq zxc-ft-buffer (get-buffer-create "*ft*"))))
  (set-buffer zxc-ft-buffer)
  (zxc-ft-mode))

(defvar zxc-ft-init-p nil)

(define-derived-mode zxc-ft-mode fundamental-mode "FT"
  "用标签重新组织文件"
  (switch-to-buffer zxc-ft-buffer)
  (zxc-ft-init)
  (page-break-lines-mode)
  (mapc #'(lambda (key)
	    (zxc-mode-action-str zxc-ft-mode-map key 'zxc-ft-tag-choose)) zxc-ft-action-keys)
  (define-key zxc-ft-mode-map (kbd "ESC") 'zxc-ft-reset-main-view))

(defun zxc-ft-init ()
  "初始化展现"
  (clrhash zxc-ft-tags-all)
  (setq zxc-ft-tags-search nil)
  (setq zxc-ft-is-sub-view nil)
  (zxc-ft-main-view))

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
      (setq zxc-ft-begin-point (point))
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
    (delete-region zxc-ft-begin-point (point-max))
    (goto-char (point-max))
    (loop for i from 0 to (- (length tags) 1)
	  do (progn
	       (when (and (= (% i 8) 0) (/= i 0))
		 (insert "\n"))
	       (insert "[" (zxc-get-action-key (nth i zxc-ft-sub-tags-keys)) "]" (nth 2 (nth i tags)) "\t")))
    (align-regexp zxc-ft-begin-point (point) "\\(\\s-*\\)\\s-" 1 1 t)))

(defun zxc-ft-reset-main-view ()
  "返回展现所有标签的主视图"
  (interactive)
  (when zxc-ft-is-sub-view
    (let ((inhibit-read-only t))
      (delete-region zxc-ft-begin-point (point-max))
      (clrhash zxc-ft-tags-all)
      (goto-char (point-max))
      (zxc-ft-view-create-all-tags (zxc-ft-get-top-tags))
      (setq zxc-ft-sub-tags-tmp nil)
      (setq zxc-ft-is-sub-view nil))))

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
  (getf (http-post zxc-ft-url
		   param)
	:data))

(defun zxc-get-action-key (key-str)
  "获取带有颜色的action字符串"
  (propertize key-str 'face 'zxc-template-face-foreground))

(defun zxc-ft-add-tags (tags)
  "将标签按照shortname和集合的方式存放到map中"
  (loop for tag in tags
	do (puthash (nth 1 tag) (cons tag (gethash (nth 1 tag) zxc-ft-tags-all)) zxc-ft-tags-all)))

(defun zxc-ft-build-query (tag)
  "构建标签查询条件,在查询中不存在时再添加"
  (if (not (member tag zxc-ft-tags-search))
      (progn (setq zxc-ft-tags-search (cons tag zxc-ft-tags-search))
	     (widget-value-set zxc-ft-tag-widget
			       (mapconcat '(lambda (temp-tag)
					     (nth 2 temp-tag))
					  zxc-ft-tags-search
					  " + "))
	     (goto-line 1))
    (message "已经选择了 %s" (nth 2 tag))))

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
