
# Bandung Food Quest (BFQ)

---

## Anggota Kelompok
- Muhammad Abyasa Pratama (2306207663)
- Raja Rafael Pangihutan Sitorus (2306244923)
- Daniel Ferdiansyah (2306275052)
- Safira Salma Humaira (2306245850)
- Evelyn Depthios (2306207543)

---

## Deskripsi Aplikasi
Bandung Food Quest (BFQ) adalah sebuah situs web e-commerce yang berfokus pada produk-produk kuliner khas Bandung. Website ini menyediakan platform bagi pelanggan untuk menemukan dan membeli berbagai produk makanan khas kota tersebut. Pada aplikasi ini, admin dapat secara langsung mengelola katalog produk dengan menambahkan, mengedit, dan menghapus produk. Sementara itu, customer dan guest hanya dapat melihat katalog produk pada modul main app (home page).

Aplikasi ini terdiri dari beberapa modul lain yang hanya dapat diakses oleh admin dan customer. Pertama, modul otentikasi dan pengelolaan profil pengguna, yang mencakup fitur registrasi, login, tampilan profil pengguna, dan pengeditan profil. Kedua, modul kategori yang menyediakan fitur pencarian dan filter produk. Ketiga, modul blog yang memungkinkan pengguna untuk mengunggah, mengedit, dan menghapus artikel milik mereka sendiri. Terakhir, modul forum yang memungkinkan pengguna untuk membuat, mengedit, dan menghapus thread, serta berpartisipasi dengan memberikan balasan pada thread tersebut.

Kelompok kami memilih kota Bandung sebagai fokus karena Bandung dikenal sebagai kota dengan kekayaan kuliner yang unggul. Kami ingin mendukung perkembangan UMKM yang memiliki potensi tinggi di bidang kuliner khas Bandung. Melalui penerapan modul-modul pada website kami, diharapkan terjadi peningkatan penjualan serta interaksi yang lebih baik antara customer dan admin.

## Daftar Modul yang Akan Diimplementasikan:
1. **Main App (Home Page)**
   - **Navbar**: Navbar untuk Admin dan Customer berisi menu Home, Categories (dropdown), Forum, Hello [nama user] (link ke edit user profile), dan Logout. Lalu, Navbar untuk Guest (landing page) berisi menu Home, Categories, dan Login. Navbar ini support mobile view.
   - **Header, Footer, Base Template**: Di folder root template, standar untuk seluruh halaman.
   - **Homepage as Admin**: Bisa menambahkan, mengedit, dan menghapus produk.
   - **Homepage as Customer**: Menampilkan produk dalam pop-up detail.
   - **Carousel**: Foto-foto Bandung dengan overview singkat.
   - **Product Display**: Admin dapat menambah, mengedit, dan menghapus produk. Customer hanya melihat detail produk.
   - **Search Bar**: Customer dan Admin dapat search berdasarkan nama makanan.
   - **Landing Page**: Landing page berisi fitur-fitur yang hampir sama dengan home page, akan tetapi navbar hanya berisi menu Home dan Login. Dalam landing page ini tetap menampilkan produk-produk.

2. **Categories**
   - **Search Bar**: Search produk menggunakan keyword nama produk.
   - **Filter**: Filtering produk berdasarkan kategori.
   - **Product Display**: Menampilkan produk berdasarkan kategori atau secara keseluruhan.

3. **Forum Diskusi**
   - **Forum**: Menampilkan postingan forum dari semua pengguna (nama dan umur ditampilkan).
   - **Tambah Topik**: Menambahkan topik untuk forum diskusi baru.
   - **Reply dan Edit Forum**: Edit dan reply post berlaku untuk seluruh akun.
   - **Delete Forum**: Hapus post hanya berlaku untuk post akun tersebut.

4. **User Info & Authentication**
   - **Register**: Nama Lengkap, Umur, Gender, No. Telepon, Username, Password, Role.
   - **Login**: Username dan Password.
   - **User Profile**: Menampilkan profil user, edit profil dan ganti password.

5. **Blog/Artikel**
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
   - Pengguna yang belum terdaftar hanya dapat melihat produk dan artikel, tetapi tidak dapat berinteraksi dengan forum atau menulis artikel.
