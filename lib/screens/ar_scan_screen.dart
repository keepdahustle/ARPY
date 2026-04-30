import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
// native intent removed — ARCore removed from the app
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/app_colors.dart';
import '../widgets/modern_dialog.dart';
import 'ar_result_screen.dart';

class ARScanScreen extends StatefulWidget {
  const ARScanScreen({super.key});

  @override
  State<ARScanScreen> createState() => _ARScanScreenState();
}

class _ARScanScreenState extends State<ARScanScreen> {
  bool _isCardDetected = false;

  // Camera controller for live preview
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    // Listen for native augmented-image detection events forwarded
    // from Android `MainActivity` via MethodChannel.
    const channel = MethodChannel('arpy/native_events');
    channel.setMethodCallHandler((call) async {
      if (call.method == 'augmentedImageDetected') {
        final args = call.arguments;
        bool detected = true;
        if (args is Map && args.containsKey('detected')) {
          detected = args['detected'] == true;
        }
        if (mounted) {
          setState(() {
            _isCardDetected = detected;
          });
        }
      }
    });
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ModernDialog.showSnack(context, 'Izin kamera dibutuhkan untuk fitur AR.');
      }
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception('No camera available');
      
      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController?.initialize();
      
      // Start image stream for AR detection
      if (mounted && _cameraController != null) {
        await _cameraController!.startImageStream(_processImage);
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ModernDialog.showSnack(context, 'Gagal mengakses kamera: ${e.toString()}');
      }
    }
  }

  void _startDetectionSimulation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_isCardDetected) {
        setState(() {
          _isCardDetected = true;
        });
      }
    });
  }

  Future<void> _processImage(CameraImage image) async {
    // TODO: Integrate ARCore image tracking here
    // For now, detection is simulated
    // This will process the camera frame to detect CardInteger.png
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            // Detection indicator banner (green when card detected)
            if (_isCardDetected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50), // Green for detected state
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Kartu AR Terdeteksi!',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFC107), // Amber for scanning state
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primaryDarkBlue),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Mencari Kartu AR...',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDarkBlue,
                      ),
                    ),
                  ],
                ),
              ),
            
            // Camera preview area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Live camera preview
                        if (_isCameraInitialized && _cameraController != null)
                          CameraPreview(_cameraController!)
                        else
                          Container(
                            color: Colors.black,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.camera_alt,
                                    size: 80,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Menginisialisasi Kamera...',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Flash button (top-right)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: FloatingActionButton(
                            mini: true,
                            heroTag: 'flash_fab',
                            onPressed: () async {
                              if (_cameraController == null || !_isCameraInitialized) {
                                ModernDialog.showSnack(context, 'Kamera belum siap');
                                return;
                              }

                              try {
                                if (_isFlashOn) {
                                  await _cameraController?.setFlashMode(FlashMode.off);
                                } else {
                                  await _cameraController?.setFlashMode(FlashMode.torch);
                                }

                                setState(() {
                                  _isFlashOn = !_isFlashOn;
                                });
                              } catch (e) {
                                ModernDialog.showSnack(context, 'Gagal mengubah flash: ${e.toString()}');
                              }
                            },
                            backgroundColor: _isFlashOn
                              ? Colors.amber.withAlpha((0.9 * 255).round())
                              : Colors.white.withAlpha((0.8 * 255).round()),
                            child: Icon(
                              _isFlashOn ? Icons.flash_on : Icons.flash_off,
                              color: _isFlashOn ? Colors.white : AppColors.primaryDarkBlue,
                            ),
                          ),
                        ),

                        // Help button (bottom-left)
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: FloatingActionButton(
                            mini: true,
                            heroTag: 'help_fab',
                            onPressed: () => _showHelpDialog(context),
                            backgroundColor: Colors.white.withAlpha((0.8 * 255).round()),
                            child: const Icon(
                              Icons.help_outline,
                              color: AppColors.primaryDarkBlue,
                            ),
                          ),
                        ),

                        // Close button (bottom-right)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            mini: true,
                            heroTag: 'close_fab',
                            onPressed: () => Navigator.of(context).pop(),
                            backgroundColor: Colors.white.withAlpha((0.8 * 255).round()),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.primaryDarkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Bottom panel
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isCardDetected ? () => _navigateToResult() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCardDetected 
                        ? AppColors.secondaryLightBlue 
                        : AppColors.lightGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Pelajari Materi',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _navigateToResult() {
    // ARCore removed — navigate to Flutter AR result page (camera + model viewer)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ARResultScreen(materialName: 'Integer'),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    ModernDialog.showConfirm(
      context,
      title: 'Panduan Scanning',
      message: 'Arahkan kamera ke kartu AR dan pastikan pencahayaan cukup. Kartu akan terdeteksi secara otomatis.',
      confirmLabel: 'Mengerti',
      cancelLabel: 'Tutup',
      onConfirm: () {},
    );
  }
}
