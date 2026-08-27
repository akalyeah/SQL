# Week 3 - Statistical Analysis and Predictive Modeling using R
# Dataset: Titanic passenger dataset

# Install packages if required
# install.packages(c("caret", "pROC"))

library(caret)
library(pROC)

# Load dataset
data <- read.csv("titanic.csv", stringsAsFactors = FALSE)

# Data preparation
data$Cabin <- NULL

data$Age[is.na(data$Age)] <- median(data$Age, na.rm = TRUE)

mode_embarked <- names(sort(table(data$Embarked), decreasing = TRUE))[1]
data$Embarked[is.na(data$Embarked)] <- mode_embarked

data$Sex <- as.factor(data$Sex)
data$Embarked <- as.factor(data$Embarked)
data$Survived <- as.factor(data$Survived)

# 1. Hypothesis Test
# H0: Mean fare is the same for survivors and non-survivors.
# H1: Mean fare is different for survivors and non-survivors.

t.test(Fare ~ Survived, data = data)

# 2. Normality Check
shapiro.test(sample(data$Age, 500))

# 3. Spearman Correlation
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

# 4. Train/Test Split
set.seed(42)

index <- createDataPartition(
  data$Survived,
  p = 0.80,
  list = FALSE
)

train_data <- data[index, ]
test_data <- data[-index, ]

# 5. Logistic Regression Model
model <- glm(
  Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
  data = train_data,
  family = binomial
)

summary(model)

# 6. Predicted Probabilities and Classes
prob <- predict(
  model,
  test_data,
  type = "response"
)

pred_class <- ifelse(
  prob >= 0.5,
  1,
  0
)

pred_class <- as.factor(pred_class)

# 7. Confusion Matrix
confusionMatrix(
  pred_class,
  test_data$Survived
)

# 8. ROC and AUC
roc_obj <- roc(
  as.numeric(as.character(test_data$Survived)),
  prob
)

plot(roc_obj)

auc(roc_obj)

# 9. Five-Fold Cross-Validation
control <- trainControl(
  method = "cv",
  number = 5
)

cv_model <- train(
  Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
  data = data,
  method = "glm",
  family = "binomial",
  trControl = control
)

cv_model