import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart'; // Pastikan path ini sesuai

class MateriScreen extends StatelessWidget {
  final String materialName;

  // Nah, kata 'required' dihilangkan di sini dan diganti default string kosong
  // Biar kalau dipanggil MateriScreen() doang gak error lagi!
  const MateriScreen({
    super.key,
    this.materialName = '',
  });

  // Data keenam materi dikumpulkan dalam satu List
  final List<Map<String, dynamic>> listMateri = const [
    {
      'nama': 'INTEGER',
      'icon': Icons.calculate_outlined,
      'color': Colors.blueAccent,
      'definisi':
          'Integer adalah tipe data untuk bilangan bulat, yaitu angka tanpa koma, seperti 0, 1, 2, -3, atau -100.',
      'penjelasan':
          'Dalam Python, tipe data Integer (int) dapat memiliki nilai positif maupun negatif. Python bisa menangani angka integer yang sangat besar karena panjang angkanya hanya dibatasi oleh memori komputermu. Tipe data ini sangat sering digunakan untuk perulangan (looping), perhitungan matematika dasar, dan indeks.',
      'contoh_kode': 'umur = 20\ntahun = 2026\nsuhu = -5',
      'poin': [
        'Tidak memiliki komponen desimal.',
        'Bisa bernilai positif atau negatif.',
        'Mendukung operasi aritmatika dasar (+, -, *, /).'
      ]
    },
    {
      'nama': 'FLOAT',
      'icon': Icons.speed_outlined,
      'color': Colors.green,
      'definisi':
          'Float adalah Tipe data untuk bilangan desimal (bilangan pecahan).',
      'penjelasan':
          'Dalam Python, tipe data Float digunakan untuk merepresentasikan angka yang memiliki nilai presisi/pecahan. Float ditulis dengan menggunakan titik (.) sebagai pemisah desimal, bukan koma. Tipe data ini sangat penting untuk perhitungan yang membutuhkan tingkat akurasi tinggi.',
      'contoh_kode': 'berat_badan = 65.5\nphi = 3.14\nnilai_ujian = 87.50',
      'poin': [
        'Menggunakan titik (.) sebagai pemisah desimal.',
        'Bisa ditulis dalam notasi ilmiah (contoh: 2.5e2).',
        'Hasil pembagian tunggal (/) selalu menghasilkan Float.'
      ]
    },
    {
      'nama': 'STRING',
      'icon': Icons.text_fields,
      'color': Colors.orangeAccent,
      'definisi':
          'String adalah tipe data untuk teks atau karakter, ditulis dengan tanda kutip tunggal \' atau ganda ".',
      'penjelasan':
          'String (str) di Python adalah urutan karakter. Kamu bisa memanipulasi string dengan sangat mudah, seperti menggabungkan dua teks, memotong teks, atau mengubahnya jadi huruf kapital. Apapun yang diapit oleh tanda kutip akan dianggap sebagai String.',
      'contoh_kode':
          'nama = "Arpy"\npesan = \'Halo, dunia!\'\nangka_teks = "100"',
      'poin': [
        'Bisa menggunakan tanda kutip tunggal (\') atau ganda (").',
        'Bisa digabungkan menggunakan operator tambah (+).',
        'Bersifat immutable (tidak bisa diubah karakternya satu per satu secara langsung).'
      ]
    },
    {
      'nama': 'BOOLEAN',
      'icon': Icons.check_circle_outline,
      'color': Colors.redAccent,
      'definisi':
          'Boolean adalah Tipe data logika yang hanya memiliki dua nilai: True atau False.',
      'penjelasan':
          'Tipe data Boolean (bool) merepresentasikan kebenaran dari sebuah pernyataan. Di Python, penulisannya wajib diawali dengan huruf kapital. Boolean adalah pondasi utama dalam membuat alur logika program (if-else) dan perulangan (while).',
      'contoh_kode':
          'is_active = True\nis_login = False\nstatus = (10 > 5) # Hasilnya: True',
      'poin': [
        'Hanya memiliki dua nilai: True atau False.',
        'Wajib menggunakan huruf kapital di awal kata.',
        'Sering dihasilkan dari operasi perbandingan (>, <, ==).'
      ]
    },
    {
      'nama': 'SET',
      'icon': Icons.shopping_basket_outlined,
      'color': Colors.teal,
      'definisi':
          'Set adalah Kumpulan data unik (tidak ada duplikat), tidak berurutan, dan tidak bisa diakses melalui indeks.',
      'penjelasan':
          'Set sangat berguna ketika kamu ingin menyimpan banyak data namun memastikan tidak ada data yang kembar. Karena sifatnya yang tidak berurutan, kamu tidak bisa memanggil item di dalam Set menggunakan nomor urut (indeks).',
      'contoh_kode':
          'keranjang = {"apel", "jeruk", "tomat"}\nangka = {1, 2, 2, 3} # Hasil: {1, 2, 3}',
      'poin': [
        'Item di dalamnya selalu unik (tidak kembar).',
        'Tidak memiliki indeks (unordered).',
        'Didefinisikan menggunakan kurung kurawal {}.'
      ]
    },
    {
      'nama': 'DICTIONARY',
      'icon': Icons.menu_book_outlined,
      'color': Colors.deepPurple,
      'definisi':
          'Dictionary Struktur data pasangan key-value (kunci-nilai). Digunakan untuk menyimpan data yang terasosiasi.',
      'penjelasan':
          'Dictionary (dict) mencari nilai (value) menggunakan sebuah kata kunci (key). Data di dalam dictionary ditulis menggunakan kurung kurawal {}, di mana key dan value dipisahkan oleh titik dua (:).',
      'contoh_kode':
          'siswa = {\n  "nama": "John",\n  "umur": 30,\n  "kota": "Jakarta"\n}\nprint(siswa["nama"]) # Output: John',
      'poin': [
        'Menggunakan format key : value.',
        'Key bersifat unik (tidak boleh ada key yang sama).',
        'Sangat efisien untuk pencarian data berukuran besar.'
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryDarkBlue,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Materi Tipe Data',
          style: GoogleFonts.poppins(
            color: AppColors.primaryDarkBlue,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: listMateri.length,
          separatorBuilder: (context, index) => const SizedBox(height: 32),
          itemBuilder: (context, index) {
            return _buildMateriSection(listMateri[index]);
          },
        ),
      ),
    );
  }

  Widget _buildMateriSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: data['color'].withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: data['color'].withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  data['icon'],
                  size: 50,
                  color: data['color'],
                ),
                const SizedBox(height: 8),
                Text(
                  data['nama'],
                  style: GoogleFonts.poppins(
                    color: data['color'],
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: data['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: data['color'].withOpacity(0.5)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.bolt, color: data['color'], size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data['definisi'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarkBlue,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Penjelasan',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDarkBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data['penjelasan'],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.primaryDarkBlue,
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '// Contoh Kode Python',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data['contoh_kode'],
                style: GoogleFonts.sourceCodePro(
                  fontSize: 14,
                  color: Colors.greenAccent,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Poin Penting',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDarkBlue,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(
                (data['poin'] as List).length,
                (index) => _buildPointItem(
                  (data['poin'] as List)[index],
                  data['color'],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPointItem(String text, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Icon(Icons.circle, size: 8, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.primaryDarkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
