-- PDF: INSERT INTO KODLARI (örnek veri)
-- Çalıştırmadan önce: 01_schema.sql

USE uluslararasi_kargo;

-- 1
INSERT INTO Rol (rol_adi, aciklama)
VALUES ('Yönetici', 'Sistem yöneticisi rolü');

-- 2
INSERT INTO Rol (rol_adi, aciklama)
VALUES ('Şube Personeli', 'Şubede işlem yapan personel');

-- 3
INSERT INTO Rol (rol_adi, aciklama)
VALUES ('Kurye', 'Teslimat personeli');

-- 4
INSERT INTO Rol (rol_adi, aciklama)
VALUES ('Müşteri', 'Gönderi oluşturan kullanıcı');

-- 5
INSERT INTO ZamanDilimi (kod, utc_offset)
VALUES ('Europe/Istanbul', '+03:00');

-- 6
INSERT INTO Ulke (ulke_adi, iso_kodu, telefon_kodu, para_birimi, zaman_dilimi_id, vergi_orani)
VALUES ('Türkiye', 'TR', '+90', 'TRY', 1, 20.00);

-- 7
INSERT INTO Ulke (ulke_adi, iso_kodu, telefon_kodu, para_birimi, zaman_dilimi_id, vergi_orani)
VALUES ('Almanya', 'DE', '+49', 'EUR', 1, 19.00);

-- 8
INSERT INTO Sehir (sehir_adi, ulke_id)
VALUES ('İzmir', 1);

-- 9
INSERT INTO Sehir (sehir_adi, ulke_id)
VALUES ('İstanbul', 1);

-- 10
INSERT INTO Kullanici (ad, soyad, email, sifre, rol_id)
VALUES ('Ali', 'Yılmaz', 'ali.yilmaz@kargo.com', 'Sifre123!', 1);

-- 11
INSERT INTO Kullanici (ad, soyad, email, sifre, rol_id)
VALUES ('Ayşe', 'Demir', 'ayse.demir@kargo.com', 'Sifre123!', 2);

-- 12
INSERT INTO Musteri (kullanici_id, ad, soyad, email)
VALUES (NULL, 'Mehmet', 'Kara', 'mehmet.kara@mail.com');

-- 13
INSERT INTO Musteri (kullanici_id, ad, soyad, email)
VALUES (NULL, 'Zeynep', 'Aksoy', 'zeynep.aksoy@mail.com');

-- 14
INSERT INTO Telefon (musteri_id, telefon_numarasi, ulke_kodu)
VALUES (1, '5551234567', '+90');

-- 15
INSERT INTO Telefon (musteri_id, telefon_numarasi, ulke_kodu)
VALUES (2, '5559876543', '+90');

-- 16
INSERT INTO GonderimTipi (tip_adi, aciklama, teslimat_suresi_saat)
VALUES ('Standart', 'Standart gönderim', 72);

-- 17
INSERT INTO GonderimTipi (tip_adi, aciklama, teslimat_suresi_saat)
VALUES ('Hızlı', 'Hızlı gönderim', 24);

-- 18
INSERT INTO Sube (sube_adi, ulke_id, sehir_id, adres)
VALUES ('İzmir Merkez Şube', 1, 1, 'Konak / İzmir');

-- PDF UPDATE örneklerinde geçen sube_id = 2 için ikinci şube
INSERT INTO Sube (sube_adi, ulke_id, sehir_id, adres)
VALUES ('İstanbul Şube', 1, 2, 'Kadıköy / İstanbul');

-- 19
INSERT INTO Kurye (ad, soyad, sube_id, durum)
VALUES ('Ahmet', 'Çelik', 1, 'aktif');

-- 20
INSERT INTO Gonderi (takip_no, gonderici_id, alici_id, gonderim_tipi_id, sube_id, kurye_id, durum)
VALUES ('TRKJ-000001', 1, 2, 1, 1, 1, 'hazırlanıyor');

-- 21
INSERT INTO Paket (gonderi_id, agirlik_kg, en_cm, boy_cm, yukseklik_cm)
VALUES (1, 2.50, 30.00, 20.00, 15.00);

-- 22
INSERT INTO OdemeYontemi (yontem_adi)
VALUES ('Kredi Kartı');

-- 23
INSERT INTO Odeme (gonderi_id, odeme_yontemi_id, tutar, durum)
VALUES (1, 1, 150.00, 'tamamlandı');

