-- Uluslararası Kargo — Veri Tabanı II (PDF: TABLOLAR)
-- MySQL 8.0+ (CHECK kısıtları için)

CREATE DATABASE IF NOT EXISTS uluslararasi_kargo
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE uluslararasi_kargo;

SET NAMES utf8mb4;

-- Referans / bağımsız tablolar
CREATE TABLE Rol (
  rol_id INT AUTO_INCREMENT PRIMARY KEY,
  rol_adi VARCHAR(50) NOT NULL UNIQUE,
  aciklama VARCHAR(255)
);

CREATE TABLE ZamanDilimi (
  zaman_dilimi_id INT AUTO_INCREMENT PRIMARY KEY,
  kod VARCHAR(50) NOT NULL,
  utc_offset VARCHAR(10) NOT NULL
);

CREATE TABLE TarifeKod (
  hs_kod VARCHAR(20) PRIMARY KEY,
  aciklama VARCHAR(255),
  vergi_orani DECIMAL(5,2)
);

CREATE TABLE GonderimTipi (
  gonderim_tipi_id INT AUTO_INCREMENT PRIMARY KEY,
  tip_adi VARCHAR(50) NOT NULL UNIQUE,
  aciklama VARCHAR(255),
  teslimat_suresi_saat INT
);

CREATE TABLE Ulke (
  ulke_id INT AUTO_INCREMENT PRIMARY KEY,
  ulke_adi VARCHAR(100) NOT NULL,
  iso_kodu CHAR(2) NOT NULL UNIQUE,
  telefon_kodu VARCHAR(10),
  para_birimi VARCHAR(10),
  zaman_dilimi_id INT,
  vergi_orani DECIMAL(5,2) DEFAULT 0.00,
  FOREIGN KEY (zaman_dilimi_id) REFERENCES ZamanDilimi(zaman_dilimi_id)
);

CREATE TABLE Sehir (
  sehir_id INT AUTO_INCREMENT PRIMARY KEY,
  sehir_adi VARCHAR(100) NOT NULL,
  ulke_id INT NOT NULL,
  FOREIGN KEY (ulke_id) REFERENCES Ulke(ulke_id)
);

CREATE TABLE Sube (
  sube_id INT AUTO_INCREMENT PRIMARY KEY,
  sube_adi VARCHAR(100) NOT NULL,
  ulke_id INT,
  sehir_id INT,
  adres VARCHAR(255),
  aktif BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (ulke_id) REFERENCES Ulke(ulke_id),
  FOREIGN KEY (sehir_id) REFERENCES Sehir(sehir_id)
);

CREATE TABLE Kullanici (
  kullanici_id INT AUTO_INCREMENT PRIMARY KEY,
  ad VARCHAR(50) NOT NULL,
  soyad VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  sifre VARCHAR(255) NOT NULL,
  rol_id INT NOT NULL,
  aktif BOOLEAN DEFAULT TRUE,
  kayit_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (rol_id) REFERENCES Rol(rol_id)
);

CREATE TABLE KullaniciRol (
  kullanici_id INT,
  rol_id INT,
  PRIMARY KEY (kullanici_id, rol_id),
  FOREIGN KEY (kullanici_id) REFERENCES Kullanici(kullanici_id),
  FOREIGN KEY (rol_id) REFERENCES Rol(rol_id)
);

CREATE TABLE OturumLog (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  kullanici_id INT,
  giris_zamani DATETIME DEFAULT CURRENT_TIMESTAMP,
  cikis_zamani DATETIME NULL,
  ip_adresi VARCHAR(45),
  basarili BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (kullanici_id) REFERENCES Kullanici(kullanici_id)
);

CREATE TABLE Musteri (
  musteri_id INT AUTO_INCREMENT PRIMARY KEY,
  kullanici_id INT,
  ad VARCHAR(50) NOT NULL,
  soyad VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  kayit_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (kullanici_id) REFERENCES Kullanici(kullanici_id)
);

