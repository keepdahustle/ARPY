import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import 'ar_scan_screen.dart';
import 'quiz_screen.dart';
import '../models/quiz_question.dart';

class MaterialDetailScreen extends StatelessWidget {
  final String materialName;

  const MaterialDetailScreen({super.key, required this.materialName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLightBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Detail Materi',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              materialName,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDarkBlue,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _getLongDescription(materialName),
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Contoh Kode (Python)',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDarkBlue,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                _getCodeExample(materialName),
                style: const TextStyle(
                  color: Color(0xFFEEFBFF),
                  fontFamily: 'monospace',
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Open Scan AR (camera) to visualize the material
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (c) => ARScanScreen(initialMaterial: materialName),
                          ),
                        );
                      },
                      icon: const Icon(Icons.view_in_ar, color: Colors.white),
                      label: Text(
                        'Visualisasi AR',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryLightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final all = QuizDataManager.getAllMaterials();
                        final match = all.firstWhere(
                          (m) => m.name.toLowerCase() == materialName.toLowerCase() || m.id.toLowerCase() == materialName.toLowerCase(),
                          orElse: () => all.first,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (c) => QuizScreen(material: match),
                          ),
                        );
                      },
                      icon: const Icon(Icons.quiz, color: AppColors.primaryLightBlue),
                      label: Text(
                        'Mulai Quiz',
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryLightBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryLightBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLongDescription(String material) {
    switch (material.toLowerCase()) {
      case 'integer':
        return """📌 APA ITU INTEGER (int)?
Integer adalah tipe data dasar dalam Python yang merepresentasikan bilangan bulat tanpa komponen pecahan atau desimal. Integer mencakup bilangan positif, negatif, dan nol (contoh: -100, -1, 0, 42, 1000).

💡 ANALOGI DUNIA NYATA:
Bayangkan "Jumlah Siswa di Kelas" atau "Jumlah Kursi di Bioskop". Anda tidak mungkin menghitung ada 25.5 siswa atau membeli 3.2 tiket kursi. Jumlahnya selalu utuh (diskrit). Begitulah integer bekerja dalam memori komputer.

⚙️ KARAKTERISTIK PENTING DALAM PYTHON:
1. Arbitrary Precision (Ukuran Tak Terbatas): Tidak seperti bahasa C/Java yang membatasi integer pada 32-bit atau 64-bit, Python mengalokasikan memori secara dinamis sehingga Anda bisa menghitung angka hingga ratusan digit tanpa overflow!
2. Operasi Aritmatika Lengkap:
   • Penjumlahan (+), Pengurangan (-), Perkalian (*)
   • Pembagian Bulat / Floor Division (//) menghasilkan int
   • Modulo / Sisa Bagi (%) sangat berguna untuk cek angka ganjil/genap
   • Perpangkatan (**)""";

      case 'float':
        return """📌 APA ITU FLOAT (Floating Point)?
Float adalah tipe data numerik yang digunakan untuk menyimpan bilangan pecahan atau angka dengan titik desimal. Float mengikuti standar internasional IEEE 754 untuk representasi angka real.

💡 ANALOGI DUNIA NYATA:
Bayangkan "Timbangan Berat Badan" atau "Harga Bensin per Liter". Berat badan Anda bisa 64.75 kg, dan suhu tubuh 36.6°C. Angka-angka ini membutuhkan tingkat presisi desimal untuk memberikan nilai akurat yang tidak bisa diwakili oleh integer utuh.

⚙️ KARAKTERISTIK PENTING DALAM PYTHON:
1. Pembagian Standar Selalu Menghasilkan Float: Di Python 3, operasi `10 / 2` menghasilkan `5.0` (float), bukan `5` (int).
2. Notasi Ilmiah (Scientific E-Notation): Anda dapat menulis angka sangat besar atau sangat kecil dengan mudah, misalnya `1.5e6` (1.500.000.0) atau `2e-3` (0.002).
3. Presisi & Pembulatan: Karena representasi biner pecahan, pembulatan desimal sering kali menggunakan fungsi bawaan `round(nilai, digit)` atau string formatting `f"{nilai:.2f}"`.""";

      case 'string':
        return """📌 APA ITU STRING (str)?
String adalah urutan berurutan (sequence) dari karakter alfanumerik dan simbol yang diapit tanda petik satu ('...'), tanda petik dua ("..."), atau triple quotes ('''...''' / \"\"\"...\"\"\") untuk teks multi-baris.

💡 ANALOGI DUNIA NYATA:
Bayangkan "Kartu Nama" atau "Rangkaian Manik-Manik Berhuruf". Setiap huruf terangkai pada posisi (indeks) tertentu yang tidak boleh tertukar agar maknanya tetap sama.

⚙️ KARAKTERISTIK PENTING DALAM PYTHON:
1. Immutability (Tidak Dapat Diubah Langsung): Setelah string dibuat di memori, Anda tidak bisa mengubah satu karakter langsung (misal: `teks[0] = 'A'` akan Error). Anda harus membuat string baru.
2. Indexing & Slicing (Pemotongan):
   • Indeks maju mulai dari `0`, indeks mundur mulai dari `-1` (karakter terakhir).
   • Slicing `[start:stop:step]` untuk mengambil potongan kalimat.
3. F-Strings (Formatted String Literals): Fitur modern Python untuk menyisipkan variabel langsung ke dalam teks dengan sintaks `f"Halo {nama}"`.""";

      case 'boolean':
        return """📌 APA ITU BOOLEAN (bool)?
Boolean adalah tipe data logika yang hanya memiliki dua kemungkinan nilai: `True` (Benar) atau `False` (Salah). Tipe data ini merupakan fondasi dari seluruh sistem pengambilan keputusan logika di komputer.

💡 ANALOGI DUNIA NYATA:
Bayangkan "Saklar Lampu" atau "Pintu Sensor Otomatis". Saklar hanya punya dua posisi: ON (True) atau OFF (False). Pintu hanya akan terbuka JIKA sensor mendeteksi orang (True).

⚙️ KARAKTERISTIK PENTING DALAM PYTHON:
1. Truthy & Falsy Values: Dalam Python, nilai nol (`0`, `0.0`), string kosong `""`, list/set/dict kosong dianggap bernilai `False` (Falsy). Sedangkan angka selain 0 dan teks berisi dianggap `True` (Truthy).
2. Operator Logika:
   • `and` : Bernilai True HANYA JIKA kedua kondisi True.
   • `or`  : Bernilai True jika SALAH SATU kondisi True.
   • `not` : Membalikkan nilai logika (not True -> False).
3. Percabangan `if-elif-else`: Mengontrol arah jalan program berdasarkan kondisi boolean.""";

      case 'dictionary':
        return """📌 APA ITU DICTIONARY (dict)?
Dictionary adalah struktur data berbasis pemetaan Pasangan Kunci-Nilai (*Key-Value Pairs*). Kunci (Key) harus bersifat unik dan immutable (biasanya string atau int), sedangkan Nilai (Value) dapat berupa tipe data apa saja.

💡 ANALOGI DUNIA NYATA:
Bayangkan "Kamus Bahasa" atau "Buku Kontak Telepon". Ketika Anda ingin mencari nomor telepon teman, Anda mencari berdasarkan "Nama" (Key), lalu mendapatkan "Nomor Telepon" (Value) miliknya.

⚙️ KARAKTERISTIK PENTING DALAM PYTHON:
1. Akses Berdasarkan Kunci (Key-Based Lookup): Anda tidak perlu mencari dengan nomor urut indeks 0, 1, 2, melainkan langsung menyebut kata kuncinya `data['nama']`.
2. Mutable (Dapat Diubah & Fleksibel): Anda bisa menambah key baru, mengupdate value yang ada, atau menghapus item kapan saja.
3. Standar Representasi Data Modern: Format dictionary Python sangat mirip dengan format JSON yang dipakai oleh API web dan sistem mobile modern di seluruh dunia.""";

      default:
        return 'Pelajari konsep dan implementasi materi Python ini dengan pemaparan interaktif dan analogi mendalam.';
    }
  }

  String _getCodeExample(String material) {
    switch (material.toLowerCase()) {
      case 'integer':
        return """# === 1. DEKLARASI & OPERASI DASAR INTEGER ===
harga_buku = 45000       # Bilangan bulat positif
stok_awal = 100
barang_terjual = 35

# Operasi pengurangan & perkalian
sisa_stok = stok_awal - barang_terjual
total_pendapatan = barang_terjual * harga_buku

print(f"Sisa stok buku: {sisa_stok} unit")
print(f"Total uang masuk: Rp {total_pendapatan:,}")

# === 2. PEMBAGIAN BULAT (//) VS SISA BAGI (%) ===
total_permen = 23
jumlah_anak = 5

permen_per_anak = total_permen // jumlah_anak   # Hasil: 4
sisa_permen = total_permen % jumlah_anak        # Hasil: 3

print(f"Masing-masing anak dapat: {permen_per_anak}")
print(f"Sisa di dalam toples: {sisa_permen}")

# === 3. CEK GANJIL / GENAP DENGAN MODULO ===
angka = 42
if angka % 2 == 0:
    print(f"{angka} adalah bilangan GENAP")""";

      case 'float':
        return """# === 1. PERHITUNGAN PRESISI DESIMAL ===
nilai_tugas = 85.5
nilai_uts = 78.0
nilai_uas = 92.25

# Pembagian (/) selalu menghasilkan float
rata_rata = (nilai_tugas + nilai_uts + nilai_uas) / 3

print(f"Rata-rata mentah: {rata_rata}")
# Format pembulatan 2 digit desimal
print(f"Nilai akhir rapor: {rata_rata:.2f}")

# === 2. PERHITUNGAN RUMUS FISIKA / MATEMATIKA ===
pi = 3.14159265
jari_jari = 7.5

luas_lingkaran = pi * (jari_jari ** 2)
keliling = 2 * pi * jari_jari

print(f"Luas lingkaran: {luas_lingkaran:.3f} cm²")
print(f"Keliling lingkaran: {keliling:.3f} cm")

# === 3. NOTASI ILMIAH (SCIENTIFIC E) ===
kecepatan_cahaya = 3e8   # 3 * 10^8 m/s (300,000,000.0)
massa_elektron = 9.11e-31 # 9.11 * 10^-31 kg
print("Kecepatan cahaya (m/s):", kecepatan_cahaya)""";

      case 'string':
        return """# === 1. MANIPULASI & METHOD STRING ===
nama_lengkap = "  albert einstein  "
# Membersihkan spasi (strip) & format Title Case
nama_rapi = nama_lengkap.strip().title()

pesan = f"Peneliti: {nama_rapi}"
print(pesan)                    # Peneliti: Albert Einstein
print("Huruf Kapital:", nama_rapi.upper())
print("Jumlah Karakter:", len(nama_rapi))

# === 2. INDEXING & SLICING (PEMOTONGAN) ===
kode_produk = "PYTHON-AR-2026-X"

bahasa = kode_produk[0:6]        # Ambil indeks 0 sampai 5 -> 'PYTHON'
fitur = kode_produk[7:9]         # Ambil indeks 7 sampai 8 -> 'AR'
tahun = kode_produk[10:14]       # Ambil indeks 10 sampai 13 -> '2026'
karakter_terakhir = kode_produk[-1] # Indeks negatif -> 'X'

print(f"Kategori: {bahasa} | Modul: {fitur} | Tahun: {tahun}")

# === 3. PENCARIAN & PENGGANTIAN TEKS ===
kalimat = "Belajar Python itu sulit"
kalimat_baru = kalimat.replace("sulit", "sangat menyenangkan & interaktif!")
print("Update:", kalimat_baru)""";

      case 'boolean':
        return """# === 1. OPERATOR PERBANDINGAN LOGIKA ===
umur_pengguna = 17
punya_kartu_identitas = True
kuota_tersedia = 5

# Evaluasi menghasilkan Boolean (True / False)
boleh_mendaftar = (umur_pengguna >= 17) and punya_kartu_identitas
print("Status Syarat Daftar:", boleh_mendaftar)  # True

# === 2. PERCABANGAN KONDISIONAL (IF - ELIF - ELSE) ===
skor_quiz = 85

if skor_quiz >= 90:
    predikat = "Sangat Baik (A)"
    lulus = True
elif skor_quiz >= 75:
    predikat = "Baik (B)"
    lulus = True
else:
    predikat = "Perlu Remedial (C)"
    lulus = False

print(f"Hasil Evaluasi: {predikat} | Lulus: {lulus}")

# === 3. KONSEP TRUTHY & FALSY ===
keranjang_belanja = []  # List kosong dianggap False

if not keranjang_belanja:
    print("Keranjang Anda masih kosong, yuk belanja!")""";

      case 'dictionary':
        return """# === 1. MEMBUAT & MENGAKSES STRUKTUR DATA USER ===
profil_siswa = {
    "user_id": "ARPY_007",
    "nama": "Sarah Coder",
    "level": 2,
    "points": 240,
    "materi_selesai": ["Integer", "Float", "String"],
    "is_active": True
}

# Mengakses nilai dengan Key
print("Nama Siswa:", profil_siswa["nama"])
print("Poin Saat Ini:", profil_siswa.get("points"))

# === 2. MENAMBAH & MENGUPDATE DATA ===
# Tambah poin setelah selesai quiz
profil_siswa["points"] += 15
# Tambah materi baru ke dalam list
profil_siswa["materi_selesai"].append("Boolean")
# Tambah Key baru (sekolah)
profil_siswa["sekolah"] = "SMK Informatika"

print(f"Poin Baru: {profil_siswa['points']}")
print("Daftar Selesai:", profil_siswa["materi_selesai"])

# === 3. ITERASI KEY & VALUE DI DICTIONARY ===
print("\\n--- Ringkasan Akun Siswa ---")
for kunci, nilai in profil_siswa.items():
    print(f"• {kunci.upper()}: {nilai}")""";

      default:
        return """# Contoh kode Python Dasar
print("Selamat datang di pembelajaran Python ARPY!")""";
    }
  }
}
