# R Script to download, tidy up and analyse data

# Load packages neeeded
library(dtplyr)

# Download, unzip, path and list files
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("datafilezip.zip")){file.create("datafilezip.zip")}
download.file(fileurl, "datafilezip.zip")
unzip("datafilezip.zip")
datafilepath <- file.path("UCI HAR Dataset")
filelist <- list.files(datafilepath)

# Read the different files and stored them in different data tables
# Files from subjects
subjecttest <- fread(file.path(datafilepath, "test", "subject_test.txt"))
subjecttrain <- fread(file.path(datafilepath, "train", "subject_train.txt"))
# Files from activities
activitytest <- fread(file.path(datafilepath, "test", "y_test.txt"))
activitytrain <- fread(file.path(datafilepath, "train", "y_train.txt"))
# Data set files
settest <- fread(file.path(datafilepath, "test", "X_test.txt"))
settrain <- fread(file.path(datafilepath, "train", "X_train.txt"))
# Features (variables) names 
features <- fread(file.path(datafilepath, "features.txt"))
# Activity names
activities <- fread(file.path(datafilepath, "activity_labels.txt"))

# Add names to variables and merge data sets (same order as previous step)
# Subject sets
subject <- rbind(subjecttest,subjecttrain)
setnames(subject, "V1", "subjectid")
# Activity sets
activity <- rbind(activitytest,activitytrain)
setnames(activity, "V1", "activityid")
# Data sets
set <- rbind(settest, settrain)
# Set features names
setnames(features, names(features), c("featureid", "featurename"))
# Set activities names
setnames(activities, names(activities), c("activityid", "activityname"))
# Merge the data sets all together
dataset <- cbind(subject, activity, set)
# Add names for activities
dataset <- merge(dataset, activities, by = "activityid", all.x = TRUE)
# Set data set keys
setkey(dataset, "subjectid", "activityid", "activityname")

# Extract only the mean and standard deviation for each feature
# Determine the variables that represent means and standard deviations
features <- features[grepl("mean\\(\\)|std\\(\\)", featurename)]
# Convert them into variables names in the data set
features$featurecode <- features[, paste0("V", featureid)]
# Subset the variables using variables names
selectedfeatures <- c(key(dataset), features$featurecode)
dataset <- dataset[, selectedfeatures, with = FALSE]

# Add descriptive names to extracted features
# Reshape data set, considering each feature a variable itself
# So then their values are a different value and each observation is a row
dataset <- melt(dataset, key(dataset), features$featurecode, variable.name = "featurecode")
# Add features names and ids, ordering variables per column
dataset <- select(merge(dataset, features, by = "featurecode", all.x = TRUE), subjectid,activityid,activityname,featureid,featurename,value)

# Create an independent tidy data set, with the means for each group
# Categorise required variables (subject, activity and feature)
dataset <- group_by(dataset, subjectid, activityname, featurename)
# Summarise the mean per group and create and independent, tidy data set
meandataset <- summarise(dataset, mean = mean(value))

# Save data set into a csv file
# Create csv files and get their paths
if(!file.exists("meandataset.txt")) {file.create("meandataset.txt")}
meandatasetfile <- file.path(getwd(), "meandataset.txt")
# Write data tables as csv
write.csv(meandataset, meandatasetfile, row.names = FALSE)
