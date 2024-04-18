Q1: İş, Problem ve İhtiyaç Tanımı

1. İş Tanımı:
-Şirket: EcoVision Technologies
-Faaliyet: Enerji verimliliği sağlayan akıllı cihazlar ve çevre dostu teknolojiler geliştirme.
2. Problem ve İhtiyaç:
-Problem: Müşteri evlerinde yeni cihazların enerji tasarrufu performansını doğru ölçememe.
-İhtiyaç: Cihazların etkinliğini kanıtlamak için müşteri enerji kullanım verileri üzerinden detaylı bir analiz yapma gerekliliği.

3. Çözüm Önerisi:
-Veri Seti: Müşteri evlerinden toplanan enerji kullanım verileri.
-Analiz: Enerji kullanımındaki değişiklikleri izleyerek cihaz performansını değerlendirme.
-Anahtar Performans Göstergeleri (KPI’lar): Enerji tasarruf yüzdesi, kullanım öncesi ve sonrası enerji tüketimi, maliyet etkinliği.

Q3: Veri Kalite Kontrolü

1. Veri Çekme ve Kalite Kontrol İşlemleri:
   - İlk olarak veritabanından verileri çekmek için SQL komutları yazılmalı. 
   Daha sonra bu veriler üzerinde eksik veriler, aykırı değerler ve veri tipi uyumsuzlukları gibi potansiyel kalite sorunları kontrol edilmelidir.

2. Veri Kalite Kontrol Adımları:
-Eksik Veriler: Veri setinde herhangi bir eksik veri olup olmadığını kontrol et ve eksik veriler varsa uygun bir yöntemle doldur.
-Aykırı Değerler: Enerji tüketimindeki anormal derecede yüksek veya düşük değerleri saptayıp analiz dışı bırak veya düzelt.
Veri Tipi Kontrolleri: Tüm sütunların doğru veri tipine sahip olduğundan emin ol.

3. R Fonksiyonları ve SQL Komutları:
Veritabanından veri çekmek için SQL komutları ve R fonksiyonları yazılır. Bu fonksiyonlar, veritabanı bağlantısı kurup SQL sorgusu çalıştırarak verileri çeker.
İşte bir örnek R fonksiyonu:
r
library(DBI)

# Veritabanından veri çekme
get_energy_data <- function() {
  db <- dbConnect(SQLite(), dbname = "Vize_Q2_170401085_Zakaria_aljamous.sqlite")
  query <- "SELECT * FROM EnergyUsage"
  data <- dbGetQuery(db, query)

  return(data)
}


# Veri kalite kontrol
check_data_quality <- function(data) {
  summary(data)   
  if(any(is.na(data))) {
    data[is.na(data)] <- median(data, na.rm = TRUE)  
  }
  data <- data[data$EnergyConsumption < quantile(data$EnergyConsumption, 0.99),]
  return(data)
}

# Veri çek ve kalite kontrol uygula
energy_data <- get_energy_data()
cleaned_data <- check_data_quality(energy_data)


4. Veri Kalite Kontrolünü Onaylayan Unit Test:
   - Veri kalitesini testthat paketi kullanarak doğrulamak için birim testleri yazın. 
   Örneğin, eksik verilerin düzeltilip düzeltilmediğini ve aykırı değerlerin uygun şekilde
   filtrelenip filtrelenmediğini doğrulayan testler oluşturabilirsiniz.

r
library(testthat)

test_that("No missing values", {
  expect_false(any(is.na(cleaned_data)))
})

test_that("No outliers", {
  expect_less_than(max(cleaned_data$EnergyConsumption), quantile(cleaned_data$EnergyConsumption, 0.99))
})



*Q4: Veri Analizi*

Analiz Amaçları:
Enerji tasarrufu performansının değerlendirilmesi.
Cihazların kurulum öncesi ve sonrası enerji tüketimlerindeki değişikliklerin analizi.
Analiz İşlemleri:
Veri Hazırlığı: Temizlenmiş verileri kullanarak, cihaz kurulumu öncesi ve sonrası dönemlere ait enerji tüketimi verilerini ayırmak.
Statistiksel Testler: Kurulum öncesi ve sonrası enerji tüketim değerleri arasındaki farkın istatistiksel olarak anlamlı olup olmadığını test etmek için t-testi gibi yöntemler kullanılabilir.
Zaman Serisi Analizi: Enerji tüketiminin zaman içindeki değişimlerini değerlendirmek için zaman serisi analizi yapmak.
R Kodları ve Grafik Üretimi:
Verilerin analiz edilmesi ve grafiklerin çizilmesi için gerekli R kodları.

