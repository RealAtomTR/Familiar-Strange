# Claude / Başka Yapay Zekâ İçin Bilgileri Markdown Dosyalarına Aktarma Prompt'u

Aşağıdaki prompt'u Claude, ChatGPT, Gemini veya başka bir yapay zekâya verebilirsin.

Amaç:
Önceden anlattığım oyun fikri, hikâye, mekanik ve atmosfer bilgilerini Godot projemde kullanacağım düzenli Markdown dokümanlarına dönüştürmek.

---

## Kullanılacak Prompt

```text
Sana daha önce anlattığım veya aşağıya yapıştıracağım oyun fikri, hikâye, mekanik, atmosfer ve ilerleyiş bilgilerini düzenli Markdown dokümanlarına ayırmanı istiyorum.

Bu dokümanlar Godot Engine projemin `docs/` klasöründe duracak.
Kod yazan yapay zekâ ajanları bu dosyaları okuyarak oyunu anlayacak.

Lütfen yeni lore, yeni mekanik veya yeni olay uydurma.
Sadece verdiğim bilgileri düzenle.
Eksik olan yerleri "BELİRSİZ" veya "DAHA SONRA DOLDURULACAK" diye işaretle.
Emin olmadığın şeyleri kesin bilgi gibi yazma.
Kısa, net ve uygulanabilir yaz.

Oyunun mevcut ana fikri:
- Oyun yapay zekâ veri merkezinde geçen liminal space + gerilim oyunu.
- İlk yaklaşık %80'lik bölüm 3D ortamda geçer ama 2D/flash oyun hissi verir.
- Kamera sabittir.
- Oyuncu sağ/sol ok arayüzleriyle geçiş efekti kullanarak yön değiştirir.
- Aktif şekilde oyuncuyu kovalayan fiziksel bir yaratık yoktur.
- Mekândaki yapay zekâ oyuncuyu hareket sensörü, ses sensörü, kameralar ve benzeri sistemlerle bulmaya çalışır.
- Sensörlerden geçmek veya onları atlatmak için ekranda çıkan arayüz mini oyunları kullanılır.
- Ana his: geniş alanda daralmışlık, izlenme hissi, kontrolün sınırlanması, liminal gerilim.

Çıktıyı şu dosyalar halinde üret:

1. `00_oyun_ozeti.md`
2. `01_hikaye_lore.md`
3. `02_mekanikler.md`
4. `03_ilerleyis_akisi.md`
5. `04_kamera_sistemi.md`
6. `05_tehdit_sistemi_ai_sensors.md`
7. `06_mini_oyunlar.md`
8. `07_atmosfer_ses_gorsel.md`
9. `08_yapay_zeka_ajan_kurallari.md`
10. `09_feature_backlog.md`
11. `10_karar_kaydi.md`

Her dosya için ayrı başlık aç.
Her dosyanın içeriğini kopyala-yapıştır yapılabilecek Markdown formatında ver.

Dosya içeriklerinde şu kurallara uy:

- `00_oyun_ozeti.md` kısa olsun. Kod ajanları bunu her zaman okuyacak.
- `01_hikaye_lore.md` sadece hikâye ve dünya bilgisi içersin.
- `02_mekanikler.md` sadece oynanış sistemlerini anlatsın.
- `03_ilerleyis_akisi.md` bölüm/bölüm ilerleyişi anlatsın.
- `04_kamera_sistemi.md` sadece kamera ve yön değiştirme sistemini anlatsın.
- `05_tehdit_sistemi_ai_sensors.md` yapay zekâ tehdidi, sensörler, kameralar ve tespit sistemini anlatsın.
- `06_mini_oyunlar.md` sensörleri atlatmak için kullanılan mini oyun mantığını anlatsın.
- `07_atmosfer_ses_gorsel.md` liminal space, ses, ışık, UI ve gerilim tonunu anlatsın.
- `08_yapay_zeka_ajan_kurallari.md` kod ajanlarına verilecek kuralları içersin.
- `09_feature_backlog.md` yapılacak feature listesini çıkarsın.
- `10_karar_kaydi.md` şu ana kadar verilmiş net tasarım kararlarını ve nedenlerini yazsın.

Özellikle şu ayrımı koru:
- Kesin bilgiler
- Belirsiz bilgiler
- Sonradan karar verilecek bilgiler

Şimdi sana mevcut konuşma notlarımı / hikâye bilgilerimi / mekanik açıklamalarımı yapıştırıyorum:

[BURAYA ESKİ SOHBETTEN VEYA NOTLARDAN BİLGİLERİ YAPIŞTIR]
```

---

## Claude'dan Çıktı Aldıktan Sonra Yapılacaklar

1. Her dosya başlığını ayrı `.md` dosyasına kopyala.
2. Dosyaları Godot projesindeki `docs/` klasörüne koy.
3. Çok uzun, fazla edebi veya belirsiz yerleri sadeleştir.
4. Eksik kalan başlıkları "DAHA SONRA DOLDURULACAK" olarak bırak.
5. Kod ajanına görev verirken ilgili dosyaları okut.

---

## Claude'a Ek Uyarı Gerekirse

Claude fazla fikir üretirse şu ek mesajı gönder:

```text
Fikir üretme.
Yeni mekanik, yeni karakter veya yeni lore ekleme.
Sadece verdiğim bilgileri daha düzenli Markdown dokümanlarına aktar.
Belirsiz şeyleri belirsiz olarak işaretle.
```

---

## Kod Ajanına Daha Sonra Verilecek Kısa Başlangıç Prompt'u

```text
Önce şu dosyaları oku:
- docs/00_oyun_ozeti.md
- docs/02_mekanikler.md
- docs/08_yapay_zeka_ajan_kurallari.md

Task ile ilgili özel dosya varsa onu da oku.

Dokümanlarla çelişen bir şey görürsen kod yazmadan önce belirt.
Lore veya mekanik uydurma.
Sadece verilen feature spec'i uygula.
```