-- 24
INSERT INTO Fatura (fatura_no, para_birimi, toplam_tutar)
VALUES ('FAT-2025-001', 'TRY', 150.00);

-- 25
INSERT INTO GonderiFatura (gonderi_id, fatura_id)
VALUES (1, 1);

-- 26
INSERT INTO GonderiTakip (gonderi_id, durum)
VALUES (1, 'Hazırlanıyor');

-- 27
INSERT INTO OdemeYontemi (yontem_adi)
VALUES ('Havale/EFT');

-- 28
INSERT INTO Kurye (ad, soyad, sube_id, durum)
VALUES ('Ece', 'Arslan', 1, 'aktif');

-- 29
INSERT INTO Gonderi (takip_no, gonderici_id, alici_id, gonderim_tipi_id, sube_id, kurye_id, durum)
VALUES ('TRKJ-000002', 2, 1, 2, 1, 2, 'hazırlanıyor');

-- 30
INSERT INTO Paket (gonderi_id, agirlik_kg, en_cm, boy_cm, yukseklik_cm)
VALUES (2, 1.20, 25.00, 18.00, 10.00);

-- 31
INSERT INTO Odeme (gonderi_id, odeme_yontemi_id, tutar, durum)
VALUES (2, 2, 120.00, 'tamamlandı');

-- 32
INSERT INTO Fatura (fatura_no, para_birimi, toplam_tutar)
VALUES ('FAT-2025-002', 'TRY', 120.00);

-- 33
INSERT INTO GonderiFatura (gonderi_id, fatura_id)
VALUES (2, 2);

-- 34
INSERT INTO GonderiTakip (gonderi_id, durum)
VALUES (2, 'Yolda');

-- 35
INSERT INTO PaketIcerik (paket_id, urun_tanimi, miktar)
VALUES (1, 'Kitap', 2);

-- 36
INSERT INTO PaketIcerik (paket_id, urun_tanimi, miktar)
VALUES (2, 'Elektronik Aksesuar', 1);

-- 37
INSERT INTO GonderimTipi (tip_adi, aciklama, teslimat_suresi_saat)
VALUES ('Uluslararası', 'Uluslararası gönderim', 120);

-- 38
INSERT INTO Gonderi (takip_no, gonderici_id, alici_id, gonderim_tipi_id, sube_id, kurye_id, durum)
VALUES ('INT-000003', 1, 2, 3, 1, 1, 'hazırlanıyor');

-- 39
INSERT INTO Paket (gonderi_id, agirlik_kg, en_cm, boy_cm, yukseklik_cm)
VALUES (3, 3.80, 40.00, 30.00, 20.00);

-- 40
INSERT INTO Odeme (gonderi_id, odeme_yontemi_id, tutar, durum)
VALUES (3, 1, 300.00, 'beklemede');

-- 41
INSERT INTO GonderiTakip (gonderi_id, durum)
VALUES (3, 'Gümrükte');

-- 42
INSERT INTO OdemeYontemi (yontem_adi)
VALUES ('Kapıda Ödeme');

-- 43
INSERT INTO Odeme (gonderi_id, odeme_yontemi_id, tutar, durum)
VALUES (3, 3, 300.00, 'tamamlandı');

-- 44
INSERT INTO Fatura (fatura_no, para_birimi, toplam_tutar)
VALUES ('FAT-2025-003', 'EUR', 300.00);

-- 45
INSERT INTO GonderiFatura (gonderi_id, fatura_id)
VALUES (3, 3);

-- PDF DELETE örnekleri: adres_id = 3 ve musteri_id = 3 için tamamlayıcı kayıtlar
INSERT INTO Musteri (kullanici_id, ad, soyad, email)
VALUES (NULL, 'Test', 'Müşteri', 'test.musteri@mail.com');

INSERT INTO Adres (musteri_id, ulke_id, sehir_id, acik_adres)
VALUES (1, 1, 1, 'Örnek adres — Müşteri 1');

INSERT INTO Adres (musteri_id, ulke_id, sehir_id, acik_adres)
VALUES (2, 1, 2, 'Örnek adres — Müşteri 2');

INSERT INTO Adres (musteri_id, ulke_id, sehir_id, acik_adres)
VALUES (3, 1, 1, 'Örnek adres — Müşteri 3');
