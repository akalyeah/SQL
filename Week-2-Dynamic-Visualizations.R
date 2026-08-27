# Week 2 - Dynamic Visualizations with R
# Dataset: Titanic passenger dataset

# Install package if required
# install.packages("ggplot2")

library(ggplot2)

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

# 1. Age Distribution
ggplot(data, aes(x = Age)) +
  geom_histogram(bins = 30) +
  labs(
    title = "Age Distribution",
    x = "Age",
    y = "Count"
  )

# 2. Fare Distribution
ggplot(data, aes(y = Fare)) +
  geom_boxplot() +
  labs(
    title = "Fare Distribution",
    y = "Fare"
  )

# 3. Survival by Sex
ggplot(data, aes(x = Sex, fill = Survived)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Survival by Sex",
    x = "Sex",
    fill = "Survived"
  )

# 4. Survival by Passenger Class
ggplot(data, aes(x = factor(Pclass), fill = Survived)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Survival by Passenger Class",
    x = "Passenger Class",
    fill = "Survived"
  )

# 5. Age and Fare by Survival Outcome
ggplot(data, aes(x = Age, y = Fare, color = Survived)) +
  geom_point(alpha = 0.6) +
  labs(
    title = "Age and Fare by Survival Outcome",
    color = "Survived"
  )

# 6. Survival Rate Across Age Groups
data$AgeGroup <- cut(
  data$Age,
  breaks = c(0, 12, 18, 30, 45, 60, 80),
  include.lowest = TRUE
)

age_summary <- aggregate(Survived ~ AgeGroup, data = data, mean)

age_summary$SurvivalRate <- age_summary$Survived * 100

ggplot(age_summary, aes(
  x = AgeGroup,
  y = SurvivalRate,
  group = 1
)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Survival Rate Across Age Groups",
    x = "Age Group",
    y = "Survival Rate (%)"
  )

# 7. Correlation Matrix
numeric_data <- data[, c(
  "Survived",
  "Pclass",
  "Age",
  "SibSp",
  "Parch",
  "Fare"
)]

cor_matrix <- cor(numeric_data)

round(cor_matrix, 2)