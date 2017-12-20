(defun zxc-crypto-encrypt (uri object)
  "Send object to URL as an HTTP POST request, returning the response
and response headers.
object is an json, eg {key:value} they are encoded using CHARSET,
which defaults to 'utf-8"
  (deferred:$
    (deferred:url-post-json (format "%s/service/rest/crypto/encrypt" zxc-db-host) object)
    (deferred:nextc it
      (lambda (buf)
	(let ((data (with-current-buffer buf (buffer-string)))
	      (json-object-type 'plist)
	      (json-array-type 'list)
	      (json-false nil))
	  (kill-buffer buf)
	  (message (decode-coding-string data 'utf-8)))))))

(provide 'zxc-crypto)
