-- PDF: ÜÇ TABLO SELECT SORGULARI

-- Sorgu 1
SELECT
  Gonderi.takip_no,
  Musteri.ad,
  Musteri.soyad,
  Gonderi.durum
FROM Gonderi
INNER JOIN Musteri
  ON Gonderi.gonderici_id = Musteri.musteri_id
INNER JOIN GonderimTipi
  ON Gonderi.gonderim_tipi_id = GonderimTipi.gonderim_tipi_id;

-- Sorgu 2
SELECT
  Odeme.tutar,
  Odeme.odeme_tarihi,
  OdemeYontemi.yontem_adi,
  Gonderi.takip_no
FROM Odeme
INNER JOIN OdemeYontemi
  ON Odeme.odeme_yontemi_id = OdemeYontemi.odeme_yontemi_id
INNER JOIN Gonderi
  ON Odeme.gonderi_id = Gonderi.gonderi_id;
