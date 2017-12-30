;; Projects Page

(defun render-projects (projects)
  "renders the projects page as an html string"
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
      (:h1 "Projects")
      (:section
       :class "content projects"
       (cl-who:str projects))
      (cl-who:str (render-footer))))))
