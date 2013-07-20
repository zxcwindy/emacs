;;; zxc-http.el --- HTTP client using the url library

;; Author: zhengxc
;; Email: david.c.aq@gmail.com
;; Keywords: comet

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

(defvar comet-id 0)
(defvar comet-client-id nil)
(defvar comet-url "http://localhost:8080/cometd-java-examples/cometd/")

(defvar comet-timer nil)

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
	:advice (list :timeout 0)))

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

(defun comet-send (url object &optional charset)
  "Send object to URL as an HTTP POST request, returning the response
and response headers.
object is an json, eg {key:value} they are encoded using CHARSET,
which defaults to 'utf-8"
  (let ((url-show-status nil))
    (http-post-simple-internal
     url
     (json-encode object)
     charset
     `(("Content-Type"
	.
	,(http-post-content-type
	  "application/json"
	  (or charset 'utf-8)))))))

(defun comet-convert-response (url object)
  "comet post and convert response to lisp"
  (http-json-2-lisp (comet-send url object)))

(defun comet-handshake ()
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
  (let ((comet-handshake-response (car (comet-convert-response comet-url
							       (comet-handshake-request)))))
    (if (equal (getf comet-handshake-response :successful) t)
	(progn
	  (setf comet-client-id (getf comet-handshake-response :clientId))
	  (when comet-timer
	    (cancel-timer comet-timer))
	  (setf comet-timer (run-at-time t 1 'comet-connect)))
      (error (getf comet-handshake-response :error)))))

(defun comet-subscribe (channel)
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
  (let ((comet-subscribe-response (car (comet-convert-response comet-url
							       (comet-subscribe-request channel)))))
    (if (equal (getf comet-subscribe-response :successful) t)
	(message "successful")
      (error (getf comet-subscribe-response :error)))))

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
  (let ((comet-connect-response (comet-convert-response comet-url
							(comet-connect-request))))
    ;; (if (equal (getf (car comet-connect-response) :successful) t)
    ;; 	(with-output-to-temp-buffer "*response*"
    ;; 	  (prin1 comet-connect-response))
    ;;   (error (getf comet-connect-response :error)))
    (when (equal (getf (car comet-connect-response) :channel) "/chat/demo")
      (with-output-to-temp-buffer "*response*"
	(prin1 (getf (getf (car comet-connect-response) :data) :chat))))))

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
  (let ((comet-publish-response (comet-convert-response comet-url
							(comet-publish-request channel data))))
    ;; (if (equal (getf comet-publish-response :successful) t)
    ;; 	(message "successful")
    ;;   (error (getf comet-publish-response :error)))
    (set-frame-parameter (selected-frame) 'alpha '(10 100))
    (run-with-timer 3 nil 'set-frame-parameter (selected-frame) 'alpha '(100 100))
    comet-publish-response))

(defun comet-disconnect ()
  (let ((comet-disconnect-response (car (comet-convert-response comet-url
								(comet-disconnect-request)))))
    (if (equal (getf comet-disconnect-response :successful) t)
	(progn
	  (setf comet-client-id (getf comet-disconnect-response :clientId))
	  (cancel-timer comet-timer))
      (error (getf comet-disconnect-response :error)))))

(provide 'zxc-comet)
