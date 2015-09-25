## ITEM 1: Merge {train, test} to create one dataset 
Variables:
* my_path = stores the result of "getwd()", the fixed part of paths needed to extract data from "txt" files into "R dataframes" 
* my_file = the variable part of the path, re-used for each case: {X,Y,subject} x {train,test} + activity_labels + features
* complete_path = my_path + my_file
* mydf_Y_train = dataframe for data extracted from "/train/Y_train.txt"
* "mydf_X/Y/subject_train/test" = dataframes for all combinations {X,Y,subject} x {train,test}

### After data is extracted into "mydf_X/Y/subject_train/test":
* columns in "Y" dataframes are renamed to "Activity_ID"
* columns in "subject" dataframes are renamed to "Subject_ID" in order to facilitate "join" with activity_labels

### Merging all six dataframes into one dataset:
* By columns (using cbind()):
	* mydf_XYsubject_test  = merge(X,Y,subject) for "test" dataframes 
	* mydf_XYsubject_train = merge(X,Y,subject) for "train" dataframes
* By rows(using rbind()):
	* mydf_XYsubject_train_test_merged  = merge( mydf_XYsubject_train, mydf_XYsubject_test ) by rows


## ITEM 3: use descriptive activity names 
* mydf_activity_labels = dataframe for data extracted from "/activity_labels.txt"
* Columns are renamed: to {Activity_ID, Activity_Name} 
* "mydf_XYsubject_train_test_merged" receives the newcolumn "Activity_Name", thanks to joining with *mydf_activity_labels*


## ITEM: 2 Extract only Mean and SD for each measurement  
* mydf_features = dataframe for data extracted from "/features.txt"
* The column of "feature/variable" names is then used inside grep() function as a vector of strings. 
* The output of grep() are two vectors, containing the indices of features "features" with "-mean()" in the name
* vector_features_id_mean = a vector returned by grep() with the positions inside the Char_Vector of those "features" with "-mean()" in the name
* vector_features_id_std  = a vector returned by grep() with the positions inside the Char_Vector of those "features" with "-std()" in the name
* mydf_features_mean_std = the filtered dataframe, having only "mean/std" features
* mydf_XYsubject_train_test_merged_mean_std = the dataframes with only the feature columns whose ID's where identified above + {activity(ID, Name); Subject}
* Now, the merged dataset has all the "mean/std" features + {activity(ID, Name); Subject}, but "feature" columns are not properly labeled.

##  ITEM 4: Label the dataset with descriptive variable names 
* Using colnames()[], the "feature" columns of "mydf_XYsubject_train_test_merged_mean_std" are renamed using the second column of "mydf_features_mean_std"
* From the dataframe above, I eliminate the activity_ID as it is no longer necesary.


## ITEM 5:  Create an independent tidy dataset 
* df_tidy_gr = dataframe, grouped_by : Subject_ID, Activity_Name      
* df_tidy_gr_ag = dataframe with aggregate(MEAN) for : Subject_ID, Activity_Name      
 *  this dataframe is sent as output to "output.txt"
      
      
