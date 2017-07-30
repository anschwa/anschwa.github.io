;; Projects Page

(defun render-projects (projects)
  "renders the projects page as an html string"
  (cl-who:with-html-output-to-string (htm nil :prologue t :indent nil)
    (:html
     :lang "en"
     (:head
      (:meta :charset "UTF-8")
      (:title "Adam Schwartz")
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
       :class "content"
       (:h1 "Projects")
       (cl-who:str projects))
      (:footer
       (:p "&copy; 2014-"
           "<script>document.write(new Date().getFullYear());</script>"
           " Adam Schwartz | "
           (:a :href "https://github.com/anschwa/anschwa.github.io" "View on GitHub")))))))
