-- PDF: İKİ TABLO SELECT SORGULARI

-- Sorgu 1
SELECT Gonderi.takip_no, Gonderi.durum, GonderimTipi.tip_adi
FROM Gonderi
INNER JOIN GonderimTipi
  ON Gonderi.gonderim_tipi_id = GonderimTipi.gonderim_tipi_id;

-- Sorgu 2
SELECT Musteri.ad, Musteri.soyad, Telefon.telefon_numarasi
FROM Musteri
INNER JOIN Telefon
  ON Musteri.musteri_id = Telefon.musteri_id;

-- Sorgu 3
SELECT Kurye.ad, Kurye.soyad, Sube.sube_adi
FROM Kurye
INNER JOIN Sube
  ON Kurye.sube_id = Sube.sube_id;
