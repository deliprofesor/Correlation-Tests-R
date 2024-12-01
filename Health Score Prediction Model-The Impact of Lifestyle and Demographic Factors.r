# Gerekli kütüphaneleri yükleyelim
library(tidyverse)  # Veri manipülasyonu ve görselleştirme için

# Veri kümesini yükleyelim
dataset <- read.csv("synthetic_health_data.csv")

# Verinin ilk birkaç satırını görüntüleyelim
head(dataset)

# Eksik değerleri kontrol edelim
sum(is.na(dataset))  # NA (eksik) değerlerin sayısını hesaplar

# Veriye yeni özellikler ekleyelim

# BMI'yi kategorize edelim: Düşük, Normal, Yüksek, Obez
dataset$BMI_Category <- cut(dataset$BMI,
                            breaks = c(-Inf, 18.5, 24.9, 29.9, Inf),
                            labels = c("Düşük", "Normal", "Yüksek", "Obez"))

# Yaş grupları oluşturalım: Genç, Orta Yaş, Yaşlı, Çok Yaşlı
dataset$Age_Group <- cut(dataset$Age,
                         breaks = c(-Inf, 30, 45, 60, Inf),
                         labels = c("Genç", "Orta Yaş", "Yaşlı", "Çok Yaşlı"))

# Özellik ölçekleme (Z-score) uygulayalım
dataset$BMI_scaled <- scale(dataset$BMI)  # BMI'nin ölçeklenmiş hali
dataset$Sleep_Hours_scaled <- scale(dataset$Sleep_Hours)  # Uyku saatlerinin ölçeklenmesi
dataset$Diet_Quality_scaled <- scale(dataset$Diet_Quality)  # Diyet kalitesinin ölçeklenmesi
dataset$Alcohol_Consumption_scaled <- scale(dataset$Alcohol_Consumption)  # Alkol tüketiminin ölçeklenmesi

# Veriyi yeniden gözden geçirelim
summary(dataset)  # Verinin özet istatistiklerini gösterir

# Cinsiyet ve egzersiz sıklığını uygun faktörlere dönüştürelim
dataset$Smoking_Status <- factor(dataset$Smoking_Status, levels = c(0, 1), labels = c("Non-smoker", "Smoker"))
dataset$Exercise_Frequency <- factor(dataset$Exercise_Frequency, levels = 0:7)

# Kolonları uygun veri türlerine dönüştürelim
dataset$Age <- as.numeric(dataset$Age)
dataset$BMI <- as.numeric(dataset$BMI)
dataset$Diet_Quality <- as.numeric(dataset$Diet_Quality)
dataset$Sleep_Hours <- as.numeric(dataset$Sleep_Hours)
dataset$Alcohol_Consumption <- as.numeric(dataset$Alcohol_Consumption)
dataset$Health_Score <- as.numeric(dataset$Health_Score)

# Verinin özetine tekrar bakalım
summary(dataset)

# Sayısal değişkenlerin dağılımlarını görselleştirelim
par(mfrow=c(2,3))  # 2 satır ve 3 sütunlu bir düzen ayarlayalım
hist(dataset$Age, main="Age Distribution", xlab="Age")  # Yaş dağılımı
hist(dataset$BMI, main="BMI Distribution", xlab="BMI")  # BMI dağılımı
hist(dataset$Diet_Quality, main="Diet Quality Distribution", xlab="Diet Quality")  # Diyet kalitesi dağılımı
hist(dataset$Sleep_Hours, main="Sleep Hours Distribution", xlab="Sleep Hours")  # Uyku saatleri dağılımı
hist(dataset$Alcohol_Consumption, main="Alcohol Consumption Distribution", xlab="Alcohol Consumption")  # Alkol tüketimi dağılımı
hist(dataset$Health_Score, main="Health Score Distribution", xlab="Health Score")  # Sağlık skoru dağılımı

