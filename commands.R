wd <- "C:/Program Files/R/Coursera114/this/is/a/test/"
if (!file.exists(wd)){
        dir.create(wd)
}
setwd(wd)

d <- as.character("Getting and Cleaning Data Project") #d represents the data folder inside "" and should be named accodingly

if (!file.exists(d)){
        dir.create(d)
} # Checks for folder d, if it does not exsist it creates it

fwd <- paste(wd, d, sep='') # Combines folder name with directory to create workspace

setwd(fwd) # Setting final directory

getwd() # Checking final directory

list.files(fwd) # Checking for files listed 

temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)
unzip(temp, exdir="data")

download <- function(url, ...) {
        # First, check protocol. If http or https, check platform:
        if (grepl('^https?://', url)) {
                
                # If Windows, call setInternet2, then use download.file with defaults.
                if (.Platform$OS.type == "windows") {
                        
                        # If we directly use setInternet2, R CMD CHECK gives a Note on Mac/Linux
                        seti2 <- `::`(utils, 'setInternet2')
                        
                        # Store initial settings, and restore on exit
                        internet2_start <- seti2(NA)
                        on.exit(suppressWarnings(seti2(internet2_start)))
                        
                        # Needed for https. Will get warning if setInternet2(FALSE) already run
                        # and internet routines are used. But the warnings don't seem to matter.
                        suppressWarnings(seti2(TRUE))
                        download.file(url, ...)
                        
                } else {
                        # If non-Windows, check for curl/wget/lynx, then call download.file with
                        # appropriate method.
                        
                        if (nzchar(Sys.which("wget")[1])) {
                                method <- "wget"
                        } else if (nzchar(Sys.which("curl")[1])) {
                                method <- "curl"
                                
                                # curl needs to add a -L option to follow redirects.
                                # Save the original options and restore when we exit.
                                orig_extra_options <- getOption("download.file.extra")
                                on.exit(options(download.file.extra = orig_extra_options))
                                
                                options(download.file.extra = paste("-L", orig_extra_options))
                                
                        } else if (nzchar(Sys.which("lynx")[1])) {
                                method <- "lynx"
                        } else {
                                stop("no download method found")
                        }
                        
                        download.file(url, method = method, ...)
                }
                
        } else {
                download.file(url, ...)
        }
}

download("https://raw.githubusercontent.com/NateThompson114/Getting-and-Cleaning-Data-Project/master/run_analysis.R", "run_analysis.R")

source("run_analysis.R")