CREATE TABLE Adres (
  adres_id INT AUTO_INCREMENT PRIMARY KEY,
  musteri_id INT NOT NULL,
  ulke_id INT NOT NULL,
  sehir_id INT NOT NULL,
  acik_adres VARCHAR(255) NOT NULL,
  posta_kodu VARCHAR(20),
  adres_tipi ENUM('gonderici','alici','fatura','iade') DEFAULT 'gonderici',
  FOREIGN KEY (musteri_id) REFERENCES Musteri(musteri_id),
  FOREIGN KEY (ulke_id) REFERENCES Ulke(ulke_id),
  FOREIGN KEY (sehir_id) REFERENCES Sehir(sehir_id)
);

CREATE TABLE Telefon (
  telefon_id INT AUTO_INCREMENT PRIMARY KEY,
  musteri_id INT NOT NULL,
  telefon_numarasi VARCHAR(20) NOT NULL,
  ulke_kodu VARCHAR(5) NOT NULL,
  aktif BOOLEAN DEFAULT TRUE,
  CHECK (telefon_numarasi REGEXP '^[0-9]{7,15}$'),
  CHECK (ulke_kodu REGEXP '^\\+[1-9][0-9]{0,2}$'),
  CHECK (CONCAT(ulke_kodu, telefon_numarasi) REGEXP '^\\+[1-9][0-9]{7,14}$'),
  FOREIGN KEY (musteri_id) REFERENCES Musteri(musteri_id)
);

CREATE TABLE Gumruk (
  gumruk_id INT AUTO_INCREMENT PRIMARY KEY,
  gumruk_adi VARCHAR(100) NOT NULL,
  ulke_id INT,
  sehir_id INT,
  tip ENUM('hava','kara','deniz') NOT NULL,
  FOREIGN KEY (ulke_id) REFERENCES Ulke(ulke_id),
  FOREIGN KEY (sehir_id) REFERENCES Sehir(sehir_id)
);

CREATE TABLE Kurye (
  kurye_id INT AUTO_INCREMENT PRIMARY KEY,
  ad VARCHAR(50),
  soyad VARCHAR(50),
  sube_id INT,
  durum ENUM('aktif','izinli','görevde') DEFAULT 'aktif',
  FOREIGN KEY (sube_id) REFERENCES Sube(sube_id)
);

CREATE TABLE Rota (
  rota_id INT AUTO_INCREMENT PRIMARY KEY,
  rota_adi VARCHAR(100) NOT NULL,
  tasima_tipi ENUM('hava','kara','deniz','demir') NOT NULL,
  aktif BOOLEAN DEFAULT TRUE
);

CREATE TABLE RotaNokta (
  rota_nokta_id INT AUTO_INCREMENT PRIMARY KEY,
  rota_id INT NOT NULL,
  ulke_id INT,
  sehir_id INT,
  gumruk_id INT,
  sira_no INT,
  FOREIGN KEY (rota_id) REFERENCES Rota(rota_id),
  FOREIGN KEY (ulke_id) REFERENCES Ulke(ulke_id),
  FOREIGN KEY (sehir_id) REFERENCES Sehir(sehir_id),
  FOREIGN KEY (gumruk_id) REFERENCES Gumruk(gumruk_id)
);

CREATE TABLE TasimaciFirma (
  tasimaci_id INT AUTO_INCREMENT PRIMARY KEY,
  firma_adi VARCHAR(100) NOT NULL UNIQUE,
  merkez_ulke_id INT,
  tasima_tipi ENUM('hava','kara','deniz','demir') NOT NULL,
  iata_kodu VARCHAR(10),
  scac_kodu VARCHAR(10),
  FOREIGN KEY (merkez_ulke_id) REFERENCES Ulke(ulke_id)
);

CREATE TABLE TasimaciOfis (
  ofis_id INT AUTO_INCREMENT PRIMARY KEY,
  tasimaci_id INT NOT NULL,
  ulke_id INT,
  sehir_id INT,
  adres VARCHAR(255),
  FOREIGN KEY (tasimaci_id) REFERENCES TasimaciFirma(tasimaci_id),
  FOREIGN KEY (ulke_id) REFERENCES Ulke(ulke_id),
  FOREIGN KEY (sehir_id) REFERENCES Sehir(sehir_id)
);

