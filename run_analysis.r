


library(dplyr)
my_path = getwd()
# ________________  ITEM 1: Merges taining with test datasets _________________________________
# .... Extract into dataframes: Y_train, X_train, subject_train ,Y_test, X_test, subject_test 
# .... rename columns for readability and for facilitating joins afterwards .............
#..........................   TRAIN .....................................................
      my_file = "/train/Y_train.txt"
      complete_path = paste(my_path, my_file, sep = "")
      mydf_Y_train = read.table( complete_path, header = FALSE )
      colnames(mydf_Y_train)[ 1 ] = "Activity_ID"
      
      my_file = "/train/X_train.txt"
      complete_path = paste(my_path, my_file, sep = "")
      mydf_X_train = read.table( complete_path, header = FALSE )
      
      my_file = "/train/subject_train.txt"
      complete_path = paste(my_path, my_file, sep = "")
      mydf_subject_train = read.table( complete_path, header = FALSE )
      colnames(mydf_subject_train)[ 1 ] = "Subject_ID"

#..........................   TEST .........................................
      my_file = "/test/Y_test.txt"
      complete_path = paste(my_path, my_file, sep = "")
      mydf_Y_test = read.table( complete_path, header = FALSE )
      colnames(mydf_Y_test)[ 1 ] = "Activity_ID"      
      
      my_file = "/test/X_test.txt"
      complete_path = paste(my_path, my_file, sep = "")
      mydf_X_test = read.table( complete_path, header = FALSE )
      
      my_file = "/test/subject_test.txt"
      complete_path = paste(my_path, my_file, sep = "")
      mydf_subject_test = read.table( complete_path, header = FALSE )
      colnames(mydf_subject_test)[ 1 ] = "Subject_ID" 

# dim( mydf_X_test )
# dim( mydf_Y_test )
# dim( mydf_X_train )
# dim( mydf_Y_train )
# ....................... Merge ................................................
      mydf_XYsubject_test = cbind.data.frame(mydf_X_test, mydf_Y_test, mydf_subject_test)
      mydf_XYsubject_train = cbind.data.frame(mydf_X_train, mydf_Y_train, mydf_subject_train)      
      mydf_XYsubject_train_test_merged = rbind.data.frame(mydf_XYsubject_train, mydf_XYsubject_test)
      #........... clean temporary variables ...........
      rm(list = c("mydf_X_test", "mydf_Y_test", "mydf_X_train", "mydf_Y_train", "mydf_XYsubject_train", "mydf_XYsubject_test", "mydf_subject_test", "mydf_subject_train"))




# _______________ ITEM: 3 Use descriptive activity names ____________________________
      #........... extract activity names ..................................
      my_file = "/activity_labels.txt"
      complete_path = paste(my_path, my_file, sep = "")
      mydf_activity_labels = read.table( complete_path, header = FALSE )
      # ............... Rename the columns .......................
      colnames( mydf_activity_labels )[ 1 ] = "Activity_ID"
      colnames( mydf_activity_labels )[ 2 ] = "Activity_Name"
      #............... Attach activity names ..............................
      mydf_XYsubject_train_test_merged = inner_join( x = mydf_XYsubject_train_test_merged, y = mydf_activity_labels, by = "Activity_ID")


# _______________ ITEM: 2 Extract only Mean and SD for each measurement __________
      my_file = "/features.txt"
      complete_path = paste(my_path, my_file, sep = "")
      mydf_features = read.table( complete_path, header = FALSE ) 
      # ..................... identify the ID's for the features with {"-mean()", "-std()"} in the name ..............
      vector_features_id_mean = grep(pattern= "-mean()", x = as.character(mydf_features$V2), value = FALSE )
      vector_features_id_std = grep(pattern= "-std()", x = as.character(mydf_features$V2)  , value = FALSE )
      mydf_features_mean_std = filter(mydf_features, is.element(mydf_features$V1, vector_features_id_mean) 
                                                   | is.element(mydf_features$V1, vector_features_id_std) )

      # ............. FILTER only the columns whose ID's where identified above  ...............................
      mydf_XYsubject_train_test_merged_mean_std = select(mydf_XYsubject_train_test_merged, c(mydf_features_mean_std$V1, 562,563, 564))
      #........... clean temporary variables ...........
      rm(list = c("vector_features_id_mean", "vector_features_id_std"))


# ________________  ITEM 4: Label the dataset with descriptive variable names __________________
      colnames(mydf_XYsubject_train_test_merged_mean_std)[1:(dim(mydf_XYsubject_train_test_merged_mean_std)[2] - 3) ]= as.character( mydf_features_mean_std$V2 )
      #............ Filter out the "Activity_ID" column .........................................
      mydf_XYsubject_train_test_merged_mean_std = mydf_XYsubject_train_test_merged_mean_std[, -which(names(mydf_XYsubject_train_test_merged_mean_std) %in% c("Activity_ID"))]
      rm(list = c("mydf_XYsubject_train_test_merged", "mydf_features", "mydf_features_mean_std", "mydf_activity_labels"))



# _______________  ITEM 5:  Create an independent tidy dataset _____________________________________________
      # ............... group_by: Subject_ID, Activity_Name ...............................
      df_tidy_gr = group_by(.data= mydf_XYsubject_train_test_merged_mean_std, Subject_ID, Activity_Name, add= F)
      # ............... aggregate(MEAN) for : Subject_ID, Activity_Name ...................
      df_tidy_gr_ag = aggregate.data.frame( x = df_tidy_gr, by=list(Subject_ID = df_tidy_gr$Subject_ID , Activity_Name = df_tidy_gr$Activity_Name ), FUN = mean)
      # ............... rearrange the first two columns .....................................
      df_tidy_gr_ag = df_tidy_gr_ag[c(2,1,3:81) ]
      
      dim(df_tidy_gr_ag)
      
      write.table(x= df_tidy_gr_ag, file="output.txt", row.names= FALSE)
      #........... clean temporary variables ...........
      rm(list = c("mydf_XYsubject_train_test_merged_mean_std", "complete_path", "my_file", "my_path", "df_tidy_gr") )















