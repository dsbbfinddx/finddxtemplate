# Hide this file from build
usethis::use_build_ignore("dev/")
usethis::use_build_ignore("ci/lib")
usethis::use_build_ignore("rsconnect")
usethis::use_git_ignore("docs/")
usethis::use_git_ignore("rsconnect/")
# usethis::create_package(".")

# Vaccinate for MacOS
usethis::git_vaccinate()

# description ----
library(desc)
unlink("DESCRIPTION")
# Utiliser `thinkridentity::get_author()` pour aider à remplir DESCRIPTION'
thinkridentity::get_author()

my_desc <- description$new("!new")
my_desc$set_version("0.0.0.9000")
my_desc$set(Package = "finddxtemplate")
my_desc$set(Title = "Tools to create a Rmd template for html/pdf documents")
my_desc$set(Description = "Tools to create a Rmd template for html/pdf documents.")
my_desc$set("Authors@R",
            'c(
  person(given = "Margot", family = "Brard", role = "aut", email = "margot@thinkr.fr", comment = c(ORCID = "0000-0001-6754-0659")),
  person(given = "Arthur", family = "Bréant", role = "aut", email = "arthur@thinkr.fr", comment = c(ORCID = "0000-0003-1668-0963")),
  person(given = "ThinkR", role = "cph")
)')
my_desc$set("VignetteBuilder", "knitr")
my_desc$del("Maintainer")
my_desc$del("URL")
my_desc$del("BugReports")
my_desc$write(file = "DESCRIPTION")

# Licence ----
usethis::use_proprietary_license("ThinkR")
# usethis::use_mit_license("ThinkR")

# Pipe ----
usethis::use_pipe()

# Data
dir.create("inst")
dir.create("inst/excel_files")

# Package quality ----

# _Tests ----
usethis::use_testthat()
usethis::use_test("app")

# _CI (cf {gitlabr} templates) ----
thinkridentity::use_gitlab_ci(image = "rocker/verse",
                              gitlab_url = "https://forge.thinkr.fr",
                              repo_name = "https://packagemanager.rstudio.com/all/__linux__/focal/latest",
                              type = "check-coverage-pkgdown-renv")
# GitLab MR and git commit templates
thinkridentity::add_gitlab_templates()

# Add kit package ----
thinkridentity::add_kit_package(type = c("package", "deliverables"))
thinkridentity::add_kit_project()

# usethis::use_github_action_check_standard()
# usethis::use_github_action("pkgdown")
#  _Add remotes::install_github("ThinkR-open/thinkrtemplate") in this action
# usethis::use_github_action("test-coverage")


# _rhub
# rhub::check_for_cran()


# Documentation ----
# _Readme
# usethis::use_readme_rmd()
chameleon::generate_readme_rmd()
chameleon::generate_readme_rmd(parts = "description")
# _Badges
usethis::use_badge(badge_name = "pipeline status",
                   href = "https://forge.thinkr.fr/<group>/<project>/-/commits/master",
                   src = "https://forge.thinkr.fr/<group>/<project>/badges/master/pipeline.svg")
usethis::use_badge(badge_name = "coverage report",
                   href = "http://<group>.pages.thinkr.fr/<project>/coverage.html",
                   src = "https://forge.thinkr.fr/<group>/<project>/badges/master/coverage.svg")

# _News
usethis::use_news_md()
# _Vignette
file.copy(system.file("templates/html/header_hide.html", package = "thinkridentity"),
          "vignettes")
thinkridentity::add_thinkr_css(path = "vignettes")

thinkridentity::create_vignette_thinkr("aa-data-exploration")
# usethis::use_vignette("ab-model")
devtools::build_vignettes()


# _Book
# remotes::install_github(repo = "ThinkR-open/chameleon")
chameleon::create_book("inst/report", clean = TRUE)
chameleon::open_guide_function()
devtools::document()
chameleon::build_book(clean_rmd = TRUE, clean = TRUE)
# pkg::open_guide()

# _Pkgdown
# pkgdown::build_site()