CREATE TABLE Gonderi (
  gonderi_id INT AUTO_INCREMENT PRIMARY KEY,
  takip_no VARCHAR(30) NOT NULL UNIQUE,
  gonderici_id INT NOT NULL,
  alici_id INT NOT NULL,
  gonderim_tipi_id INT NOT NULL,
  sube_id INT NULL,
  kurye_id INT NULL,
  olusturulma_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
  tahmini_teslim DATETIME NULL,
  durum VARCHAR(50) DEFAULT 'hazırlanıyor',
  FOREIGN KEY (gonderici_id) REFERENCES Musteri(musteri_id),
  FOREIGN KEY (alici_id) REFERENCES Musteri(musteri_id),
  FOREIGN KEY (gonderim_tipi_id) REFERENCES GonderimTipi(gonderim_tipi_id),
  FOREIGN KEY (sube_id) REFERENCES Sube(sube_id),
  FOREIGN KEY (kurye_id) REFERENCES Kurye(kurye_id)
);

CREATE TABLE Paket (
  paket_id INT AUTO_INCREMENT PRIMARY KEY,
  gonderi_id INT NOT NULL,
  agirlik_kg DECIMAL(10,2) NOT NULL,
  en_cm DECIMAL(10,2) NOT NULL,
  boy_cm DECIMAL(10,2) NOT NULL,
  yukseklik_cm DECIMAL(10,2) NOT NULL,
  barkod VARCHAR(50) UNIQUE,
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id)
);

CREATE TABLE PaketIcerik (
  icerik_id INT AUTO_INCREMENT PRIMARY KEY,
  paket_id INT NOT NULL,
  urun_tanimi VARCHAR(255) NOT NULL,
  miktar INT NOT NULL DEFAULT 1,
  birim VARCHAR(20),
  birim_deger DECIMAL(12,2),
  toplam_deger DECIMAL(12,2),
  para_birimi VARCHAR(10),
  ozel_elleceleme BOOLEAN DEFAULT FALSE,
  tehlikeli_madde BOOLEAN DEFAULT FALSE,
  aciklama TEXT,
  FOREIGN KEY (paket_id) REFERENCES Paket(paket_id)
);

CREATE TABLE Fatura (
  fatura_id INT AUTO_INCREMENT PRIMARY KEY,
  fatura_no VARCHAR(50) UNIQUE,
  tarih DATETIME DEFAULT CURRENT_TIMESTAMP,
  para_birimi VARCHAR(10) DEFAULT 'TRY',
  toplam_tutar DECIMAL(12,2) DEFAULT 0.00
);

CREATE TABLE GonderiFatura (
  gonderi_id INT,
  fatura_id INT,
  PRIMARY KEY (gonderi_id, fatura_id),
  UNIQUE KEY uniq_gonderi_fatura (gonderi_id),
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id),
  FOREIGN KEY (fatura_id) REFERENCES Fatura(fatura_id)
);

CREATE TABLE OdemeYontemi (
  odeme_yontemi_id INT AUTO_INCREMENT PRIMARY KEY,
  yontem_adi VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Odeme (
  odeme_id INT AUTO_INCREMENT PRIMARY KEY,
  gonderi_id INT NOT NULL,
  odeme_yontemi_id INT NOT NULL,
  tutar DECIMAL(12,2) NOT NULL,
  odeme_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
  durum ENUM('beklemede','tamamlandı','iptal') DEFAULT 'tamamlandı',
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id),
  FOREIGN KEY (odeme_yontemi_id) REFERENCES OdemeYontemi(odeme_yontemi_id)
);

