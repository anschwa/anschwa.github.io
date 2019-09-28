package main // import "github.com/anschwa/anschwa.github.io/"

import (
	"bufio"
	"context"
	"encoding/json"
	"flag"
	"html/template"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"time"

	"golang.org/x/net/html"
)

func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

type Site struct {
	Host    string
	Dir     string
	Visited map[string]bool
}

func cleanURI(host, path string) string {
	return host + filepath.Clean(("/" + path))
}

// Fetch a list of URLs that are relative to a given page.
func (s *Site) Fetch(uri string) (urls []string) {

	r, err := http.Get(uri)
	check(err)

	z := html.NewTokenizer(r.Body)
	defer r.Body.Close()

	for {
		tt := z.Next()
		switch {
		case tt == html.ErrorToken:
			// Reached HTML EOF
			return
		case tt == html.StartTagToken:
			t := z.Token()
			if t.Data == "a" || t.Data == "link" || t.Data == "img" {
				for _, x := range t.Attr {
					if x.Key == "href" || x.Key == "src" {
						if _, isRelative := url.ParseRequestURI(x.Val); isRelative != nil {
							if x.Val[0] != '#' {
								nextURL := cleanURI(s.Host, x.Val)
								urls = append(urls, nextURL)
								break
							}
						}
					}
				}
			}
		}
	}
}

// Try to save each webpage as `index.html` in it's own directory. Otherwise, save the file as is.
func (s *Site) Save(uri string) {
	page := "/"
	if base := filepath.Base(uri); base != filepath.Base(s.Host) {
		page += base
	}
	path := filepath.Clean(s.Dir + page)

	if filepath.Ext(path) == "" {
		if err := os.MkdirAll(path, os.ModePerm); err != nil {
			log.Fatal(err)
		}
		path += "/index.html"
	}

	r, err := http.Get(uri)
	check(err)

	b, err := ioutil.ReadAll(r.Body)
	check(err)
	defer r.Body.Close()

	f, err := os.Create(path)
	check(err)

	defer func() {
		if err := f.Close(); err != nil {
			log.Fatal(err)
		}
	}()

	log.Printf("Saving %s\n", path)
	_, err = f.Write(b)
	check(err)
	return
}

// Freeze recursively crawls pages to a maximum of depth.
//
// Example Usage:
//  site := Site{"http://localhost:8080", "./build", make(map[string]bool)}
//  Freeze(site.Host, 4, &site)
func Freeze(uri string, depth int, site *Site) {
	// TODO: Fetch URLs concurrently.

	req, err := url.ParseRequestURI(uri)
	check(err)

	key := cleanURI(req.Host, req.Path)

	if site.Visited[key] || depth <= 0 {
		return
	}

	urls := site.Fetch(uri)
	site.Save(uri)
	site.Visited[key] = true

	for _, u := range urls {
		Freeze(u, depth-1, site)
	}
}

type Book struct {
	Title  string
	Author string
}

// Only unmarshal the desired fields
type Projects []struct {
	Name        string
	Description string
	Language    string
	Updated     string    // stores the date format as a string
	Created     string    // for use in the HTML template
	UpdatedAt   time.Time `json:"updated_at"`
	CreatedAt   time.Time `json:"created_at"`
	URL         string    `json:"html_url"`
	Stars       int       `json:"stargazers_count"`
}

type Post struct {
	Date string
	Body template.HTML
}

type Page struct {
	Title    string
	Meta     string
	Books    []Book
	Projects Projects
	Body     template.HTML
	Blog     Post
}

func staticHandler(pattern, filename string) {
	http.HandleFunc(pattern, func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, filename)
	})
}

var templates = template.Must(template.ParseFiles("templates/about.html",
	"templates/footer.html", "templates/projects.html", "templates/blog.html"))

