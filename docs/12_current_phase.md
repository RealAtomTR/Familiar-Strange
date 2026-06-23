# Current Phase

## 1. Current Goal
- Playable vertical slice tamamlamak.
- Hedef kapsam: Faz 1 ağırlıklı ilerlemek, Faz 2 geçişini yalnızca gerekli kadar hazırlamak.

## 2. Current Phase
- Faz 1 odaklı üretim.
- Oran: `%80 Faz 1` / `%20 Faz 2`
- Durum: `BELİRSİZ` detaylar varsa önce `docs/10_karar_kaydi.md` ve `docs/00_oyun_ozeti.md` kontrol edilmeli.

## 3. Active Task
- `2D -> 3D Geçiş Sahnesi`
- Öncelik: Faz 1 bittiğinde devreye girecek minimal narratif glitch / geçiş prototipini planlamak.

## 4. Done
- İki fazlı yapı kararı kayıt altında.
- Fiziksel chase enemy olmayacağı kararı kayıt altında.
- Faz 1 / Faz 2 ayrımı ve vertical slice hedefi dokümana işlendi.
- Proje takip amacıyla bu state dosyası oluşturuldu.
- `Waypoint Hareket Sistemi (Faz 1)` tamamlandı.
- Kamera sol / sağ UI oklarıyla waypoint pozisyonları arasında geçiyor.
- Faz 1 kamera geçişinde yalnızca pozisyon değişiyor; kamera açısı sabit korunuyor.
- `Interaction / Raycast akışını doğrulama` tamamlandı.
- Mouse release + drag threshold + raycast + `interactable` isim kuralı çalışır durumda.
- Test interactable objesi ile `_on_interact()` çağrısı doğrulandı.
- `Ses Sensörü Entegrasyonu` prototipi tamamlandı.
- Ceket/aranabilir obje prototipi `Q` yavaş arama ve `E` hızlı arama ile noise üretiyor.
- `PlayerState` Autoload eklendi; `noise_level`, `detection_level` ve tekil `player_caught` emit koruması çalışır durumda.
- `Baş Ağrısı ve Görsel Geri Bildirim` prototipi tamamlandı.
- `PlayerState.detection_level` arttıkça tam ekran kırmızı overlay alpha değeri artıyor.
- `Bayılma / Respawn Protokolü` prototipi tamamlandı.
- `PlayerState.player_caught` sinyali siyah overlay ve sahne reload/reset akışını tetikliyor.

## 5. Next Tasks
- Faz 1 tamamlandığında tetiklenecek minimal glitch transition prototipi eklemek.
- Geçiş için `PHASE_TRANSITION` / `PHASE_2_3D` state kararını küçük mimari task olarak netleştirmek.
- Test interactable objesinin production sahnesinde kalıp kalmayacağını sonraki temizlikte netleştirmek.
- `State Machine` geçişlerini mevcut backlog sırasına göre planlamak.

## 6. Blockers
- UI ok yerleşimi farklı çözünürlüklerde manuel kontrol edilmeli.
- Test interactable objesi production sahnesinde geçici test objesi olarak duruyor; sonraki temizlikte kaldırılmalı veya netleştirilmeli.
- `player_state.gd` dosyasında BOM olduğu raporlandı; Godot genelde tolere eder ama sonraki temizlikte BOM'suz standarda çekilebilir.
- `caught_respawn_overlay.gd` içinde `PlayerState.player_caught` bağlantısı runtime debugger'da kontrol edilmeli; statik review temiz.
- Eğer `docs/10_karar_kaydi.md` ile backlog arasında çelişki çıkarsa önce karar kaydı esas alınır.

## 7. Last Important Decision
- Oyun iki fazlı olacak.
- İlk yaklaşık `%80` bölüm Faz 1, son `%20` bölüm Faz 2 olarak ilerleyecek.
- İlk hedef playable vertical slice.

## 8. Notes for Agents
- Önce `docs/10_karar_kaydi.md` ve `docs/00_oyun_ozeti.md` oku.
- Gereksiz doküman okutma; yalnızca task ile ilgili dosyaları aç.
- Yeni lore, yeni mekanik veya yeni sistem uydurma.
- Belirsiz alanları `BELİRSİZ` olarak bırak.
- `.tscn` dosyalarını BOM'suz UTF-8 olarak kaydet.
- Çelişki varsa kod yazmadan önce raporla.
- Bu dosya production state içindir, lore dokümanı değildir.
