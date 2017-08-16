;; Reusable templates like the footer

(defun render-footer ()
  (cl-who:with-html-output-to-string (htm nil :prologue nil :indent nil)
    (:footer
     (:p "&copy; 2014-"
         "<script>document.write(new Date().getFullYear());</script>"
         " Adam Schwartz | "
         (:a :href "https://github.com/anschwa/anschwa.github.io" "View on GitHub")))))
