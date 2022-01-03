## Script pour deployer sur Connect avec le CI
# _Créer un token de déploiement dédié au projet pour le user générique sur Connect
# _Ajouter le token en variable privée masquée dans le dépot GitLab: CONNECT_TOKEN
# _Ajouter le nom d'utilisateur Connect en variable privée masquée dans le dépot GitLab: CONNECT_USER
# _Ajouter la ligne suivante dans votre gitlab-ci.yml, après la création du pkgdown
#   __ Si c'est le pkgdown que vous voulez envoyer
# `        - Rscript "dev/dev_history_connect.R"`

# Un stage complet de CI peut-être (Attention avec les espaces, faire du LINT)
# Changer master par main si besoin

# connect:
#   stage: deploy-connect
#   dependencies:
#     - integration
#   only:
#     - master
#   script:
#     - 'curl --location --output artifacts.zip --header "JOB-TOKEN: $CI_JOB_TOKEN" "https://forge.thinkr.fr/api/v4/projects/$CI_PROJECT_ID/jobs/artifacts/master/download?job=pages" &&
#               unzip artifacts.zip &&
#               rm artifacts.zip &&
#               echo "copied master artifacts" ||
#               echo "copied master artifacts failed"'
#     - Rscript "dev/dev_history_connect.R"

# Ne pas oublier d'ajouter le stage "deploy-connect" à la liste des stages du début du CI
# stages:
#   - build
#   - test
#   - pkgdown
#   - pkgdown-move
#   - deploy-connect
#   - deploy

# /!\ => La premiere fois, executer en commentant le parametre "appID"
# Les fois suivantes, décommenter "appID" pour mettre le numéro de l'app sur Connect
# Choisir les paramètres ci-dessous en fonction de votre besoin

# Définir les droits de lecture de l'app sur Connect avec des individus et pas des groupes.
# Seuls les devs du projet et le client contact y ont accès

# Deps
install.packages("rsconnect")

## deploy shinyapp
# orgiwd <- setwd(".") # Uncomment here and below
## deploy pkgdown
origwd <- setwd("docs")

rsconnect::addServer("https://connect.thinkr.fr/__api__", name = "connect")
rsconnect::connectApiUser(account = Sys.getenv("CONNECT_USER"),
                          server = "connect", apiKey = Sys.getenv("CONNECT_TOKEN"))

# S'il y a {renv} dans votre projet, vous devrez probablement cacher quelques dossiers, par exemple
appFiles <- list.files(".", recursive = TRUE)
appFiles <- appFiles[!grepl(".Rprofile|renv|rstudio_|deliverables|dev|data-raw|docker", appFiles)]

rsconnect::deployApp(
  ".",                          # the directory containing the content
  appName = "pkgdown-website",
  appFiles = appFiles,          # the list of files to include as dependencies (all of them)
  appPrimaryDoc = "index.html", # the primary file for pkgdown
  # appPrimaryDoc = "app.R", # the primary file for shinyapp # Uncomment here
  # appId = xx, # Define when known
  account = Sys.getenv("CONNECT_USER"),
  server  = "connect",
  forceUpdate = FALSE
)

setwd(origwd)
