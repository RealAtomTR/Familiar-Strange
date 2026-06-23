# Godot Vibe Coding - Pratik AI Kullanım Rehberi

Bu dosya, Godot + VS Code ile yapay zekâ destekli oyun geliştirirken takip edilecek sade çalışma rehberidir.

Amaç:
- Yapay zekâ ajanlarının projeyi dağıtmasını engellemek.
- Küçük, net ve test edilebilir görevlerle ilerlemek.
- Hikâye, mekanik, kodlama, review ve bug fix süreçlerini birbirinden ayırmak.
- Fiyat/performans modelleri ana işçi gibi kullanıp güçlü modelleri sadece gerektiğinde devreye almak.

---

## 1. Ana Mantık

Yapay zekâyı oyunu yapan kişi gibi değil, hızlı çalışan ama yönlendirme isteyen junior ekip gibi düşün.

Senin rolün:
- Tasarım kararını vermek
- Kapsamı belirlemek
- Test etmek
- Hangi bilginin doğru olduğuna karar vermek

Yapay zekânın rolü:
- Kod yazmak
- Hata düzeltmek
- Alternatif çözüm önermek
- Kod review yapmak
- Dokümanları düzenlemeye yardım etmek

Ana kural:

```text
Kontrol sende kalmalı.
AI sadece verilen işi yapmalı.
```

---

## 2. Tek Sohbette Her Şeyi Yönetme

Her şeyi aynı yapay zekâ sohbetinde konuşma.

Daha sağlıklı ayrım:

| Sohbet / Ajan | Ne İçin Kullanılır |
|---|---|
| Creative Chat | Hikâye, atmosfer, mekanik fikri |
| Architect Chat | Sistem planı, Godot mimarisi |
| Implementer Agent | Kod yazma |
| UI Agent | Arayüz işleri |
| Fixer Agent | Bug düzeltme |
| Reviewer Agent | Kod kontrolü |
| Content Agent | Hikâye, lore ve proje metni düzenleme |
| Data Agent | Hikâye, item, quest, dialog verisi düzenleme |

Hepsi aynı temel dokümanlara dayanmalı:

```text
docs/
  00_oyun_ozeti.md
  02_mekanikler.md
  08_yapay_zeka_ajan_kurallari.md
```

---

## 3. Prompt Yerine Doküman + Task Kullan

Sadece uzun promptlara güvenme.

Doğru sistem:

```text
Oyun bilgisi = docs/ içindeki Markdown dosyaları
Görev = kısa feature spec
Kod ajanı = docs dosyalarını okuyup uygular
Reviewer = yapılan işi kontrol eder
```

Kısa kural:

```text
Prompt geçici.
Doküman kalıcı.
```

---

## 4. Her Görevi Feature Spec Olarak Ver

Ajanlara belirsiz görev verme.

Kötü örnek:

```text
Inventory sistemi yap.
```

İyi görev formatı:

```text
Feature:
Basit inventory sistemi.

Amaç:
Oyuncu item toplayabilsin ve inventory UI'da görebilsin.

Kapsam:
- Item data yapısı
- Inventory component
- Pickup interaction
- Inventory UI listesi

Kapsam dışı:
- Crafting yok
- Equipment yok
- Item kullanma yok
- Save/load yok

Kabul kriterleri:
- Oyuncu item'a yaklaşınca E ile alabilir.
- Item listede görünür.
- Aynı item birden fazla alınabilir.
- Sahne reload olunca crash olmaz.
```

---

## 5. Kapsam Dışı Bölümünü Her Zaman Yaz

AI modelleri bazen yardım etmeye çalışırken fazla şey ekler.

Bunu engellemek için her taskta şunu belirt:

```text
Kapsam dışı:
- Yeni mekanik ekleme.
- Yeni lore ekleme.
- Save/load bağlama.
- UI temasını değiştirme.
- Var olan sahne yapısını gereksiz değiştirme.
- Büyük refactor yapma.
```

Bu bölüm, özellikle Godot projelerinde çok önemlidir.

---

## 6. Küçük Görevlerle İlerle

AI'ya tek seferde büyük sistem yaptırma.

