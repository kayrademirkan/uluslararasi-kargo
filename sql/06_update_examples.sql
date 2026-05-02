-- PDF: UPDATE KODLARI

USE uluslararasi_kargo;

-- 1
UPDATE Gonderi
SET durum = 'Yolda'
WHERE gonderi_id = 1;

-- 2
UPDATE Gonderi
SET durum = 'Teslim Edildi'
WHERE gonderi_id = 2;

-- 3
UPDATE Kurye
SET durum = 'görevde'
WHERE kurye_id = 1;

-- 4
UPDATE Kurye
SET durum = 'izinli'
WHERE kurye_id = 2;

-- 5
UPDATE Sube
SET aktif = FALSE
WHERE sube_id = 2;

-- 6
UPDATE Sube
SET aktif = TRUE
WHERE sube_id = 1;

-- 7
UPDATE Odeme
SET durum = 'tamamlandı'
WHERE odeme_id = 3;

-- 8
UPDATE Telefon
SET aktif = FALSE
WHERE telefon_id = 2;

-- 9
UPDATE Fatura
SET toplam_tutar = 270.00
WHERE fatura_id = 1;

-- 10
UPDATE GonderiTakip
SET durum = 'Teslim Edildi'
WHERE takip_id = 1;
