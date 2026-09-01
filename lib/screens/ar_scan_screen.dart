import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../utils/app_colors.dart';
import '../widgets/modern_dialog.dart';
import 'ar_result_screen.dart';

// AR Kartu marker - daftar materi yang tersedia
const List<Map<String, String>> _kMaterials = [
  {'id': 'Integer', 'card': 'assets/ARCard/ARCardInteger.png', 'color': '0xFF3B5BDB'},
  {'id': 'Float', 'card': 'assets/ARCard/ARCardFloat.png', 'color': '0xFF2F9E44'},
  {'id': 'String', 'card': 'assets/ARCard/ARCardString.png', 'color': '0xFFE8590C'},
  {'id': 'Boolean', 'card': 'assets/ARCard/ARCardBoolean.png', 'color': '0xFFE03131'},
  {'id': 'Dictionary', 'card': 'assets/ARCard/ARCardDictionary.png', 'color': '0xFF7048E8'},
];

class ARScanScreen extends StatefulWidget {
  final String? initialMaterial;
  const ARScanScreen({super.key, this.initialMaterial});

  @override
  State<ARScanScreen> createState() => _ARScanScreenState();
}

class _ARScanScreenState extends State<ARScanScreen> {
  // === Detection State ===
  // Pending = user belum pilih/scan kartu. Scanning = pilih kartu, kamera cari konfirmasi.
  // Detected = kartu terkonfirmasi dari camera frame analysis
  String? _selectedMaterialId;   // kartu yang user pilih untuk di-scan
  bool _isConfirmed = false;      // true HANYA setelah frame camera terkonfirmasi cocok
  bool _isProcessingFrame = false;
  int _frameHits = 0;             // frame berturut yang cocok
  static const int _requiredHits = 8; // butuh 8 frame stabil sebelum konfirmasi

  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    // Terima event dari native ARCore jika tersedia
    const channel = MethodChannel('arpy/native_events');
    channel.setMethodCallHandler((call) async {
      if (call.method == 'augmentedImageDetected' && mounted) {
        final args = call.arguments;
        if (args is Map) {
          final name = args['name']?.toString();
          final detected = args['detected'] == true;
          if (detected && name != null && name.isNotEmpty) {
            setState(() {
              _selectedMaterialId = name;
              _isConfirmed = true;
            });
          } else if (!detected) {
            setState(() => _isConfirmed = false);
          }
        }
      }
    });
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) ModernDialog.showSnack(context, 'Izin kamera diperlukan untuk fitur AR.');
      return;
    }
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(back, ResolutionPreset.high, enableAudio: false);
      await _cameraController!.initialize();
      if (mounted) {
        await _cameraController!.startImageStream(_processFrame);
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      if (mounted) ModernDialog.showSnack(context, 'Kamera gagal: ${e.toString()}');
    }
  }

  // Analisis frame: cari pola kontras tinggi (kartu dicetak) di area tengah frame
  Future<void> _processFrame(CameraImage image) async {
    if (_isProcessingFrame || !mounted) return;
    if (_selectedMaterialId == null) {
      // Belum ada kartu dipilih, tidak ada yang di-scan
      return;
    }
    _isProcessingFrame = true;

    try {
      final y = image.planes[0].bytes;
      final int w = image.width;
      final int h = image.height;

      // Hanya analisa area tengah (40% lebar, 50% tinggi) = area reticle
      final int x0 = (w * 0.30).round();
      final int x1 = (w * 0.70).round();
      final int y0 = (h * 0.25).round();
      final int y1 = (h * 0.75).round();

      int sum = 0;
      int edgeCount = 0;
      int samples = 0;
      int prevPx = -1;

      for (int row = y0; row < y1; row += 4) {
        for (int col = x0; col < x1; col += 4) {
          final px = y[row * w + col];
          sum += px;
          samples++;
          if (prevPx >= 0 && (px - prevPx).abs() > 40) edgeCount++;
          prevPx = px;
        }
      }

      if (samples == 0) { _isProcessingFrame = false; return; }

      final double avgLuma = sum / samples;
      final double edgeDensity = edgeCount / samples;

      // Kartu cetak memiliki:
      //  - Kecerahan sedang-tinggi (ruangan cukup terang, 80-210)
      //  - Kerapatan tepi tinggi (banyak teks dan border kartu)
      final bool cardVisible = avgLuma > 80 && avgLuma < 210 && edgeDensity > 0.22;

      if (cardVisible) {
        _frameHits++;
        if (_frameHits >= _requiredHits && !_isConfirmed && mounted) {
          setState(() => _isConfirmed = true);
        }
      } else {
        _frameHits = 0;
        if (_isConfirmed && mounted) {
          setState(() => _isConfirmed = false);
        }
      }
    } catch (_) {
    } finally {
      _isProcessingFrame = false;
    }
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    super.dispose();
  }

  void _selectMaterial(String id) {
    setState(() {
      _selectedMaterialId = id;
      _isConfirmed = false;
      _frameHits = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // === Live Camera ===
            if (_isCameraInitialized && _cameraController != null)
              SizedBox.expand(child: CameraPreview(_cameraController!))
            else
              const Center(child: CircularProgressIndicator(color: Colors.white)),

            // === Center Reticle ===
            Center(
              child: Container(
                width: 270,
                height: 360,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isConfirmed
                        ? const Color(0xFF4CAF50)
                        : _selectedMaterialId != null
                            ? Colors.amber
                            : AppColors.secondaryLightBlue,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _isConfirmed && _selectedMaterialId != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: ModelViewer(
                          key: ValueKey('lock_$_selectedMaterialId'),
                          src: 'assets/3d/$_selectedMaterialId.glb',
                          alt: _selectedMaterialId!,
                          ar: false,
                          autoRotate: true,
                          autoRotateDelay: 0,
                          rotationPerSecond: '30deg',
                          cameraControls: true,
                          loading: Loading.eager,
                          backgroundColor: const Color(0xCC000000),
                        ),
                      )
                    : _selectedMaterialId != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Arahkan kartu $_selectedMaterialId\nke dalam bingkai ini',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.qr_code_scanner, color: Colors.white38, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                'Pilih kartu AR di bawah\nlalu arahkan ke kamera',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.white38,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
              ),
            ),

            // === Top Status Banner ===
            Positioned(
              top: 16,
              left: 72,
              right: 72,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: _isConfirmed
                      ? const Color(0xFF4CAF50)
                      : Colors.black.withAlpha((0.7 * 255).round()),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  _isConfirmed
                      ? '✓ Kartu $_selectedMaterialId Terdeteksi!'
                      : _selectedMaterialId != null
                          ? 'Mencari kartu $_selectedMaterialId...'
                          : 'Pilih kartu AR terlebih dahulu',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // === Back Button ===
            Positioned(
              top: 10,
              left: 12,
              child: FloatingActionButton(
                mini: true,
                heroTag: 'back_btn',
                backgroundColor: Colors.white.withAlpha((0.85 * 255).round()),
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: AppColors.primaryDarkBlue),
              ),
            ),

            // === Flash Toggle ===
            Positioned(
              top: 10,
              right: 12,
              child: FloatingActionButton(
                mini: true,
                heroTag: 'flash_btn',
                backgroundColor: _isFlashOn
                    ? Colors.amber.withAlpha((0.9 * 255).round())
                    : Colors.white.withAlpha((0.85 * 255).round()),
                onPressed: () async {
                  if (_cameraController == null || !_isCameraInitialized) return;
                  try {
                    await _cameraController!.setFlashMode(
                        _isFlashOn ? FlashMode.off : FlashMode.torch);
                    setState(() => _isFlashOn = !_isFlashOn);
                  } catch (_) {}
                },
                child: Icon(
                  _isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: _isFlashOn ? Colors.white : AppColors.primaryDarkBlue,
                ),
              ),
            ),

            // === Card Selector Row ===
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _kMaterials.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final m = _kMaterials[i];
                    final isSelected = _selectedMaterialId == m['id'];
                    return GestureDetector(
                      onTap: () => _selectMaterial(m['id']!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : Colors.black.withAlpha((0.6 * 255).round()),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryDarkBlue : Colors.white24,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              m['id']!,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.primaryDarkBlue : Colors.white,
                              ),
                            ),
                            Text(
                              'AR Card',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: isSelected ? AppColors.textMedium : Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // === Action Button ===
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isConfirmed && _selectedMaterialId != null
                      ? () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ARResultScreen(materialName: _selectedMaterialId!),
                          ))
                      : null,
                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                  label: Text(
                    _isConfirmed
                        ? 'Buka Materi $_selectedMaterialId'
                        : _selectedMaterialId != null
                            ? 'Mencari kartu...'
                            : 'Pilih kartu AR',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isConfirmed
                        ? AppColors.secondaryLightBlue
                        : Colors.grey.withAlpha((0.5 * 255).round()),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: _isConfirmed ? 6 : 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
