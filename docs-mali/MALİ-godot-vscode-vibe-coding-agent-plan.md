# Godot + VS Code Vibe Coding Ajan Planı

Bu doküman, Godot Engine ile oyun geliştirirken farklı yapay zekâ modellerini ajan rollerine bölmek için hazırlanmıştır.

Amaç:  
- Fikir ve hikâye ayrı modelde düşünülsün.
- Kod yazan ajan sadece uygulama yapsın.
- Pahalı/çok üst modeller sürekli kullanılmasın.
- Fiyat/performans modeller ana işçi olarak çalışsın.
- Daha güçlü ama abartı olmayan modeller yedek/çözümleyici olarak kullanılsın.

---

## 1. Genel Model Stratejisi

| Rol | Ana F/P Model | Güçlü Yedek Model | Not |
|---|---|---|---|
| Ana kod yazan ajan | DeepSeek V4 Pro | Claude Sonnet 4.6 | Sürekli coding için en mantıklı rol |
| Basit kod / UI / data işleri | Qwen3-Coder-Next veya DeepSeek V4 Flash | DeepSeek V4 Pro | Ucuz ve bol token harcanabilir |
| Kod inceleme / reviewer | Claude Sonnet 4.6 | GPT-5.5 | Kod kalitesi ve mimari kontrol |
| Zor bug çözme | DeepSeek V4 Pro | Claude Sonnet 4.6 | Uzun hata takibinde iyi |
| Büyük mimari karar | Gemini 3.1 Pro veya GPT-5.5 | Claude Opus 4.8 | Sürekli değil, gerektiğinde |
| Uzun repo / büyük context | Gemini 3.1 Pro | GPT-5.5 | Büyük dosya ve proje analizi |
| Local / açık ağırlıklı çalışma | Qwen3-Coder-Next | Devstral / Llama / GPT-OSS | Gizlilik ve düşük maliyet için |

---

## 2. Ajan Rolleri

### 2.1 Implementer Agent

Ana kod yazan ajandır.

**Kullanım alanı:**
- GDScript yazma
- Godot sahne/script bağlantıları
- Gameplay sistemleri
- Inventory, combat, quest, dialog, save/load gibi sistemler
- Dosya düzenleme
- Küçük/orta refactor

**F/P model:**
- DeepSeek V4 Pro
- Qwen3-Coder-Next

**Güçlü yedek:**
- Claude Sonnet 4.6

**Kullanılmaması gereken işler:**
- Büyük mimari karar
- Yeni mekanik fikri üretme
- Tüm projeyi baştan tasarlama

**Prompt:**

```text
Sen Godot 4.x ve GDScript odaklı bir implementer ajansın.
Yaratıcı fikir üretme.
Mekanik tasarlama.
Sadece verilen task'ı uygula.

Kurallar:
- Önce ilgili dosyaları oku.
- Var olan mimariyi bozma.
- Minimum dosya değiştir.
- Node path varsayımı yapma.
- Gerekiyorsa export var kullan.
- Godot 4.x ve GDScript 2.0 syntax kullan.
- Büyük refactor yapmadan önce açıkça belirt.
- İş bitince değişen dosyaları ve test adımlarını yaz.
```

---

### 2.2 Fixer Agent

Sadece bug düzeltir.

**Kullanım alanı:**
- Hata mesajına göre düzeltme
- Çalışmayan script düzeltme
- Node reference, signal, autoload, scene path hataları
- Reviewer tarafından bulunan sorunları düzeltme

**F/P model:**
- DeepSeek V4 Pro
- Qwen3-Coder-Next

**Güçlü yedek:**
- Claude Sonnet 4.6

**Kullanılmaması gereken işler:**
- Yeni özellik ekleme
- Gereksiz refactor
- Mekanik değiştirme

**Prompt:**

```text
Sen Godot 4.x fixer ajansın.
Yeni özellik ekleme.
Sadece verilen hatayı düzelt.

Kurallar:
- Hata mesajını ve ilgili dosyaları incele.
- Minimum değişiklik yap.
- Var olan davranışı bozma.
- Godot 4.x API uyumluluğunu kontrol et.
- İş sonunda neyi düzelttiğini ve nasıl test edileceğini yaz.
```

