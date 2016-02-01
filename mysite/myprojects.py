import os.path, urllib.request, json

github_repo_url = "https://api.github.com/users/anschwa/repos"
github_repo_file = "github_repos.json"
github_repo_data = {}
wanted_repos = [
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
]

github_repo_names = [ "MA42 Keyboard", "ES6 Typing Test", "PyCryption",
               "Helm iTunes", "jChat", "STiLT DB",]

# If there is not an existing repository file, retrieve one.
if not os.path.isfile(github_repo_file):
    urllib.requst.urlretrieve(github_repo_url, github_repo_file)


# Parse repository file and store desired information
with open(github_repo_file) as file:
    my_repos = json.loads(file.read())

# Get desired info from repository file
# TODO add to dictionary from list: ["description", "html_url", "created_at", etc]
for r in my_repos:
    if r["name"] in wanted_repos:
        github_repo_data[r["name"]] = {"description" : r["description"],
                                "link" : r["html_url"],
                                "date" : r["updated_at"],
                                "stars": r["stargazers_count"]}

        
def get_repos():
    return(github_repo_data)

# TODO sort dictionary by popularity (stargazer_count)
# Probably needs to be done in the projects.html template