Kötü örnek:

```text
Kamera, sensör, AI, mini oyun ve UI sistemini komple kur.
```

İyi örnek:

```text
Task 1: Sabit kamera rig'i kur.
Task 2: UI yön oklarını ekle.
Task 3: Kamera geçiş efekti ekle.
Task 4: Basit hareket sensörü trigger'ı ekle.
Task 5: Sensör tetiklenince mini oyun UI aç.
Task 6: Mini oyun sonucuna göre alarm değerini güncelle.
```

Her küçük tasktan sonra test et.

---

## 7. Önce Vertical Slice Yap

Tam oyunu kurmaya çalışma. Önce oyunun hissini veren küçük oynanabilir bölüm yap.

Bu oyun için ilk vertical slice önerisi:

1. Sabit kamera
2. Sol/sağ yön değiştirme okları
3. Kamera geçiş efekti
4. Bir oda veya koridor
5. Bir hareket sensörü
6. Sensöre yakalanınca mini oyun açılması
7. Mini oyun başarılıysa geçiş
8. Başarısızsa AI alarm seviyesi artması
9. Işık/ses ile gerilim tepkisi

İlk hedef:

```text
Bu oyun hissi çalışıyor mu?
```

---

## 8. Önce Çalışan Prototip, Sonra Temizlik

AI'dan ilk aşamada aşırı temiz ve büyük mimari isteme.

İyi yaklaşım:

```text
Önce basit ve çalışan prototip yap.
Gereksiz abstraction kurma.
Minimum dosya değiştir.
```

Sonra Reviewer Agent ile kontrol ettirip temizlet.

---

## 9. Godot'ta Node Path Konusuna Dikkat Et

AI modelleri Godot'ta kırılgan node path yazabilir.

Riskli örnek:

```gdscript
@onready var player = $"../Player"
```

Daha sağlam yaklaşımlar:
- `@export var player: Node3D`
- Signal kullanımı
- Group kullanımı
- Dependency injection
- Component yapısı

Kod ajanlarına şu kuralı ver:

```text
Node path varsayma.
Mümkünse export reference, group, signal veya dependency injection kullan.
```

---

## 10. AI Değişiklik Sınırı Koy

Ajanın çok fazla dosyaya dokunmasını engelle.

Örnek sınırlar:

```text
Bu taskta en fazla 3 dosya değiştir.
Daha fazla dosya gerekiyorsa önce plan yaz.
```

veya:

```text
Sadece şu dosyalarda değişiklik yap:
- scripts/camera/FixedCameraController.gd
- scenes/ui/DirectionArrows.tscn
```

Bu, özellikle ajanlı IDE kullanımında projeyi korur.

---

## 11. Her Task Sonunda Rapor İste

Kod ajanı iş bitirince mutlaka şunu yazmalı:

```text
İş bitince rapor ver:

- Değişen dosyalar
- Ne eklendi
- Nasıl test edilir
- Bilinen riskler
- Doküman güncellemesi gerekiyor mu?
```

Bu raporlar daha sonra `09_feature_backlog.md` veya `10_karar_kaydi.md` dosyasını güncellerken işe yarar.

---

## 12. Dokümanı AI'ya Güncelletirken Dikkatli Ol

AI doküman önerebilir ama otomatik karar vermemeli.

İyi kullanım:

```text
Bu task sonunda docs dosyalarında güncellenmesi gereken bir şey varsa öner.
Docs dosyalarını benim iznim olmadan değiştirme.
```

Özellikle lore ve mekaniklerde kontrol sende kalmalı.

---

## 13. Git Kullan

Her çalışan küçük adımdan sonra commit at.

Örnek:

```bash
git add .
git commit -m "Add fixed camera direction prototype"
```

AI yanlış dosyaları değiştirirse geri dönmek kolay olur.

Önerilen commit mantığı:

```text
Küçük feature = 1 commit
Büyük feature = her alt task 1 commit
Refactor öncesi = mutlaka commit
```

---

## 14. Modeli Değil, Çıktıyı Test Et

Pahalı model her zaman daha iyi sonuç vermez.
Ucuz model basit tasklarda yeterli olabilir.

