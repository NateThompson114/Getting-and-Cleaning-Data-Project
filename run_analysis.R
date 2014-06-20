# Submission by Nate Thompson
# Project Due Date: Sunday 22 June 2014
# Source of data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# Created a R script called run_analysis.R that does the following. 
# 1) Merges the training and the test sets to create one data set.
tt1 <- read.table("data/UCI HAR Dataset/train/subject_train.txt")#tt temporary table
tt2 <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
S <- rbind(tt1, tt2)

tt1 <- read.table("data/UCI HAR Dataset/train/X_train.txt") 
tt2 <- read.table("data/UCI HAR Dataset/test/X_test.txt")
X <- rbind(tt1, tt2)

tt1 <- read.table("data/UCI HAR Dataset/train/y_train.txt")
tt2 <- read.table("data/UCI HAR Dataset/test/y_test.txt")
Y <- rbind(tt1, tt2)
rm(tt1,tt2) #Clean up the global of items no longer needed
# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("data/UCI HAR Dataset/features.txt")
MEAN_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X <- X[, MEAN_features]
names(X) <- features[MEAN_features, 2]
names(X) <- gsub("\\(|\\)", "", names(X)) # sub perform replacement of the first and all matches respectively.
names(X) <- tolower(names(X)) #T ranslate characters in character vectors.
rm(MEAN_features,features)
# 3) Uses descriptive activity names to name the activities in the data set
activities <- read.table("data/UCI HAR Dataset/activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
Y[,1] = activities[Y[,1], 2]
names(Y) <- "activity"
# 4) Appropriately labels the data set with descriptive variable names. 
names(S) <- "subject"
cleaned <- cbind(S, Y, X)
write.table(cleaned, "cleaned.txt")
rm(Y, X)
# 5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
uniqueSubjects = unique(S)[,1]
numSubjects = length(unique(S)[,1])
numActivities = length(activities[,1])
numCols = dim(cleaned)[2]
result = cleaned[1:(numSubjects*numActivities), ]

row = 1
for (s in 1:numSubjects) {
        for (a in 1:numActivities) {
                result[row, 1] = uniqueSubjects[s]
                result[row, 2] = activities[a, 2]
                tmp <- cleaned[cleaned$subject==s & cleaned$activity==activities[a, 2], ]
                result[row, 3:numCols] <- colMeans(tmp[, 3:numCols])
                row = row+1
        }
}
write.table(result, "Average_cleaned.txt")
rm(list=ls()) ## cleaning the global