CREATE TABLE UcretTarifesi (
  tarif_id INT AUTO_INCREMENT PRIMARY KEY,
  ulke_kaynak_id INT,
  ulke_hedef_id INT,
  gonderim_tipi_id INT,
  min_kilo DECIMAL(10,2),
  max_kilo DECIMAL(10,2),
  fiyat DECIMAL(12,2),
  para_birimi VARCHAR(10),
  FOREIGN KEY (ulke_kaynak_id) REFERENCES Ulke(ulke_id),
  FOREIGN KEY (ulke_hedef_id) REFERENCES Ulke(ulke_id),
  FOREIGN KEY (gonderim_tipi_id) REFERENCES GonderimTipi(gonderim_tipi_id)
);

CREATE TABLE GonderiUcret (
  gonderi_id INT PRIMARY KEY,
  hesaplanan_ucret DECIMAL(12,2),
  para_birimi VARCHAR(10),
  hesaplama_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id)
);

CREATE TABLE VergiTipi (
  vergi_id INT AUTO_INCREMENT PRIMARY KEY,
  vergi_adi VARCHAR(100) NOT NULL,
  oran DECIMAL(5,2) NOT NULL
);

CREATE TABLE FaturaVergi (
  fatura_id INT,
  vergi_id INT,
  tutar DECIMAL(12,2),
  PRIMARY KEY (fatura_id, vergi_id),
  FOREIGN KEY (fatura_id) REFERENCES Fatura(fatura_id),
  FOREIGN KEY (vergi_id) REFERENCES VergiTipi(vergi_id)
);

CREATE TABLE GonderiSigorta (
  sigorta_id INT AUTO_INCREMENT PRIMARY KEY,
  gonderi_id INT NOT NULL,
  sigorta_sirketi VARCHAR(100),
  `poliçe_no` VARCHAR(50),
  teminat_tutari DECIMAL(12,2),
  para_birimi VARCHAR(10),
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id)
);

CREATE TABLE GonderiTasimaci (
  gonderi_id INT,
  tasimaci_id INT,
  PRIMARY KEY (gonderi_id, tasimaci_id),
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id),
  FOREIGN KEY (tasimaci_id) REFERENCES TasimaciFirma(tasimaci_id)
);

CREATE TABLE GonderiRota (
  gonderi_id INT,
  rota_id INT,
  PRIMARY KEY (gonderi_id, rota_id),
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id),
  FOREIGN KEY (rota_id) REFERENCES Rota(rota_id)
);

CREATE TABLE GumrukIslem (
  islem_id INT AUTO_INCREMENT PRIMARY KEY,
  gonderi_id INT NOT NULL,
  gumruk_id INT NOT NULL,
  islem_tipi ENUM('ihracat','ithalat','transit') NOT NULL,
  islem_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
  hs_kodu VARCHAR(20),
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id),
  FOREIGN KEY (gumruk_id) REFERENCES Gumruk(gumruk_id)
);

CREATE TABLE GonderiGumruk (
  gonderi_id INT,
  hs_kod VARCHAR(20),
  gumruk_id INT,
  PRIMARY KEY (gonderi_id, hs_kod),
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id),
  FOREIGN KEY (hs_kod) REFERENCES TarifeKod(hs_kod),
  FOREIGN KEY (gumruk_id) REFERENCES Gumruk(gumruk_id)
);

CREATE TABLE SubeMudur (
  sube_id INT PRIMARY KEY,
  kullanici_id INT NOT NULL,
  FOREIGN KEY (sube_id) REFERENCES Sube(sube_id),
  FOREIGN KEY (kullanici_id) REFERENCES Kullanici(kullanici_id)
);

CREATE TABLE KuryeRota (
  kurye_id INT,
  rota_id INT,
  PRIMARY KEY (kurye_id, rota_id),
  FOREIGN KEY (kurye_id) REFERENCES Kurye(kurye_id),
  FOREIGN KEY (rota_id) REFERENCES Rota(rota_id)
);

