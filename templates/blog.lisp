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
        :class "content"
        (:header
         (:h2 :class "title"
              (:a :href "#2016/06/welcome-to-my-blog" "Welcome to my blog"))
         (:p :class "timestamp" (:time "June 17, 2016")))
        (:section
         (:p "Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit.")
         (:p "Here is some python.")
         (cl-who:str *example-code*)
         (:p
          "Vitae, "
          (:a :href "http://example.com" "auctor eu augue")
          " ut lectus arcu, bibendum at varius vel, pharetra vel "
          (:strong "turpis")
          " nunc eget lorem dolor, sed viverra. Aliquam sem et tortor "
          (:code "consequat id")
          " porta nibh "
          (:em "venenatis")
          " cras.")
         (:p "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Maecenas faucibus mollis interdum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec sed odio dui. Donec sed odio dui.")
         (:p "Nullam quis risus eget urna mollis ornare vel eu leo. Donec id elit non mi porta gravida at eget metus. Sed posuere consectetur est at lobortis. Integer posuere erat a ante venenatis dapibus posuere velit aliquet.")
         (:p "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Etiam porta sem malesuada magna mollis euismod. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Donec sed odio dui. Aenean lacinia bibendum nulla sed consectetur."))
        (:footer
         (:p "&copy; 2014-"
             "<script>document.write(new Date().getFullYear());</script>"
             " Adam Schwartz | "
             (:a :href "https://github.com/anschwa/anschwa.github.io" "View on GitHub")))))))))