# Sayısal değişkenler arasındaki çiftli korelasyonları hesaplayalım
cor(dataset[, c("Age", "BMI", "Diet_Quality", "Sleep_Hours", "Alcohol_Consumption", "Health_Score")])

# Sayısal değişkenler arasındaki ilişkileri daha ayrıntılı görmek için scatter plot matrix çizelim
pairs(dataset[, c("Age", "BMI", "Diet_Quality", "Sleep_Hours", "Alcohol_Consumption", "Health_Score")])

# Basit doğrusal regresyon modelini kuralım
model <- lm(Health_Score ~ Age + BMI + Exercise_Frequency + Diet_Quality + Sleep_Hours + Smoking_Status + Alcohol_Consumption, data = dataset)

# Modelin özetini alalım
summary(model)

# Model varsayımlarını kontrol edelim: Artıklar (residuals) grafiği
par(mfrow=c(2,2))  # 2x2'lik grafik düzeni
plot(model)  # Modelin artıklarına ait dört farklı grafiği görselleştirir

# Modelden tahminler yapalım
predictions <- predict(model, newdata = dataset)

# Gerçek ve tahmin edilen değerleri karşılaştıralım
comparison <- data.frame(Actual = dataset$Health_Score, Predicted = predictions)
head(comparison)

# Modelin R-kare (R²) değerini hesaplayalım
rsq <- summary(model)$r.squared
cat("R-squared: ", rsq)  # Modelin açıklama gücünü verir

# Ortalama Kare Hata (MSE) hesaplayalım
mse <- mean((dataset$Health_Score - predictions)^2)
cat("Mean Squared Error: ", mse)  # Modelin hata oranını ölçer

# Gerçek ve tahmin edilen değerlerin karşılaştırma grafiğini çizelim
ggplot(comparison, aes(x = Actual, y = Predicted)) +
  geom_point() +  # Gerçek vs tahmin edilen değerleri gösterir
  geom_abline(slope = 1, intercept = 0, color = "red") +  # Y = X doğrusu, mükemmel tahminin göstergesidir
  labs(title = "Actual vs Predicted Health Scores", x = "Actual Health Score", y = "Predicted Health Score")

# Polinomial regresyon modelini kuralım (doğrusal olmayan ilişkiler için)
polynomial_model <- lm(Health_Score ~ poly(Age, 2) + poly(BMI, 2) + Exercise_Frequency + 
                       Diet_Quality + Sleep_Hours + Smoking_Status + Alcohol_Consumption, data = dataset)

# Polinomial regresyon modelinin özetini alalım
summary(polynomial_model)

# Random Forest modelini kuralım
library(randomForest)
random_forest_model <- randomForest(Health_Score ~ Age + BMI + Exercise_Frequency + 
                                    Diet_Quality + Sleep_Hours + Smoking_Status + Alcohol_Consumption, 
                                    data = dataset, ntree = 100)

# Random Forest modelinin özetini yazdıralım
print(random_forest_model)

# Destek Vektör Regresyonu (SVR) modelini kuralım
install.packages('e1071')
library(e1071)
svr_model <- svm(Health_Score ~ Age + BMI + Exercise_Frequency + Diet_Quality + 
                 Sleep_Hours + Smoking_Status + Alcohol_Consumption, data = dataset)

# SVR modelinin özetini alalım
summary(svr_model)

# Hiperparametre optimizasyonu için caret paketini kullanalım
library(caret)
grid <- expand.grid(mtry = c(2, 3, 4, 5))  # Random Forest'ın 'mtry' parametresi için değerler
train_control <- trainControl(method = "cv", number = 10)  # 10 katlamalı çapraz doğrulama

# Random Forest modelini Grid Search ile eğitelim
rf_model <- train(Health_Score ~ Age + BMI + Exercise_Frequency + Diet_Quality + 
                  Sleep_Hours + Smoking_Status + Alcohol_Consumption, data = dataset,
                  method = "rf", trControl = train_control, tuneGrid = grid)

