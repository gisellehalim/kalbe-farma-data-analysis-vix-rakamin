CREATE DATABASE kimia_farma_2022;
USE kimia_farma_2022;

CREATE TABLE penjualan (
id_invoice VARCHAR(20) NOT NULL,
tanggal DATE,
id_customer VARCHAR(20) NOT NULL,
id_barang VARCHAR(20) NOT NULL,
jumlah_barang INT,
unit VARCHAR(15),
harga INT,
mata_uang VARCHAR(5));

CREATE TABLE pelanggan (
id_customer VARCHAR(20) NOT NULL,
level VARCHAR(10),
nama VARCHAR (100),
id_cabang VARCHAR(10),
cabang_sales VARCHAR(20),
id_distributor VARCHAR(5),
grup VARCHAR(10),
primary key (id_customer));

CREATE TABLE barang (
kode_barang VARCHAR(20) NOT NULL,
nama_barang VARCHAR(50),
kemasan VARCHAR(10),
harga INT,
nama_tipe VARCHAR(30),
kode_brand VARCHAR(20),
brand VARCHAR(30),
primary key (kode_barang));

ALTER TABLE penjualan ADD CONSTRAINT FOREIGN KEY (id_customer) REFERENCES pelanggan (id_customer);
ALTER TABLE penjualan ADD CONSTRAINT FOREIGN KEY (id_barang) REFERENCES barang (kode_barang);

SELECT * FROM penjualan

SELECT * FROM barang

SELECT * FROM pelanggan

CREATE TABLE base_table (
	SELECT
	CONCAT(penjualan.id_invoice,penjualan.id_barang) AS id_penjualan,
	penjualan.id_invoice,
	penjualan.tanggal,
	penjualan.id_customer,
	pelanggan.level,
	pelanggan.nama,
	pelanggan.id_cabang,
	pelanggan.cabang_sales,
	pelanggan.id_distributor,
	pelanggan.grup,
	penjualan.id_barang,
	barang.nama_barang,
	penjualan.jumlah_barang,
	penjualan.unit,
	barang.nama_tipe,
	barang.kode_brand,
	barang.brand,
	penjualan.harga,
	penjualan.mata_uang
    
	FROM penjualan 
		LEFT JOIN pelanggan ON pelanggan.id_customer = penjualan.id_customer
		LEFT JOIN barang ON kode_barang = penjualan.id_barang
    ORDER BY penjualan.tanggal
	);
    
ALTER TABLE base_table ADD CONSTRAINT PRIMARY KEY (id_penjualan);

SELECT * FROM base_table;

CREATE TABLE sales_table (
	SELECT 
	id_penjualan,
	tanggal,
    MONTHNAME(tanggal) AS bulan,
	id_customer,
	nama,
	grup,
	cabang_sales,
	id_barang,
	nama_barang,
	jumlah_barang,
	unit,
	brand,
	harga,
	jumlah_barang * harga AS total_sales

	FROM base_table);

SELECT * FROM sales_table;

CREATE TABLE sales_barang (
	SELECT 
	id_barang,
	nama_barang,
	brand,
	harga,
	COUNT(id_penjualan) AS total_transaksi,
	SUM(jumlah_barang * harga) AS total_sales_barang,
	MIN(jumlah_barang * harga) AS min_penjualan,
	AVG(jumlah_barang * harga) AS avg_sales_barang,
	MAX(jumlah_barang * harga) AS max_penjualan,
	SUM(jumlah_barang) AS jumlah_penjualan_barang,
	MIN(jumlah_barang) AS min_penjualan_barang,
	MAX(jumlah_barang) AS max_penjualan_barang

	FROM base_table
	GROUP BY id_barang, nama_barang, brand, harga
	ORDER BY total_sales_barang);

SELECT * FROM sales_barang;

CREATE TABLE sales_brand (
	SELECT 
	brand,
	COUNT(id_penjualan) AS total_transaksi,
	SUM(jumlah_barang * harga) AS total_sales_brand,
	MIN(jumlah_barang * harga) AS min_penjualan,
	AVG(jumlah_barang * harga) AS avg_sales_brand,
	MAX(jumlah_barang * harga) AS max_penjualan,
	SUM(jumlah_barang) AS jumlah_penjualan_brand,
	MIN(jumlah_barang) AS min_penjualan_brand,
	MAX(jumlah_barang) AS max_penjualan_brand

	FROM base_table
	GROUP BY brand
	ORDER BY total_sales_brand);

SELECT * FROM sales_brand;

CREATE TABLE sales_harian (
	SELECT 
	tanggal,
	MONTHNAME(tanggal) AS bulan,
	COUNT(id_penjualan) AS total_transaksi,
	SUM(jumlah_barang * harga) AS total_sales_harian,
	MIN(jumlah_barang * harga) AS min_penjualan_harian,
	MAX(jumlah_barang * harga) AS max_penjualan_harian,
	SUM(jumlah_barang) AS jumlah_penjualan_harian,
	MIN(jumlah_barang) AS min_penjualan_barang_harian,
	MAX(jumlah_barang) AS max_penjualan_barang_harian

	FROM base_table
	GROUP BY tanggal, bulan
	ORDER BY tanggal);

SELECT * FROM sales_harian;

CREATE TABLE sales_cabang (
	SELECT
	id_cabang, 
	cabang_sales,
	COUNT(cabang_sales) AS jumlah_transaksi,
	SUM(jumlah_barang * harga) AS total_sales,
	SUM(jumlah_barang) AS jumlah_penjualan

	FROM base_table
	GROUP BY id_cabang, cabang_sales
	ORDER BY total_sales);

SELECT * FROM sales_cabang;

CREATE TABLE sales_distributor (
	SELECT
	id_distributor,
	COUNT(id_distributor) AS jumlah_transaksi,
	SUM(jumlah_barang * harga) AS total_sales,
	SUM(jumlah_barang) AS jumlah_penjualan
	FROM base_table
	GROUP BY id_distributor
	ORDER BY total_sales);

SELECT * FROM sales_distributor;

CREATE TABLE sales_grup (
	SELECT
	grup,
	COUNT(grup) AS jumlah_transaksi,
	SUM(jumlah_barang * harga) AS total_sales,
	SUM(jumlah_barang) AS jumlah_penjualan

	FROM base_table
	GROUP BY grups
	ORDER BY grup);

SELECT * FROM sales_grup;

CREATE TABLE sales_brand_detail (
	SELECT
	brand,
	cabang_sales,
	SUM(jumlah_barang*harga) AS jumlah_penjualan,
	SUM(jumlah_barang) AS jumlah_barang_terjual
	FROM base_table
	GROUP BY brand, cabang_sales);

SELECT * FROM sales_brand_detail;

CREATE TABLE sales_barang_detail (
	SELECT
	nama_barang,
	cabang_sales,
	SUM(jumlah_barang*harga) AS jumlah_penjualan,
	SUM(jumlah_barang) AS jumlah_barang_terjual
	FROM base_table
	GROUP BY nama_barang, cabang_sales);

SELECT * FROM sales_barang_detail;

CREATE TABLE sales_harian_cabang (
	SELECT 
	tanggal,
	MONTHNAME(tanggal) AS bulan,
	cabang_sales,
	COUNT(id_penjualan) AS total_transaksi,
	SUM(jumlah_barang * harga) AS total_sales_harian,
	SUM(jumlah_barang) AS jumlah_penjualan_barang

	FROM base_table
	GROUP BY tanggal, bulan, cabang_sales
	ORDER BY tanggal);

SELECT * FROM sales_harian_cabang;
