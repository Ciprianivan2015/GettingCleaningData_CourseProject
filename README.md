# GettingCleaningData_CourseProject

The **run_analysis.r** script extracts data from the train, test, activity and feature text files into dataframes. The script gets data only from **X_**, **Y_** and **subject_** files, for both **train** and **test**. It does not go into **Inertial** data.

First data is merged by column to relate **X** to **Y** to **Subject**, then by row to merge **train** and **test**
**Y** column is renamed to *Activity_ID*, **Subject** column is renamed to *Subject_ID*. 

Thanks to Activity_ID column, the merged dataframe can be joined with **activity** dataframe in order to receive a column of meaningful activity names.

Then, using grep() function in order to identify **feature** names having **-mean()** or **-std()**, two vectors of indices are obtained. The indices are used to select only the *mean/std* columns of the merged dataframe. The columns are renamed to meaningful feature names, using the information from the feature dataframe. 

The "activity_ID" column is no longer necessary, so it is eliminated. 

Then, the well-named and well-filtered dataframe is grouped by activity and subject, then aggregation (mean) is computed by activity and subject. 

At the end, the aggregated dataframe is exported to txt file.
