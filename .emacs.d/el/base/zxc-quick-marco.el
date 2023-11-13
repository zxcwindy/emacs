(defalias 'a91 #'(lambda ()
		   (interactive)
		   (find-file "~/download"))
  "跳转到download")

(defalias 'a92 #'(lambda ()
		   (interactive)
		   (find-file "/home/david/work/bmsoft/bangong/周报/研发周报.org"))
  "跳转到周报")

(defalias 'a93 #'(lambda ()
		   (interactive)
		   (find-file "~/tmp"))
  "跳转到tmp")

(defalias 'a94 #'(lambda ()
		   (interactive)
		   (find-file "~/workspace/4.0/framework/"))
  "跳转到framework")

(defalias 'a95 #'(lambda ()
		   (interactive)
		   (find-file "~/workspace/4.0/frontpage"))
  "跳转到front")

(defalias 'a96 #'(lambda ()
		   (interactive)
		   (find-file "~/zxc/SJZC/交通"))
  "跳转到SJZC")

(defalias 'a97 #'(lambda ()
		   (interactive)
		   (find-file "/home/david/opt/data/2022工作交接/"))
  "跳转到2022工作交接")

(defalias 'a98 #'(lambda ()
		   (interactive)
		   (find-file "/home/david/opt/openresty-1.11.2.3/nginx/conf/nginx.conf"))
  "跳转到nginx配置")

(defalias 'a99 #'(lambda ()
		   (interactive)
		   (find-file "/home/david/Documents/WeChat Files/zhxch_1984/FileStorage/MsgAttach/"))
  "跳转到微信文件配置")


(provide 'zxc-quick-marco)