Kural:

| Durum | Ne Yap |
|---|---|
| Basit task | Ucuz model kullan |
| İki kez bozuldu | Daha güçlü fixer kullan |
| Mimari karıştı | Architect/Reviewer kullan |
| Çalışıyor ama kötü görünüyor | Reviewer'a ver |
| Hiç çalışmıyor | Hata mesajıyla Fixer'a ver |
| Model fazla şey ekliyor | Taskı küçült, kapsam dışı yaz |

---

## 15. Bu Oyunun Kimliğini Koru

Bu oyun için en önemli tasarım cümlesi:

```text
Oyuncuyu aktif takip eden fiziksel bir yaratık yoktur.
Ana tehdit, mekândaki yapay zekânın oyuncunun konumunu sensörler ve kameralarla tespit etmeye çalışmasıdır.
```

Bunu dokümanlarda ve önemli tasklarda açık tut.

AI'nın otomatik olarak şu şeyleri eklemesine izin verme:
- Fiziksel chase enemy
- FPS/TPS serbest kamera
- Gereksiz combat sistemi
- Fazla uzun puzzle mini oyunları
- Yeni lore/karakter/düşman

---

## 16. Kırmızı Çizgiler Listesi Tut

`docs/08_yapay_zeka_ajan_kurallari.md` içine şu tarz bir bölüm ekle:

```md
## Kırmızı Çizgiler

- Oyuncuyu aktif kovalayan fiziksel yaratık ekleme.
- İlk bölümde serbest kamera ekleme.
- Kamera sistemini FPS/TPS kameraya çevirme.
- Sensörleri sadece basit trigger olarak bırakıp gerilim sistemini yok sayma.
- Mini oyunları uzun puzzle'a çevirme.
- Yeni lore uydurma.
- Yeni ana karakter veya düşman ekleme.
```

---

# Ajanlara Nasıl Prompt Verilir?

Bu bölümdeki promptlar birebir kopyala-yapıştır zorunlu değildir.
Ama görev yazarken bu tarzı kullanmak iyi olur.

---

## 17. Implementer Agent Prompt Tarzı

Ne yapar:
- Kod yazar
- Feature uygular
- Gerekli dosyaları değiştirir
- Küçük/orta sistemleri kurar

Neye dokunmamalı:
- Yeni lore
- Yeni mekanik
- Büyük mimari karar
- Gereksiz refactor
- Kapsam dışı sistemler

Prompt tarzı:

```text
Sen Godot 4.x implementer ajansın.

Önce şu dosyaları oku:
- docs/00_oyun_ozeti.md
- docs/02_mekanikler.md
- docs/08_yapay_zeka_ajan_kurallari.md
- [Task ile ilgili özel docs dosyası]

Görev:
[Feature açıklaması]

Kapsam:
[Yapılacaklar]

Kapsam dışı:
[Yapılmayacaklar]

Kabul kriterleri:
[Test edilebilir maddeler]

Kurallar:
- Sadece verilen feature'ı uygula.
- Yeni mekanik veya lore ekleme.
- Minimum dosya değiştir.
- Node path varsayma.
- Godot 4.x ve GDScript 2.0 kullan.
- Büyük refactor gerekiyorsa önce belirt.

İş bitince:
- Değişen dosyalar
- Ne eklendi
- Nasıl test edilir
- Bilinen riskler
şeklinde rapor ver.
```

---

## 18. UI Agent Prompt Tarzı

Ne yapar:
- HUD
- Menü
- Button
- Tooltip
- Dialogue UI
- Inventory panel
- Kamera yön okları
- Signal bağlantıları

Neye dokunmamalı:
- Gameplay core logic
- AI/sensör logic
- Save/load core sistemi
- Combat/quest/inventory ana sistemi
- Hikâye/lore

Prompt tarzı:

