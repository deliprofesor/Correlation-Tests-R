# Health Score Prediction Model: The Impact of Lifestyle and Demographic Factors

![health](https://github.com/user-attachments/assets/41068931-b9f8-4716-8353-888074c47c66)


## Veri Yükleme ve Ön İşlemeler

- **Veri kümesi yüklendi ve ilk birkaç satırı görüntülendi. Verilerdeki eksik değerler kontrol edilip, verilerin temiz olduğu görüldü (sum(is.na(dataset)) = 0).**
- **BMI (Body Mass Index) kategorilerine ayrılmış (Düşük, Normal, Yüksek, Obez) ve yaş grupları oluşturuldu (Genç, Orta Yaş, Yaşlı, Çok Yaşlı).**
- **Özellik ölçekleme yapıldı. BMI, uyku saatleri, diyet kalitesi ve alkol tüketimi için Z-puanı dönüşümleri uygulandı.**
  
## Veri Özet İstatistikleri

Veri setindeki sayısal değişkenlerin özet istatistikleri (summary(dataset)) incelendi. Bu özet, her değişkenin minimum, maksimum, ortalama, medyan ve çeyrek değerlerini sunuyor.

- **BMI:** Ortalama 25.35, maksimum 40.97.
- **Uyku saatleri:** Ortalama 6.97 saat, maksimum 11.64 saat.
- **Sağlık skoru:** Ortalama 85.48, maksimum 100.00.
  
## Veri Görselleştirmesi

Yaş, BMI, Diyet kalitesi, Uyku saatleri, Alkol tüketimi ve Sağlık skoru gibi değişkenlerin histogramları çizildi. 

![distrubution](https://github.com/user-attachments/assets/122d9ce1-8ade-4447-bef2-d9b7d8283e3f)


## Korelasyon Analizi

Korelasyon matrisi hesaplandı ve sayısal değişkenler arasındaki ilişkiler incelendi

- **BMI ile Sağlık Skoru arasında negatif bir ilişki (-0.415), yani BMI arttıkça sağlık skoru düşüyor.**
- **Diyet kalitesi ile Sağlık Skoru arasında güçlü bir pozitif ilişki (0.681), bu da daha kaliteli bir diyetin daha iyi sağlık skorları ile ilişkili olduğunu gösteriyor.**
- **Alkol tüketimi ve Sağlık Skoru arasında negatif bir ilişki (-0.138).**
  
![pairs](https://github.com/user-attachments/assets/01ddbf8f-b017-431d-a319-0939045c1d28)

Ayrıca scatterplot matrisi ile değişkenler arasındaki ilişkiler görselleştirildi

## Doğrusal Regresyon Modeli

Basit doğrusal regresyon modeli kurulmuş (lm() fonksiyonu):

- **Bağımlı değişken: Sağlık Skoru.**
- **Bağımsız değişkenler: Yaş, BMI, Egzersiz sıklığı, Diyet kalitesi, Uyku saatleri, Sigara içme durumu, Alkol tüketimi.**
  
**Model özeti:** Modelin R-kare değeri 0.834, yani model veriyi %83.4 oranında açıklayabiliyor.
  
## Modelin Önemli Sonuçları:

- **Yaş**: Yaşın sağlık skoru üzerindeki etkisi negatiftir. Yani yaş arttıkça sağlık skoru düşer. Bu ilişkinin katsayısı -0.238'dir. Bu, yaş başına sağlık skorunun 0.238 birim azaldığını gösterir.
- **BMI (Body Mass Index):** BMI değeri arttıkça sağlık skoru düşer. -1.133'lük katsayısı, BMI'deki her bir birim artışının sağlık skorunu yaklaşık 1.133 birim azalttığını gösterir.
- **Egzersiz Sıklığı:** Egzersiz sıklığı arttıkça sağlık skoru artar. Bu pozitif ilişki, egzersiz yapan kişilerin sağlık skorlarının daha yüksek olduğunu gösteriyor. Bu ilişkinin gücü, egzersiz sıklığındaki artışla birlikte sağlık skorunun artacağı yönündedir.
- **Diyet Kalitesi:** Diyet kalitesi de sağlık skoru üzerinde pozitif bir etki yapar. +0.605'lik katsayı, diyet kalitesinin her bir birim artışı ile sağlık skorunun 0.605 birim arttığını gösteriyor.

## Random Forest Modeli:

**Eğitim Verisi Performansı:**

- **R² (R-kare):** 0.9742. Bu değer, modelin veri setindeki değişkenliği %97.42 oranında açıkladığını gösteriyor. Bu, modelin eğitim verisi üzerinde oldukça başarılı olduğu anlamına gelir.
- **MSE (Ortalama Kare Hata):** 8.49. Bu düşük MSE değeri, modelin tahminlerinin gerçek değerlere yakın olduğunu gösteriyor.
- **MAE (Ortalama Mutlak Hata):** 2.24. Bu, modelin tahminlerinin gerçek değerlere ortalama olarak 2.24 birim uzaklıkta olduğunu gösterir.
  
**Test Verisi Performansı:**

- **R² (R-kare):** 0.8116. Bu değer, modelin test verisi üzerinde %81.16 oranında bir açıklama sağladığını gösteriyor, bu da modelin genelleme yeteneğinin hala oldukça iyi olduğunu fakat eğitim verisi kadar başarılı olmadığını gösteriyor.
- **MSE (Ortalama Kare Hata):** 40.36. Bu, eğitim verisine göre test verisindeki hata oranının arttığını gösteriyor. Bu artış, modelin test verisi üzerinde bazı hatalar yapmaya başladığını işaret ediyor.
- **MAE (Ortalama Mutlak Hata):** 5.22. Test verisi üzerindeki tahminlerin gerçek değerlere olan ortalama uzaklığı 5.22 birimdir, bu da test setinde modelin başarısının biraz düştüğünü gösteriyor.
  
![random_forest](https://github.com/user-attachments/assets/02749331-ba2a-4ac8-a1a9-8caf438ede10)


##  Polinomial Regresyon Modeli:

**Eğitim Verisi Performansı:**

- **R² (R-kare):** 0.8361. Bu, modelin eğitim verisindeki değişkenliği %83.61 oranında açıkladığını gösteriyor. Random Forest modeline göre daha düşük ancak yine de kabul edilebilir bir performans.
- **MSE (Ortalama Kare Hata):** 30.43. Bu daha yüksek bir hata değeri, Polinomial regresyon modelinin daha fazla hata yaptığını gösteriyor.
- **MAE (Ortalama Mutlak Hata):** 4.35. Bu da modelin tahminlerinin gerçek değerlere ortalama olarak 4.35 birim uzaklıkta olduğunu gösteriyor.
  
**Test Verisi Performansı:**

- **R² (R-kare):** 0.8257. Polinomial regresyon modelinin test verisi üzerindeki R² değeri %82.57, bu da modelin test verisinde de makul derecede iyi performans gösterdiğini fakat Random Forest modeline göre biraz daha düşük olduğunu belirtiyor.
- **MSE (Ortalama Kare Hata):** 30.27. Polinomial regresyon modelinin test verisi üzerindeki hata oranı, eğitim verisine göre pek farklı değil, ancak Random Forest’a göre daha düşük.
- **MAE (Ortalama Mutlak Hata):** 4.32. Bu da, modelin tahminlerinin gerçek değerlere ortalama olarak 4.32 birim uzaklıkta olduğunu gösteriyor. Test verisi üzerinde daha iyi bir performans sergilediği görülüyor.

## Sonuç:

- **Genel Performans:** Random Forest modeli, her iki set için de daha yüksek R² değerleri ile daha iyi sonuçlar veriyor. Ancak test verisi üzerinde performansı biraz düşerken, Polinomial Regresyon modeli test setinde daha stabil bir performans sergiliyor.
- **Hata Karşılaştırması:** Test verisi üzerinde Random Forest’ın MSE ve MAE değerleri, Polinomial regresyonun değerlerinden yüksek. Bu, Random Forest modelinin test verisinde daha büyük hatalar yapabileceğini gösteriyor. Polinomial regresyon, daha düşük hata değerleriyle daha kararlı bir sonuç sağlıyor.
- **Model Karşılaştırma:** Grafikte gerçek değerlerle tahmin edilen değerler arasındaki farkları daha net bir şekilde görebilirsiniz. Bu, her iki modelin doğruluğunu ve hatalarını görsel olarak anlamanızı sağlar.
Her iki model de eğitim verisi üzerinde oldukça iyi performans gösteriyor, ancak test verisi üzerinde Random Forest modelinin hataları arttığı için Polinomial Regresyon daha tutarlı bir performans sunmuş gibi görünüyor.

## Model Karşılaştırma Grafiği

İlk olarak, Random Forest ve Polinomial Regresyon modellerinin gerçek değerlerle tahmin edilen değerleri arasındaki farkı görselleştirdik. 

![random_vs_polinominal](https://github.com/user-attachments/assets/8d39d149-bcff-4a44-9585-9488b8dcff88)

## Özetleyici İstatistikler ve Hata Analizi

Her iki modelin tahmin hatalarını analiz ettik. 

- **Random Forest Hata Dağılımı:** error_rf veri çerçevesi, Random Forest modelinin tahmin hatalarını içeriyor. Bu hataları histogram şeklinde görselleştirerek, modelin tahmin hatalarının ne kadar dağıldığını ve hangi değere daha yakın olduğunu inceleyebildik.
  
- **Polinomial Regresyon Hata Dağılımı:** Benzer şekilde, error_poly veri çerçevesi Polinomial Regresyon modelinin hata dağılımını içeriyor. Bu modelin hata dağılımını da histogramla görselleştirerek, tahmin hatalarının özelliklerini gözlemledik.


## Model Hiperparametre Optimizasyonu (Random Forest)

Random Forest modelinin hiperparametre optimizasyonunu gerçekleştirdik. Bunun için tuneRF fonksiyonunu kullandık ve modelin mtry (modelin her karar ağacında kullanacağı özellik sayısı) parametresini optimize ettik. 

**Sonuçlar:**

- **mtry = 2: OOB (Out-of-Bag) hata oranı %42.41.**
- **mtry = 3: OOB hata oranı %38.45.**
- **mtry = 4: OOB hata oranı %38.32.**
  
En düşük hata oranını elde etmek için mtry = 4 parametresi seçildi. Bu, modelin her karar ağacında 4 özellik kullanarak daha iyi tahminler yapmasını sağladı.

## Çapraz Doğrulama Sonuçları

Modelin doğruluğunu artırmak amacıyla çapraz doğrulama (cross-validation) kullandık. Bunun için trainControl fonksiyonu ile 10 katlı çapraz doğrulama yapıldı

**Sonuçlar:**

- **mtry = 2: RMSE = 7.92, R² = 0.82, MAE = 6.43.**
- **mtry = 7: RMSE = 6.43, R² = 0.79, MAE = 4.97.**
- **mtry = 13: RMSE = 6.54, R² = 0.77, MAE = 5.01.**
  
En iyi sonuç mtry = 7 ile elde edildi. Bu durumda modelin doğruluğu iyileşmiş ve hata oranları azalmıştır. RMSE (Root Mean Squared Error) değeri küçülerek modelin tahmin doğruluğu artmıştır.

## Sonuçların Özeti:

- **Random Forest Modeli, Polinomial Regresyon Modeli ile karşılaştırıldığında, daha iyi bir tahmin performansı sergilemiştir. Özellikle mtry hiperparametre optimizasyonu ile modelin doğruluğu önemli ölçüde artırıldı.**
- **Polinomial Regresyon modelinin hata dağılımı genellikle daha geniş bir dağılıma sahipken, Random Forest modelinin hataları daha dar bir aralıkta toplanmıştır.**
- **Çapraz doğrulama, modelin farklı hiperparametrelerle test edilmesini sağlayarak en iyi parametreyi (mtry = 7) bulmamıza yardımcı olmuştur.**
  
Bu sonuçlar, modelin performansını ve doğruluğunu değerlendirirken kullanılan araçların, özellikle hiperparametre optimizasyonunun ve çapraz doğrulamanın ne kadar önemli olduğunu göstermektedir.
