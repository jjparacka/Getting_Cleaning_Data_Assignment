##1. Loading the required libraries. Assiming that the packages are already installed. 
library(dplyr)
library(reshape2)


##2. downloading and extracting the data files. downloads only if working directory does not contain Dataset.zip 
if(!file.exists("./Dataset.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" , "Dataset.zip")
  unzip("Dataset.zip")
}

##3. reading the required data into R 
features <- read.table("./UCI HAR Dataset/features.txt" , stringsAsFactors = FALSE )
activities <- read.table("./UCI HAR Dataset/activity_labels.txt" , stringsAsFactors = FALSE, col.names = c("activity_id", "activity_desc") )

## reading train data
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")

## reading test data 
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")

## 4.Appropriately labels the data set with descriptive variable names. 
## give meaningful names to data sets, variable names from features.txt are used as column names
names(subject_train) [1] <- "subject_id"
names(y_train) [1] <- "activity_id"
names(x_train) [] <- features[,2]

names(subject_test) [1] <- "subject_id"
names(y_test) [1] <- "activity_id"
names(x_test) [] <- features[,2]

## column bind the data by including subject id, activity id and measurements
train <- cbind(subject_train, y_train, x_train)
test  <- cbind(subject_test, y_test, x_test)
## 1.Merges the training and the test sets to create one data set.
## row bind test and train data into a single data set
data <- rbind(train, test)

## 3.Use descriptive activity names to name the activities in the data set
## replace activity ID with activity description using merge
data <- merge(activities, data,  by.x="activity_id", by.y="activity_id", all=TRUE)
data$activity_id <- NULL

## change subject id and activity description to factor variables
data$subject_id <- factor(data$subject_id)
data$activity_desc <- factor(data$activity_desc)

##2.Extracts only the measurements on the mean and standard deviation for each measurement
## Note excluding fields named meanFreq() 
meanstd <- as.character(features[grep("mean\\(\\)|std\\(\\)",features[,2]), 2 ])

##5. independent tidy data set with the average of each variable for each activity and each subject.
## melt the data set with activity and subject as ids and all mean and std fields as variables
## cast the melted data with mean of each variable
melteddata<-melt(data, id=c("activity_desc","subject_id"), measure.vars=meanstd)
tidydata <- dcast(melteddata, subject_id+activity_desc ~ variable, mean )

## append avg to the column names of measurements to indicate that these are average values
names(tidydata)[3:68] <- paste("avg",names(tidydata)[3:68], sep="") 

## write the data to an output file tidydata.txt
write.table(tidydata,file="tidydata.txt",row.names = FALSE)
