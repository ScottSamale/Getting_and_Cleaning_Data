# CodeBook for Coursera Data Science

`README.md` file of this repository for background information on this data set

## Variables <a name="variables"></a>

Each row contains 79 mean signal measurements

### Identifiers <a name="identifiers"></a>

- `Subject`

	Subject identifier, integer, ranges from 1 to 30

- `Activity`

	Activity identifier, string with 6 possible values: 
	- `WALKING`: Subject was walking
	- `WALKING_UPSTAIRS`: Subject was walking upstairs
	- `WALKING_DOWNSTAIRS`: Subject was walking downstairs
	- `SITTING`: Subject was sitting down
	- `STANDING`: Subject was standing up 
	- `LAYING`: Subject was laying down

## Transformations <a name="transformations"></a>

The zip file containing the source data is located at [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The following transformations were applied to the source data:

 -The training and test datasets were merged into one Master File
 -The measurements on the mean and standard deviation were extracted on each measurement
 -The activity labels (numbers) were replaced with activity names (strings)
 -The variable names were replaced with descriptive variable names
 -After Step 4, the final dataset was made using an average of each variable for each activity and each subject
