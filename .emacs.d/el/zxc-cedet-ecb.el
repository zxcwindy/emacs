;;; zxc-cedet-ecb.el --- HTTP client using the url library

;; Author: zhengxc
;; Email: david.c.aq@gmail.com
;; Keywords: emacs cedet ecb

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


(require 'ecb)
;; (semantic-load-enable-minimum-features)
;; (semantic-load-enable-code-helpers)
;;(semantic-load-enable-gaudy-code-helpers)
(setf ecb-tip-of-the-day nil)
(global-set-key [f9] 'ecb-minor-mode)
(provide 'zxc-cedet-ecb)
