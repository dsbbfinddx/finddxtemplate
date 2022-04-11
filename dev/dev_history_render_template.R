## Script pour deployer sur Connect avec le CI

## find rmd file
rmd_file <- file.path(getwd(), "inst", "rmarkdown", "rmd_template.Rmd")

## render html
rmarkdown::render(input = rmd_file,
                  output_format = finddxtemplate::html_document_find(),
                  output_dir = "public")
