# Kod Yazan Yapay Zeka Ajanı Kuralları

Bu kurallar bu projede kod yazacak veya düzenleyecek tüm yapay zeka ajanları (Cursor, Codex, Gemini vb.) için katı ve çiğnenemez kurallardır.

## Kodlama Standartları
- **Dil:** Godot 4.x projesi için GDScript kullanımı zorunludur.
- **Static Typing:** Tüm değişken, fonksiyon parametreleri ve dönüş tiplerinde statik tipleme (`: int`, `: Void`, `-> String`) zorunludur. Dinamik veya gevşek tipleme yapılamaz.
- **Mimari:** Global durumlar, envanter ve algılanma seviyeleri kesinlikle Autoload Singleton (`GameState`, `PlayerState`) üzerinden yönetilecektir. Sahne içlerinde bağımsız izole durum değişkenleri tanımlanamaz.

## Kısıtlamalar ve Yasaklar
- **Lore/Mekanik Uydurma Yasağı:** Dokümanlarda belirtilmeyen hiçbir yeni oyun mekaniği, düşman türü, hikaye elementi, diyalog veya karakter koda eklenemez.
- **Görsel/Ses Varlıkları:** Asset listesinde olmayan hiçbir harici ses veya model koda hardcoded olarak gömülemez. Eksik süreçler "DAHA SONRA DOLDURULACAK" şeklinde yorum satırıyla bırakılmalıdır.
- **Çelişki Kuralı:** Eğer yazılması istenen kod görevi (task), `docs/` klasöründeki herhangi bir mimari kararla çelişiyorsa, ajan kod yazmayı durdurmalı ve önce kullanıcıya bu çelişkiyi raporlamalıdır.

## Her Task Öncesi Zorunlu Davranış

- Önce task türünü sınıflandır.
- Sadece ilgili docs dosyalarını oku.
- Task docs ile çelişiyorsa kod yazma.
- En fazla 3 dosya değiştirmeye çalış.
- Daha fazla dosya gerekiyorsa önce plan yaz.

## Yasaklar

- Fiziksel chase enemy ekleme.
- Faz 1'e WASD/mouse look ekleme.
- Faz 2'ye yeni seçim sistemi ekleme.
- Yeni lore/diyalog uydurma.
- Gereksiz refactor yapma.