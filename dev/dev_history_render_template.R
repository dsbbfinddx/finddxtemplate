## Script pour deployer sur Connect avec le CI

## find rmd file
rmd_file <- file.path(getwd(), "inst", "rmarkdown", "rmd_template.Rmd")

## deploy html
if (dir.exists("public")) {
  origwd <- setwd("public")
} else {
  origwd <- getwd()
}
print(paste("--", getwd(), "--"))

rmarkdown::render(input = rmd_file,
                  output_format = rmarkdown::html_document(),
                  output_dir = getwd())

setwd(origwd)
