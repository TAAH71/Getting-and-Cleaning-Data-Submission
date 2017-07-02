#Load up the reshape library needed for the final step

install.packages("reshape2"); library(reshape2)

# Download relevant data sets from URL and read in unzipped data files

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)

data_x_train <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
data_y_train <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))
data_x_test <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))
data_y_test <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
data_s_train <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))
data_s_test <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))

# 1.Merges the training and the test sets to create one data set.

data_x <- rbind(data_x_train,data_x_test)
data_y <- rbind(data_y_train,data_y_test)
data_s <- rbind(data_s_train,data_s_test)

colnames(data_y) <- "Activity"
colnames(data_s) <- "Subject"

# 2.Extracts only the measurements on the mean and standard deviation for each measurement

# Read in variable labels and add tidy titles

labels <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))
label_names <- c("index", "vblname")
colnames(labels) <- label_names

# Create an index of all variables with mean() and std() in the title

extract <- grep("mean\\(\\)|std\\(\\)",labels$vblname)

# Use index to extract the required measures

e_data_x <- data_x[,extract]
extract_names <- labels[extract,]
colnames(e_data_x) <- extract_names[,2]

# 3.Uses descriptive activity names to name the activities in the data set

# Get activity labels add useful lables

activity_labels <- read.table(unz(temp,"UCI HAR Dataset/activity_labels.txt"))
colnames(activity_labels) <- c("act_ind","act_label")

# Change acivity indicators to activity names using labels

data_y[,1] = activity_labels[data_y[,1],2]

# Combine all data sets

all_data <- cbind(e_data_x,data_y,data_s)

# 4.Appropriately labels the data set with descriptive variable names. 

n_all_data <- gsub ("tBody", "timebody", names(all_data), ignore.case=FALSE)
n_all_data <- gsub ("tGravity", "timegravity", n_all_data, ignore.case=FALSE)
n_all_data <- gsub ("Mag", "Magnitude", n_all_data, ignore.case=FALSE)
n_all_data <- gsub ("Gyro", "Gyroscope", n_all_data, ignore.case=FALSE)
n_all_data <- gsub ("Acc", "Accelerometer", n_all_data, ignore.case=FALSE)
n_all_data <- gsub ("fBody", "fastFourierTransformBody", n_all_data, ignore.case=FALSE)
n_all_data <- gsub ("Freq", "Frequency", n_all_data, ignore.case=FALSE)
n_all_data <- gsub ("BodyBody", "Body", n_all_data, ignore.case=FALSE)

colnames(all_data) <- n_all_data

# 5.From the data set in step 4, creates a second, independent tidy data
# set with the average of each variable for each activity and each subject.

# Start by melting data using Activity and Subject as ids to create a long
# list of variables by activity and subject.

melteddata <- melt(all_data,id=c("Activity","Subject"))

# Then reshape the melted data and calculate the average of the activity and subject for each variable

final_data <- dcast(melteddata, Activity+Subject ~ variable, mean)

# Finally, save as a CSV file.

write.table(final_data, "finaldata.txt", row.names=FALSE)