chameleon::build_pkgdown(
  # lazy = TRUE,
  yml = system.file("pkgdown/_pkgdown.yml", package = "thinkridentity"),
  favicon = system.file("pkgdown/favicon.ico", package = "thinkridentity"),
  move = TRUE, clean_before = TRUE, clean_after = TRUE
)

chameleon::open_pkgdown_function(path = "docs")
# pkg::open_pkgdown()

## __ deploy on rsconnect
usethis::use_git_ignore("docs/rsconnect")
usethis::use_git_ignore("inst/docs/rsconnect")
usethis::use_git_ignore("rsconnect")

rsconnect::accounts()
account_name <- rstudioapi::showPrompt("Rsconnect account", "Please enter your username:", "name")
account_server <- rstudioapi::showPrompt("Rsconnect server", "Please enter your server name:", "1.1.1.1")
origwd <- setwd("inst/docs")
rsconnect::deployApp(
  ".",                       # the directory containing the content
  appFiles = list.files(".", recursive = TRUE), # the list of files to include as dependencies (all of them)
  appPrimaryDoc = "index.html",                 # the primary file
  appName = "appname",                   # name of the endpoint (unique to your account on Connect)
  appTitle = "appname",                  # display name for the content
  account = account_name,                # your Connect username
  server = account_server                    # the Connect server, see rsconnect::accounts()
)
setwd(origwd)

# Dependencies ----
## Ce qu'il faut avant d'envoyer sur le serveur
# devtools::install_github("ThinkR-open/attachment")
attachment::att_amend_desc(
  extra.suggests = c("knitr", "testthat")
)
# Cela est normal : "Error in eval(x, envir = envir) : object 'db_local' not found"
devtools::check()

# Description and Bibliography
chameleon::create_pkg_desc_file(out.dir = "inst", source = c("archive"), to = "html")
thinkridentity::create_pkg_biblio_file_thinkr()

# Utils for dev ----
# Clean non-ASCII character ----
# TODO Add to {thinkr}
chars <- c(
  "à", "â",
  "é", "è", "ê",
  "î", "ï",
  "ô", "ö", "ø",
  "æ", "œ",
  "ù",
  "ç",
  "’", "²",
  "€"
)

files <- list.files("R", full.names = TRUE, pattern = ".R$")

for (file in files) {
  # file <- files[23]
  lines <- readr::read_lines(file)

  # Test if non-ascii characters
  asc <- iconv(lines, "latin1", "ASCII")
  ind_rox <- which((is.na(asc) | asc != lines) & grepl("^#'", lines))
  ind_no_rox <- which((is.na(asc) | asc != lines) & !grepl("^#'", lines))

  if (length(ind_rox) != 0) {

    for (char in chars) {
      lines[ind_rox] <- stringi::stri_replace_all_coll(
        lines[ind_rox],
        char,
        paste0("\\", stringi::stri_trans_general(char, "hex"))
      )
    }

  }
  if  (length(ind_no_rox) != 0) {

    for (char in chars) {
      lines[ind_no_rox] <- stringi::stri_replace_all_coll(
        lines[ind_no_rox],
        char,
        stringi::stri_trans_general(char, "hex")
      )
    }
  }

  if (length(c(ind_rox, ind_no_rox)) != 0) {
    readr::write_lines(lines, file)
  }

  asc <- iconv(lines, "latin1", "ASCII")
  ind_rox <- which((is.na(asc) | asc != lines) & grepl("^#'", lines))
  ind_no_rox <- which((is.na(asc) | asc != lines) & !grepl("^#'", lines))

  if (length(ind_rox) != 0 | length(ind_no_rox) != 0) {
    warning("Some character of file '", file, "' have not been converted in lines:", paste(ind_rox, ind_no_rox))
  }

  cat(crayon::green(file, "should be clean"))
}

# Get global variables
checkhelper::print_globals()
# Install
devtools::install(upgrade = "never")
# devtools::load_all()
devtools::check(vignettes = TRUE)
# ascii
stringi::stri_trans_general("é", "hex")