CREATE TABLE SubeGunlukRapor (
  rapor_id INT AUTO_INCREMENT PRIMARY KEY,
  sube_id INT,
  rapor_tarihi DATE,
  toplam_gonderi INT DEFAULT 0,
  toplam_iade INT DEFAULT 0,
  FOREIGN KEY (sube_id) REFERENCES Sube(sube_id)
);

CREATE TABLE TransferKaydi (
  transfer_id INT AUTO_INCREMENT PRIMARY KEY,
  gonderi_id INT,
  sube_kaynak_id INT,
  sube_hedef_id INT,
  transfer_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id),
  FOREIGN KEY (sube_kaynak_id) REFERENCES Sube(sube_id),
  FOREIGN KEY (sube_hedef_id) REFERENCES Sube(sube_id)
);

CREATE TABLE GonderiTakip (
  takip_id INT AUTO_INCREMENT PRIMARY KEY,
  gonderi_id INT NOT NULL,
  durum VARCHAR(50) NOT NULL,
  konum_sehir_id INT,
  aciklama TEXT,
  islem_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id),
  FOREIGN KEY (konum_sehir_id) REFERENCES Sehir(sehir_id)
);

CREATE TABLE BildirimTipi (
  bildirim_tipi_id INT AUTO_INCREMENT PRIMARY KEY,
  adi VARCHAR(100) NOT NULL UNIQUE,
  aciklama VARCHAR(255)
);

CREATE TABLE Bildirim (
  bildirim_id INT AUTO_INCREMENT PRIMARY KEY,
  gonderi_id INT,
  musteri_id INT,
  bildirim_tipi_id INT,
  kanal ENUM('sms','email','push') DEFAULT 'email',
  mesaj TEXT,
  gonderim_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
  okundu BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id),
  FOREIGN KEY (musteri_id) REFERENCES Musteri(musteri_id),
  FOREIGN KEY (bildirim_tipi_id) REFERENCES BildirimTipi(bildirim_tipi_id)
);

CREATE TABLE OlayTipi (
  olay_tipi_id INT AUTO_INCREMENT PRIMARY KEY,
  adi VARCHAR(100) NOT NULL UNIQUE,
  aciklama VARCHAR(255)
);

CREATE TABLE OlayRaporu (
  olay_id INT AUTO_INCREMENT PRIMARY KEY,
  gonderi_id INT,
  olay_tipi_id INT,
  aciklama TEXT,
  olusturma_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id),
  FOREIGN KEY (olay_tipi_id) REFERENCES OlayTipi(olay_tipi_id)
);

CREATE TABLE IadeNedeni (
  iade_nedeni_id INT AUTO_INCREMENT PRIMARY KEY,
  aciklama VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Iade (
  iade_id INT AUTO_INCREMENT PRIMARY KEY,
  gonderi_id INT NOT NULL,
  iade_nedeni_id INT NOT NULL,
  iade_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (gonderi_id) REFERENCES Gonderi(gonderi_id),
  FOREIGN KEY (iade_nedeni_id) REFERENCES IadeNedeni(iade_nedeni_id)
);

CREATE TABLE LogKaydi (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  kullanici_id INT,
  tablo_adi VARCHAR(100),
  islem ENUM('INSERT','UPDATE','DELETE','LOGIN','LOGOUT'),
  islem_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
  ip_adresi VARCHAR(45),
  FOREIGN KEY (kullanici_id) REFERENCES Kullanici(kullanici_id)
);

CREATE TABLE YedeklemeLog (
  yedek_id INT AUTO_INCREMENT PRIMARY KEY,
  tarih DATETIME DEFAULT CURRENT_TIMESTAMP,
  durum ENUM('başarılı','hatalı') DEFAULT 'başarılı',
  aciklama TEXT
);

CREATE TABLE Ayarlar (
  ayar_adi VARCHAR(100) PRIMARY KEY,
  deger VARCHAR(255),
  aciklama VARCHAR(255)
);

CREATE TABLE HataKaydi (
  hata_id INT AUTO_INCREMENT PRIMARY KEY,
  hata_kodu VARCHAR(50),
  mesaj TEXT,
  olusturma_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP
);
