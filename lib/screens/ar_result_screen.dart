import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../utils/app_colors.dart';
//import '../models/quiz_question.dart';
//import 'quiz_screen.dart';
import 'material_detail_screen.dart';
import 'ar_scan_screen.dart';

class ARResultScreen extends StatefulWidget {
  final String materialName;

  const ARResultScreen({super.key, required this.materialName});

  @override
  State<ARResultScreen> createState() => _ARResultScreenState();
}

class _ARResultScreenState extends State<ARResultScreen> {
  double _rotation = 0.0; // degrees for camera orbit

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
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
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
                    height: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha((0.12 * 255).round()),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ModelViewer(
                        src: _getModelAsset(materialName),
                        alt: materialName,
                        ar: true,
                        autoRotate: false,
                        cameraControls: true,
                        // cameraOrbit expects something like "0deg 75deg 90deg"
                        cameraOrbit: '0deg 75deg ${_rotation}deg',
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  // Rotation slider
                  Row(
                    children: [
                      const Icon(Icons.rotate_right, color: Colors.grey),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: 360,
                          divisions: 36,
                          value: _rotation,
                          onChanged: (v) => setState(() => _rotation = v),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    _getDescription(materialName),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
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

                  // Action buttons: Visualisasi AR + Info
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Open Scan AR (camera) to view material in AR
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (c) => const ARScanScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.view_in_ar, color: Colors.white),
                          label: Text(
                            'Lihat Visualisasi AR',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryLightBlue,
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
                            'Info',
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
      case 'set':
        return 'Set adalah tipe data koleksi yang tidak berurut dan tidak mengizinkan duplikasi. Set digunakan untuk menyimpan beberapa item unik dalam satu variabel.';
      default:
        return 'Pelajari lebih lanjut tentang tipe data Python dan penggunaannya dalam pemrograman.';
    }
  }
}
