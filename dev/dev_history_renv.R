# Start {renv} the first time ====
renv::init()

# Set RENV cache ====
# Recommend setting a global variable: RENV_PATHS_CACHE
# With cache path where to store all R packages, between projects
# usethis::edit_r_environ(scope = "project")
# => Tell all contributors to set this Environment variable

# Add the following lines to your .Rprofile in the project
# <!-- Rprofile STARTS -->
# Sourcing user .Rprofile if it exists
home_profile <- file.path(
  Sys.getenv("HOME"),
  ".Rprofile"
)
if (file.exists(home_profile)){
  source(home_profile)
}

# Fix CRAN version
source("renv/activate.R")
lock_ <- renv:::lockfile(file = "renv.lock")

if (Sys.info()["sysname"] == "Linux") {
  # Enable this universe
  options(repos = c(
    thinkropen = 'https://thinkr-open.r-universe.dev',
    CRAN = "https://packagemanager.rstudio.com/all/__linux__/focal/latest"
  )
  )
  lock_$repos(
    thinkropen = 'https://thinkr-open.r-universe.dev',
    CRAN = "https://packagemanager.rstudio.com/all/__linux__/focal/latest"
  )
} else {
  # Important for MacOS users in particular
  options(
    repos = c(
      thinkropen = 'https://thinkr-open.r-universe.dev',
      CRAN = "https://cran.rstudio.com"
    )
  )
  lock_$repos(
    thinkropen = 'https://thinkr-open.r-universe.dev',
    CRAN = "https://cran.rstudio.com"
  )
}
lock_$write(file = "renv.lock")
rm(lock_)

renv::activate()

# cache
if (Sys.getenv("RENV_PATHS_CACHE") != "") {
  renv::settings$use.cache(TRUE)
} else if (dir.exists(Sys.getenv("LOCAL_RENV_CACHE", unset = "~/renv_cache"))) {
  # Cache on your own computer
  # shared between projects
  Sys.setenv(RENV_PATHS_CACHE = Sys.getenv("LOCAL_RENV_CACHE", unset = "~/renv_cache"))
  renv::settings$use.cache(TRUE)
} else if (dir.exists("/opt/local/renv/cache")) {
  # Cache inside the docker container with persistent drive with {devindocker}
  # shared on host
  Sys.setenv(RENV_PATHS_CACHE = "/opt/local/renv/cache")
  renv::settings$use.cache(TRUE)
} else {
  # No cache
  renv::settings$use.cache(FALSE)
}
# <!-- Rprofile ENDS -->

# You may need to verify renv.lock with:
# "Name": "REPO_NAME",
# "URL": "https://packagemanager.rstudio.com/all/latest"

# You may need to verify not empty
# Sys.getenv("RENV_PATHS_CACHE")

# Install from GitHub through r-universe
install.packages("attachment", repos = getOption("repos")["thinkropen"])
install.packages("fusen", repos = getOption("repos")["thinkropen"])

# git push / pull ====
## Ce qu'il faut avant d'envoyer sur le serveur
# install.packages("attachment", repos = getOption("repos")["thinkropen"])
# attachment::att_amend_desc(extra.suggests = c("bookdown"))
# attachment::create_dependencies_file()
attachment::att_amend_desc()
devtools:check()

# _renv
custom_packages <- c(
  attachment::att_from_description(),
  "renv",
  "devtools", "roxygen2", "usethis", "pkgload",
  "testthat", "covr", "attachment",
  # remotes::install_github("ThinkR-open/checkhelper")
  "pkgdown", "styler", "checkhelper", "remotes", "fusen",
  # remotes::install_github("ThinkR-open/thinkrtemplate")
  "thinkrtemplate"
)
renv::snapshot(packages = custom_packages)

## After pull
renv::restore()