r
library(ggplot2)

# Enerji tüketimi verilerini zaman serisi olarak çizdirme
ggplot(cleaned_data, aes(x = Date, y = EnergyConsumption)) +
  geom_line() +
  labs(title = "Enerji Tüketimi Zaman Serisi", x = "Tarih", y = "Enerji Tüketimi (kWh)")

# Kurulum öncesi ve sonrası enerji tüketimi karşılaştırması
pre_installation <- subset(cleaned_data, Date < as.Date("2023-01-01"))
post_installation <- subset(cleaned_data, Date >= as.Date("2023-01-01"))

# T-testi
t_test_results <- t.test(pre_installation$EnergyConsumption, post_installation$EnergyConsumption)

# Grafik çizdirme
ggplot() +
  geom_boxplot(data = pre_installation, aes(y = EnergyConsumption, fill = "Pre-installation")) +
  geom_boxplot(data = post_installation, aes(y = EnergyConsumption, fill = "Post-installation")) +
  labs(title = "Kurulum Öncesi ve Sonrası Enerji Tüketimi Karşılaştırması", y = "Enerji Tüketimi (kWh)") +
  scale_fill_manual(values = c("Pre-installation" = "blue", "Post-installation" = "green"))


4. *Analiz Sonuçlarının Yorumlanması:*
   - Elde edilen grafikler ve t-test sonuçları, cihazların enerji tasarrufu performansını değerlendirmek için kullanılacak. Grafikler ve test sonuçları, müşterilere cihazların etkilerini göstermek ve enerji tasarrufu sağlayıp sağlamadıklarını objektif bir şekilde değerlendirmek için raporun bir parçası olarak sunulacak.



*Q5: Sonuçlar ve Değerlendirmeler*

Sonuçların Değerlendirilmesi:
Cihazların enerji tasarrufu performansını değerlendirmek için kurulum öncesi ve sonrası enerji tüketimi karşılaştırıldı ve zaman serisi analizleri yapıldı. Eğer t-testi ve diğer istatistiksel analizler enerji tüketiminde anlamlı bir düşüş gösteriyorsa, cihazların etkili olduğu sonucuna varılabilir.
Bulguların Analizi:
Başarı Durumu: Analiz sonuçları, enerji tüketiminde istatistiksel olarak anlamlı bir düşüş gösteriyorsa, cihazların başarılı olduğu kabul edilebilir. Bu başarı, cihazların enerji tasarrufu vaatlerini yerine getirdiğini gösterir.
Başarısızlık Durumu: Eğer sonuçlar, önemli bir enerji tasarrufu sağlanamadığını gösteriyorsa, bu durumda cihazların tasarımı ve müşteriye sunumu üzerinde iyileştirmeler yapılması gerekebilir.
Öneriler ve Tavsiyeler:
Çalışmanın Genişletilmesi: Enerji tüketim verileri üzerinde daha detaylı demografik ve mevsimsel faktörlerin etkilerini inceleyen ileri analizler yapılabilir. Ayrıca, farklı coğrafyalarda ve farklı türde binalarda cihazların performansının değerlendirilmesi önerilir.
Devamı için Öneriler: Cihazların daha geniş bir müşteri kitlesine sunulmadan önce pilot çalışmaların sayısını artırmak ve farklı kullanım senaryolarında test etmek önemlidir. Ayrıca, müşteri geri bildirimlerini toplayarak cihazların kullanıcı deneyimini iyileştirmek için de çalışmalar yapılmalıdır.
Rapora Eklenecek Ögeler:
Tüm analiz sonuçları, elde edilen grafikler ve istatistiksel test sonuçları, detaylı bir şekilde raporlanır.
Müşterilere sunulacak rapor, cihazların performansını ve potansiyel iyileştirmeleri net bir şekilde ortaya koyacak şekilde hazırlanır.
Sonuçların ve önerilerin, şirket stratejileri ve müşteri beklentileri ile nasıl uyumlu olduğu detaylandırılır.