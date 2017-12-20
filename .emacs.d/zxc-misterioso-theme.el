;; misterioso-theme.el --- my util tools collection

;; Author: zhengxc <david.c.aq@gmail.com>
;; Keywords: theme

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

(deftheme zxc-misterioso
  "Created 2013-12-01.")

(custom-theme-set-variables
 'zxc-misterioso
 '(ansi-color-names-vector ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"]))

(custom-theme-set-faces
 'zxc-misterioso
 '(cursor ((t (:background "white"))))
 '(fringe ((((class color) (min-colors 89)) (:background "#2e3748"))))
 '(highlight ((t (:background "blue" :foreground "#e1e1e0"))))
 '(region ((t (:background "blue" :foreground "#e1e1e0"))))
 '(isearch ((((class color) (min-colors 89)) (:background "#fcffad" :foreground "#000000"))))
 '(lazy-highlight ((((class color) (min-colors 89)) (:background "#338f86"))))
 '(trailing-whitespace ((((class color) (min-colors 89)) (:background "#ff4242"))))
 '(mode-line ((((class color) (min-colors 89)) (:background "#212931" :foreground "#eeeeec"))))
 '(mode-line-inactive ((((class color) (min-colors 89)) (:background "#878787" :foreground "#eeeeec"))))
 '(header-line ((((class color) (min-colors 89)) (:background "#e5e5e5" :foreground "#333333"))))
 '(minibuffer-prompt ((((class color) (min-colors 89)) (:foreground "#729fcf" :weight bold))))
 '(font-lock-builtin-face ((((class color) (min-colors 89)) (:foreground "#23d7d7"))))
 '(font-lock-comment-face ((t (:foreground "chartreuse2"))))
 '(font-lock-constant-face ((t (:foreground "OliveDrab1"))))
 '(font-lock-function-name-face ((((class color) (min-colors 89)) (:foreground "#00ede1" :weight bold))))
 '(font-lock-keyword-face ((((class color) (min-colors 89)) (:foreground "#ffad29" :weight bold))))
 '(font-lock-string-face ((t (:foreground "spring green"))))
 '(font-lock-type-face ((((class color) (min-colors 89)) (:foreground "#34cae2"))))
 '(font-lock-variable-name-face ((((class color) (min-colors 89)) (:foreground "#dbdb95"))))
 '(font-lock-warning-face ((((class color) (min-colors 89)) (:foreground "#ff4242" :weight bold))))
 '(button ((((class color) (min-colors 89)) (:underline t))))
 '(link ((((class color) (min-colors 89)) (:foreground "#59e9ff" :underline t))))
 '(link-visited ((((class color) (min-colors 89)) (:foreground "#ed74cd" :underline t))))
 '(gnus-group-news-1 ((((class color) (min-colors 89)) (:foreground "#ff4242" :weight bold))))
 '(gnus-group-news-1-low ((((class color) (min-colors 89)) (:foreground "#ff4242"))))
 '(gnus-group-news-2 ((((class color) (min-colors 89)) (:foreground "#00ede1" :weight bold))))
 '(gnus-group-news-2-low ((((class color) (min-colors 89)) (:foreground "#00ede1"))))
 '(gnus-group-news-3 ((((class color) (min-colors 89)) (:foreground "#23d7d7" :weight bold))))
 '(gnus-group-news-3-low ((((class color) (min-colors 89)) (:foreground "#23d7d7"))))
 '(gnus-group-news-4 ((((class color) (min-colors 89)) (:foreground "#74af68" :weight bold))))
 '(gnus-group-news-4-low ((((class color) (min-colors 89)) (:foreground "#74af68"))))
 '(gnus-group-news-5 ((((class color) (min-colors 89)) (:foreground "#dbdb95" :weight bold))))
 '(gnus-group-news-5-low ((((class color) (min-colors 89)) (:foreground "#dbdb95"))))
 '(gnus-group-news-low ((((class color) (min-colors 89)) (:foreground "#008b8b"))))
 '(gnus-group-mail-1 ((((class color) (min-colors 89)) (:foreground "#ff4242" :weight bold))))
 '(gnus-group-mail-1-low ((((class color) (min-colors 89)) (:foreground "#ff4242"))))
 '(gnus-group-mail-2 ((((class color) (min-colors 89)) (:foreground "#00ede1" :weight bold))))
 '(gnus-group-mail-2-low ((((class color) (min-colors 89)) (:foreground "#00ede1"))))
 '(gnus-group-mail-3 ((((class color) (min-colors 89)) (:foreground "#23d7d7" :weight bold))))
 '(gnus-group-mail-3-low ((((class color) (min-colors 89)) (:foreground "#23d7d7"))))
 '(gnus-group-mail-low ((((class color) (min-colors 89)) (:foreground "#008b8b"))))
 '(gnus-header-content ((((class color) (min-colors 89)) (:weight normal :foreground "#ffad29"))))
 '(gnus-header-from ((((class color) (min-colors 89)) (:foreground "#e67128" :weight bold))))
 '(gnus-header-subject ((((class color) (min-colors 89)) (:foreground "#dbdb95"))))
 '(gnus-header-name ((((class color) (min-colors 89)) (:foreground "#00ede1"))))
 '(gnus-header-newsgroups ((((class color) (min-colors 89)) (:foreground "#e67128"))))
 '(message-header-name ((((class color) (min-colors 89)) (:foreground "#ffad29" :weight bold))))
 '(message-header-cc ((((class color) (min-colors 89)) (:foreground "#e67128"))))
 '(message-header-other ((((class color) (min-colors 89)) (:foreground "#e67128"))))
 '(message-header-subject ((((class color) (min-colors 89)) (:foreground "#dbdb95"))))
 '(message-header-to ((((class color) (min-colors 89)) (:foreground "#00ede1"))))
 '(message-cited-text ((((class color) (min-colors 89)) (:foreground "#74af68"))))
 '(message-separator ((((class color) (min-colors 89)) (:foreground "#23d7d7"))))
 '(cypher-pattern-face ((t (:foreground "dark goldenrod" :bold t))))
 '(cypher-variable-face ((t (:foreground "pink4"))))
 '(default ((((class color) (min-colors 4096)) (:background "#2d3743" :foreground "#e1e1e0")) (((class color) (min-colors 89)) (:background "#3a3a3a" :foreground "#e1e1e0")))))

(provide-theme 'zxc-misterioso)
