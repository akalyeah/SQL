# Week 1 - Data Cleaning and Preliminary Analysis with R

# 1. Load dataset
data <- read.csv("titanic.csv", stringsAsFactors = FALSE)

# 2. Initial inspection
head(data)
str(data)
summary(data)
dim(data)
colSums(is.na(data))

# 3. Remove Cabin because of too many missing values
data$Cabin <- NULL

# 4. Handle missing values
data$Age[is.na(data$Age)] <- median(data$Age, na.rm = TRUE)

mode_embarked <- names(sort(table(data$Embarked), decreasing = TRUE))[1]
data$Embarked[is.na(data$Embarked)] <- mode_embarked

# 5. Check duplicates
sum(duplicated(data))
data <- data[!duplicated(data), ]

# 6. Outlier detection for Fare
Q1 <- quantile(data$Fare, 0.25)
Q3 <- quantile(data$Fare, 0.75)
IQR_value <- IQR(data$Fare)

lower_bound <- Q1 - 1.5 * IQR_value
upper_bound <- Q3 + 1.5 * IQR_value

outliers <- data[data$Fare < lower_bound | data$Fare > upper_bound, ]

boxplot(data$Fare, main = "Fare Outlier Check")

# 7. Normalize Age and Fare
normalize <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

data$Age_Normalized <- normalize(data$Age)
data$Fare_Normalized <- normalize(data$Fare)

# 8. Encode categorical variables
data$Sex <- as.factor(data$Sex)
data$Embarked <- as.factor(data$Embarked)

# 9. Basic visualizations
hist(data$Age, breaks = 25,
     main = "Age Distribution",
     xlab = "Age")

survival_by_sex <- aggregate(Survived ~ Sex, data = data, FUN = mean)
survival_by_class <- aggregate(Survived ~ Pclass, data = data, FUN = mean)

# 10. Correlation
numeric_data <- data[, c("Survived", "Pclass", "Age", "SibSp", "Parch", "Fare")]

round(cor(numeric_data, use = "complete.obs"), 2)