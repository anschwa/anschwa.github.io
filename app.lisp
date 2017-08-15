#!/bin/sh
#|-*- mode:lisp -*-|#
#|
exec ros -Q -- $0 "$@"
|#

;;; My personal website in common lisp
;;; Powered by ningle: https://github.com/fukamachi/ningle
;;; Adam Schwartz 2017-07-10

(ql:quickload :clack)
(ql:quickload :ningle)
(ql:quickload :cl-ppcre)
(ql:quickload :inferior-shell)

(import 'lack.builder:builder)

(load "utils.lisp")
(load "templates/about.lisp")
(load "templates/projects.lisp")
(load "templates/blog.lisp")

(defparameter *app* (make-instance 'ningle:<app>))
(defparameter *clack-server* nil)

(defparameter *static-directory*
  (merge-pathnames #P"static/" *default-pathname-defaults*))

(setf *books-url* "https://raw.githubusercontent.com/anschwa/books/master/readme.org")
(setf *books-file* "books.txt")
(setf *projects-url* "https://api.github.com/users/anschwa/repos")
(setf *projects-file* "projects.json")
(get-latest-content) ; run to update books and projects if needed

;; Define Routes
(setf (ningle:route *app* "/")
      (let ((books (get-current-book *books-file*)))
        (render-about books)))

(setf (ningle:route *app* "/projects/") ; use '*' to match /projects
                                        ; and /projects/
      (let ((projects (get-projects-as-html *projects-file*)))
        (render-projects projects)))

(setf (ningle:route *app* "/blog/")
      (let ((posts ()))
        (render-blog posts)))

(setf (ningle:route *app* "/blog/archive/")
      "archive")

(setf (ningle:route *app* "/blog/*/*/*")
      #'(lambda (params)
          ;; matches /blog/2017/01/my-first-post.html
          (let ((url (cdr (assoc :splat params))))
            (format nil "year: ~A month: ~A title: ~A"
                    (first url) (second url) (third url)))))

;; Launch App
(defun start-server ()
  (setf *clack-server*
        (clack:clackup
         (builder
          (:static
           :path (lambda (path)
                   (if (ppcre:scan "\\.css$|\\.jpg$|\\.js$" path)
                       path   ; only host the static files we want
                       nil))  ; otherwise we get a 'Not Found' for all pages
           :root *static-directory*)
          *app*))))

(defun stop-server ()
  (clack:stop *clack-server*))

(defun main (&optional option)
  "apparently roswell kills the lisp process after executing, so we
need to run the manage.sh script from here"
  (cond ((string-equal option "build")
         (progn
           (start-server)
           (inferior-shell:run/s '(./manage.sh build))
           (stop-server)))
        ((string-equal option "deploy")
         (inferior-shell:run/s '(./manage.sh deploy)))))
