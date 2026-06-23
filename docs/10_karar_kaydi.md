# Mimari ve Tasarım Karar Kaydı (Architecture Decision Log)

Bu doküman, proje geliştirme sürecinde alınan kritik tasarım ve teknik kararları, gerekçeleriyle birlikte kayıt altında tutar.

## ADR 01: İki Fazlı (2D Flash ve 3D) Oyun Yapısı
- **Durum:** Onaylandı.
- **Karar:** Oyunun ilk yaklaşık %80'lik bölümünün (yani Oyun kısmının) sabit kamera ve point-and-click (waypoint teleport) mantığıyla çalışmasına, ardından narratif bir glitch geçişiyle serbest 3D hareket moduna geçmesine karar verilmiştir. Daha detaylı açıklama olarak oyunun ilk %80 i oyunumuz olcak işte mini game ler falan, sonraki %20 bölümde işte yaptığı seçimlerle karşısına çıkacak olan sonu 3 boyutlu olarak normal karakter hareketleriyle görücek.
- **Gerekçe:** Oyuncuda ilk etapta kontrolün sınırlanması, sıkışmışlık ve şuurun tam yerine gelmemesi hissini yaratmak; ardından serbest dünyaya geçiş anının narratif etkisini güçlendirmek.

## ADR 02: ConeShape3D Yerine Dot Product Kullanımı
- **Durum:** Onaylandı.
- **Karar:** Güvenlik kameralarının tarama konisi (SpotLight3D) içerisindeki oyuncu tespit hesaplamalarında Godot 4'te bulunmayan `ConeShape3D` yerine, kod tarafında manuel **dot product (noktasal çarpım)** algoritması kullanılacaktır.
- **Gerekçe:** Engine kısıtlamalarını aşmak ve performans açısından daha optimize, matematiksel olarak kesin bir kontrol sağlamak.

## ADR 03: Fiziksel Takip Eden Canavar Olmaması
- **Durum:** Onaylandı.
- **Karar:** Oyunda oyuncuyu haritada aktif olarak kovalayan, etten kemikten veya fiziksel bir yaratık/düşman bulunmayacaktır.
- **Gerekçe:** Korku unsurunu jumpscare veya kovalamaca yerine; görünmez bir sistem tarafından izlenme, veri merkezi ortamının liminal yapısı ve mekanik sensörlerin yarattığı psikolojik gerilim üzerine kurmak.

## ADR 04: "Lo-Fi Geometry, Hi-Fi Rendering" Estetiği
- **Durum:** Onaylandı.
- **Karar:** 3D modellerin low-poly (PS1 tarzı) tutulmasına, ancak ışıklandırma, sis, SSR ve gölge gibi rendering teknolojilerinin tamamen modern ve yüksek kalitede tutulmasına karar verilmiştir.
- **Gerekçe:** Nostaljik ve tekinsiz oyun estetiğini, modern atmosferik derinlikle birleştirerek özgün bir liminal alan hissi oluşturmak.