## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
 
library(data.table)
library(reshape2)
# Load the provided data, merge the training and test sets to create one data set:
activity_labels <- read.table("P:/R/activity_labels.txt")[,2]
features <- read.table("P:/R/UCI HAR Dataset/features.txt")[,2]
extract_features <- grepl("mean|std", features)

X_test <- read.table("P:/R/X_test.txt")
y_test <- read.table("P:/R/test/y_test.txt")
subject_test <- read.table("P:/R/test/subject_test.txt")
names(X_test) = features
                            
                            # Extract only the measurements on the mean and standard deviation for each measurement.
                            X_test = X_test[,extract_features]
                            
                            
                            
                            # Load activity labels
                            y_test[,2] = activity_labels[y_test[,1]]
                            names(y_test) = c("Activity_ID", "Activity_Label")
                            names(subject_test) = "subject"
                            
                            # Combine data file
                            test_data <- cbind(as.data.table(subject_test), y_test, X_test)
                            
                            
                            X_train <- read.table("P:/R/train/X_train.txt")
                            y_train <- read.table("P:/R/train/y_train.txt")
                            
                            subject_train <- read.table("P:/R/train/subject_train.txt")
                            
                            names(X_train) = features
                            
                            
                            X_train = X_train[,extract_features]
                            
                            # Load activity data
                            y_train[,2] = activity_labels[y_train[,1]]
                            names(y_train) = c("Activity_ID", "Activity_Label")
                            names(subject_train) = "subject"
                            
                            
                            train_data <- cbind(as.data.table(subject_train), y_train, X_train)
                            
                            # Compare test and train data
                            data = rbind(test_data, train_data)
                            
                            id_labels = c("subject", "Activity_ID", "Activity_Label")
                            data_labels = setdiff(colnames(data), id_labels)
                            melt_data = melt(data, id = id_labels, measure.vars = data_labels)
                            
                            
                            tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)
                            
                            write.table(tidy_data, file = "P:/R/tidy_data_file.txt")
                            
                            