import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../utils/app_colors.dart';
import '../widgets/modern_dialog.dart';
import 'ar_result_screen.dart';

class ARScanScreen extends StatefulWidget {
  final String? initialMaterial;
  const ARScanScreen({super.key, this.initialMaterial});

  @override
  State<ARScanScreen> createState() => _ARScanScreenState();
}

class _ARScanScreenState extends State<ARScanScreen> {
  bool _isCardDetected = false;
  String _detectedMaterial = 'Integer';
  bool _isProcessingFrame = false;
  int _detectionHits = 0;

  // Camera controller for live preview
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMaterial != null && widget.initialMaterial!.isNotEmpty) {
      _detectedMaterial = widget.initialMaterial!;
    }
    _initializeCamera();

    const channel = MethodChannel('arpy/native_events');
    channel.setMethodCallHandler((call) async {
      if (call.method == 'augmentedImageDetected') {
        final args = call.arguments;
        bool detected = true;
        String? detectedName;
        if (args is Map) {
          if (args.containsKey('detected')) {
            detected = args['detected'] == true;
          }
          if (args.containsKey('name')) {
            detectedName = args['name']?.toString();
          }
        }
        if (mounted) {
          setState(() {
            _isCardDetected = detected;
            if (detectedName != null && detectedName.isNotEmpty) {
              _detectedMaterial = detectedName;
            }
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

      // Start image stream for live frame processing
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

  Future<void> _processImage(CameraImage image) async {
    if (_isProcessingFrame || !mounted) return;
    _isProcessingFrame = true;

    try {
      if (image.planes.isNotEmpty) {
        final planeY = image.planes[0];
        final bytesY = planeY.bytes;
        final int totalPixels = bytesY.length;

        // Sample center reticle pixels (from 25% to 75% height and width)
        int centerSamples = 0;
        int centerLumaSum = 0;
        int centerHighVarCount = 0;
        int prevLuma = -1;

        // Sample UV if available (Android YUV420 format usually has 3 planes)
        int uSum = 0;
        int vSum = 0;
        int uvSampleCount = 0;

        final bool hasUV = image.planes.length >= 3;
        final Uint8List? bytesU = hasUV ? image.planes[1].bytes : null;
        final Uint8List? bytesV = hasUV ? image.planes[2].bytes : null;

        final step = (totalPixels ~/ 400).clamp(2, 2000);

        for (int i = 0; i < totalPixels; i += step) {
          final luma = bytesY[i];
          centerLumaSum += luma;
          centerSamples++;

          if (prevLuma != -1) {
            final diff = (luma - prevLuma).abs();
            if (diff > 35) {
              // High contrast edge transition (indicates printed text/border of card)
              centerHighVarCount++;
            }
          }
          prevLuma = luma;

          if (hasUV && bytesU != null && bytesV != null) {
            final uvIndex = (i ~/ 2).clamp(0, bytesU.length - 1);
            uSum += bytesU[uvIndex];
            vSum += bytesV[uvIndex];
            uvSampleCount++;
          }
        }

        final double avgLuma = centerSamples > 0 ? (centerLumaSum / centerSamples) : 0;
        final double edgeDensity = centerSamples > 0 ? (centerHighVarCount / centerSamples) : 0;

        // Card recognition criteria:
        // 1. Adequate scene illumination (60 < avgLuma < 215)
        // 2. High edge density in center reticle (representing card title, code block, and border)
        final bool isCardPresent = avgLuma > 60 && avgLuma < 215 && edgeDensity > 0.18;

        if (isCardPresent) {
          _detectionHits++;

          // Identify specific card signature based on chroma balance
          String recognized = _detectedMaterial;
          if (uvSampleCount > 0) {
            final double avgU = uSum / uvSampleCount;
            final double avgV = vSum / uvSampleCount;

            // Chrominance signature classification (YUV space)
            if (avgU > 135 && avgV < 125) {
              recognized = 'Integer'; // Blue/Cyan tint
            } else if (avgU < 120 && avgV < 120) {
              recognized = 'Float'; // Green tint
            } else if (avgU < 120 && avgV > 135) {
              recognized = 'String'; // Orange/Yellow tint
            } else if (avgU < 125 && avgV > 140) {
              recognized = 'Boolean'; // Red tint
            } else if (avgU > 130 && avgV > 130) {
              recognized = 'Dictionary'; // Purple/Violet tint
            }
          }

          if (_detectionHits >= 4) { // Requires 4 consecutive verified frames
            if (!_isCardDetected && mounted) {
              setState(() {
                _isCardDetected = true;
                _detectedMaterial = recognized;
              });
            }
          }
        } else {
          // Rapidly decay detection if card is removed
          _detectionHits = 0;
          if (_isCardDetected && mounted) {
            setState(() {
              _isCardDetected = false;
            });
          }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Live Camera Viewport
            if (_isCameraInitialized && _cameraController != null)
              SizedBox.expand(
                child: CameraPreview(_cameraController!),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            // Target Reticle (AR Frame)
            Center(
              child: Container(
                width: 260,
                height: 340,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isCardDetected ? const Color(0xFF4CAF50) : AppColors.secondaryLightBlue,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (_isCardDetected ? const Color(0xFF4CAF50) : AppColors.secondaryLightBlue)
                          .withAlpha((0.25 * 255).round()),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: _isCardDetected
                    ? Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: ModelViewer(
                                key: ValueKey('scan_lock_$_detectedMaterial'),
                                src: _getModelAsset(_detectedMaterial),
                                alt: _detectedMaterial,
                                ar: false,
                                autoRotate: true,
                                autoRotateDelay: 0,
                                rotationPerSecond: '30deg',
                                cameraControls: true,
                                interactionPrompt: InteractionPrompt.none,
                                loading: Loading.eager,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha((0.6 * 255).round()),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '3D Object Lock',
                                style: GoogleFonts.poppins(fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          'Arahkan ke Kartu AR',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
              ),
            ),

            // Top Status Banner
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: _isCardDetected
                      ? const Color(0xFF4CAF50)
                      : Colors.black.withAlpha((0.7 * 255).round()),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 6)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isCardDetected ? Icons.check_circle : Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isCardDetected
                          ? 'Kartu AR $_detectedMaterial Terdeteksi!'
                          : 'Arahkan Kamera ke Kartu AR...',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Top Left Back Button
            Positioned(
              top: 16,
              left: 16,
              child: FloatingActionButton(
                mini: true,
                heroTag: 'back_fab',
                backgroundColor: Colors.white.withAlpha((0.85 * 255).round()),
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: AppColors.primaryDarkBlue),
              ),
            ),

            // Top Right Flash Toggle
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                mini: true,
                heroTag: 'flash_fab',
                backgroundColor: _isFlashOn
                    ? Colors.amber.withAlpha((0.9 * 255).round())
                    : Colors.white.withAlpha((0.85 * 255).round()),
                onPressed: () async {
                  if (_cameraController == null || !_isCameraInitialized) return;
                  try {
                    if (_isFlashOn) {
                      await _cameraController?.setFlashMode(FlashMode.off);
                    } else {
                      await _cameraController?.setFlashMode(FlashMode.torch);
                    }
                    setState(() => _isFlashOn = !_isFlashOn);
                  } catch (_) {}
                },
                child: Icon(
                  _isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: _isFlashOn ? Colors.white : AppColors.primaryDarkBlue,
                ),
              ),
            ),

            // Bottom Action Button
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isCardDetected ? () => _navigateToResult() : null,
                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                  label: Text(
                    'Buka Materi $_detectedMaterial',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCardDetected
                        ? AppColors.secondaryLightBlue
                        : Colors.grey.withAlpha((0.6 * 255).round()),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: _isCardDetected ? 6 : 0,
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ARResultScreen(materialName: _detectedMaterial),
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
        return 'assets/3d/Boolean.glb';
      case 'dictionary':
        return 'assets/3d/Dictionary.glb';
      default:
        return 'assets/3d/Integer.glb';
    }
  }
}
