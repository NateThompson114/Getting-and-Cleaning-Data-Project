mainDir <- "~"
subDir <- "outputDirectory"

if (file.exists(paste(mainDir, subDir, "/", sep = "/", collapse = "/"))) {
        cat("subDir exists in mainDir and is a directory")
} else if (file.exists(paste(mainDir, subDir, sep = "/", collapse = "/"))) {
        cat("subDir exists in mainDir but is a file")
        # you will probably want to handle this separately
} else {
        cat("subDir does not exist in mainDir - creating")
        dir.create(file.path(mainDir, subDir))
}

if (file.exists(paste(mainDir, subDir, "/", sep = "/", collapse = "/"))) {
        # By this point, the directory either existed or has been successfully created
        setwd(file.path(mainDir, subDir))
} else {
        cat("subDir does not exist")
        # Handle this error as appropriate
}

setwd(subDir)

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

temp <- tempfile()
download("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)
unzip(temp, exdir="data")

download("https://raw.githubusercontent.com/NateThompson114/Getting-and-Cleaning-Data-Project/master/run_analysis.R", "run_analysis.R")# downloading run_analysis

source("run_analysis.R")# running run_analysis

Average_cleaned <- read.table("~/outputDirectory/Average_cleaned.txt", header=T, quote="\"")
View(Average_cleaned)

cleaned <- read.table("~/outputDirectory/cleaned.txt", header=T, quote="\"")
View(cleaned)