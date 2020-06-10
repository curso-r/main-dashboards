view_html_on_viewer <- function(file) {
  dir <- tempfile()
  dir.create(dir)
  htmlFile <- file.path(dir, "temp.html")
  file.copy(from = file, to = htmlFile)
  rstudioapi::viewer(htmlFile)
  rstudioapi::navigateToFile(htmlFile)
}