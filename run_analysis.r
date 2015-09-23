#....................................................................................
# Step: 1 = Merge {train, test} {X,Y} into one dataset
# Extract into dataframes: 
#   X_train
#   Y_train
#   X_test
#   Y_test
#
# Extract: 
#  - "features" vector
#  - "activity_labels"
#  
#....................................................................................


library(dplyr)

my_path = getwd()

#___________ Extract into dataframes: Y_train, X_train,Y_test, X_test _______________  
#..........................   TRAIN .........................................
my_file = "/train/Y_train.txt"
complete_path = paste(my_path, my_file, sep = "")
mydf_Y_train = read.table( complete_path, header = FALSE )
colnames(mydf_Y_train) = "Activity_ID"

my_file = "/train/X_train.txt"
complete_path = paste(my_path, my_file, sep = "")
mydf_X_train = read.table( complete_path, header = FALSE )

my_file = "/train/subject_train.txt"
complete_path = paste(my_path, my_file, sep = "")
mydf_subject_train = read.table( complete_path, header = FALSE )
colnames(mydf_subject_train) = "Subject_ID"


#..........................   TEST .........................................
my_file = "/test/Y_test.txt"
complete_path = paste(my_path, my_file, sep = "")
mydf_Y_test = read.table( complete_path, header = FALSE )
colnames(mydf_Y_test) = "Activity_ID"


my_file = "/test/X_test.txt"
complete_path = paste(my_path, my_file, sep = "")
mydf_X_test = read.table( complete_path, header = FALSE )

my_file = "/test/subject_test.txt"
complete_path = paste(my_path, my_file, sep = "")
mydf_subject_test = read.table( complete_path, header = FALSE )
colnames(mydf_subject_test) = "Subject_ID"


# dim( mydf_X_test )
# dim( mydf_Y_test )
# dim( mydf_X_train )
# dim( mydf_Y_train )
# ....................... Merge ................................................
mydf_XYsubject_test = cbind.data.frame(mydf_X_test, mydf_Y_test, mydf_subject_test)
mydf_XYsubject_train = cbind.data.frame(mydf_X_train, mydf_Y_train, mydf_subject_train)

mydf_XY_train_test_merged = rbind.data.frame(mydf_XYsubject_train, mydf_XYsubject_test)

#___________ clean temporary variables ____________________
rm(list = c("mydf_X_test", "mydf_Y_test", "mydf_X_train", "mydf_Y_train", "mydf_XYsubject_train", "mydf_XYsubject_test", "mydf_subject_test", "mydf_subject_train"))
#colnames(mydf_XY_train_test_merged)


# _______________ Step: 3 Use descriptive activity names ____________________________
#........... extract activity names ..................................
my_file = "/activity_labels.txt"
complete_path = paste(my_path, my_file, sep = "")
mydf_activity_labels = read.table( complete_path, header = FALSE )

# ............... Rename the columns .......................
colnames( mydf_activity_labels )[ 1 ] = "Activity_ID"
colnames( mydf_activity_labels )[ 2 ] = "Activity_Name"

#............... Attach activity names ..............................
mydf_XY_train_test_merged = 
  inner_join( x = mydf_XY_train_test_merged, y = mydf_activity_labels 
              , by = "Activity_ID")

#mydf_XY_train_test_merged$Activity_Name

# _______________ Step: 2 Extract only Mean and SD for each measurement __________
my_file = "/features.txt"
complete_path = paste(my_path, my_file, sep = "")
mydf_features = read.table( complete_path, header = FALSE ) 
# ..................... identify the features with {"-mean()", "-std()"} in the name ..............
vector_features_id_mean = grep(pattern= "-mean()", x = as.character(mydf_features$V2), value = FALSE )
vector_features_id_std = grep(pattern= "-std()", x = as.character(mydf_features$V2)  , value = FALSE )

# ............. Extract only Mean and SD for each measurement  ...............................
mydf_features_mean_sd = filter(mydf_features, is.element(mydf_features$V1, vector_features_id_mean) 
                                            | is.element(mydf_features$V1, vector_features_id_std) )

rm(list = c("vector_features_id_mean", "vector_features_id_std"))

mydf_XY_train_test_merged_mean_std = select(mydf_XY_train_test_merged
                                            , c(mydf_features_mean_sd$V1, 562,563, 564))


# ________________  Step 4: Label the dataset with descriptive variable names __________________
colnames(mydf_XY_train_test_merged_mean_std)[1:(dim(mydf_XY_train_test_merged_mean_std)[2] - 3) ]= as.character( mydf_features_mean_sd$V2 )
mydf_XY_train_test_merged_mean_std = select(mydf_XY_train_test_merged_mean_std, -80)
#colnames(mydf_XY_train_test_merged_mean_std)
rm(list = c("mydf_XY_train_test_merged", "mydf_features", "mydf_features_mean_sd", "mydf_activity_labels"))
#head(mydf_XY_train_test_merged_mean_std)


# _______________  Step 5:  Create an independent tidy dataset .............................
df_gr = group_by(.data= mydf_XY_train_test_merged_mean_std, Subject_ID, Activity_Name, add= F)
df_gr_ag =  aggregate.data.frame(x=df_gr, by=list(Subject_ID = df_gr$Subject_ID , Activity_Name = df_gr$Activity_Name ), FUN = mean)
rm("df_gr")
df_gr_ag = df_gr_ag[c(2,1,3:81) ]

write.table(x= df_gr_ag, file="output.txt", row.names= FALSE)

rm(list = c("mydf_XY_train_test_merged_mean_std", "complete_path", "my_file", "my_path") )