---

### 2.3 Reviewer Agent

Kod yazmaz, yapılan işi kontrol eder.

**Kullanım alanı:**
- Kod kalitesi kontrolü
- Godot mimarisi kontrolü
- Node path, signal, autoload riskleri
- Save/load uyumluluğu
- Tight coupling kontrolü
- Implementer'a düzeltme prompt'u üretme

**F/P model:**
- Claude Sonnet 4.6

**Güçlü yedek:**
- GPT-5.5
- Gemini 3.1 Pro

**Kullanılmaması gereken işler:**
- Dosya değiştirme
- Yeni sistem yazma
- Gereksiz fikir üretme

**Prompt:**

```text
Sen Godot 4.x code reviewer ajansın.
Kod yazma.
Dosya değiştirme.
Sadece inceleme yap.

Şunlara bak:
- Node path kırılganlığı
- Signal bağlantı hataları
- Autoload kullanımı
- Save/load uyumluluğu
- Tight coupling
- GDScript syntax hataları
- Godot 4.x API hataları
- Gereksiz refactor riski

Cevap formatı:
1. Kritik sorunlar
2. Orta seviye riskler
3. Temiz olan yerler
4. Implementer'a verilecek net düzeltme prompt'u
```

---

### 2.4 UI Agent

Sadece kullanıcı arayüzüyle ilgilenir.

**Kullanım alanı:**
- HUD
- Inventory panel
- Dialogue UI
- Settings menu
- Save/load menu
- Tooltip
- Button ve signal bağlantıları

**F/P model:**
- Qwen3-Coder-Next
- DeepSeek V4 Flash

**Güçlü yedek:**
- DeepSeek V4 Pro
- Claude Sonnet 4.6

**Kullanılmaması gereken işler:**
- Gameplay logic değiştirme
- Combat, quest, inventory core logic yazma
- Scene yapısını gereksiz bozma

**Prompt:**

```text
Sen Godot 4.x UI implementer ajansın.
Sadece Control tabanlı UI, signal bağlantıları ve UI state yönetimiyle ilgilen.

Kurallar:
- Gameplay sistemlerini değiştirme.
- UI gerekli veriyi mevcut public method veya signal üzerinden alsın.
- UI kodunu gameplay logic ile karıştırma.
- Minimum dosya değiştir.
- İş bitince test adımlarını yaz.
```

---

### 2.5 Content Agent

İçerik, lore metni ve proje dokümanı düzenleyen ajandır.

**Kullanım alanı:**
- Hikâye metni
- Feature açıklamaları
- Doküman güncellemeleri
- Proje takibi için metin düzenleme

**F/P model:**
- DeepSeek V4 Flash
- Qwen3-Coder-Next

**Güçlü yedek:**
- DeepSeek V4 Pro

**Kullanılmaması gereken işler:**
- Mekanik tasarlama
- Core gameplay kodu değiştirme
- Mimari değiştirme
- Yeni lore uydurma

**Prompt:**

```text
Sen content agent'sın.
Yeni mekanik tasarlama.
Yeni lore uydurma.
Sadece verilen içerik metnini mevcut docs yapısına uygun şekilde düzenle.

Kurallar:
- Docs kararlarını bozma.
- BELİRSİZ alanları BELİRSİZ bırak.
- Kod tarafına minimum müdahale et.
- İş sonunda hangi dokümanın güncellendiğini yaz.
```

---

### 2.6 Data Agent

Veri, item, quest ve yapılandırma içeriği düzenleyen ajandır.

**Kullanım alanı:**
- Diyalog verileri
- Item listesi
- Quest step verileri
- JSON, CSV, Resource, .tres düzenleme
- Teknik veri / content formatlama

**F/P model:**
- DeepSeek V4 Flash
- Qwen3-Coder-Next

**Güçlü yedek:**
- DeepSeek V4 Pro

**Kullanılmaması gereken işler:**
- Mekanik tasarlama
- Core gameplay kodu değiştirme
- Mimari değiştirme

**Prompt:**

