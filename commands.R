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
source("run_analysis.R")
