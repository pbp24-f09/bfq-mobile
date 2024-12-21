
# Bandung Food Quest (BFQ)

---

## Anggota Kelompok
- Muhammad Abyasa Pratama (2306207663)
- Raja Rafael Pangihutan Sitorus (2306244923)
- Daniel Ferdiansyah (2306275052)
- Safira Salma Humaira (2306245850)
- Evelyn Depthios (2306207543)

---

Deployment : 

## Deskripsi Aplikasi
Bandung Food Quest (BFQ) adalah sebuah situs web e-commerce yang berfokus pada produk-produk kuliner khas Bandung. Website ini menyediakan platform bagi pelanggan untuk menemukan dan membeli berbagai produk makanan khas kota tersebut. Pada aplikasi ini, admin dapat secara langsung mengelola katalog produk dengan menambahkan, mengedit, dan menghapus produk. Sementara itu, customer dan guest hanya dapat melihat katalog produk pada modul main app (home page).

Aplikasi ini terdiri dari beberapa modul lain yang hanya dapat diakses oleh admin dan customer. Pertama, modul otentikasi dan pengelolaan profil pengguna, yang mencakup fitur registrasi, login, tampilan profil pengguna, dan pengeditan profil. Kedua, modul kategori yang menyediakan fitur pencarian dan filter produk. Ketiga, modul blog yang memungkinkan pengguna untuk mengunggah, mengedit, dan menghapus artikel milik mereka sendiri. Terakhir, modul forum yang memungkinkan pengguna untuk membuat, mengedit, dan menghapus thread, serta berpartisipasi dengan memberikan balasan pada thread tersebut.

Kelompok kami memilih kota Bandung sebagai fokus karena Bandung dikenal sebagai kota dengan kekayaan kuliner yang unggul. Kami ingin mendukung perkembangan UMKM yang memiliki potensi tinggi di bidang kuliner khas Bandung. Melalui penerapan modul-modul pada website kami, diharapkan terjadi peningkatan penjualan serta interaksi yang lebih baik antara customer dan admin.

## Daftar Modul yang Akan Diimplementasikan:
1. **Main App (Home Page)** - Daniel
   - **Left Drawer (di semua page)**:
        - Admin: Greeting, Home, Categories, Forum, Blog, Logout.
        - Customer: Greeting, Home, Categories. Forum. Blog, Logout
        - Guest: Home, Login, Register.
   - **Homepage**:
        - Admin: Display, add, edit, dan delete product + Akses categories, forum, dan blog
        - Customer: Product display + akses categories, forum, dan blog
        - Guest: Product display
   - **Carousel**: Slider dekoratif Bandung Food Quest.
   - **Product Display**: Fetch database model product antara Django dan Flutter serta mengimplementasi pop-up modal untuk menampilkan product details.

2. **Categories** - Abyasa
   - **Search Bar**: Search produk menggunakan keyword nama produk.
   - **Filter**: Filtering produk berdasarkan kategori.
   - **Product Display**: Menampilkan produk berdasarkan kategori atau secara keseluruhan.

3. **Forum Diskusi** - Raja
   - **Forum**: Menampilkan postingan forum dari semua pengguna (nama dan umur ditampilkan).
   - **Tambah Topik**: Menambahkan topik untuk forum diskusi baru.
   - **Reply dan Edit Forum**: Edit dan reply post berlaku untuk seluruh akun.
   - **Delete Forum**: Hapus post hanya berlaku untuk post akun tersebut.

4. **User Info & Authentication** - Evelyn
   - **Register**: Nama Lengkap, Umur, Gender, No. Telepon, Username, Password, Role.
   - **Login**: Username dan Password.
   - **User Profile**: Menampilkan profil user, edit profil, delete akun, dan ganti password.

5. **Blog/Artikel** - Safira
   - **Post Artikel**: Judul, Topik, Artikel, Penulis.
   - **Display Artikel**: Menampilkan artikel.
   - **My Article**: Lihat, edit, dan hapus artikel sendiri.

## Sumber Initial Dataset:
[Initial Dataset](https://docs.google.com/spreadsheets/d/17DGOKHDmYB2t5OF1HMo6wjNFQnZkCA3M83gFQPy6X2A/edit?gid=0#gid=0)

## Role atau Peran Pengguna Beserta Deskripsinya:
1. **Admin**:
   - Mengelola produk (menambah, mengedit, menghapus) dan kategori produk.
   - Mengelola forum dan artikel (menghapus atau mengedit postingan yang tidak sesuai).
   - Memiliki akses penuh terhadap semua fitur pengelolaan dalam aplikasi.

2. **Customer**:
   - Dapat melihat produk dan kategori produk yang ditampilkan.
   - Dapat berpartisipasi dalam diskusi forum dengan membuat dan membalas topik.
   - Bisa membaca artikel kuliner serta menulis dan mengelola artikel pribadi mereka.

3. **Guest**:
   - Pengguna yang belum terdaftar hanya dapat melihat produk, tidak dapat berinteraksi dengan forum atau menulis artikel.
  
## Langkah-Langkah Integrasi dengan Web Service
1. **Identifikasi Kebutuhan dan Perancangan Aplikasi**
- Kami memulai dengan menentukan fitur utama yang harus disediakan oleh web service, seperti mengambil data produk dan validasi pengguna.
- Selanjutnya, kami mengidentifikasi format data yang digunakan, yakni JSON, dan mencatat endpoint yang disediakan oleh web service.

2. **Konfigurasi dan Koneksi ke Web Service**
- Data yang dikirim ke aplikasi Flutter adalah dalam format JSON. Ketika Flutter mengirim permintaan data ke server, Django akan mengirimkan respons dalam format JSON.

3. **Pengujian Proses Integrasi**
- Sebelum menghubungkan web service ke aplikasi, kami menggunakan alat seperti Postman untuk menguji setiap endpoint dan memahami format responsnya.
- Pengujian dilakukan pada berbagai skenario, baik keberhasilan maupun kegagalan, untuk memastikan sistem siap digunakan.

4. **Pengembangan User Interface**
- Setelah integrasi teknis selesai, kami membuat antarmuka pengguna (UI/UX) untuk mengolah dan menampilkan data yang diperoleh dari web service secara intuitif dan interaktif.

5. **Deployment dan Pemantauan**
- Kami memastikan koneksi ke web service tetap stabil saat aplikasi dijalankan.
- Performa web service, termasuk waktu respons dan error log, dipantau secara berkala untuk menjaga kelancaran operasional aplikasi.

---

## Progress Tracker
https://docs.google.com/spreadsheets/d/1jme9nQszFj6PM0KthMlKFVwGmmGhkD531HXKvJ9v3Ms/edit?usp=sharing
