## https://rstudio-pubs-static.s3.amazonaws.com/37290_8e5a126a3a044b95881ae8df530da583.html
##https://rpubs.com/sustainabu/datacleaning_project
## https://github.com/deduce/Getting-and-Cleaning-Data-Project/blob/master/run_analysis.R
##https://rpubs.com/Jb_2823/55939
## Get downloaded file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Dataset.zip",method="auto")

##unzip file
unzip(zipfile="./Dataset.zip",exdir="./data")

##create dataset
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

##Merges the training and the test sets to create one data set.
##To get into table
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

## Read all tables
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

## Create variables for each dataset
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
head(dataSubject)

## Merge tables together
dataCombine <- cbind(dataSubject, dataActivity)
dataCombine2 <- cbind(dataFeatures, dataCombine)
head(dataFeaturesNames$V2)


##Extracts only the measurements on the mean and standard deviation for each measurement. 
dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeaturesNames$V2,value=TRUE)

# Taking only measurements for the mean and standard deviation and add "subject","activityNum"
dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)

str(dataFeaturesMeanStd)
head(dataFeaturesMeanStd)


##selecting using the featuresname
selectedNames<-c(as.character(dataFeaturesMeanStd), "subject", "activity" )
Datafeafin <- subset(dataCombine2,select=selectedNames)

str(Datafeafin)
head(Datafeafin)

##Uses descriptive activity names to name the activities in the data set
##get activity labels table
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
library(dplyr)
activityLabels2 <- rename(activityLabels, activity= V1, activitynames = V2)
str(activityLabels2)
head(activityLabels2)

##enter name of activity into dataTable
dataTable <- merge(activityLabels2, Datafeafin , by="activity", all.x=TRUE)
str(dataTable)
head(dataTable)
names(dataTable)

##Appropriately labels the data set with descriptive variable names.
##give name to each dataset
names(dataTable) <- gsub("Acc", "Accelerator", names(dataTable))
names(dataTable) <- gsub("Mag", "Magnitude", names(dataTable))
names(dataTable) <- gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable) <- gsub("^t", "time", names(dataTable))
names(dataTable) <- gsub("^f", "frequency", names(dataTable))
names(dataTable)

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(dataTable, "TidyDatatest.txt", row.name=FALSE)




