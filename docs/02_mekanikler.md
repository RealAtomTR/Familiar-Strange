# Oynanış Sistemleri ve Mekanikler

## Core Loop (Ana Oynanış Döngüsü)
1. Oyuncu ofis koltuğunda uyanır (Faz 1).
2. Oyunun sunduğu Ekrandaki Butonlarla görüşler arası gezer (sabit açılar var hareket edemez kullanıcı serbestçe), raycast yardımıyla masaları inceler.
3. Masalardan ilgili odanın `Access Card` nesnesini toplar.
4. Kartı kapıda okutarak kilitli odaya giriş sağlar (Girişler SEREN tarafından loglanır).
5. Oda içerisindeki terminal ekranına tıklayarak mini oyunu başlatır ve tamamlar.
6. Bu süreçte kameraları, hareket ve ses sensörlerini atlatır.
7. Toplam 5 odadan 3'ünü tamamladığında Faz 2'ye geçiş tetiklenir.

## İki Faz Mekaniği
- **Faz 1 (2D Flash / Point-and-Click Modu):**
  - Kamera pozisyonu tamamen sabittir.
  - Serbest yürüme yoktur; ekrandaki UI oklarına tıklanarak önceden tanımlanmış waypoint'lere direkt teleport olunur.
- **Faz 2 (3D Low-Poly Gerilim Modu):**
  - Serbest WASD hareketi ve serbest mouse bakışı aktifleşir.
  - Hikaye sahneleri ve zamanlama bazlı quick-event'ler (saklanma) devreye girer.
  - Oyuncu bu fazda serbestçe gezebilir ancak oyunun gidişatını etkileyecek yeni kararlar veremez; tüm kararlar Faz 1'de tamamlanmıştır.

## Oda ve Kart Seçim Sistemi
- Tesiste toplam 5 oda bulunur. 3'ü erişilebilir (kartları yerleştirilmiştir), 2'si tamamen kilitlidir.
- **Oda Tipleri:**
  - **Tip A Odaları:** SEREN'in internet erişimi, nesne algılama gibi spesifik modüllerini etkiler.
  - **Tip B Odaları:** Farklı altyapı modüllerini etkiler.
- Oyuncunun tercih ettiği 3 odanın kombinasyonu (örn: 2A + 1B veya 3A), SEREN'in oyuncuyu ne kadar ve nasıl tanımlayacağını belirleyerek finale direkt etki eder.

## Algılanma (Detection) Sistemi
- `PlayerState` altındaki `detection_level` değişkeni 0.0 ile 1.0 arasında çalışır.
- Sensörler ve kameralar bu değeri artırır.
- Değer yükseldikçe tam ekranda kırmızı bir vignette overlay belirir (0.0'da tamamen şeffaf, 1.0'da 0.3 alpha değerinde kırmızı).
- Değer 1.0'a ulaştığında oyuncu yakalanır, bayılma efekti tetiklenir ve sistem cezalandırma/respawn protokolünü başlatır.