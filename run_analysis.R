library(dplyr)

rd <- function(file, col = numeric()){
  scan(file) %>%
    matrix(ncol = col,  byrow = TRUE) %>%
    as.data.frame(stringAsFactors = FALSE)
}

label <- function(df){
  mutate(df, activity_label = ifelse(activity_id == 1, "WALKING",
                                              ifelse(activity_id == 2, "WALKING_UPSTAIRS",
                                                    ifelse(activity_id == 3, "WALKING_DOWNSTAIRS",
                                                           ifelse(activity_id == 4, "SITTING",
                                                                  ifelse(activity_id == 5, "STANDING", "LAYING"))))), .after = activity_id)
}

setwd("./data/train")
x_train <- rd("X_train.txt", 561)
y_train <- rd("y_train.txt", 1)
sub_train <- rd("subject_train.txt", 1)

setwd("../")
setwd("./test")
x_test <- rd("X_test.txt", 561)
y_test <- rd("y_test.txt", 1)
sub_test <- rd("subject_test.txt", 1)

xdata <- rbind(x_train, x_test)
ydata <- rbind(y_train, y_test)
subdata <- rbind(sub_train, sub_test)

setwd("../")
ft <- read.table("features.txt", sep = " ")
ft[[1]] <- NULL
names(xdata) <- t(ft)

data <- cbind(subdata, ydata, xdata)
names(data)[1:2] <- c("participant_id", "activity_id")

mean_v <- grep("mean", names(data))
meandata <- data[,mean_v]
std_v <- grep("std", names(data))
stddata <- data[,std_v]
extractdata <- cbind(data[,1:2],meandata, stddata)

data <- label(extractdata)
data <- arrange(data, participant_id, activity_id)
names(data) <- gsub("-", "_", names(data))
names(data) <- gsub("\\(\\)", "", names(data))

data <- group_by(data, participant_id, activity_id)
sumdata <- summarize(data, across(everything() & !activity_label, mean))
names(sumdata) <- gsub("_1", "", names(sumdata))
sumdata <- label(sumdata)
colnames(sumdata)[4:82] <- paste("mean", colnames(sumdata)[4:82], sep = "_")

rm(rd, label, ft, x_train, x_test, y_train, y_test, sub_train, sub_test, xdata, ydata, subdata, mean_v, std_v, meandata, stddata, extractdata)
setwd("../")
write.table(data, file = "tidy.txt", sep = " ", row.names = FALSE)
write.table(sumdata, file = "tidy_mean.txt", sep = " ", row.names = FALSE)