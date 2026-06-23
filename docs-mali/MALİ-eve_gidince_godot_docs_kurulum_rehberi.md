# Eve Geçince Yapılacaklar - Godot Oyun Dokümantasyon Kurulumu

Bu dosya, eve geçince oyun bilgilerini Godot projesine düzenli şekilde taşımak için kişisel yapılacaklar rehberidir.

Amaç:
- Hikâye, mekanik, ilerleyiş ve atmosfer bilgilerini dağınık yerlerden toparlamak.
- Godot projesinde `docs/` klasörü oluşturmak.
- Yapay zekâ ajanlarının okuyabileceği net `.md` dosyaları hazırlamak.
- Kod ajanlarının oyunu yanlış anlamasını engellemek.

---

## 1. Önce Godot Projesinde Klasör Aç

Godot projesinin ana dizininde şu klasörü oluştur:

```text
docs/
```

Örnek yapı:

```text
res://
  docs/
    00_oyun_ozeti.md
    01_hikaye_lore.md
    02_mekanikler.md
    03_ilerleyis_akisi.md
    04_kamera_sistemi.md
    05_tehdit_sistemi_ai_sensors.md
    06_mini_oyunlar.md
    07_atmosfer_ses_gorsel.md
    08_yapay_zeka_ajan_kurallari.md
    09_feature_backlog.md
    10_karar_kaydi.md
```

Başlangıçta hepsini doldurmak zorunda değilsin. İlk önce şu 6 dosya yeterli:

```text
00_oyun_ozeti.md
02_mekanikler.md
04_kamera_sistemi.md
05_tehdit_sistemi_ai_sensors.md
08_yapay_zeka_ajan_kurallari.md
09_feature_backlog.md
```

---

## 2. Şimdiki Oyun Bilgisi Özeti

Bu bilgileri `00_oyun_ozeti.md` dosyasına koy:

```md
# Oyun Özeti

Tür:
Liminal space + gerilim + yapay zekâ veri merkezi oyunu.

Ana mekân:
Yapay zekâ veri merkezi / yapay zekâ tarafından kontrol edilen liminal tesis.

Ana tehdit:
Oyuncuyu aktif kovalayan fiziksel bir yaratık yok.
Mekândaki yapay zekâ, oyuncuyu sensörler, kameralar, ses algılama ve hareket izleme sistemleriyle bulmaya çalışır.

Kamera:
Oyunun ilk yaklaşık %80'lik kısmı 3D ortamda geçer ama 2D/flash oyun hissi verir.
Kamera sabittir.
Oyuncu sağ/sol ok arayüzlerine basarak geçiş efektiyle yön değiştirir.

Ana his:
Geniş bir alanda daralmış, izleniyor ve kontrolü sınırlanmış hissetmek.

İlk bölüm hedefi:
Oyuncuya kameranın, sensörlerin, mini oyunların ve yapay zekâ tehdidinin temel mantığını öğretmek.
```

---

## 3. Dosyalar Ne İçin Kullanılacak?

### `00_oyun_ozeti.md`

Herkesin okuyacağı kısa özet dosyası.

İçinde şunlar olacak:
- Oyunun türü
- Ana mekân
- Ana tehdit
- Kamera mantığı
- Ana atmosfer
- Oyuncunun temel deneyimi

Kısa tutulmalı. Kod ajanları her zaman bunu okuyabilir.

---

### `01_hikaye_lore.md`

Hikâye ve dünya bilgileri.

İçinde şunlar olabilir:
- Oyuncu kim?
- Veri merkezi ne?
- Yapay zekâ ne istiyor?
- Oyuncu neden orada?
- Olayların geçmişi
- Bilerek belirsiz bırakılan noktalar

Önemli:
Belirsiz konuları özellikle yaz. Böylece yapay zekâ boşlukları kafasına göre doldurmaz.

---

### `02_mekanikler.md`

Ana oynanış sistemleri.

İçinde şunlar olacak:
- Kamera yön değiştirme
- Sensörlerden kaçma
- Mini oyunlar
- Yapay zekâ tespit sistemi
- Gerilim sistemi
- Oyuncu etkileşimleri
- Başarısızlık sonuçları

---

### `03_ilerleyis_akisi.md`

Oyunun hangi bölümünde ne olacağını anlatır.

İçinde şunlar olacak:
- İlk %80'lik bölüm
- Oyuncuya hangi mekanik ne zaman öğretilecek?
- Hangi olaydan sonra oyun yapısı değişecek?
- Bölüm bölüm akış

---

### `04_kamera_sistemi.md`

Kamera sistemi için özel dosya.

İçinde şunlar olacak:
- İlk bölümde kamera sabit
- Serbest bakış yok
- Ekrandaki oklarla yön değiştirme
- Geçiş efekti
- 3D ortamda 2D/flash oyun hissi
- Tasarım amacı: kontrol kısıtlaması, gerilim, izlenme hissi

---

### `05_tehdit_sistemi_ai_sensors.md`

Yapay zekâ ve sensör tehdidi.

İçinde şunlar olacak:
- Fiziksel yaratık yok
- Yapay zekâ oyuncuyu bulmaya çalışıyor
- Hareket sensörleri
- Ses sensörleri
- Kameralar
- Mini oyunla sensör atlatma
- AI alarm seviyesi
- Başarısızlık sonuçları