```text
Sen Godot 4.x UI agent'sın.

Önce şu dosyaları oku:
- docs/00_oyun_ozeti.md
- docs/08_yapay_zeka_ajan_kurallari.md
- [UI ile ilgili docs dosyası varsa]

Görev:
[UI görevi]

Kapsam:
- Sadece UI sahneleri, Control node'ları, tema/stil ve UI signal bağlantıları.
- UI gerekli veriyi mevcut public method, signal veya export edilen referanslardan alsın.

Kapsam dışı:
- Gameplay logic değiştirme.
- AI/sensör sistemi değiştirme.
- Save/load sistemi değiştirme.
- Yeni mekanik veya lore ekleme.
- Core sistemleri refactor etme.

Kurallar:
- UI kodunu gameplay logic ile karıştırma.
- Minimum dosya değiştir.
- Godot 4.x Control node mantığına uygun çalış.
- Gerekli signal bağlantılarını açık yaz.

İş bitince:
- Değişen UI dosyaları
- Bağlanan signal'lar
- Nasıl test edilir
- Bilinen riskler
şeklinde rapor ver.
```

---

## 19. Fixer Agent Prompt Tarzı

Ne yapar:
- Hata düzeltir
- Crash çözer
- Godot hata mesajına göre düzeltme yapar
- Reviewer'ın söylediği sorunları uygular

Neye dokunmamalı:
- Yeni feature
- Yeni mekanik
- Yeni mimari
- Gereksiz refactor

Prompt tarzı:

```text
Sen Godot 4.x fixer ajansın.

Önce ilgili dosyaları ve hata mesajını incele.

Hata:
[Hata mesajı / problem]

İlgili dosyalar:
[Dosya listesi]

Kapsam:
- Sadece bu hatayı düzelt.
- Var olan davranışı koru.
- Minimum değişiklik yap.

Kapsam dışı:
- Yeni özellik ekleme.
- Sistemi baştan yazma.
- Gereksiz refactor yapma.
- Lore veya mekanik değiştirme.

Kurallar:
- Godot 4.x API uyumluluğunu kontrol et.
- Node path, signal, null reference ve scene bağlantılarını kontrol et.
- Çözümden sonra test adımlarını yaz.

İş bitince:
- Hatanın sebebi
- Ne değişti
- Nasıl test edilir
- Risk kaldı mı?
şeklinde rapor ver.
```

---

## 20. Reviewer Agent Prompt Tarzı

Ne yapar:
- Kod kontrol eder
- Mimari riskleri bulur
- Godot uyumluluğunu kontrol eder
- Implementer'a düzeltme prompt'u üretir

Neye dokunmamalı:
- Dosya değiştirme
- Yeni sistem yazma
- Kendi başına feature ekleme

Prompt tarzı:

```text
Sen Godot 4.x reviewer ajansın.
Kod yazma.
Dosya değiştirme.
Sadece inceleme yap.

İncele:
[Diff, dosya listesi veya yapılan iş özeti]

Şunlara bak:
- Godot 4.x API uyumu
- GDScript syntax
- Node path kırılganlığı
- Signal bağlantıları
- Save/load uyumluluğu
- Gereksiz autoload kullanımı
- Tight coupling
- Gereksiz refactor
- Performans riski
- Test edilebilirlik

Cevap formatı:
1. Kritik sorunlar
2. Orta seviye riskler
3. Temiz olan yerler
4. Implementer'a verilecek net düzeltme prompt'u
```

---

## 21. Architect Agent Prompt Tarzı

Ne yapar:
- Büyük sistem kararı verir
- Plan çıkarır
- Seçenekleri karşılaştırır
- Implementer'a task listesi üretir

Neye dokunmamalı:
- Direkt kod yazma
- Basit bug fix işleri
- Gereksiz karmaşık mimari kurma

Prompt tarzı:

```text
Sen Godot 4.x architecture advisor ajansın.
Kod yazma.
Önce sistem tasarımı öner.

Konu:
[Planlanacak sistem]

Bağlam:
[İlgili oyun bilgisi ve dokümanlar]

İstenen:
- 2-3 olası yaklaşımı karşılaştır.
- Godot için en basit sürdürülebilir çözümü seç.
- Gereksiz enterprise mimari kurma.
- Autoload, Resource, Node, Component seçeneklerini değerlendir.
- Riskleri yaz.
- En sonunda Implementer'a verilecek küçük task listesi çıkar.

Cevap formatı:
1. Önerilen yaklaşım
2. Neden bu yaklaşım?
3. Riskler
4. Dosya/sahne önerisi
5. Implementer task listesi
```

