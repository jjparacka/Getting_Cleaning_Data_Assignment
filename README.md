# Getting Cleaning Data Assignment

## How it works - run_analysis.R

### Source data
The source data for the script includes the following files 
1. activity_labels.txt
2. features.txt
3. \test\subject_test.txt
4. \test\X_test.txt
5. \test\y_test.txt
6. \train\subject_train.txt
7. \train\X_train.txt
8. \train\y_train.txt

The above files are expected to be in a folder named "UCI HAR Dataset" in the working directory

### initializing required libraries
the R packages dplyr and reshape2 are used in the script. It is assumed that these packages are already installed. 

### Downloading source data 
Source data is downloaded from the URL https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Download is done only if the file Dataset.zip is not present in the working directory. 
After the file is downoaded it is unzipped into the working directory

### Reading source data 
The read.table function is used to read all the required data into R. All 8 files mentioned above are read

### Labeling the data set
Data from files "subject_train" and "subject_test" are named as "subject_id"
Data from files "y_train" and "y_test" are named as "activity_id"
Data from files "X_train" and "X_test" are named as per the fied names provided in the file features.txt

Note: the naming of fields can also be done as part of read.table by using the col.names parameter. It is done explicitly for sake of clarity

### Combining the data
used cbind function to combine the columns of subject_train, y_train and x_train. This creates the complete data set for the training set. Similarly create the complete dataset for test.

used rbind to combine the rows of train and test data sets.

### Making the tidy dataset
replace the activity_id with the activity description by using the merge function to merge the "activities" data on the field "activity_id"
After merging remove the "activity_id" file since this is now duplicate information 

### Melting the data
- subject_ID and activity_desc are converted into factor variables. 
- using the grep function on the features data, select the columns that have "means()" or "std()" in the name. Note that there is explicit check for the strings to exclude fields like "meanFreq"
- melt the complete data set with activity_desc and subject_id as the ids and all the selected mean and std field as variables
- from the melted data create a tidy data set by applying the "mean" function over the variables 
- write the tidydata into a file tidydata.txt using the write.table function 
- 