```text
Sen data agent'sın.
Sadece verilen veri içeriğini mevcut formatına uygun şekilde düzenle.

Kurallar:
- Kod tarafına minimum müdahale et.
- Mevcut data formatını koru.
- Eksik alan varsa belirt.
- İş sonunda eklenen/değişen verileri listele.
```

---

### 2.7 Architect Agent

Büyük sistem kararı verir. Sürekli kullanılmaz.

**Kullanım alanı:**
- Inventory sistemi nasıl kurulmalı?
- Quest sistemi nasıl bölünmeli?
- Save/load mimarisi nasıl olmalı?
- Autoload mı component mi?
- Sistem baştan mı yazılmalı, refactor mı edilmeli?

**F/P model:**
- Gemini 3.1 Pro
- GPT-5.5

**Güçlü yedek:**
- Claude Sonnet 4.6
- Claude Opus 4.8

**Kullanılmaması gereken işler:**
- Sürekli küçük kod yazma
- Basit bug düzeltme
- Data girişi

**Prompt:**

```text
Sen Godot 4.x architecture advisor ajansın.
Kod yazma.
Önce sistem tasarımı öner.

Kurallar:
- Basit ve sürdürülebilir çözüm öner.
- Gereksiz enterprise mimari kurma.
- Godot sahne yapısına uygun düşün.
- Autoload, Resource, Node, Component seçeneklerini karşılaştır.
- En sonunda Implementer'a verilecek kısa task listesi çıkar.
```

---

## 3. Görev Türüne Göre Model Seçimi

| Görev | F/P Model | Güçlü Yedek | Açıklama |
|---|---|---|---|
| Player movement | DeepSeek V4 Flash | DeepSeek V4 Pro | Basit, ucuz model yeter |
| Enemy AI | DeepSeek V4 Pro | Claude Sonnet 4.6 | State machine hataları olabilir |
| Combat sistemi | DeepSeek V4 Pro | Claude Sonnet 4.6 | Denge ve event akışı önemli |
| Inventory sistemi | DeepSeek V4 Pro | Claude Sonnet 4.6 | Data + UI + save bağlantısı var |
| Dialogue sistemi | Qwen3-Coder-Next | DeepSeek V4 Pro | Data ağırlıklıysa ucuz model yeter |
| Quest sistemi | DeepSeek V4 Pro | Claude Sonnet 4.6 | State yönetimi dikkat ister |
| Save/load | DeepSeek V4 Pro | GPT-5.5 | Kritik sistem, reviewer şart |
| UI/HUD | Qwen3-Coder-Next | DeepSeek V4 Pro | Ayrı UI ajanına verilmeli |
| Settings menu | Qwen3-Coder-Next | DeepSeek V4 Pro | Basit UI/data işi |
| Refactor | DeepSeek V4 Pro | Claude Sonnet 4.6 | Önce reviewer çalıştır |
| Büyük bug | DeepSeek V4 Pro | Claude Sonnet 4.6 | Hâlâ çözülmezse GPT-5.5 |
| Proje mimarisi | Gemini 3.1 Pro | GPT-5.5 | Sık kullanılmamalı |
| Kod review | Claude Sonnet 4.6 | GPT-5.5 | Kod yazdırma, sadece kontrol |
| Data/content ekleme | DeepSeek V4 Flash | Qwen3-Coder-Next | Token ucuz olmalı |

---

## 4. Model Açıklamaları

### DeepSeek V4 Pro

**En iyi olduğu yerler:**
- Ana coding agent
- Uzun task uygulama
- Bug fixing
- Fiyat/performans
- Çok dosyalı ama net tanımlı işler

**Kullanım şekli:**
- Implementer
- Fixer
- Orta seviye refactor

**Not:**
Sürekli kod yazdırmak için en mantıklı ana model adaylarından biri.

---

### DeepSeek V4 Flash

**En iyi olduğu yerler:**
- Basit script işleri
- UI düzeltmeleri
- Data/content düzenleme
- Hızlı deneme-yanılma

**Kullanım şekli:**
- UI Agent
- Data Agent
- Basit Fixer

**Not:**
Ucuz ve hızlı işler için ideal. Kritik sistemlerde tek başına bırakılmamalı.

