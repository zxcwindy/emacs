(require 'json)
(require 'cl-lib)
(require 'url)


(defun zxc-aimodel-deepseek-fetch (prompt)
  (let* ((url-request-method "POST")
	 (url-request-extra-headers
	  '(("Accept-Language" . "zh-CN,zh;q=0.9")
	    ("Connection" . "keep-alive")
	    ("Cookie" . "route=e93784f35248272d8ad6e514725fd7a4|6f8463e6e0fc28568ed5f94061f80538; Hm_lvt_fb5acee01d9182aabb2b61eb816d24ff=1702283883; HWWAFSESID=69b89822ddeef899e9; HWWAFSESTIME=1704766772278; Hm_lvt_1fff341d7a963a4043e858ef0e19a17c=1704245953,1704365082,1704419679,1704766774; Hm_lpvt_1fff341d7a963a4043e858ef0e19a17c=1704766774")
	    ("Origin" . "https://chat.deepseek.com")
	    ("Referer" . "https://chat.deepseek.com/coder")
	    ("Sec-Fetch-Dest" . "empty")
	    ("Sec-Fetch-Mode" . "cors")
	    ("Sec-Fetch-Site" . "same-origin")
	    ("User-Agent" . "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
	    ("accept" . "*/*")
	    ("authorization" . "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiZjhhZDc5MGUtYWEyMS00YzQ4LWFkYTUtMWI4ZTdlMmZmYjM1IiwiZW1haWwiOiIiLCJtb2JpbGVfbnVtYmVyIjoiMTM2NjgyOTI2MjgiLCJhcmVhX2NvZGUiOiIrODYiLCJtb2JpbGUiOiIxMzY2ODI5MjYyOCIsImV4cCI6MTcwNTQwMDM3MywiYXVkIjoiNjUyOGFkMzk2ZmFhMTM2N2ZlZTZkMTZjIn0.hnl0mu-9RErmZSB_cSaNXZBHrNMLqqK8WoG_guw1plM")
	    ("content-type" . "application/json")
	    ("sec-ch-ua" . "\"Not_A Brand\";v=\"8\", \"Chromium\";v=\"120\", \"Google Chrome\";v=\"120\"")
	    ("sec-ch-ua-mobile" . "?0")
	    ("sec-ch-ua-platform" . "\"Linux\"")
	    ("x-app-version" . "20231201.0")))
	 (url-request-data
	  (encode-coding-string
	   (json-encode `((stream . true) (message . ,prompt) (model_preference . nil) (model_class . deepseek_code) (temperature . 0)))
	   'utf-8)))
    (with-current-buffer (url-retrieve-synchronously "https://chat.deepseek.com/api/v0/chat/completions")
      (goto-char url-http-end-of-headers)
      (decode-coding-string
       (buffer-substring-no-properties
	(point)
	(point-max))
       'utf-8))))

(defun zxc-aimodel-deepseek-process-result (lst)
  (when lst
    (let* ((json-object (json-read-from-string (substring (car lst) 6)))
	   (choices (cdr (assoc 'choices json-object))))
      (when choices
	(cl-loop for choice across choices
		 do (let* ((delta (cdr (assoc 'delta choice)))
			   (content (cdr (assoc 'content delta))))
		      (when content
			(insert content))))))
    (zxc-aimodel-deepseek-process-result (cdr lst))))


(defun zxc-aimodel-deepseek-prompt (prompt)
  (insert "\n")
  (zxc-aimodel-deepseek-process-result
   (cl-remove-if #'(lambda (str) (string= str ""))
		 (split-string (zxc-aimodel-deepseek-fetch prompt) "\n"))))

(defun zxc-aimodel-deepseek-prompt-line ()
  "Prompt with current word."
  (interactive)
  (deferred:$
    (deferred:next
      (lambda ()
	(zxc-aimodel-deepseek-prompt (thing-at-point 'line))))))


(global-set-key (kbd "C-; a i p") 'zxc-aimodel-deepseek-prompt-line)

(provide 'zxc-aimodel)
