This Code Book describes the variables, the data, and any transformations or work that was performed to clean up the data collected
when downloading the file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, a file containing
wearable device data.

Training and test data were combined and variables "Activity" and "Subject" were added to a single file to allow for subsequent data
transformations.

Variable names were taken from the "features" file and used to name the combined data set.

These were amended to provide more meaningful titles.

Activities numbers were changed to descrtiptive text.

Finally, the data table was melted down by Activity and Subject and averages taken and saved into "final.data.csv".
