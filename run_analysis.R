## Part 1 : Merges the training and the test sets to create one data set.
## Get downloaded file
filetodownload <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(filetodownload,destfile="./Dataset.zip",method="auto")

## Unzip file
unzip(zipfile="./Dataset.zip",exdir="./data")

## Create dataset
path_file <- file.path("./data" , "UCI HAR Dataset")
filesall <- list.files(path_file, recursive=TRUE)

## To get into table
dataActivityTest  <- read.table(file.path(path_file, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_file, "train", "Y_train.txt"),header = FALSE)

dataSubjectTrain <- read.table(file.path(path_file, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_file, "test" , "subject_test.txt"),header = FALSE)

dataFeaturesTest  <- read.table(file.path(path_file, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_file, "train", "X_train.txt"),header = FALSE)

## Combine both files for each segment - train & test
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

## Rename variables for each dataset
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_file, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

## Merge all tables together
dataCombine <- cbind(dataSubject, dataActivity)
dataCombine2 <- cbind(dataFeatures, dataCombine)


## Part 2 : Extracts only the measurements on the mean and standard deviation for each measurement. 
dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeaturesNames$V2,value=TRUE)
str(dataFeaturesMeanStd)
head(dataFeaturesMeanStd)

# Selecting data only with mean and std using the featuresname
selectedNames<-c(as.character(dataFeaturesMeanStd), "subject", "activity" )
Datafeafin <- subset(dataCombine2,select=selectedNames)
str(Datafeafin)
head(Datafeafin)

## Part 3 : Uses descriptive activity names to name the activities in the data set
## Get activity labels table
activityLabels <- read.table(file.path(path_file, "activity_labels.txt"),header = FALSE)
library(dplyr)
activityLabels2 <- rename(activityLabels, activity= V1, activitynames = V2)
str(activityLabels2)
head(activityLabels2)

## Enter name of activity into dataTable
dataTable <- merge(activityLabels2, Datafeafin , by="activity", all.x=TRUE)
str(dataTable)
head(dataTable)
names(dataTable)

## Part 4 : Appropriately labels the data set with descriptive variable names.
## Give name to each dataset
names(dataTable) <- gsub("Acc", "Accelerator", names(dataTable))
names(dataTable) <- gsub("Mag", "Magnitude", names(dataTable))
names(dataTable) <- gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable) <- gsub("^t", "time", names(dataTable))
names(dataTable) <- gsub("^f", "frequency", names(dataTable))
names(dataTable)

## Part 5 : From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(dataTable, "TidyData.txt", row.name=FALSE)




