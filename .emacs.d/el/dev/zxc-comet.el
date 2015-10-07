;;; zxc-http.el --- HTTP client using the url library

;; Author: zhengxc
;; Email: david.c.aq@gmail.com
;; Keywords: comet long-polling

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as1
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.

;; You should have received a copy of the GNU General Public
;; License along with this program; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA

(require 'zxc-http)
(require 'deferred)

(defconst comet-path "cometd")
(defvar comet-id 0)
(defvar comet-client-id nil)
(defvar comet-url "http://localhost:8080/service/cometd/")
(defvar comet-current-channel nil )
(defvar comet-is-connected nil)
(defvar comet-channel-prefix "/developMode")

(defvar comet-timer nil)

(defun comet-set-url (url)
  "Splicing URL with \"/\" "
  (interactive "s输入网站的contextPath：")
  (if (s-ends-with? "/" url)
      (setf comet-url (concatenate 'string url comet-path))
    (setf comet-url (concat-string-by-backslash url comet-path)))
  (comet-send comet-url (comet-handshake-request) #'comet-handshake-send))

(defun comet-next-id (&optional is-init)
  (when is-init
    (setf comet-id 0))
  (setf comet-id (+ 1 comet-id))
  (int-to-string comet-id))

(defun comet-handshake-request ()
  (list :channel "/meta/handshake"
	:version "1.0"
	:minimumVersion "1.0beta"
	:supportedConnectionTypes ["long-polling"]
	:id (comet-next-id t)
	:advice (list :timeout 60000 :interval 0)))

(defun comet-connect-request ()
  (list :channel "/meta/connect"
	:clientId comet-client-id
	:connectionType "long-polling"
	:id (comet-next-id)
	;; :advice (list :timeout 30000)
	))

(defun comet-disconnect-request ()
  (list
   :channel "/meta/disconnect"
   :clientId comet-client-id
   :id (comet-next-id)))

(defun comet-subscribe-request (channel)
  (list
   :channel "/meta/subscribe"
   :clientId comet-client-id
   :subscription channel
   :id (comet-next-id)))

(defun comet-unsubscribe-request (channel)
  (list
   :channel "/meta/unsubscribe"
   :clientId comet-client-id
   :subscription channel
   :id (comet-next-id)))

(defun comet-publish-request (channel data)
  (list
   :channel channel
   :clientId comet-client-id
   :data data
   :id (comet-next-id)))

(defun comet-send (url object &optional comet-callback)
  "Send object to URL as an HTTP POST request, returning the response
and response headers.
object is an json, eg {key:value} they are encoded using CHARSET,
which defaults to 'utf-8"
  (lexical-let ((comet-callback comet-callback))
    (deferred:$
      (deferred:url-post-json url object)
      (deferred:nextc it
	(lambda (buf)
	  (let ((data (with-current-buffer buf (buffer-string)))
		(json-object-type 'plist)
		(json-array-type 'list)
		(json-false nil))
	    (kill-buffer buf)
	    (json-read-from-string data))))
      (deferred:nextc it
	(lambda (response)
	  (funcall comet-callback response))))))

(defun comet-handshake-send (response)
  "An example successful handshake response is:
`[
 {
 'channel': '/meta/handshake',
 'version': '1.0',
 'minimumVersion': '1.0beta',
 'supportedConnectionTypes': ['long-polling','callback-polling'],
 'clientId': 'Un1q31d3nt1f13r',
 'successful': true,
 'authSuccessful': true,
 'advice': { 'reconnect': 'retry' }
 }
 ]

An example unsuccessful handshake response is:

`[
 {
 'channel': '/meta/handshake',
 'version': '1.0',
 'minimumVersion': '1.0beta',
 'supportedConnectionTypes': ['long-polling','callback-polling'],
 'successful': false,
 'error': 'Authentication failed',
 'advice': { 'reconnect': 'none' }
 }
]
"
  (let ((comet-handshake-response (car response)))
    (if (equal (getf comet-handshake-response :successful) t)
	(progn
	  (setf comet-is-connected t)
	  (setf comet-client-id (getf comet-handshake-response :clientId))
	  (comet-connect))
      (error (getf comet-handshake-response :error)))))

(defun comet-subscribe (channel)
  (interactive "s输入页面url地址：")
  (let ((new-channel (concatenate 'string comet-channel-prefix channel)))
    (setf comet-current-channel new-channel)
    (comet-send comet-url (comet-subscribe-request new-channel) #'comet-subscribe-send)))

(defun comet-subscribe-send (response)
  "An example successful subscribe response is:

`[
  {
     'channel': '/meta/subscribe',
     'clientId': 'Un1q31d3nt1f13r',
     'subscription': '/foo/**',
     'successful': true,
     'error': ''
   }
]

An example failed subscribe response is:

`[
  {
     'channel': '/meta/subscribe',
     'clientId': 'Un1q31d3nt1f13r',
     'subscription': '/bar/baz',
     'successful': false,
     'error': '403:/bar/baz:Permission Denied'
   }
]
"
  (let ((comet-subscribe-response (car response)))
    (if (equal (getf comet-subscribe-response :successful) t)
	(message "successful")
      (error (getf comet-subscribe-response :error)))))

(defun comet-unsubscribe (channel)
  (let ((comet-unsubscribe-response (car (comet-convert-response comet-url
								 (comet-unsubscribe-request channel)))))
    (if (equal (getf comet-unsubscribe-response :successful) t)
	(message "successful")
      (error (getf comet-unsubscribe-response :error)))))

(defun comet-connect ()
  "An example connect response is:

`[
  {
     'channel': '/meta/connect',
     'successful': true,
     'error': '',
     'clientId': 'Un1q31d3nt1f13r',
     'timestamp': '12:00:00 1970',
     'advice': { 'reconnect': 'retry' }
   }
]
"
  (comet-send comet-url (comet-connect-request)
	      #'(lambda (comet-connect-response)
		  (when (equal (getf (car comet-connect-response) :channel) comet-current-channel)
		    (with-output-to-temp-buffer "*response*"
		      (princ (getf (getf (car comet-connect-response) :data) :message))))
		  (when comet-is-connected
		    (comet-connect)))))

(defun comet-publish (channel data)
  "An example event reponse message is:

`[
  {
     'channel': '/some/channel',
     'successful': true,
     'id': 'some unique message id'
  }
]
"
  (let ((publish-channel (or channel comet-current-channel)))
    (comet-send comet-url (comet-publish-request publish-channel data)
		#'(lambda (comet-publish-response)
		    (set-frame-parameter (selected-frame) 'alpha '(60 100))
		    (run-with-timer 2 nil 'set-frame-parameter (selected-frame) 'alpha '(100 100))
		    (minibuffer-message comet-publish-response)))))

(defun comet-publish-region (start end)
  "publish a region to the channel."
  (interactive "r")
  (comet-publish nil (list :message (buffer-substring-no-properties start end))))


(defun comet-publish-paragraph ()
  "publish the current paragraph to the channel"
  (interactive)
  (let ((start (save-excursion
		 (backward-paragraph)
		 (point)))
	(end (save-excursion
	       (forward-paragraph)
	       (point))))
    (comet-publish-region start end)))

(defun comet-publish-html (func)
  (interactive "s输入方法：")
  (comet-publish nil (list :message (concat func "(\" " (buffer-substring-no-properties (region-beginning) (region-end)) " \")"))))

(defun comet-disconnect ()
  (setf comet-client-id nil)
  (when comet-is-connected
    (comet-send comet-url (comet-disconnect-request)
		#'(lambda (response)
		    (let ((comet-disconnect-response (car response)))
		      (if (equal (getf comet-disconnect-response :successful) t)
			  (error (getf comet-disconnect-response :error)))))))
  (setf comet-is-connected nil))

(defun deferred:url-post-json (url &optional params)
  "Perform a HTTP POST method with `url-retrieve'. PARAMS is
a parameter list of (key . value) or key. The next deferred
object receives the buffer object that URL will load into."
  (lexical-let ((nd (deferred:new))
		(url url) (params params)
		buf)
    (deferred:next
      (lambda (x)
	(let ((url-request-method "POST")
	      (url-request-extra-headers
	       '(("Content-Type" . "application/json;charset=utf-8")))
	      (url-request-data
	       (json-encode params)))
	  (condition-case err
	      (setq buf
		    (url-retrieve
		     url
		     (lambda (&rest args)
		       (deferred:post-task nd 'ok buf))))
	    (error (deferred:post-task nd 'ng err))))
	nil))
    (setf (deferred-cancel nd)
	  (lambda (x)
	    (when (buffer-live-p buf)
	      (kill-buffer buf))))
    (let ((d (deferred:nextc nd 'deferred:url-delete-header)))
      (deferred:set-next
	d (deferred:new 'deferred:url-delete-buffer))
      d)))

(provide 'zxc-comet)
