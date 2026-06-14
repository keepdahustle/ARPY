class MiniProject {
  final String id;
  final String title;
  final String description;
  final String briefContent;
  final String difficulty;
  final String icon;
  final int estimatedDays;

  MiniProject({
    required this.id,
    required this.title,
    required this.description,
    required this.briefContent,
    required this.difficulty,
    required this.icon,
    required this.estimatedDays,
  });
}

class ProjectsDataManager {
  static List<MiniProject> getAllProjects() {
    return [
      MiniProject(
        id: 'project_1',
        title: 'Kalkulator Sederhana',
        description: 'Buat program kalkulator dengan operasi dasar (+, -, *, /)',
        briefContent: '''
Tujuan: Membuat program kalkulator sederhana menggunakan Python

Deskripsi:
Dalam project ini, Anda akan membuat sebuah program kalkulator interaktif yang dapat menangani operasi matematika dasar. Program harus dapat menerima input dari pengguna dan menampilkan hasil operasi.

Fitur yang Harus Diimplementasikan:
1. Fungsi penjumlahan (+)
2. Fungsi pengurangan (-)
3. Fungsi perkalian (*)
4. Fungsi pembagian (/)
5. Menu untuk memilih operasi
6. Input validasi dari pengguna
7. Tampilan hasil yang jelas

Struktur Program:
- Definisikan fungsi untuk setiap operasi
- Gunakan perulangan untuk menu pilihan
- Tangani error jika ada pembagian dengan nol
- Berikan feedback kepada pengguna

Contoh Output:
=== KALKULATOR SEDERHANA ===
1. Penjumlahan
2. Pengurangan
3. Perkalian
4. Pembagian
5. Keluar

Pilih operasi (1-5): 1
Masukkan bilangan pertama: 10
Masukkan bilangan kedua: 5
Hasil: 10 + 5 = 15

Tips:
- Gunakan try-except untuk menangani input yang salah
- Pastikan program dapat menjalankan multiple operasi sebelum keluar
- Tambahkan validasi untuk pembagian dengan nol
        ''',
        difficulty: 'Pemula',
        icon: '🧮',
        estimatedDays: 3,
      ),
      MiniProject(
        id: 'project_2',
        title: 'Sistem Manajemen Kontak',
        description: 'Aplikasi untuk menyimpan, mencari, dan mengelola daftar kontak',
        briefContent: '''
Tujuan: Membuat aplikasi manajemen kontak menggunakan Python

Deskripsi:
Anda akan membuat program untuk mengelola daftar kontak pribadi. Program harus dapat menyimpan informasi kontak (nama, nomor telepon, email) dan memberikan fungsionalitas untuk menambah, mencari, mengedit, dan menghapus kontak.

Fitur yang Harus Diimplementasikan:
1. Tambah kontak baru dengan nama, nomor telepon, dan email
2. Lihat semua kontak dalam daftar
3. Cari kontak berdasarkan nama
4. Edit informasi kontak yang sudah ada
5. Hapus kontak dari daftar
6. Simpan kontak ke file (opsional: JSON atau CSV)
7. Muat kontak dari file saat program dimulai

Struktur Data:
- Gunakan Dictionary untuk menyimpan informasi kontak
- Gunakan List untuk menyimpan multiple kontak
- Pertimbangkan struktur yang mudah untuk searching dan sorting

Menu Utama:
1. Tambah Kontak
2. Lihat Semua Kontak
3. Cari Kontak
4. Edit Kontak
5. Hapus Kontak
6. Keluar

Tips:
- Validasi input email dan nomor telepon
- Implementasikan fungsi pencarian yang fleksibel
- Simpan data ke file untuk persistensi
- Gunakan try-except untuk error handling
        ''',
        difficulty: 'Menengah',
        icon: '📇',
        estimatedDays: 5,
      ),
      MiniProject(
        id: 'project_3',
        title: 'Game Tebak Angka',
        description: 'Game interaktif dimana pemain menebak angka rahasia',
        briefContent: '''
Tujuan: Membuat game tebak angka yang seru dan interaktif

Deskripsi:
Anda akan membuat game dimana komputer menghasilkan angka acak antara 1-100, dan pemain harus menebak angka tersebut. Program memberikan hint apakah tebakan terlalu tinggi atau terlalu rendah.

Fitur yang Harus Diimplementasikan:
1. Generate angka acak antara 1-100
2. Terima input tebakan dari pemain
3. Berikan hint (lebih tinggi/lebih rendah)
4. Hitung jumlah percobaan
5. Tampilkan pesan kemenangan dengan skor
6. Tawarkan untuk bermain lagi
7. Implementasikan level kesulitan berbeda

Level Kesulitan:
- Mudah: Angka 1-50, maksimal 10 percobaan
- Normal: Angka 1-100, maksimal 8 percobaan
- Sulit: Angka 1-500, maksimal 10 percobaan

Fitur Tambahan:
- Statistik permainan (total kemenangan, rata-rata percobaan)
- Leaderboard atau high score
- Waktu bermain sebagai kompetisi

Alur Program:
1. Tampilkan welcome message
2. Tanyakan level kesulitan
3. Generate angka
4. Loop: minta tebakan, berikan hint, hitung percobaan
5. Tampilkan hasil akhir
6. Tanyakan bermain lagi

Tips:
- Gunakan random module
- Implementasikan validasi input dengan baik
- Buat fungsi terpisah untuk logika game
        ''',
        difficulty: 'Menengah',
        icon: '🎮',
        estimatedDays: 4,
      ),
      MiniProject(
        id: 'project_4',
        title: 'Aplikasi To-Do List',
        description: 'Aplikasi untuk membuat dan mengelola daftar tugas harian',
        briefContent: '''
Tujuan: Membuat aplikasi To-Do List yang fungsional dan user-friendly

Deskripsi:
Anda akan membuat aplikasi untuk mengelola daftar tugas. Pengguna dapat menambah, menandai selesai, mengedit, dan menghapus tugas. Data akan disimpan dalam file sehingga data tetap ada setelah program ditutup.

Fitur yang Harus Diimplementasikan:
1. Tambah tugas baru dengan deskripsi dan tanggal deadline
2. Lihat semua tugas dengan status (selesai/belum)
3. Tandai tugas sebagai selesai
4. Edit deskripsi tugas
5. Hapus tugas
6. Filter tugas berdasarkan status (semua/aktif/selesai)
7. Urutkan tugas berdasarkan prioritas atau tanggal
8. Simpan dan muat dari file JSON/CSV
9. Tampilkan statistik (total tugas, tugas selesai, tugas tertunda)

Struktur Data:
- Setiap tugas memiliki: ID, deskripsi, deadline, prioritas, status
- Gunakan List of Dictionary untuk menyimpan tasks
- Implementasikan sorting dan filtering

Menu Utama:
1. Lihat Semua Tugas
2. Tambah Tugas
3. Tandai Selesai
4. Edit Tugas
5. Hapus Tugas
6. Lihat Statistik
7. Keluar

Fitur Lanjutan:
- Kategori/tags untuk tugas
- Reminder untuk deadline yang mendekati
- Export to PDF atau printer
- Dark mode

Tips:
- Gunakan datetime module untuk menangani deadline
- Implementasikan persistensi data dengan JSON
- Buat UI yang clean dan intuitif
- Gunakan try-except untuk error handling yang baik
        ''',
        difficulty: 'Menengah Lanjut',
        icon: '✅',
        estimatedDays: 7,
      ),
    ];
  }

  static MiniProject getProjectById(String projectId) {
    return getAllProjects().firstWhere((p) => p.id == projectId);
  }
}
