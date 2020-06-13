# Read in trainings tables:
xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Read in testing tables:
xtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Read in feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Read in activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# Assign Column Names
colnames(xtrain) <- features[,2] 
colnames(ytrain) <-"activityId"
colnames(subjecttrain) <- "subjectId"
colnames(xtest) <- features[,2] 
colnames(ytest) <- "activityId"
colnames(subjecttest) <- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

# 1 set to rule them all
mrgtrain <- cbind(ytrain, subjecttrain, xtrain)
mrgtest <- cbind(ytest, subjecttest, xtest)
setAllInOne <- rbind(mrgtrain, mrgtest)

#Readin Column Names
colNames <- colnames(setAllInOne)

#Vectoring
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean" , colNames) | 
                   grepl("std" , colNames) 
)
#subset
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)
#Create tidy
TidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
TidySet <- TidySet[order(TidySet$subjectId, TidySet$activityId),]

write.table(TidySet, "TidySet.txt", row.name=FALSE)
