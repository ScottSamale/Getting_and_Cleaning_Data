###
### Loading Packages
###

library(data.table)
library(reshape2)

###
### Retrieving Data
###

path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")


###
### Reading in Features and Activity Labels and Extracting Mean/Standard Deviation
###

Activity_Labels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt")
                        , col.names = c("Labels", "Activity_Name"))

Features <- fread(file.path(path, "UCI HAR Dataset/features.txt")
                  , col.names = c("index", "featureNames"))
Selected_Features <- grep("(mean|std)\\(\\)", Features[, featureNames])

Measurements <- Features[Selected_Features, featureNames]
Measurements <- gsub('[()]', '', Measurements)


###
### Reading in Training Data and Binding the Tables
###

Training_Data <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, Selected_Features, with = FALSE]
data.table::setnames(Training_Data, colnames(Training_Data), Measurements)
TrainingActivity_Data <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt")
                         , col.names = c("Activity"))
TrainingSubjects_Data <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt")
                       , col.names = c("Subject"))
Training_Final <- cbind(TrainingSubjects_Data, TrainingActivity_Data, Training_Data)

###
### Reading in Test Data and Binding the Tables
###

Test_Data <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, Selected_Features, with = FALSE]
data.table::setnames(Test_Data, colnames(Test_Data), Measurements)
TestActivity_Data <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt")
                        , col.names = c("Activity"))
TestSubjects_Data <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")
                      , col.names = c("Subject"))
Test_Final <- cbind(TestSubjects_Data, TestActivity_Data, Test_Data)


###
### Merging Training and Test Data
###

Activity_MasterFile <- rbind(Training_Final, Test_Final)


###
### Properly Label the Activites
###

Activity_MasterFile$Activity <- factor(Activity_MasterFile$Activity, 
                                       levels = Activity_Labels[["Labels"]], labels = Activity_Labels[["Activity_Name"]])


###
### Fetch Column Names to Label Variable Names
###

Activity_MasterFile_Cols <- colnames(Activity_MasterFile)


### Get Rid of some Specials

Activity_MasterFile_Cols <- gsub("[\\(\\)-]", "", Activity_MasterFile_Cols)


### Gsub for Cleaning the Names

Activity_MasterFile_Cols <- gsub("Acc", "Accelerometer", Activity_MasterFile_Cols)
Activity_MasterFile_Cols <- gsub("Freq", "Frequency", Activity_MasterFile_Cols)
Activity_MasterFile_Cols <- gsub("^f", "Frequency_Domain", Activity_MasterFile_Cols)
Activity_MasterFile_Cols <- gsub("Gyro", "Gyroscope", Activity_MasterFile_Cols)
Activity_MasterFile_Cols <- gsub("Mag", "Magnitude", Activity_MasterFile_Cols)
Activity_MasterFile_Cols <- gsub("mean", "Mean", Activity_MasterFile_Cols)
Activity_MasterFile_Cols <- gsub("std", "Standard_Deviation", Activity_MasterFile_Cols)
Activity_MasterFile_Cols <- gsub("^t", "Time_Domain", Activity_MasterFile_Cols)

### Adding new names into MasterFile

colnames(Activity_MasterFile) <- Activity_MasterFile_Cols


###
### Tidy File with a Group By using a chaining operator to summarise and write to a table
###

Activity_MasterFile_Means <- Activity_MasterFile %>% 
    group_by(Subject, Activity) %>%
    summarise_each(funs(mean))

write.table(Activity_MasterFile_Means, "Final_Tidy_Dataset", row.names = FALSE, 
            quote = FALSE)
