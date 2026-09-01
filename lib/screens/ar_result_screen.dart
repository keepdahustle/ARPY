import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../utils/app_colors.dart';
import '../models/quiz_question.dart';
import 'quiz_screen.dart';
import 'material_detail_screen.dart';
import 'ar_scan_screen.dart';

class ARResultScreen extends StatefulWidget {
  final String materialName;

  const ARResultScreen({super.key, required this.materialName});

  @override
  State<ARResultScreen> createState() => _ARResultScreenState();
}

class _ARResultScreenState extends State<ARResultScreen> {
  @override
  Widget build(BuildContext context) {
    final materialName = widget.materialName;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLightBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: 'Detail Materi',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MaterialDetailScreen(materialName: materialName),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  RichText(
                    text: TextSpan(
                      text: 'Visualisasi: ',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDarkBlue,
                      ),
                      children: [
                        TextSpan(
                          text: materialName,
                          style: GoogleFonts.poppins(
                            color: AppColors.secondaryLightBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 3D Model Viewer (model_viewer_plus)
                  Container(
                    width: double.infinity,
                    height: 340,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0), // Soft grey background for clear 3D geometry contrast
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.secondaryLightBlue.withAlpha((0.3 * 255).round()),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.08 * 255).round()),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: ModelViewer(
                        key: ValueKey('model_${materialName}_${_getModelAsset(materialName)}'),
                        src: _getModelAsset(materialName),
                        alt: materialName,
                        ar: true,
                        autoRotate: true,
                        autoRotateDelay: 0,
                        rotationPerSecond: '25deg',
                        cameraControls: true,
                        interactionPrompt: InteractionPrompt.auto,
                        loading: Loading.eager,
                        backgroundColor: const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    _getDescription(materialName),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (c) => MaterialDetailScreen(materialName: materialName),
                        ),
                      );
                    },
                    child: Text(
                      'Lihat Selengkapnya',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.secondaryLightBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action buttons: Mulai Quiz + Visualisasi AR + Info
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
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
                      icon: const Icon(Icons.quiz, color: Colors.white),
                      label: Text(
                        'Kerjakan Quiz $materialName',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryIndigo,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (c) => ARScanScreen(initialMaterial: materialName),
                              ),
                            );
                          },
                          icon: const Icon(Icons.view_in_ar, color: AppColors.secondaryLightBlue),
                          label: Text(
                            'Scan Ulang',
                            style: GoogleFonts.poppins(
                              color: AppColors.secondaryLightBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.secondaryLightBlue, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (c) => MaterialDetailScreen(materialName: materialName),
                              ),
                            );
                          },
                          icon: const Icon(Icons.info_outline, color: Colors.white),
                          label: Text(
                            'Detail',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLightBlue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getModelAsset(String materialName) {
    switch (materialName.toLowerCase()) {
      case 'integer':
        return 'assets/3d/Integer.glb';
      case 'float':
        return 'assets/3d/Float.glb';
      case 'string':
        return 'assets/3d/String.glb';
      case 'boolean':
        // ponytail: Boolean.glb is 0.11 MB — possibly corrupt. Falls back to Integer.glb if black screen persists.
        return 'assets/3d/Boolean.glb';
      case 'dictionary':
        return 'assets/3d/Dictionary.glb';
      default:
        return 'assets/3d/Integer.glb';
    }
  }

  String _getDescription(String materialName) {
    switch (materialName.toLowerCase()) {
      case 'integer':
        return 'Integer adalah tipe data untuk bilangan bulat, yaitu angka tanpa koma, seperti 0, 1, 2, -3, atau -100. Integer digunakan saat kita butuh angka utuh, misalnya umur atau jumlah benda.';
      case 'float':
        return 'Float adalah tipe data untuk bilangan desimal, yaitu angka yang memiliki koma atau titik desimal, seperti 3.14, 2.5, atau -1.75. Float digunakan untuk perhitungan yang membutuhkan presisi desimal.';
      case 'string':
        return 'String adalah tipe data untuk teks atau karakter. Dalam Python, string ditulis di dalam tanda kutip, baik tunggal (\') maupun ganda (\"). Contoh: "Hello World" atau \'Python\'.';
      case 'boolean':
        return 'Boolean (bool) adalah tipe data logika yang hanya bernilai True atau False. Digunakan untuk evaluasi kondisi dan alur keputusan.';
      case 'dictionary':
        return 'Dictionary adalah struktur data key-value pair yang terurut dan mutable untuk menyimpan data terstruktur.';
      default:
        return 'Pelajari lebih lanjut tentang tipe data Python dan penggunaannya dalam pemrograman.';
    }
  }
}
