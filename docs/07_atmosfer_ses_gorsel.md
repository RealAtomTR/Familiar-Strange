# Sanat Tasarımı, Atmosfer ve Ses

## Görsel Stil (Art Style)
- **"Lo-fi geometry, hi-fi rendering"**
- Modeller kasıtlı ve estetik bir tercih olarak low-poly (düşük poligonlu) tasarlanmıştır.
- Rendering kalitesi ise moderndir; volumetric fog, screen space reflections (SSR), global illumination (GI) ve dinamik gölgeler yoğun şekilde kullanılır.
- PS1 dönemi estetiğinin modern shader teknolojileriyle birleşimi hedeflenmiştir.

## Renk Paleti ve Işıklandırma
- **Ana Tonlar:** Derin siyah ve koyu gri (#0a0a0a, #1a1a1a).
- **Aksent (Sunucu Işıkları):** Soğuk mavi (#1a3a6e, #2a5aa0) sunucu LED'leri.
- **Tehlike Durumu:** Yakalanma anlarında ve riskli bölgelerde baskın kırmızı (#8b0000, #cc0000).
- **Kaçış/Şans:** Başarılı sensör atlatma anlarında sarı (#b8860b).
- **Ortam (Ambient):** Haritada genel bir ortam ışığı yoktur, neredeyse sıfırdır. Işık sadece teknik kaynaklardan (LED, spot, ekran) yayılır.

## Liminal Space Elementleri
- İnsan ölçeğine göre yapılmış ancak tamamen insansız bırakılmış devasa endüstriyel alanlar.
- Endüstriyel bir veri merkezinin ortasına absürt şekilde yerleştirilmiş eski ofis mobilyaları (koltuk, masalar).
- Açıklayıcı hiçbir yazı veya tabela içermeyen, sadece ağır teknik jargon barındıran ekranlar.

## Ses Tasarımı Katmanları
1. **Base Layer (Taban):** Sürekli arkada dönen düşük frekanslı server hum ve soğutma sistemi mekanik sesleri.
2. **Dynamic Layer (Dinamik):** Sunucu yüküne göre değişen fan RPM sesleri, rastgele status beeg'leri ve HVAC havalandırma ritmi.
3. **Event Layer (Olay):** Kapıların hidrolik açılma mekanizmaları, sensörlerin devreye girme sinyalleri ve kart okuyucu sesleri.
4. **Tension Layer (Gerilim):** Oyuncunun `detection_level` değeri arttıkça senkronize olarak yoğunlaşan kalp atışı benzeri derin ambiyans ve baş ağrısı/kulak çınlaması efektleri. Kasıtlı olarak oyuncu adım sesi eklenmemiştir.