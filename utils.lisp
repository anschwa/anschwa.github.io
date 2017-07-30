;; web development with common lisp
;;
;; Utilities:
;; Display current book: (get-current-book *books-file*)
;; Display favorite projects: (get-projects-as-html (load-projects *projects-file*))

(ql:quickload :drakma)
(ql:quickload :cl-who)
(ql:quickload :yason)
(setf (cl-who:html-mode) :html5)

;; define global vars
(defvar *books-url*)
(defvar *projects-url*)
(defvar *books-file*)
(defvar *projects-file*)

;; cl-who mini example
(cl-who:with-html-output-to-string
    (htm nil :indent nil)
  (:cite "hello,"))

(defun fetch-page (url file)
  "fetch the contents of a webpage and write it to a file if it
doesn't already exist"
  (let ((page-str (drakma:http-request url :want-stream t)))
    (setf (flexi-streams:flexi-stream-external-format page-str) :utf-8)
    (with-open-file (file-str file
                              :direction :output
                              :if-exists nil)
      (loop
         for line = (read-line page-str nil)
         while line do (format file-str "~a~%" line )))))

(defun get-latest-content ()
  "downloads the latest project and book list from github"
  (progn
    (fetch-page *books-url* *books-file*)
    (fetch-page *projects-url* *projects-file*)))

(defun current-books (book-file)
  "grab the books I'm currently reading"
  (let* ((okayp nil)
         (books '()))
    (with-open-file (str book-file)
      (loop
         for line = (read-line str nil 'eof)
         until (eq line 'eof)
         do (cond
              ((string-equal line "* Books I am currently reading")
               (setf okayp t))
              ((string-equal line "* Books I plan to read")
               (setf okayp nil))
              ((eq okayp t)
               (push line books)))))
    (nreverse books)))


;; only parse the first book into html

(defun get-current-book (books-file)
  "format the book I'm currently reading as html"
  (let* ((books (current-books books-file))
         (parsed-books '()))
    (loop
       for i from 1 to 2
       do (let ((line (pop books)))
            (unless (= (length line) 0)
              (cond
                ((eq #\. (char line 1))
                 (push
                  (concatenate 'string "<cite>" (subseq line 3) ",</cite> by ")
                  parsed-books))
                ((eq #\- (char line 3))
                 (push (subseq line 5) parsed-books))))))
    ;; ~{ ~} iterates over a list to join strings
    (format nil "~{~A~}" (nreverse parsed-books))))


;; (get-current-book *books-file*)

(defparameter *wanted* '("ma42"
                         "typing-test"
                         "emacs.d"
                         "dotfiles"
                         "books"
                         "anschwa.github.io"
                         "dupy"
                         "helm-itunes"
                         "current-song"
                         "jchat"
                         "stiltdb"
                         "pycryption"
                         "nbimporter"
                         "savetheyak"))

(defparameter *info* '(:html_url
                       :name
                       :description
                       :updated_at
                       :created_at
                       :language
                       :stargazers_count))

(defun make-keyword (name)
  "turn a string into a keyword"
  (values (intern (string-upcase name) "KEYWORD")))

(defun get-stars (plist)
  "helper function for sorting projects by stars"
  (getf plist :stargazers_count))

(defun load-projects (file)
  "parse the json project file into a property list sorted by stars"
  (with-open-file (str file)
    (let ((plist (yason:parse str :object-as :plist :object-key-fn #'make-keyword)))
      (sort plist #'> :key #'get-stars))))

(defun plist-to-html (project)
  (cl-who:with-html-output-to-string
      (htm nil :indent nil)
    (:h2 (:a :href (getf project :html_url) (cl-who:str (getf project :name))))
    (:p (cl-who:str (getf project :description)))
    (:ul
     (:li :class "project-date" "Updated: " (cl-who:str (subseq (getf project :updated_at) 0 10)))
     (:li :class "project-date" "Created: " (cl-who:str (subseq (getf project :created_at) 0 10)))
     (:li "Language: " (cl-who:str (getf project :language)))
     (:li "Stars: " (cl-who:str (getf project :stargazers_count))))))

(defun get-projects-as-html (project-file)
  "return a list of all my ns as html"
  (let ((project-plist (load-projects project-file))
        (html-projects '()))
    (loop
       for project in project-plist do
       ;; only convert the repositories we wants
         (loop
            for (key val) on project by #'cddr
            when (and (string-equal key "name")
                      (member val *wanted* :test #'string-equal))
            do
              (push
               (plist-to-html project)
               html-projects)))
    (format nil "~{~A~}" (nreverse html-projects))))

;; (print (car (get-projects-as-html (load-projects *projects-file*))))