---

### Qwen3-Coder-Next

**En iyi olduğu yerler:**
- Coding agent işleri
- Local veya düşük maliyetli çalışma
- Basit/orta seviye Godot sistemleri
- Data ve UI işleri

**Kullanım şekli:**
- Implementer
- UI Agent
- Content Agent

**Not:**
Fiyat/performans güçlüdür. Çok karmaşık sistemlerde reviewer ile kullanılmalı.

---

### Claude Sonnet 4.6

**En iyi olduğu yerler:**
- Kod review
- Zor bug çözme
- Refactor kontrolü
- Godot mimari hatalarını yakalama
- Daha az baş ağrıtan coding

**Kullanım şekli:**
- Reviewer
- Güçlü Fixer
- Güçlü Implementer yedeği

**Not:**
Ana model olarak kullanılabilir ama sürekli token yakmak pahalı olabilir. Reviewer/yedek rolünde çok mantıklı.

---

### GPT-5.5

**En iyi olduğu yerler:**
- Büyük mimari kararlar
- Karmaşık sistem analizi
- Save/load, quest, combat gibi bağlı sistemleri değerlendirme
- Genel problem çözme

**Kullanım şekli:**
- Architect
- Reviewer yedeği
- Kriz çözücü

**Not:**
Sürekli küçük kod yazdırmak için gereksiz pahalı olabilir. Zor karar ve review için kullanmak daha mantıklı.

---

### Gemini 3.1 Pro

**En iyi olduğu yerler:**
- Uzun context
- Büyük repo analizi
- Çok dosyalı sistemleri anlama
- Planlama ve mimari değerlendirme

**Kullanım şekli:**
- Architect
- Repo Analyzer
- Büyük sistem reviewer

**Not:**
Büyük context gerektiğinde güçlüdür. Kod yazan ana ajan olarak değil, proje okuyan/planlayan ajan olarak daha mantıklı.

---

### Claude Opus 4.8

**En iyi olduğu yerler:**
- En zor buglar
- Büyük refactor kararları
- Karmaşık reasoning
- Kod kalitesi değerlendirme

**Kullanım şekli:**
- Emergency Solver
- High-level Reviewer
- Son çare mimari çözümleyici

**Not:**
Çok güçlüdür ama sürekli kullanım için gereksiz pahalı olabilir. Kriz durumunda kullanılmalı.

---

### Devstral / Llama / GPT-OSS

**En iyi olduğu yerler:**
- Local çalışma
- Gizlilik
- Offline test
- Basit/orta seviye coding
- Açık ağırlıklı model denemeleri

**Kullanım şekli:**
- Local Implementer
- Basit Fixer
- Deneysel Agent

**Not:**
Kapalı üst modeller kadar stabil olmayabilir. Ama local ve düşük maliyet için değerlidir.

---

## 5. Önerilen Günlük Akış

### Normal feature geliştirme

1. Fikir/hikâye modeli feature spec çıkarır.
2. Implementer Agent kodu yazar.
3. Reviewer Agent kodu kontrol eder.
4. Fixer Agent sadece bulunan sorunları düzeltir.
5. Gerekirse UI Agent arayüzü bağlar.
6. Content Agent data ekler.

---

## 6. Feature Spec Formatı

Her görevi ajana şu formatla ver:

```text
Feature:
Kısa özellik adı.

Amaç:
Bu özellik ne yapacak?

Kapsam:
- Yapılacak şey 1
- Yapılacak şey 2
- Yapılacak şey 3

Kapsam dışı:
- Yapılmayacak şey 1
- Yapılmayacak şey 2

Mevcut dosyalar:
- varsa ilgili dosyalar

Kabul kriterleri:
- Test edilebilir kriter 1
- Test edilebilir kriter 2
- Test edilebilir kriter 3

Kısıtlar:
- Godot 4.x
- GDScript 2.0
- Minimum dosya değişikliği
- Var olan API bozulmayacak
```

---

## 7. Implementer İçin Evrensel Kurallar

Her kod yazan ajana eklenmeli:

