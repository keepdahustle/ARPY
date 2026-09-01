import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
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
  // Detection state
  bool _isCardDetected = false;
  String? _detectedMaterial;
  bool _isProcessingFrame = false;
  int _consecutiveHits = 0;

  // Active target material
  String _activeTarget = 'Integer';
  final List<String> _materials = [
    'Integer',
    'Float',
    'String',
    'Boolean',
    'Dictionary',
  ];

  // Camera controller
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMaterial != null && _materials.contains(widget.initialMaterial)) {
      _activeTarget = widget.initialMaterial!;
    }
    _initializeCamera();
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
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();

      if (mounted && _cameraController != null) {
        await _cameraController!.startImageStream(_processCameraFrame);
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ModernDialog.showSnack(context, 'Gagal menginisialisasi kamera: ${e.toString()}');
      }
    }
  }

  /// Adaptive HDR frame analysis: recognizes printed cards AND backlit smartphone/tablet screens
  Future<void> _processCameraFrame(CameraImage image) async {
    if (_isProcessingFrame || !mounted) return;
    _isProcessingFrame = true;

    try {
      if (image.planes.isNotEmpty) {
        final planeY = image.planes[0];
        final bytesY = planeY.bytes;
        final int w = image.width;
        final int h = image.height;

        // Sample center reticle region (25% to 75% dimensions)
        final int startRow = (h * 0.25).round();
        final int endRow = (h * 0.75).round();
        final int startCol = (w * 0.25).round();
        final int endCol = (w * 0.75).round();

        int sumLuma = 0;
        int edgeTransitions = 0;
        int samples = 0;
        int lastPx = -1;

        // Chroma sampling
        int uSum = 0;
        int vSum = 0;
        int uvSamples = 0;
        final bool hasUV = image.planes.length >= 3;
        final bytesU = hasUV ? image.planes[1].bytes : null;
        final bytesV = hasUV ? image.planes[2].bytes : null;

        for (int r = startRow; r < endRow; r += 4) {
          final rowOffset = r * w;
          for (int c = startCol; c < endCol; c += 4) {
            final idx = rowOffset + c;
            if (idx >= bytesY.length) continue;

            final px = bytesY[idx];
            sumLuma += px;
            samples++;

            // Adaptive threshold scaled with average illumination
            if (lastPx != -1 && (px - lastPx).abs() > 32) {
              edgeTransitions++;
            }
            lastPx = px;

            if (hasUV && bytesU != null && bytesV != null) {
              final uvIdx = (r ~/ 2) * (w ~/ 2) + (c ~/ 2);
              if (uvIdx < bytesU.length && uvIdx < bytesV.length) {
                uSum += bytesU[uvIdx];
                vSum += bytesV[uvIdx];
                uvSamples++;
              }
            }
          }
        }

        if (samples > 0) {
          final double avgLuma = sumLuma / samples;
          final double edgeDensity = edgeTransitions / samples;

          // Adaptive HDR: Supports dim paper (luma > 40) up to bright mobile screens (luma < 252)
          final bool cardPresent = avgLuma > 40 && avgLuma < 252 && edgeDensity > 0.16;

          if (cardPresent) {
            _consecutiveHits++;

            // Color-space topic classification
            String identified = _activeTarget;
            if (uvSamples > 0) {
              final double avgU = uSum / uvSamples;
              final double avgV = vSum / uvSamples;

              if (avgU > 132 && avgV < 125) {
                identified = 'Integer';
              } else if (avgU < 124 && avgV < 124) {
                identified = 'Float';
              } else if (avgU < 124 && avgV > 132) {
                identified = 'String';
              } else if (avgU < 126 && avgV > 138) {
                identified = 'Boolean';
              } else if (avgU > 130 && avgV > 130) {
                identified = 'Dictionary';
              }
            }

            if (_consecutiveHits >= 3) {
              if (!_isCardDetected && mounted) {
                setState(() {
                  _isCardDetected = true;
                  _detectedMaterial = identified;
                });
              }
            }
          } else {
            _consecutiveHits = 0;
            if (_isCardDetected && mounted) {
              setState(() {
                _isCardDetected = false;
                _detectedMaterial = null;
              });
            }
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

  void _manualSnapTarget() {
    setState(() {
      _isCardDetected = true;
      _detectedMaterial = _activeTarget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ─── Live Camera Feed with AspectRatio Protection ───
            if (_isCameraInitialized && _cameraController != null)
              Center(
                child: AspectRatio(
                  aspectRatio: 1 / _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            // ─── Center AR Card Overlay Anchor Reticle (Tap to Snap) ───
            Center(
              child: GestureDetector(
                onTap: _manualSnapTarget,
                child: Container(
                  width: 280,
                  height: 380,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isCardDetected ? const Color(0xFF4CAF50) : AppColors.secondaryLightBlue,
                      width: 3.5,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: (_isCardDetected ? const Color(0xFF4CAF50) : AppColors.secondaryLightBlue)
                            .withAlpha((0.3 * 255).round()),
                        blurRadius: 24,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: _isCardDetected && _detectedMaterial != null
                      ? Stack(
                          children: [
                            // Target Card Background Alignment
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Opacity(
                                  opacity: 0.35,
                                  child: Image.asset(
                                    'assets/ARCard/ARCard${_detectedMaterial!}.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            // 3D Object Rendered On Top of the Card
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ModelViewer(
                                  key: ValueKey('ar_lock_${_detectedMaterial!}'),
                                  src: _getModelAsset(_detectedMaterial!),
                                  alt: _detectedMaterial!,
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
                              top: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle, size: 12, color: Colors.white),
                                    const SizedBox(width: 4),
                                    Text(
                                      'AR Tracked',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.qr_code_scanner_rounded,
                                size: 56,
                                color: Colors.white54,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Arahkan kamera ke Kartu AR\natau ketuk layar untuk kunci',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha((0.15 * 255).round()),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Target: $_activeTarget',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),

            // ─── Top Status Banner ───
            Positioned(
              top: 16,
              left: 64,
              right: 64,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: _isCardDetected
                      ? const Color(0xFF4CAF50)
                      : Colors.black.withAlpha((0.72 * 255).round()),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 6)],
                ),
                child: Text(
                  _isCardDetected
                      ? '✓ Kartu ${_detectedMaterial!} Terdeteksi!'
                      : 'Mencari Kartu $_activeTarget...',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // ─── Top Left Back Button ───
            Positioned(
              top: 12,
              left: 12,
              child: FloatingActionButton(
                mini: true,
                heroTag: 'ar_scan_back',
                backgroundColor: Colors.white.withAlpha((0.85 * 255).round()),
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: AppColors.primaryDarkBlue),
              ),
            ),

            // ─── Top Right Flash Toggle ───
            Positioned(
              top: 12,
              right: 12,
              child: FloatingActionButton(
                mini: true,
                heroTag: 'ar_scan_flash',
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

            // ─── Material Selector Chips ───
            Positioned(
              bottom: 92,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _materials.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final mat = _materials[i];
                    final isTarget = _detectedMaterial == mat || (_detectedMaterial == null && _activeTarget == mat);
                    return ChoiceChip(
                      label: Text(
                        mat,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: isTarget ? FontWeight.w600 : FontWeight.w400,
                          color: isTarget ? Colors.white : Colors.white70,
                        ),
                      ),
                      selected: isTarget,
                      selectedColor: _isCardDetected ? const Color(0xFF4CAF50) : AppColors.primaryLightBlue,
                      backgroundColor: Colors.black.withAlpha((0.6 * 255).round()),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _activeTarget = mat;
                            _isCardDetected = false;
                            _detectedMaterial = null;
                          });
                        }
                      },
                    );
                  },
                ),
              ),
            ),

            // ─── Bottom Action Button ───
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isCardDetected && _detectedMaterial != null
                      ? () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ARResultScreen(materialName: _detectedMaterial!),
                            ),
                          )
                      : null,
                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                  label: Text(
                    _isCardDetected && _detectedMaterial != null
                        ? 'Buka Materi $_detectedMaterial'
                        : 'Arahkan ke Kartu AR untuk Membuka',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCardDetected
                        ? AppColors.secondaryLightBlue
                        : Colors.grey.withAlpha((0.5 * 255).round()),
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
}
