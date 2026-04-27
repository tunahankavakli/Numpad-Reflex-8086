# Numpad Refleks Oyunu (8086 Assembly)

Bu proje, 8086 Assembly dili kullanılarak donanım seviyesinde (klavye tamponu ve sistem saati) geliştirilmiş bir refleks ve tepki süresi ölçüm simülasyonudur.

## 🚀 Proje Özellikleri
- **Donanım Seviyesinde Zamanlama:** BIOS saat kesmesi (`INT 1Ah`) ile rastgele sayı üretimi ve milisaniye bazlı tepki süresi ölçümü.
- **Asenkron Girdi Okuma:** Klavye tamponunun (buffer) program akışını durdurmadan (`INT 16h`) dinlenmesi.
- **Dinamik Zorluk Motoru:** Oyuncu doğru tuşlara bastıkça daralan zaman limiti.
- **Performans Ölçümü:** Oyun sonunda toplam skor ve ortalama tepki süresinin (ms) hesaplanıp ekrana yazdırılması.

## 🛠️ Kullanılan Teknolojiler
- **Dil:** x86 Assembly (16-bit)
- **Geliştirme Ortamı:** Emu8086 Mikroişlemci Emülatörü
- **Mimari:** Kesme (Interrupt) tabanlı durum makinesi (State Machine)

## 🎮 Kurulum ve Çalıştırma
1. Bu depoyu bilgisayarınıza klonlayın.
2. `numpad_refleks.asm` dosyasını Emu8086 (veya uyumlu bir emülatör) ile açın.
3. `Emulate` butonuna basarak kodu derleyin ve çalıştırın.
4. Çıkan ekranda `ENTER` tuşuna basarak testi başlatın.
*Not: Harici bir klavye kullanıyorsanız sayılara basabilmek için `NumLock` tuşunun açık olduğundan emin olun.*

## 📄 Detaylı Dökümantasyon
Projenin donanım kesmeleri, mimari kararları ve algoritma şeması hakkında detaylı bilgi için `Proje_Raporu.pdf` dosyasını inceleyebilirsiniz.
