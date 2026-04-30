import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
// import '../widgets/modern_dialog.dart';
import 'ar_scan_screen.dart';
import 'quiz_materials_screen.dart';
// import '../models/quiz_question.dart';

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
                            builder: (c) => const ARScanScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.view_in_ar, color: Colors.white),
                      label: Text(
                        'Lihat Visualisasi Materi',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
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
                        // Open quiz materials list (user should pick which material to take)
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (c) => const QuizMaterialsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.quiz, color: AppColors.primaryLightBlue),
                      label: Text(
                        'Lihat Quiz Terkait',
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryLightBlue,
                          fontWeight: FontWeight.w600,
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
        return """Integer adalah tipe data untuk bilangan bulat, yaitu angka tanpa koma, seperti 0, 1, 2, -3, atau -100. Integer digunakan saat kita butuh angka utuh, misalnya menghitung jumlah barang, umur, atau skor permainan. Dengan integer, kita bisa melakukan operasi seperti tambah, kurang, kali, bagi bulat, dan sisa bagi.

Misalnya, jika nilai Matematika adalah 80, Bahasa Indonesia 75, dan IPA 85, kita bisa menjumlahkan nilai-nilai tersebut untuk mendapatkan total. Python memudahkan kita melakukan operasi dengan integer seperti ini.

Dengan menggunakan integer, kita bisa dengan mudah melakukan perhitungan seperti ini dalam program.""";
      default:
        return 'Deskripsi lengkap mengenai materi akan ditampilkan di sini.';
    }
  }

  String _getCodeExample(String material) {
    switch (material.toLowerCase()) {
      case 'integer':
        return """# Mendeklarasikan nilai-nilai ujian
nilai_matematika = 80
nilai_bahasa_indonesia = 75
nilai_ipa = 85

# Menjumlahkan semua nilai
total_nilai = nilai_matematika + nilai_bahasa_indonesia + nilai_ipa

# Menampilkan total nilai
print("Total nilai ujian:", total_nilai)

# Dengan menggunakan integer, kita bisa dengan mudah melakukan perhitungan seperti ini dalam program.""";
      default:
        return """# Contoh kode akan muncul di sini""";
    }
  }
}
