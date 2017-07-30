;; About Page

(defun render-about (books)
  "renders the about page as an html string"
  (cl-who:with-html-output-to-string (htm nil :prologue t :indent nil)
    (:html
     :lang "en"
     (:head
      (:meta :charset "UTF-8")
      (:title "Adam Schwartz")
      (:link :href "style.css" :rel "stylesheet"))
     (:body
      (:header
       :class "masthead"
       (:a :class "logo" :href "http://anschwa.com" "Adam Schwartz")
       (:nav :class "menu"
             (:ul (:li (:a :href "/blog/" "Blog"))
                  (:li (:a :href "/projects/" "Projects"))
                  (:li (:a :href "https://github.com/anschwa" "GitHub")))))
      (:section
       :class "content"
       (:h1 "About")
       (:p :class "gravatar" (:img :class "gravatar" :src "me.jpg"))
       (:p "Hi, I'm a Computer Science major at "
           (:a :href "https://earlham.edu" "Earlham College")
           " and have a passion for programming languages, web development, privacy, and Emacs.")
       (:h2 "Books")
       (:p "I'm currently reading " (cl-who:str books))
       (:p "Check out the complete "
           (:a :href "https://github.com/anschwa/books" "list of books")
           " I've read since high school."))
      (:footer
       (:p "&copy; 2014-"
           "<script>document.write(new Date().getFullYear());</script>"
           " Adam Schwartz | "
           (:a :href "https://github.com/anschwa/anschwa.github.io" "View on GitHub")))))))