```text
Godot 4.x kullan.
GDScript 2.0 syntax kullan.
Node path varsayma.
Sahne ağacını değiştirmeden önce açıkça belirt.
Autoload ekleme gerekiyorsa nedenini açıkla.
Var olan public API'yi bozma.
Mevcut dosya yapısını koru.
Minimum değişiklik yap.
Fikir üretme.
Alternatif mekanik önermeye çalışma.
Verilen feature spec'i uygula.

İş bitince:
- Değişen dosyalar
- Ne eklendi
- Nasıl test edilir
- Bilinen riskler
şeklinde rapor ver.
```

---

## 8. Reviewer İçin Evrensel Kurallar

```text
Kod yazma.
Dosya değiştirme.
Sadece inceleme yap.

Şunları kontrol et:
- Godot 4.x API uyumu
- GDScript syntax
- Node path riskleri
- Signal bağlantıları
- Save/load uyumluluğu
- Gereksiz autoload kullanımı
- Tight coupling
- Gereksiz büyük refactor
- Performans riski
- Test edilebilirlik

En sonda Implementer'a verilecek net düzeltme prompt'u yaz.
```

---

## 9. Hata Çözme Akışı

Bir şey çalışmazsa:

1. Hata mesajını ve ilgili dosyaları Fixer Agent'a ver.
2. Fixer sadece hatayı düzeltsin.
3. Aynı hata 2 kez çözülmezse Claude Sonnet 4.6'ya ver.
4. Hâlâ çözülmezse GPT-5.5 veya Gemini 3.1 Pro ile sistem seviyesinde analiz yaptır.
5. Çözüm prompt'unu tekrar Implementer/Fixer'a uygulat.

---

## 10. En Mantıklı Setup

### Ekonomik ve güçlü setup

| Rol | Model |
|---|---|
| Ana kod yazan | DeepSeek V4 Pro |
| Basit işler | Qwen3-Coder-Next / DeepSeek V4 Flash |
| Review | Claude Sonnet 4.6 |
| Mimari | Gemini 3.1 Pro / GPT-5.5 |
| Kriz çözümü | Claude Sonnet 4.6 veya GPT-5.5 |

---

### Daha konforlu setup

| Rol | Model |
|---|---|
| Ana kod yazan | Claude Sonnet 4.6 |
| Basit işler | DeepSeek V4 Flash |
| Review | GPT-5.5 |
| Mimari | Gemini 3.1 Pro |
| Kriz çözümü | Claude Opus 4.8 |

---

### Local / düşük maliyet setup

| Rol | Model |
|---|---|
| Ana kod yazan | Qwen3-Coder-Next |
| Basit işler | Devstral / DeepSeek Flash |
| Review | Claude Sonnet 4.6 |
| Mimari | GPT-5.5 veya Gemini 3.1 Pro |
| Kriz çözümü | Claude Sonnet 4.6 |

---

## 11. Kısa Karar Rehberi

- Sürekli kod yazdıracaksan: DeepSeek V4 Pro
- En ucuz bol token işi istiyorsan: DeepSeek Flash veya Qwen
- Daha az baş ağrısı istiyorsan: Claude Sonnet 4.6
- Büyük proje okutacaksan: Gemini 3.1 Pro
- Mimari karar aldıracaksan: GPT-5.5 veya Gemini 3.1 Pro
- Kod review yaptıracaksan: Claude Sonnet 4.6
- Hiçbir model çözemiyorsa: GPT-5.5 veya Claude Opus 4.8
- Local çalışacaksan: Qwen3-Coder-Next veya Devstral

---

## 12. Ana Kural

Pahalı modeli sürekli kod yazdırmak için kullanma.

En iyi yapı:

```text
Ucuz/güçlü model = kod yazar
Orta-üst model = review yapar
Üst model = sadece zor karar ve kriz çözer
```

Godot vibe coding için önerilen ana kombinasyon:

```text
Implementer: DeepSeek V4 Pro
UI/Data: Qwen3-Coder-Next veya DeepSeek Flash
Reviewer: Claude Sonnet 4.6
Architect: Gemini 3.1 Pro veya GPT-5.5
Emergency Solver: GPT-5.5 veya Claude Opus 4.8
```

