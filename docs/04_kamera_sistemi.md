# Kamera ve Etkileşim (Interact) Sistemi

## Kamera Kontrolü (`camera_controller.gd`)
Oyun boyunca `Camera3D` nodu iki farklı faz modunda çalışır:

### Faz 1 (2D Flash / Point-and-Click Modu)
- Kamera pozisyonu tamamen sabittir, Y ekseni kilitlidir.
- Sadece belirli pozisyonlar arasında geçiş yapabilir.
- **Hareket:** Serbest yürüme kapalıdır. Ekranda beliren sol/sağ ok UI elemanlarına tıklandığında, waypoint lokasyonlarını tutan `Vector3` dizisindeki koordinatlara direkt teleport (`global_position = waypoint`) gerçekleştirilir.

### Faz 2 (3D Modu)
- Serbest WASD hareketi yatay düzlemde aktifleşir, Y ekseni sabit kalır.
- Mouse ile serbest bakış açısı (yatay ve dikey rotasyon) devreye girer.

## Etkileşim (Interact) Mekaniği
Kamera script'ine entegre edilmiş raycast tabanlı bir sistemdir.

## Akış ve Kurallar
1. Oyuncu mouse sol tıkını bıraktığında (released), imlecin sürüklenme mesafesi kontrol edilir. Eğer mesafe CLICK_THRESHOLD değerinden küçükse, işlem bir sürükleme değil tıklama olarak kabul edilir ve _try_interact() tetiklenir.

2. PhysicsRayQueryParameters3D kullanılarak kameradan ileriye doğru interact_max_distance mesafesince bir raycast fırlatılır.

3. Çarpan nesnenin (result.collider) üst parent nodunun bir StaticBody3D olup olmadığı kontrol edilir.

4. İsim Kuralı: Algılamanın gerçekleşmesi için ilgili StaticBody3D nodunun isminin içinde küçük/büyük harf duyarsız şekilde "interactable" ifadesi geçmek zorundadır (to_lower() kontrolü).

5. Şartlar sağlanıyorsa nesne üzerindeki _on_interact() methodu çağrılır.

## Önemli Geliştirme Notu
Sahne hiyerarşisinde CollisionShape3D, her zaman StaticBody3D veya Area3D nodlarının altında yer almalıdır; doğrudan MeshInstance3D altına eklenmemelidir.
