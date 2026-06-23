# İlerleyiş Akışı ve Bölüm Tasarımı

## State Machine (Oyun Durumları)
Oyunun genel akışı `GAME_STATE` enum yapısı üzerinden yönetilir:
- **PHASE_1_2D:** Kamera pozisyonu sabit, sadece yatay bakış ve tıklama ile waypoint hareketi devrededir. Tüm oynanış kararları buradadır.
- **PHASE_TRANSITION:** 3 oda tamamlandığında tetiklenen, yükleme ekranı olmayan narratif glitch efekti sahnesidir.
- **PHASE_2_3D:** Serbest WASD hareketi, atmosfer ve quick-event odaklı dikey kesit.
- **CAUGHT:** `PlayerState.detection_level == 1.0` olduğunda tetiklenen yakalanma anı.
- **GAME_OVER:** Oyuncunun yakalanması sonrası beliren ekran veya restart protokolü.

## Bölüm ve İlerleyiş Yapısı
1. **Uyanış (Start):** Oyuncu veri merkezinin ortasındaki eski bir ofis koltuğunda bilincini kazanır (PHASE_1_2D başlar).
2. **Keşif ve Kart Toplama:** Odaların kilitlerini açabilmek için etraftaki masalar raycast ile aranarak `Access Card` nesneleri toplanır.
3. **Oda Girişleri ve Terminal Eventleri:** Toplamda 5 odadan erişilebilir olan 3 odaya girilir. Her odada SEREN'in işletim sistemini barındıran bir terminal bulunur; bu terminallerde mini oyunlar tamamlanır.
4. **Geçiş (Transition):** 3 oda başarıyla tamamlandığı an `PHASE_TRANSITION` devreye girer, ekran bozulur ve dünya 3D olarak yeniden render edilir.
5. **Dikey Kesit ve Final (PHASE_2_3D):** Oyuncu serbest hareketle ilerlerken atmosferi deneyimler ve zamanlama bazlı quick-event'leri atlatır. Oyun, girilen oda kombinasyonlarına (Tip A / Tip B) göre SEREN'in oyuncuyu tanımlama düzeyini belirlediği final sahnesi ile sonlanır.

## Kesin Olmayan / Belirsiz Bilgiler
- **DAHA SONRA DOLDURULACAK:** Kalan 2 kilitli odanın sonraki run'lar için tasarımları.
- **WIP (SONRADAN KARAR VERİLECEK):** Seçilen oda kombinasyonlarının SEREN ile karşılaşma anındaki diyalog ve mekanik ağaçlarına tam etkisi.