# En iyi model parametrelerini yazdıralım
print(rf_model$bestTune)

# K-fold çapraz doğrulama kullanmak
cv_model <- train(Health_Score ~ Age + BMI + Exercise_Frequency + Diet_Quality + 
                  Sleep_Hours + Smoking_Status + Alcohol_Consumption, data = dataset,
                  method = "lm", trControl = trainControl(method = "cv", number = 10))

# Modelin sonuçlarını yazdıralım
print(cv_model)

# Random Forest modelinin tahminlerini alalım
rf_predictions <- predict(random_forest_model, newdata = dataset)

# Polinomial regresyon modelinin tahminlerini alalım
polynomial_predictions <- predict(polynomial_model, newdata = dataset)

# Gerçek ve tahmin edilen değerleri karşılaştıralım
comparison_rf <- data.frame(Actual = dataset$Health_Score, Predicted = rf_predictions)
comparison_poly <- data.frame(Actual = dataset$Health_Score, Predicted = polynomial_predictions)

# Random Forest ve Polinomial regresyon için gerçek ve tahmin edilen değerlerin karşılaştırma grafiğini çizelim
ggplot(comparison_rf, aes(x = Actual, y = Predicted)) + 
  geom_point() + 
  geom_abline(slope = 1, intercept = 0, color = "red") + 
  labs(title = "Actual vs Predicted Health Scores (Random Forest)", x = "Actual", y = "Predicted") 
# Random Forest ve Polinomial regresyon için performans metriklerini hesaplayalım
# R2 (R-kare), MSE (Ortalama Kare Hata), MAE (Ortalama Mutlak Hata) gibi metrikleri hesaplayalım

# Random Forest modelinin performans metriklerini hesaplayalım
rf_r2 <- cor(dataset$Health_Score, rf_predictions)^2  # R² değeri
rf_mse <- mean((dataset$Health_Score - rf_predictions)^2)  # MSE
rf_mae <- mean(abs(dataset$Health_Score - rf_predictions))  # MAE

cat("Random Forest - R-squared:", rf_r2, "\n")
cat("Random Forest - Mean Squared Error:", rf_mse, "\n")
cat("Random Forest - Mean Absolute Error:", rf_mae, "\n")

# Polinomial regresyon modelinin performans metriklerini hesaplayalım
poly_r2 <- cor(dataset$Health_Score, polynomial_predictions)^2  # R² değeri
poly_mse <- mean((dataset$Health_Score - polynomial_predictions)^2)  # MSE
poly_mae <- mean(abs(dataset$Health_Score - polynomial_predictions))  # MAE

cat("Polinomial Regresyon - R-squared:", poly_r2, "\n")
cat("Polinomial Regresyon - Mean Squared Error:", poly_mse, "\n")
cat("Polinomial Regresyon - Mean Absolute Error:", poly_mae, "\n")

# Eğitim seti ile test setine ayıralım (70% eğitim, 30% test)
set.seed(123)  # Sonuçların tekrar edilebilir olması için
train_indices <- sample(1:nrow(dataset), size = 0.7 * nrow(dataset))
train_data <- dataset[train_indices, ]
test_data <- dataset[-train_indices, ]

# Eğitim verisi üzerinde Random Forest modelini tekrar eğitelim
rf_model_train <- randomForest(Health_Score ~ Age + BMI + Exercise_Frequency + 
                               Diet_Quality + Sleep_Hours + Smoking_Status + Alcohol_Consumption, 
                               data = train_data, ntree = 100)

# Eğitim verisi üzerinde Polinomial regresyon modelini tekrar eğitelim
polynomial_model_train <- lm(Health_Score ~ poly(Age, 2) + poly(BMI, 2) + Exercise_Frequency + 
                             Diet_Quality + Sleep_Hours + Smoking_Status + Alcohol_Consumption, 
                             data = train_data)