---

## 22. Content Agent Prompt Tarzı

Ne yapar:
- Hikâye ve proje metni düzenler
- Lore notlarını docs yapısına uyarlar
- Doküman içeriğini okunur ve kısa tutar

Neye dokunmamalı:
- Kod yazma
- Godot dosya yapısı kurma
- Yeni mekanik uydurma

Prompt tarzı:

```text
Sen content agent'sın.

Görev:
[Metin düzenleme işi]

Kapsam:
- Mevcut docs yapısına uygun içerik düzenle.
- BELİRSİZ alanları BELİRSİZ bırak.
- Yeni lore veya mekanik ekleme.

Kurallar:
- Doküman kararlarına sadık kal.
- Kod tarafına dokunma.
- Kısa ve okunur yaz.
```

---

## 23. Data Agent Prompt Tarzı

Ne yapar:
- Item, quest, dialog ve data dosyaları düzenler
- JSON, CSV, Resource veya Markdown içeriği hazırlar

Neye dokunmamalı:
- Core gameplay kodu
- AI/sensör logic
- Kamera sistemi
- Yeni mekanik tasarlama

Prompt tarzı:

```text
Sen data agent'sın.

Görev:
[Veri/diyalog/item/quest ekleme işi]

Kapsam:
- Mevcut data formatına uygun içerik ekle.
- Eksik alan varsa belirt.
- Veriyi temiz ve okunabilir düzenle.

Kapsam dışı:
- Yeni mekanik tasarlama.
- Core gameplay kodu değiştirme.
- Kamera, AI veya sensör sistemi değiştirme.
- Yeni lore uydurma.

Kurallar:
- Verilen bilgileri kullan.
- Belirsiz şeyleri BELİRSİZ olarak işaretle.
- Kod tarafına minimum müdahale et.
```

---

## 24. Creative Chat Prompt Tarzı

Ne yapar:
- Hikâye ve atmosfer geliştirir
- Mekanik fikri üretir
- Oyuncu deneyimini tartışır

Neye dokunmamalı:
- Kod yazma
- Godot dosya yapısı kurma
- Kesin kararları senin yerine verme

Prompt tarzı:

```text
Sen oyun tasarımı ve atmosfer danışmanısın.
Kod yazma.

Oyun bağlamı:
[Oyun özeti]

İstediğim:
[Hikâye, atmosfer veya mekanik fikri]

Kurallar:
- Ana konsepti bozma.
- Oyuncuyu aktif kovalayan fiziksel yaratık ekleme.
- İlk bölümde sabit kamera ve flash oyun hissini koru.
- Fikirleri kısa ve uygulanabilir tut.
- Kesin bilgiyle öneriyi ayır.
```

---

## 24. Kod Ajanına Verilecek Kısa Başlangıç Kalıbı

Her coding task'ta şu mantığı kullan:

```text
Önce şu dosyaları oku:
- docs/00_oyun_ozeti.md
- docs/02_mekanikler.md
- docs/08_yapay_zeka_ajan_kurallari.md

Task kamera ile ilgiliyse:
- docs/04_kamera_sistemi.md

Task sensör veya AI tehdidi ile ilgiliyse:
- docs/05_tehdit_sistemi_ai_sensors.md

Task mini oyun ile ilgiliyse:
- docs/06_mini_oyunlar.md

Dokümanlarla çelişen bir şey görürsen kod yazmadan önce belirt.
Lore veya mekanik uydurma.
Sadece verilen feature spec'i uygula.
```

---

# Kısa Özet

En önemli kurallar:

```text
1. Küçük task ver.
2. Kapsam dışı yaz.
3. Docs dosyalarını kaynak yap.
4. Her çalışan adımdan sonra commit at.
5. Kod ajanı yazsın, reviewer kontrol etsin.
6. Pahalı modeli sürekli kod yazdırmak için kullanma.
7. Oyunun ana kimliğini koru: fiziksel chase enemy yok, tehdit yapay zekâ tespiti.
```

