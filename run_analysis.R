# The first thing I did was putting all the txt files under the same paste
# By doing that I would not need to further specify where inside the directory...
# the R software was supposed to look for the file.

getwd()

# The first step now is to get the training set
training = read.table ('X_train.txt')

# Now I have to add the variable that indicate me which kind of activity is being performed
# As the training table has 561 columns, I specify I want this variable to be added..
# in the 562th column (this means I'm creating a new column)
training[,562] = read.table ('y_train.txt')

# Now I have to add the variable that indicates the person who's performing the activity
# Just like the last example, I will create a new column for that
training[,563] = read.table ('subject_train.txt')

# For making sure everything is correct
View(training)

# Now we repeat the same steps for the testing set
testing = read.table ('X_test.txt')
testing[,562] = read.table ('y_test.txt')
testing[,563] = read.table ('subject_test.txt')
View(testing)

# Loading the activity labels into R
Activity = read.table ('activity_labels.txt')
View(Activity)

# Loading the features into R
Features = read.table ('features.txt')
View(Features)

# MERGING THE DATA
# For that to be done, it is necessary to merge by rows, just as following:
FullData = rbind (training, testing)
View(FullData)

# As I want to extract only the measurements on the mean and standard deviation for each measurement
Measurements = grep ('.*-mean.*|.*-std.*', Features[,2])
View(Measurements)

# From that, I remove the the items I do not want to calculate in the Features matrix
Features = Features[Measurements,]
View(Features)

# Now, I insert the Activity and the Labels columns into the Measurements
Measurements = c(Measurements, 562, 563)
View(Measurements) 

# Now, I'm ready to remove all the columns that are not needed in the full data
FullData = FullData[,Measurements]
View (FullData)

# Here I tried to rename the columns in the FullData matrix, but somethign was going wrong
# I discovered I had the structure of the features as follows
Features[,2] = gsub ('-mean', 'Mean', Features [,2])
Features[,2] = gsub ('-std', 'Std', Features [,2])
Features[,2] = gsub ('[-()]', '', Features [,2])
View(Features)

# Then I could rename the columns
colnames(FullData) = c (Features$V2, 'Activity', 'Subject')
View(FullData)

# Next I labeled the Acitivy column accordingly
# Probably there is a better way for doing this, but i could not figure it out
FullData$Activity = gsub(1, Activity$V2[1], FullData$Activity) 
FullData$Activity = gsub(2, Activity$V2[2], FullData$Activity)
FullData$Activity = gsub(3, Activity$V2[3], FullData$Activity)
FullData$Activity = gsub(4, Activity$V2[4], FullData$Activity)
FullData$Activity = gsub(5, Activity$V2[5], FullData$Activity)
FullData$Activity = gsub(6, Activity$V2[6], FullData$Activity) 
View(FullData)

# Now I just transform the class of the variables Activity and Subject to be factors
FullData$Activity <- as.factor(FullData$Activity) 
FullData$Subject <- as.factor(FullData$Subject) 

# Creating a document with a tidy data
TidyData = aggregate(FullData, by=list(Activity = FullData$Activity, Subject=FullData$Subject), mean)

# Writing the Table
write.table(TidyData, "TidyData.txt", sep="\t", row.name=FALSE)
