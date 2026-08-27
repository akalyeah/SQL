# Week 4 - Comprehensive Data Analysis with R
# Dataset: Titanic passenger dataset

# Install packages if required
# install.packages(c("ggplot2", "caret", "pROC"))

library(ggplot2)
library(caret)
library(pROC)

# Load dataset
data <- read.csv("titanic.csv", stringsAsFactors = FALSE)

# --------------------------------
# 1. DATA CLEANING
# --------------------------------

# Remove Cabin because of extensive missing values
data$Cabin <- NULL

# Handle missing Age values
data$Age[is.na(data$Age)] <- median(
  data$Age,
  na.rm = TRUE
)

# Handle missing Embarked values
mode_embarked <- names(
  sort(table(data$Embarked), decreasing = TRUE)
)[1]

data$Embarked[is.na(data$Embarked)] <- mode_embarked

# Check and remove duplicates
sum(duplicated(data))

data <- data[!duplicated(data), ]

# Convert categorical variables
data$Sex <- as.factor(data$Sex)
data$Embarked <- as.factor(data$Embarked)
data$Survived <- as.factor(data$Survived)

# View cleaned data
summary(data)

# --------------------------------
# 2. DESCRIPTIVE ANALYSIS
# --------------------------------

# Dataset dimensions
dim(data)

# Missing values
colSums(is.na(data))

# Survival by Sex
survival_by_sex <- aggregate(
  Survived ~ Sex,
  data = data,
  mean
)

survival_by_sex$SurvivalRate <-
  survival_by_sex$Survived * 100

survival_by_sex

# Survival by Passenger Class
survival_by_class <- aggregate(
  Survived ~ Pclass,
  data = data,
  mean
)

survival_by_class$SurvivalRate <-
  survival_by_class$Survived * 100

survival_by_class

# --------------------------------
# 3. VISUALIZATION
# --------------------------------

# Age Distribution
ggplot(data, aes(x = Age)) +
  geom_histogram(bins = 30) +
  labs(
    title = "Age Distribution",
    x = "Age",
    y = "Count"
  )

# Fare Distribution
ggplot(data, aes(y = Fare)) +
  geom_boxplot() +
  labs(
    title = "Fare Distribution",
    y = "Fare"
  )

# Survival by Sex
ggplot(data, aes(x = Sex, fill = Survived)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Survival by Sex",
    x = "Sex",
    fill = "Survived"
  )

# Survival by Passenger Class
ggplot(
  data,
  aes(x = factor(Pclass), fill = Survived)
) +
  geom_bar(position = "dodge") +
  labs(
    title = "Survival by Passenger Class",
    x = "Passenger Class",
    fill = "Survived"
  )

# Age and Fare
ggplot(
  data,
  aes(x = Age, y = Fare, color = Survived)
) +
  geom_point(alpha = 0.6) +
  labs(
    title = "Age and Fare by Survival Outcome",
    color = "Survived"
  )

# --------------------------------
# 4. STATISTICAL ANALYSIS
# --------------------------------

# Welch t-test
fare_test <- t.test(
  Fare ~ Survived,
  data = data
)

fare_test

# Shapiro-Wilk normality test
set.seed(42)

age_sample <- sample(
  data$Age,
  500
)

shapiro.test(age_sample)

# Spearman correlation
numeric_data <- data[, c(
  "Age",
  "Fare",
  "SibSp",
  "Parch",
  "Pclass"
)]

cor(
  numeric_data,
  method = "spearman"
)

# --------------------------------
# 5. LOGISTIC REGRESSION
# --------------------------------

set.seed(42)

# Split data
index <- createDataPartition(
  data$Survived,
  p = 0.80,
  list = FALSE
)

train_data <- data[index, ]
test_data <- data[-index, ]

# Build model
model <- glm(
  Survived ~ Pclass + Sex + Age +
    SibSp + Parch + Fare + Embarked,
  data = train_data,
  family = binomial
)

summary(model)

# Predict survival probabilities
prob <- predict(
  model,
  test_data,
  type = "response"
)

# Convert probabilities into classes
pred_class <- ifelse(
  prob >= 0.5,
  1,
  0
)

pred_class <- as.factor(pred_class)

# --------------------------------
# 6. MODEL EVALUATION
# --------------------------------

# Confusion Matrix
confusionMatrix(
  pred_class,
  test_data$Survived
)

# ROC Curve
roc_obj <- roc(
  as.numeric(
    as.character(test_data$Survived)
  ),
  prob
)

plot(
  roc_obj,
  main = "ROC Curve"
)

# AUC
auc(roc_obj)

# --------------------------------
# 7. FIVE-FOLD CROSS-VALIDATION
# --------------------------------

control <- trainControl(
  method = "cv",
  number = 5
)

cv_model <- train(
  Survived ~ Pclass + Sex + Age +
    SibSp + Parch + Fare + Embarked,
  data = data,
  method = "glm",
  family = "binomial",
  trControl = control
)

cv_model

# --------------------------------
# END OF WEEK 4 ANALYSIS
# --------------------------------