# Test verisi üzerinde tahmin yapalım
rf_predictions_test <- predict(rf_model_train, newdata = test_data)
polynomial_predictions_test <- predict(polynomial_model_train, newdata = test_data)

# Test seti üzerindeki modelin performansını değerlendirelim
rf_r2_test <- cor(test_data$Health_Score, rf_predictions_test)^2
rf_mse_test <- mean((test_data$Health_Score - rf_predictions_test)^2)
rf_mae_test <- mean(abs(test_data$Health_Score - rf_predictions_test))

cat("Test Set - Random Forest - R-squared:", rf_r2_test, "\n")
cat("Test Set - Random Forest - Mean Squared Error:", rf_mse_test, "\n")
cat("Test Set - Random Forest - Mean Absolute Error:", rf_mae_test, "\n")

poly_r2_test <- cor(test_data$Health_Score, polynomial_predictions_test)^2
poly_mse_test <- mean((test_data$Health_Score - polynomial_predictions_test)^2)
poly_mae_test <- mean(abs(test_data$Health_Score - polynomial_predictions_test))

cat("Test Set - Polinomial Regresyon - R-squared:", poly_r2_test, "\n")
cat("Test Set - Polinomial Regresyon - Mean Squared Error:", poly_mse_test, "\n")
cat("Test Set - Polinomial Regresyon - Mean Absolute Error:", poly_mae_test, "\n")

# Model karşılaştırma grafiği
comparison_test <- data.frame(Actual = test_data$Health_Score, 
                              RF_Predicted = rf_predictions_test, 
                              Poly_Predicted = polynomial_predictions_test)

ggplot(comparison_test, aes(x = Actual)) +
  geom_point(aes(y = RF_Predicted, color = "Random Forest"), alpha = 0.5) +
  geom_point(aes(y = Poly_Predicted, color = "Polinomial"), alpha = 0.5) +
  labs(title = "Test Set: Actual vs Predicted Health Scores", 
       x = "Actual Health Score", y = "Predicted Health Score") +
  scale_color_manual(values = c("Random Forest" = "blue", "Polinomial" = "green"))

# Özetleyici istatistikler ve hata analizi
error_rf <- data.frame(Actual = test_data$Health_Score, Predicted = rf_predictions_test, Error = test_data$Health_Score - rf_predictions_test)
error_poly <- data.frame(Actual = test_data$Health_Score, Predicted = polynomial_predictions_test, Error = test_data$Health_Score - polynomial_predictions_test)

# Hata dağılımlarını görselleştirelim
par(mfrow = c(1, 2))
hist(error_rf$Error, main = "Random Forest Errors", xlab = "Error", col = "lightblue", breaks = 20)
hist(error_poly$Error, main = "Polinomial Regresyon Errors", xlab = "Error", col = "lightgreen", breaks = 20)

# Modellemede hiperparametre optimizasyonu yapılabilir. Örneğin Random Forest için:
tune_rf <- tuneRF(train_data[, c("Age", "BMI", "Exercise_Frequency", "Diet_Quality", 
                                 "Sleep_Hours", "Smoking_Status", "Alcohol_Consumption")], 
                  train_data$Health_Score, 
                  ntreeTry = 100, 
                  stepFactor = 1.5, 
                  improve = 0.01, 
                  trace = TRUE)

# İyileştirilmiş Random Forest modelini yazdıralım
print(tune_rf)

# Son olarak, çapraz doğrulama ile modelin doğruluğunu tekrar kontrol edelim
cv_results <- train(Health_Score ~ Age + BMI + Exercise_Frequency + Diet_Quality + 
                    Sleep_Hours + Smoking_Status + Alcohol_Consumption, 
                    data = dataset, method = "rf", trControl = trainControl(method = "cv", number = 10))

# Çapraz doğrulama sonuçlarını yazdıralım
print(cv_results)
