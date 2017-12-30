;; Blog Page

(defun render-blog (posts)
  "renders the blog page as an html string"
  (cl-who:with-html-output-to-string (htm nil :prologue t :indent nil)
    (:html
     :lang "en"
     (:head
      (:meta :charset "UTF-8")
      (:title "Adam Schwartz")
      (:meta :name "description" :content "Hi, I'm a Computer Science major at Earlham College and have a passion for programming languages, web development, privacy, and Emacs.")
      (:link :href "../style.css" :rel "stylesheet"))
     (:body
      (:header
       :class "masthead"
       (:a :class "logo" :href "http://anschwa.com" "Adam Schwartz")
       (:nav :class "menu"
             (:ul (:li (:a :href "../blog/" "Blog"))
                  (:li (:a :href "../projects/" "Projects"))
                  (:li (:a :href "https://github.com/anschwa" "GitHub")))))
      (:section
       (:h1 "Blog")
       (:ul :class "menu" (:li (:a :href "#archive/" "Archive")))
       (:article
        :class "content blog-content"
          (cl-who:str (file-to-string (first posts)))))
       (cl-who:str (render-footer))))))