func renderTemplate(w http.ResponseWriter, tmpl string, p *Page) {
	err := templates.ExecuteTemplate(w, tmpl+".html", p)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func renderPage(filename string) template.HTML {
	cmd := exec.Command("pandoc", filename)
	page, err := cmd.Output()
	if err != nil {
		log.Println("Pandoc wasn't found...assuming page is HTML")
		page, err := ioutil.ReadFile(filename)
		check(err)
		return template.HTML(page)
	}
	return template.HTML(page)
}

func getLatestInfo(url, filename string) {
	resp, err := http.Get(url)
	check(err)
	defer resp.Body.Close()

	f, err := os.Create(filename)
	check(err)
	defer f.Close()
	_, err = io.Copy(f, resp.Body)
}

func currentBooks(filename string) []Book {
	f, err := os.Open(filename)
	check(err)
	defer f.Close()

	scanner := bufio.NewScanner(f)

	var books []string
	var line string
	var found bool

	for scanner.Scan() {
		line = scanner.Text()
		if line == "* Books I am currently reading" {
			found = true
		} else if line == "* Books I have read" {
			found = false
		} else if line == "" {
			continue
		} else if found == true {
			books = append(books, strings.TrimSpace(line))
		}
	}
	check(scanner.Err())

	// check both title and author line at the same time
	parsedBooks := []Book{}
	lenBooks := len(books)

	if lenBooks < 2 {
		return parsedBooks
	}

	for i := 0; i < lenBooks; i += 2 {
		b := Book{}

		if title := books[i]; title[1] == '.' {
			footnote := len(title) - 3
			if title[footnote] == '[' {
				b.Title = title[3 : footnote-1]
			} else {
				b.Title = title[3:]
			}
		}
		if author := books[i+1]; author[0] == '-' {
			b.Author = author[2:]
		}

		parsedBooks = append(parsedBooks, b)
	}

	return parsedBooks
}

func getProjects(filename string) Projects {
	projects := Projects{}
	keep := Projects{}
	wanted := []string{
		"ma42",
		"typing-test",
		"emacs.d",
		"dotfiles",
		"books",
		"anschwa.github.io",
		"dupy",
		"helm-itunes",
		"current-song",
		"jchat",
		"stiltdb",
		"pycryption",
		"nbimporter",
		"savetheyak",
		"capstone",
		"book-keeper",
	}

	f, err := ioutil.ReadFile(filename)
	check(err)
	json.Unmarshal(f, &projects)

	for _, repo := range projects {
		for _, want := range wanted {
			if repo.Name == want {
				repo.Updated = repo.UpdatedAt.Format("2006-01-02")
				repo.Created = repo.CreatedAt.Format("2006-01-02")
				keep = append(keep, repo)
			}
		}
	}
	// sort by stars
	sort.Slice(keep, func(i, j int) bool {
		return keep[i].Stars > keep[j].Stars
	})
	return keep
}

// http.ServeMux forces us to be very explicit
var validPath = regexp.MustCompile("^/($|blog|projects)$")

func makeHandler(template string, page *Page) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		m := validPath.FindStringSubmatch(r.URL.Path)
		if m == nil {
			http.NotFound(w, r)
			return
		}

		renderTemplate(w, template, page)
	}
}

func startServer(server *http.Server, shutdown chan os.Signal) {
	description := `Hi, I'm a recent graduate from Earlham College and
	have a passion for programming languages, web development,
	privacy, and Emacs.`

	about := Page{
		Title: "Adam Schwartz",
		Meta:  description,
		Body:  renderPage("./pages/about.org"),
		Books: currentBooks("books.txt"),
	}

	projects := Page{
		Title:    "Projects | Adam Schwartz",
		Meta:     description,
		Projects: getProjects("projects.json"),
	}

	blog := Page{
		Title: "Blog | Adam Schwartz",
		Meta:  description,
		Blog: Post{
			Date: "May 25, 2018",
			Body: renderPage("./pages/blog.org"),
		},
	}

	http.HandleFunc("/", makeHandler("about", &about))
	http.HandleFunc("/blog", makeHandler("blog", &blog))
	http.HandleFunc("/projects", makeHandler("projects", &projects))

	staticHandler("/style.css", "./static/style.css")
	staticHandler("/me.jpg", "./static/me.jpg")

	signal.Notify(shutdown, os.Interrupt)
	go func() {
		<-shutdown
		ctx := context.Background()
		server.SetKeepAlivesEnabled(false)
		err := server.Shutdown(ctx)
		check(err)
	}()

	if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		log.Fatal(err)
	}
}

func buildSite(server *http.Server, site *Site) {
	shutdown := make(chan os.Signal, 1)
	go startServer(server, shutdown)

	time.Sleep(time.Second) // simpler than channels
	Freeze(site.Host, 4, site)
	shutdown <- os.Interrupt
}

func deploySite(server *http.Server, site *Site, cname []byte) {
	f, err := os.Create(filepath.Join(site.Dir, "CNAME"))
	check(err)
	defer func() {
		if err := f.Close(); err != nil {
			log.Fatal(err)
		}
	}()

	log.Println("Writing CNAME...")
	_, err = f.Write(cname)
	check(err)

	cmd := exec.Command("ghp-import", "-b", "master", "-m", "[deploy] Build", "-p", site.Dir)
	out, err := cmd.CombinedOutput()
	log.Println(string(out)) // captures error message
	check(err)
}

func main() {
	build := flag.Bool("build", false, "build static site")
	deploy := flag.Bool("deploy", false, "deploy to GitHub Pages")
	update := flag.Bool("update", false, "fetch latest info when building the site")
	flag.Parse()

	if *update {
		books := "https://raw.githubusercontent.com/anschwa/books/master/readme.org"
		projects := "https://api.github.com/users/anschwa/repos"

		getLatestInfo(books, "books.txt")
		getLatestInfo(projects, "projects.json")
		log.Printf("Fetching %s\nFetching %s\n", books, projects)
	}

	server := &http.Server{
		Addr:         ":8080",
		ReadTimeout:  time.Second,
		WriteTimeout: time.Second,
		IdleTimeout:  time.Second,
	}

	site := &Site{"http://localhost:8080", "./build", make(map[string]bool)}
	cname := []byte("anschwa.com")

	switch {
	case *build:
		log.Println("Building static site...")
		buildSite(server, site)
	case *deploy:
		log.Println("Deploying site to GitHub Pages...")
		buildSite(server, site)
		deploySite(server, site, cname)
	default:
		log.Println("Starting webserver...")
		shutdown := make(chan os.Signal, 1)
		startServer(server, shutdown)
	}
}
