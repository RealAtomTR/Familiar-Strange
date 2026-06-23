# İlk Ay Codex Kullanım Planı - Güncel Model Eşleştirmesi

Bu dosya, ilk ay Codex kullanırken Godot + VS Code projesinde ajanlara göre hangi OpenAI/Codex modelini seçeceğini anlatır.

Kaynak notu:
OpenAI Codex model sayfasında önerilen güncel modeller:
- `gpt-5.5`
- `gpt-5.4`
- `gpt-5.4-mini`
- `gpt-5.3-codex-spark` — ChatGPT Pro kullanıcıları için research preview

Ayrıca:
- `gpt-5.2` ve `gpt-5.3-codex` modelleri ChatGPT ile giriş yapılan Codex kullanımında deprecated olarak belirtiliyor.
- Bu yüzden yeni tasklarda `gpt-5.3-codex` kullanma.
- Eğer arayüzde model seçimi farklı görünürse aynı mantığı uygula: güçlü model / normal model / mini model.

---

## 1. Model Mantığı

| Model | Ne İçin? | Kısa Yorum |
|---|---|---|
| `gpt-5.5` | En zor işler, mimari, karmaşık coding, kriz çözümü | En güçlü seçenek. Her işte kullanırsan limit/credit hızlı gidebilir. |
| `gpt-5.4` | Ana coding işleri, profesyonel feature implementation | İlk ay ana çalışma modeli olarak mantıklı. |
| `gpt-5.4-mini` | Basit/orta işler, UI, küçük fix, data, subagent | Daha hızlı ve düşük maliyetli işler için. |
| `gpt-5.3-codex-spark` | Çok hızlı real-time coding iteration | Pro kullanıcılarına research preview. Plus'ta görünmeyebilir. |
| Deprecated: `gpt-5.3-codex` | Kullanma | Eski dosya/ayar varsa güncelle. |
| Deprecated: `gpt-5.2` | Kullanma | Eski model. |

---

## 2. İlk Ay Ana Strateji

Kafayı karıştırmamak için ilk ay şu mantık yeterli:

```text
Zor / kritik / mimari:
gpt-5.5

Normal kod yazma:
gpt-5.4

Basit UI / data / küçük fix:
gpt-5.4-mini

Eğer Pro kullanıyorsan ve görünüyorsa hızlı deneme:
gpt-5.3-codex-spark
```

20 dolarlık Plus kullanıyorsan `gpt-5.3-codex-spark` görünmeyebilir. Görünmüyorsa sorun değil; onun yerine `gpt-5.4-mini` kullan.

---

# 3. Ajan Sohbetleri

Her ajanı ayrı Codex sohbeti/thread'i gibi düşün.

Önerilen sohbetler:

```text
01_implementer_agent
02_ui_agent
03_fixer_agent
04_reviewer_agent
05_architect_agent
06_content_agent
07_data_agent
08_emergency_solver
```

Her sohbetin görevi ayrı olsun.
Bir ajan başka ajanın işine karışmasın.

---

# 4. Ajanlara Göre Model Seçimi

## 4.1 Implementer Agent

Ana kod yazan ajandır.

Kullanım:
- Gameplay sistemi yazma
- Kamera sistemi
- Sensör sistemi
- Mini oyun prototipi
- GDScript dosyaları oluşturma
- Orta seviye feature implementation
- Sahne/script bağlantıları

Önerilen model:
```text
gpt-5.5
```

Basit task ise:
```text
gpt-5.4-mini
```

İki kez başarısız olursa:
```text
gpt-5.5
```

Kullanım notu:
Implementer'a sürekli `gpt-5.5` kullandırma. Normal kod yazma için önce `gpt-5.4` ile başla.

Prompt tarzı:

