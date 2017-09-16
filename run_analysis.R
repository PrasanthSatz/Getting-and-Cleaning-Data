library(dplyr)

filename <- "getting_and_cleaning_data.zip"

## Download the Dataset from the UCI Machine Learning Repository
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, mode = "wb")
}  

## Unzipping the Donwloaded Dataset
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

## Reading the Test Dataset
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Reading the Training Dataset
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## Merging the Test and Training Dataset to Create one Dataset
test_data <- cbind(subject_test,y_test,x_test)
train_data <- cbind(subject_train,y_train,x_train)
merged_data<-rbind(train_data,test_data)

## Reading the Features and Activity Dataset
features <- read.table("./UCI HAR Dataset/features.txt")
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity) <- c('activity_id','activityType')

## Assigning the Column Names to the Merged Dataset
columnnames<-c("subject_id","activity_id",as.character(features[,2]))
colnames(merged_data)<- columnnames

## Extracting only the measurements on the mean and standard deviation for each measurement.
mean_and_std <- (grepl("activity_id",columnnames)|
                     grepl("subject_id",columnnames)|
                     grepl("mean\\(\\)",columnnames)|
                     grepl("std\\(\\)",columnnames)
                     )

mean_and_std_data <- merged_data[,mean_and_std==TRUE]

## Assigning descriptive activity names to name the activities in the data set
data_with_activity_names <- merge(mean_and_std_data, activity, by='activity_id',all.x = TRUE)

## Creating independent tidy data set with the average of each variable for each Activity and each Subject.
tidy_data <- data_with_activity_names %>% group_by(activity_id, subject_id) %>% summarise_all(funs(mean))
write.table(tidy_data, "tidy_data.txt", row.name=FALSE, col.names=TRUE)






