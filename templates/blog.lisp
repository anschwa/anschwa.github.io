;; Blog Page

(defparameter *example-code* "<div class=\"sourceCode\" rundoc-language=\"python\" rundoc-results=\"output\" rundoc-exports=\"both\"><pre class=\"sourceCode python rundoc-block\"><code class=\"sourceCode python\"><span class=\"im\">from</span> __future__ <span class=\"im\">import</span> print_function

<span class=\"kw\">def</span> hello(noun<span class=\"op\">=</span><span class=\"st\">&quot;world&quot;</span>):
    <span class=\"co\">&quot;&quot;&quot;Say hello to a thing&quot;&quot;&quot;</span>
    <span class=\"bu\">print</span>(<span class=\"st\">&quot;hello&quot;</span>, noun)

hello()
hello(<span class=\"st\">&quot;moon&quot;</span>)</code></pre></div>
<pre class=\"example\"><code>hello world
hello moon
</code></pre>")

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