```text
Sen Godot 4.x implementer agent'sın.

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

## 4.2 UI Agent

Sadece arayüz işleriyle ilgilenir.

Kullanım:
- Kamera yön okları
- HUD
- Mini oyun UI
- Alarm göstergesi
- Menü
- Tooltip
- Button ve signal bağlantıları

Önerilen model:
```text
gpt-5.4-mini
```

Eğer UI gameplay sistemine bağlanacaksa:
```text
gpt-5.4
```

Eğer model seçeneklerinde varsa ve Pro kullanıyorsan hızlı deneme için:
```text
gpt-5.3-codex-spark
```

Neye dokunmamalı:
- Gameplay core logic
- AI/sensör sistemi
- Save/load sistemi
- Lore
- Büyük refactor

Prompt tarzı:

```text
Sen Godot 4.x UI agent'sın.

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

## 4.3 Fixer Agent

Sadece hata çözer.

Kullanım:
- Godot hata mesajı
- Null reference
- Node path hatası
- Signal bağlantı hatası
- Scene/script bağlantısı
- Çalışmayan küçük sistemler
- Reviewer'ın bulduğu sorunları düzeltme

Önerilen model:
```text
gpt-5.5
```

Basit hata için:
```text
gpt-5.4-mini
```

Aynı hata 2 kez çözülmezse:
```text
gpt-5.5
```

Neye dokunmamalı:
- Yeni feature
- Yeni mekanik
- Yeni lore
- Sistemi baştan yazma
- Gereksiz refactor

Prompt tarzı:

```text
Sen Godot 4.x fixer agent'sın.

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

## 4.4 Reviewer Agent

Kod yazmaz, kontrol eder.

Kullanım:
- Feature bittikten sonra diff kontrolü
- Godot mimarisi kontrolü
- Node path riskleri
- Signal bağlantıları
- Gereksiz autoload
- Tight coupling
- Save/load uyumluluğu
- Docs ile çelişki kontrolü

Önerilen model:
```text
gpt-5.5
```

Çok kritik sistemlerde:
```text
gpt-5.5
```

Basit UI/data review için:
```text
gpt-5.4-mini
```

Neye dokunmamalı:
- Dosya değiştirme
- Yeni sistem yazma
- Feature ekleme

Prompt tarzı:

```text
Sen Godot 4.x reviewer agent'sın.
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
- docs dosyalarıyla çelişki

Cevap formatı:
1. Kritik sorunlar
2. Orta seviye riskler
3. Temiz olan yerler
4. Implementer'a verilecek net düzeltme prompt'u
```

---

## 4.5 Architect Agent

Teknik plan çıkarır, kod yazmaz.

Kullanım:
- Sensör sistemi node/component olarak nasıl kurulmalı?
- AI alarm seviyesi autoload mı olmalı?
- Mini oyun manager nasıl çalışmalı?
- Kamera yönleri nasıl saklanmalı?
- Save/load ileride nasıl bağlanmalı?
- Büyük sistemleri küçük tasklara bölme

Önerilen model:
```text
gpt-5.5
```

Daha küçük teknik kararlar için:
```text
gpt-5.4
```

Neye dokunmamalı:
- Direkt kod yazma
- Basit bug fix
- Gereksiz enterprise mimari

Prompt tarzı:

```text
Sen Godot 4.x architecture advisor agent'sın.
Kod yazma.
Önce sistem tasarımı öner.

Konu:
[Planlanacak sistem]

Bağlam:
[İlgili oyun bilgisi ve docs dosyaları]

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

## 4.6 Content Agent

İçerik ve tasarım metni düzenler.

Kullanım:
- Lore / hikâye metni
- Feature açıklamaları
- Doküman güncellemeleri
- Proje takibi için metin düzenleme

Önerilen model:
```text
gpt-5.5
```

Neye dokunmamalı:
- Core gameplay kodu
- AI/sensör logic
- Kamera sistemi
- Yeni mekanik tasarlama
- Kural dışı lore uydurma

Prompt tarzı:

```text
Sen content agent'sın.
Kod yazma.
Yeni lore veya yeni mekanik uydurma.
Sadece verilen içerik metnini mevcut doküman yapısına uygun şekilde düzenle.

Kurallar:
- Mevcut docs kararlarını bozma.
- BELİRSİZ alanları BELİRSİZ olarak bırak.
- Gereksiz uzun açıklama ekleme.
- Minimum dosya değiştir.
- İş bitince hangi dokümanın güncellendiğini yaz.
```

