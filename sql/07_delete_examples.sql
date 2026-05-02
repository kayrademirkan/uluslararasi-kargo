-- PDF: DELETE KODLARI
-- Not: PDF sırası bazı FK bağımlılıklarında hata verebilir; tam çalıştırma için geçici olarak kontroller kapatılır.

USE uluslararasi_kargo;

SET FOREIGN_KEY_CHECKS = 0;

-- 1
DELETE FROM Telefon
WHERE telefon_id = 2;

-- 2
DELETE FROM GonderiTakip
WHERE takip_id = 1;

-- 3
DELETE FROM PaketIcerik
WHERE paket_id = 2;

-- 4
DELETE FROM Odeme
WHERE odeme_id = 3;

-- 5
DELETE FROM GonderiFatura
WHERE gonderi_id = 2;

-- 6
DELETE FROM Fatura
WHERE fatura_id = 2;

-- 7
DELETE FROM Kurye
WHERE kurye_id = 2;

-- 8
DELETE FROM Adres
WHERE adres_id = 3;

-- 9
DELETE FROM Musteri
WHERE musteri_id = 3;

-- 10
DELETE FROM Gonderi
WHERE gonderi_id = 2;

SET FOREIGN_KEY_CHECKS = 1;