---

### `06_mini_oyunlar.md`

Mini oyunların mantığı.

İçinde şunlar olacak:
- Mini oyunlar neden var?
- Sensörleri nasıl atlatıyor?
- Hangi mini oyun türleri olacak?
- Başarı/başarısızlık sonuçları
- Mini oyunlar kısa ve gerilimi bozmayan yapıda olmalı

---

### `07_atmosfer_ses_gorsel.md`

Atmosfer, ses, görsel yön.

İçinde şunlar olabilir:
- Liminal space hissi
- Veri merkezi ışıkları
- Geniş ama boğucu alanlar
- Kamera geçiş efektleri
- UI sesleri
- Yapay zekâ ses/uyarı dili
- Ortam sesleri

---

### `08_yapay_zeka_ajan_kurallari.md`

Kod ajanlarına verilecek sabit kurallar.

İçinde şunlar olmalı:
- Lore uydurma
- Yeni mekanik ekleme
- Sadece verilen feature'ı uygula
- Godot 4.x kullan
- GDScript 2.0 kullan
- Node path varsayma
- Minimum dosya değiştir
- İş bitince rapor ver

---

### `09_feature_backlog.md`

Yapılacak özellik listesi.

Örnek:

```md
# Feature Backlog

## Yapılacaklar

### Kamera yön değiştirme prototipi
Durum: yapılacak
Öncelik: yüksek

### İlk hareket sensörü prototipi
Durum: yapılacak
Öncelik: yüksek

### Mini oyun temel sistemi
Durum: yapılacak
Öncelik: yüksek

### AI alarm seviyesi sistemi
Durum: planlanacak
Öncelik: orta
```

---

### `10_karar_kaydi.md`

Neden böyle kararlar alındığını tutar.

Örnek:

```md
# Karar Kaydı

## Karar 001 - İlk bölümde sabit kamera kullanılacak

Sebep:
Oyuncuya 2D/flash oyun hissi vermek ve kontrolü sınırlayarak gerilim yaratmak.

Sonuç:
İlk yaklaşık %80'lik bölümde kamera serbest olmayacak.
Oyuncu yön değiştirmek için UI oklarını kullanacak.
```

---

## 4. Claude veya Başka Yapay Zekâdan Bilgi Aktarma Akışı

Eğer hikâye ve mekanikleri başka bir yapay zekâ sohbetinde anlattıysan:

1. O sohbetteki önemli mesajları kopyala.
2. `claude_bilgileri_md_dosyalarina_aktar_promptu.md` dosyasındaki prompt'u Claude'a ver.
3. Claude'dan şu dosyalar için ayrı ayrı Markdown çıktısı iste:
   - `00_oyun_ozeti.md`
   - `01_hikaye_lore.md`
   - `02_mekanikler.md`
   - `03_ilerleyis_akisi.md`
   - `04_kamera_sistemi.md`
   - `05_tehdit_sistemi_ai_sensors.md`
   - `06_mini_oyunlar.md`
   - `07_atmosfer_ses_gorsel.md`
   - `09_feature_backlog.md`
   - `10_karar_kaydi.md`
4. Çıktıları Godot projesindeki `docs/` klasörüne kaydet.
5. Çok uzun veya gereksiz fikirleri sil.
6. Her dosyanın başına "Bu dosya tek gerçek kaynak değildir; değiştikçe güncellenecek" gibi not eklemene gerek yok. Temiz tut.

---

## 5. Kod Ajanlarına Görev Verirken Kullanılacak Format

Her coding task'ı için şu formatı kullan:

```text
Önce şu dosyaları oku:
- docs/00_oyun_ozeti.md
- docs/02_mekanikler.md
- docs/08_yapay_zeka_ajan_kurallari.md

Bu task kamera ile ilgiliyse ayrıca:
- docs/04_kamera_sistemi.md

Bu task sensör/AI tehdidi ile ilgiliyse ayrıca:
- docs/05_tehdit_sistemi_ai_sensors.md

Bu task mini oyun ile ilgiliyse ayrıca:
- docs/06_mini_oyunlar.md

Sonra aşağıdaki feature'ı uygula.

Feature:
...

Kapsam:
...

Kapsam dışı:
...

Kabul kriterleri:
...
```

---

## 6. İlk Yapılacak Feature Sırası

Başlangıç için önerilen teknik sıra:

1. Sabit kamera + yön değiştirme prototipi
2. Ekran ok UI sistemi
3. Kamera geçiş efekti
4. Basit player interaction sistemi
5. İlk hareket sensörü prototipi
6. İlk mini oyun prototipi
7. Sensör başarısızlık sonucu
8. AI alarm seviyesi
9. İlk kısa oynanabilir akış
10. Reviewer ile kod kontrolü

---

## 7. Ana Kural

Sadece promptlara güvenme.

Doğru sistem:

```text
Oyun bilgisi = docs/ içindeki Markdown dosyaları
Kod görevi = kısa feature spec
Kod yazan ajan = docs dosyalarını okuyup uygular
Reviewer ajan = yapılan işi kontrol eder
```

Kısa özet:

```text
Prompt geçici.
Doküman kalıcı.
Ajanlar dokümanı okumalı.
Kod dokümana göre yazılmalı.
```