---

## 4.7 Data Agent

Veri, item, quest ve yapılandırma içeriği düzenler.

Kullanım:
- Dialogue data
- Item listesi
- Quest step
- Mini oyun parametreleri
- JSON / Resource / Markdown veri düzenleme
- Feature backlog için teknik olmayan veri girişi

Önerilen model:
```text
gpt-5.4-mini
```

Eğer data sistemi kodla iç içeyse:
```text
gpt-5.4
```

Eğer Pro kullanıyorsan ve hızlı iterasyon istiyorsan:
```text
gpt-5.3-codex-spark
```

Neye dokunmamalı:
- Core gameplay kodu
- AI/sensör logic
- Kamera sistemi
- Yeni mekanik tasarlama

Prompt tarzı:

```text
Sen content/data integration agent'sın.
Yeni mekanik tasarlama.
Sadece verilen hikâye, item, quest ve diyalog verilerini mevcut data formatına uygun şekilde ekle.

Kurallar:
- Kod tarafına minimum müdahale et.
- Mevcut data formatını koru.
- Eksik alan varsa belirt.
- İş sonunda eklenen/değişen verileri listele.
```

---## 4.7 Emergency Solver

Sadece işler karışınca kullanılır.

Kullanım:
- Aynı bug 2-3 kez çözülmedi
- Sistem çalışıyor ama mimari çok karıştı
- Save/load bozuldu
- Sensör + mini oyun + AI alarm sistemi birbirine girdi
- Kod ajanı çok fazla dosyayı bozdu
- Ne yapacağını bilmiyorsun

Önerilen model:
```text
gpt-5.5
```

Neye dokunmamalı:
- Direkt her şeyi baştan yazmak
- Önce analiz yapmadan kod değiştirmek
- Gereksiz büyük refactor

Prompt tarzı:

```text
Sen emergency solver agent'sın.
Önce analiz yap.
Hemen kod değiştirme.

Sorun:
[Problem özeti]

Şu ana kadar denenenler:
[Denemeler]

Değişen dosyalar:
[Dosya listesi]

İstenen:
1. Sorunun muhtemel kök sebebini bul.
2. En güvenli çözüm yolunu öner.
3. Gerekirse önce geri alınması gereken değişiklikleri belirt.
4. Implementer/Fixer'a verilecek net düzeltme prompt'u yaz.
5. Riskleri yaz.

Kurallar:
- Tüm sistemi baştan yazma önermeden önce neden gerektiğini açıkla.
- Minimum kurtarma planı öner.
- Godot 4.x uyumluluğunu dikkate al.
```

---

# 5. İlk Ay İçin Günlük Akış

## Normal feature geliştirme

```text
1. Claude Project veya ana danışman sohbetinde feature spec hazırla.
2. Implementer Agent ile gpt-5.4 kullanarak uygulat.
3. Godot'ta test et.
4. Hata varsa Fixer Agent ile düzelt.
5. Feature önemliyse Reviewer Agent ile kontrol ettir.
6. Çalışıyorsa Git commit at.
7. Docs/backlog güncelle.
```

---

## Basit UI veya data işi

```text
1. UI Agent veya Data Agent aç.
2. gpt-5.4-mini kullan.
3. Sadece ilgili dosyalara dokunmasını söyle.
4. Test et.
5. Çalışıyorsa commit at.
```

---

## Zor sistem planlama

```text
1. Architect Agent aç.
2. gpt-5.5 kullan.
3. Kod yazdırma, sadece plan al.
4. Planı küçük tasklara böl.
5. Implementer Agent'a gpt-5.4 ile uygulat.
```

---

## Bug çözme

```text
1. Hata mesajını Fixer Agent'a ver.
2. Basitse gpt-5.4-mini, normal ise gpt-5.4 kullan.
3. Aynı hata 2 kez çözülmezse gpt-5.5 Emergency Solver'a geç.
4. Çözümden sonra test et.
5. Commit at.
```

---

# 6. İlk Ay Model Kullanım Kuralları

## `gpt-5.5` kullan

