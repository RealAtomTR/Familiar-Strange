# Tehdit Sistemi ve Yapay Zeka Sensörleri

## Merkezi Algılama Sistemi (`player_state.gd`)
SEREN'in oyuncuyu tespit etme süreci `PlayerState` singleton yapısı üzerinden merkezi olarak yürütülür.
- **`detection_level`:** 0.0 ile 1.0 arasında sınırlandırılmış float değişken.
- **API:** `add_detection(amount: float)` ve `reduce_detection(amount: float)` methodları ile tüm sensörler bu değeri manipüle eder.
- `detection_level` değeri 1.0'a ulaştığında `_on_caught()` tetiklenir, oyuncu yakalanır ve bayılma/respawn döngüsü başlar.

## 1. Güvenlik Kamerası Mekaniği (`security_camera.gd`)
**Node Yapısı:** `Node3D (security_camera)` -> `Head (Node3D)` -> `SpotLight3D (Detection Cone)`.
- **Salınım (Sweep):** Kamera kafası (`Head`), `sin(time * sweep_speed) * sweep_angle` formülü ile yatay eksende otomatik salınım yapar. Varsayılan değerler: `sweep_speed = 1.0`, `sweep_angle = 45.0`.
- **Algılama Mantığı:** Godot 4'te `ConeShape3D` bulunmadığı için tarama konisi tespiti **dot product (noktasal çarpım)** algoritması ile manuel hesaplanır.
- Oyuncu, kameranın SpotLight3D konisi içinde kaldığı her kare (frame) için `PlayerState.add_detection(0.01)` çağrısıyla cezalandırılır.

## 2. Hareket Sensörü / Bozuk Hoparlör (`motion_sensor.gd`)
SEREN tarafından modifiye edilmiş, interval bazlı çalışan el yapımı bir duvar sensörüdür.
- **Node Yapısı:** `Node3D` -> `Area3D` -> `CollisionShape3D` ve geri bildirim için bir `OmniLight3D`.
- **Çalışma Döngüsü:**
  - **Normal Durum:** Sensör ışığı beyaz yanar, algılama yapmaz.
  - **Tarama Zamanı:** `check_interval = 1.5` saniyede bir (veya rastgele aralıklarla) tarama başlar, ışık kırmızıya döner.
  - **Ceza/Şans Kontrolü:** Kırmızı ışık esnasında oyuncu sensörün `Area3D` alanı içindeyse ve hareket ediyorsa, `catch_chance = 0.7` olasılıkla yakalanır.
    - *Yakalandıysa:* Işık kırmızı kalır, `PlayerState.add_detection(1.0)` tetiklenir ve oyun biter.
    - *Şans eseri kurtulduysa (Kaçtı):* Işık sarı renge döner (0.5 saniye), ardından tekrar beyaz duruma geçerek sıfırlanır.

## 3. Ses Sensörü Mekaniği
- Belirli bir odada, erişim kartının gizlendiği ceket arama alanında aktiftir.
- Oyuncu ceketleri ararken hızlı veya dikkatsiz etkileşime girerse gürültü üretilir; smooth ve yavaş etkileşim zorunludur. Gürültü doğrudan `detection_level` değerini artırır.

## 4. Kamera Quick Event Sistemi (Faz 2)
- Faz 2 serbest hareket modunda devreye giren, haritada önceden belirlenmiş 2 adet saklanma noktasını kullanan, timing (zamanlama) tabanlı saklanma mekaniğidir.