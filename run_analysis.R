#loading necessary libraries
library(dplyr)
library(data.table)
library(reshape2)

#Saving the url to a variable, it is a zipped file
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
filename <- "getdata_dataset.zip"


#download zip file, download mode binary, only if it does not already exist
if(!file.exists(destfile)){
download.file(fileURL,filename,mode='wb', method='auto')}
##
if (!file.exists(filename)){
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


#reading all files with read_table, using sep = '\n' so there are no repeated names
features<-read.table("./UCI HAR Dataset/features.txt", sep='\n')
features[,1] <- as.character(features[,1])
activity_names<-read.table("./UCI HAR Dataset/activity_labels.txt")
activity_names[,2] <- as.character(activity_names[,2])

Xfeatures <- grep(".*mean.*|.*std.*", features[,1])
Xfeatures.names <- features[Xfeatures,1]
Xfeatures.names = gsub('-mean', 'Mean', Xfeatures.names)
Xfeatures.names = gsub('-std', 'Std', Xfeatures.names)
Xfeatures.names <- gsub('[-()]', '', Xfeatures.names)


#reading train and test files
f_train<-read.table("./UCI HAR Dataset/train/X_train.txt")[Xfeatures]
activities_train<-read.table("./UCI HAR Dataset/train/Y_train.txt")
sub_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
train <- cbind(sub_train, activities_train, f_train)

f_test<-read.table("./UCI HAR Dataset/test/X_test.txt")[Xfeatures]
activities_test<-read.table("./UCI HAR Dataset/test/Y_test.txt")
sub_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
test <- cbind(sub_test, activities_test, f_test)

#Q1 : test_train is the merge of the train and test sets
TestTrain <- rbind(train, test)
colnames(TestTrain) <- c("subject", "activity", Xfeatures.names)


# turn activities & subjects into factors
TestTrain$activity <- factor(TestTrain$activity, levels = activity_names[,1], labels = activity_names[,2])
TestTrain$subject <- as.factor(TestTrain$subject)

TestTrain.melted <- melt(TestTrain, id = c("subject", "activity"))
TestTrain.mean <- dcast(TestTrain.melted, subject + activity ~ variable, mean)

write.table(TestTrain.mean, "New_and_tidy.txt", row.names = FALSE, quote = FALSE)