- Mimari karar
- Zor bug
- Aynı hatanın tekrar tekrar çözülmemesi
- Büyük refactor kararı
- Save/load gibi kritik sistemler
- Kod ajanının ne yaptığını anlamadığın durumlar
- Karmaşık research/knowledge işi

Kullanma:
- Basit UI
- Küçük script
- Data girişi
- Basit hata
- Her normal feature

---

## `gpt-5.4` kullan

- Ana implementasyon
- Normal bug fix
- Gameplay feature
- Godot script yazma
- Sensör / kamera / mini oyun prototipi
- Orta seviye refactor
- Reviewer işi

Bu ilk ayın ana modeli bu olabilir.

---

## `gpt-5.4-mini` kullan

- UI düzenleme
- Data/content işi
- Küçük bug fix
- Markdown düzenleme
- Basit GDScript fonksiyonu
- Hızlı prototip
- Subagent işleri

Kullanma:
- Büyük mimari
- Karmaşık bug
- Çok dosyalı feature
- Save/load
- Sistem refactor

---

## `gpt-5.3-codex-spark` kullan

Sadece arayüzde görünüyorsa ve Pro erişimin varsa kullan.

İyi olduğu yer:
- Çok hızlı coding iteration
- Anlık küçük değişiklikler
- Basit UI/data
- Küçük fix
- Deneme/yanılma

Plus kullanıyorsan görünmeyebilir. Görünmüyorsa yerine `gpt-5.4-mini` kullan.

---

# 7. İlk Ay İçin En Mantıklı Model Dağılımı

| Ajan | Ana Model | Yedek / Zor Durum |
|---|---|---|
| Implementer | `gpt-5.4` | `gpt-5.5` |
| UI Agent | `gpt-5.4-mini` | `gpt-5.4` |
| Fixer | `gpt-5.4` | `gpt-5.5` |
| Reviewer | `gpt-5.5` | `gpt-5.4` |
| Architect | `gpt-5.5` | `gpt-5.4` |
| Content Agent | `gpt-5.5` | `gpt-5.4` |
| Data Agent | `gpt-5.4-mini` | `gpt-5.4` |
| Emergency Solver | `gpt-5.5` | Taskı küçült / geri al |
| Fast Iteration | `gpt-5.4-mini` | `gpt-5.3-codex-spark` varsa deneyebilirsin |

---

# 8. Eski Dosyadan Güncellenen Noktalar

Önceki planda geçen şu ifadeleri güncelle:

```text
GPT-5-Codex / GPT-5.3-Codex
```

yerine artık genelde:

```text
gpt-5.4
```

veya zor işlerde:

```text
gpt-5.5
```

kullan.

`gpt-5.3-codex` artık deprecated olarak görünüyor.
Yeni tasklarda kullanma.

---

# 9. İlk Ay Sonunda Kendine Sor

```text
1. Codex kullanımı beni rahatsız etti mi?
2. gpt-5.4 normal implementation için yeterli mi?
3. gpt-5.5'i çok sık kullanmak zorunda kaldım mı?
4. gpt-5.4-mini basit işler için yeterli oldu mu?
5. Godot projesinde dosyaları çok dağıttı mı?
6. Reviewer gerçekten hata yakaladı mı?
7. Aynı işi OpenRouter + DeepSeek/Qwen ile daha ucuza yapabilir miyim?
8. Codex'in kolaylığı fiyatına değiyor mu?
```

Eğer cevaplar olumsuzsa ikinci ay şu yapıya geçilebilir:

```text
VS Code
  + ZooCode / Cline / Kilo Code / Continue
  + OpenRouter
  + DeepSeek / Qwen / Claude / GPT
```

---

# 10. Kısa Özet

```text
Normal kod yazma:
gpt-5.4

Basit UI/data:
gpt-5.4-mini

Mimari ve kriz:
gpt-5.5

Pro kullanıyorsan hızlı deneme:
gpt-5.3-codex-spark

Kullanma:
gpt-5.3-codex
gpt-5.2
```

Her task:
```text
Küçük olsun.
Kapsam dışı yazılsın.
Test kriteri olsun.
Commit atılsın.
```





