# Geliştirme Bekleme Listesi (Feature Backlog)

Bu liste, projenin mevcut durumuna göre yapılması planlanan işlerin öncelik sırasını göstermektedir.

## 1. Yüksek Öncelikli İşler (Core Mechanics)
- **TAMAMLANDI - Waypoint Hareket Sistemi (Faz 1):** Ekranda tıklanabilir sol/sağ ok arayüzlerinin oluşturulması ve kameranın belirlenen noktalara ışınlanma mekaniği.
- **TAMAMLANDI - Interaction / Raycast Akışı:** Faz 1 waypoint kamera akışı içinde tıklanabilir objelerin raycast ile algılanması ve `_on_interact()` çağrısının doğrulanması.
- **TAMAMLANDI - Ses Sensörü Entegrasyonu:** Ceket arama etkileşimi, yavaş/hızlı arama kontrolü ve üretilen gürültünün `PlayerState` üzerindeki tespiti.
- **TAMAMLANDI - Baş Ağrısı ve Görsel Geri Bildirim:** `detection_level` yükseldikçe devreye girecek gelişmiş vignette ve kulak çınlaması gibi ses/görsel efekt döngüleri.
- **TAMAMLANDI - Bayılma / Respawn Protokolü:** Oyuncu yakalandığında (`detection_level == 1.0`) tetiklenecek olan sahne kararması ve yeniden başlama mekaniği.
- **2D → 3D Geçiş Sahnesi:** Faz 1 bittiğinde devreye girecek olan ve yükleme ekranı barındırmayan narratif glitch efekti animasyonu.

## 2. Orta Öncelikli İşler (Sistem Genişletme)
- **Kamera Quick Event:** Faz 2 için tasarlanan, zamanlama tabanlı saklanma mekanizması (Haritada 2 nokta).
- **Terminal Mini Oyun Altyapısı:** Terminal ekranına tıklandığında açılacak olan izole oyun arayüzü sistemi.
- **State Machine Entegrasyonu:** `PHASE_1`, `TRANSITION`, `PHASE_2` ve `CAUGHT` durumları arasındaki merkezi geçiş mimarisinin oturtulması.
- **Oda Sıralama Mantığı:** Toplam 5 odadan hangilerinin erişilebilir olacağını ve bu seçimlerin envanter/log sistemine nasıl yansıyacağını yöneten kod yapısı.
- **Eksik Kritik Modeller:** Fiziksel güvenlik kamerası modeli, normal iç odalar arası geçiş kapısı modeli ve tıklanabilir terminal ekranı modeli.

## 3. Düşük Öncelikli İşler (Cila ve Kozmetik)
- **Ses Varlıkları (Epidemic Sound):** Server hum, soğutma fanı sesi, durum bip sesleri, kapı mekanizması, kart okuyucu ve sensör aktivasyon seslerinin entegrasyonu.
- **Grafik ve Rendering Cilası:** Screen Space Reflections (SSR), Global Illumination (GI) ayarları ve su birikintisi shader kodları.
- **SEREN Ses/Diyalog Sistemi:** Hoparlörlerden gelecek olan sistem sesleri ve log çıktı arayüzleri.
- **UI ve Envanter Gösterimi:** Toplanan access card nesnelerinin ekranda gösterilmesi ve ana menü tasarımı.




