
<!-- README.md is generated from README.Rmd. Please edit that file -->

# finddxtemplate <img src="man/figures/logo.png" align="right" alt="" width="120" />

[![R build
status](https://forge.thinkr.fr/thinkr/missions/finddx/finddxtemplate/badges/main/pipeline.svg)](https://forge.thinkr.fr/finddx/finddxtemplate/-/pipelines)
[![Codecov test
coverage](https://forge.thinkr.fr/thinkr/missions/finddx/finddxtemplate/badges/main/coverage.svg)](https://connect.thinkr.fr/finddxtemplate-pkgdown-website/coverage.html)

The {finddxtemplate} package provides design tools to create a Rmd
template for html documents.

Current version is 0.0.0.9000.

The documentation is available here:

  - pkgdown: <https://connect.thinkr.fr/finddxtemplate-pkgdown-website/>
  - coverage report:
    <https://connect.thinkr.fr/finddxtemplate-pkgdown-website/coverage.html>

## HTML template

An overview of the HTML template is available here:
<https://connect.thinkr.fr/finddxtemplate-pkgdown-website/rmd_template.html>

Or in command
line:

``` r
browseURL(system.file("rmarkdown", "rmd_template.html", package = "finddxtemplate"))
```

## Installation

You can install the package with:

``` r
# install.packages("remotes")
remotes::install_local(path = "finddxtemplate_0.0.0.9000.tar.gz")
```

``` r
options(remotes.git_credentials = git2r::cred_user_pass("gitlab-ci-token", Sys.getenv("FORGE_THINKR_TOKEN")))
remotes::install_git("https://forge.thinkr.fr/thinkr/missions/finddx/finddxtemplate")
```

## Use

  - *Package installation and dependencies* *(TODO)*
  - *Integration of the FIND graphic design in R Markdown reports*

Open the pkgdown:

``` r
finddxtemplate::open_pkgdown()
```
