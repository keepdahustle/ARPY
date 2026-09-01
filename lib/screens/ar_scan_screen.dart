import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../utils/app_colors.dart';
import 'ar_result_screen.dart';

class ARScanScreen extends StatefulWidget {
  final String? initialMaterial;
  const ARScanScreen({super.key, this.initialMaterial});

  @override
  State<ARScanScreen> createState() => _ARScanScreenState();
}

class _ARScanScreenState extends State<ARScanScreen> {
  ArCoreController? _arController;
  bool _arSupported = true;
  bool _permissionGranted = false;
  bool _isLoading = true;

  // Tracking state
  String? _detectedMaterial;
  bool _isTracking = false;
  final Set<int> _loadedNodeIndices = {};

  // Mapping: card name → material name → GLB file
  static const Map<String, String> _cardMaterialMap = {
    'integer': 'Integer',
    'float': 'Float',
    'string': 'String',
    'boolean': 'Boolean',
    'dictionary': 'Dictionary',
  };

  static const Map<String, String> _materialGlbMap = {
    'Integer': 'assets/3d/Integer.glb',
    'Float': 'assets/3d/Float.glb',
    'String': 'assets/3d/String.glb',
    'Boolean': 'assets/3d/Boolean.glb',
    'Dictionary': 'assets/3d/Dictionary.glb',
  };

  @override
  void initState() {
    super.initState();
    _checkPermissionAndSupport();
  }

  Future<void> _checkPermissionAndSupport() async {
    final status = await Permission.camera.request();
    if (!mounted) return;

    if (!status.isGranted) {
      setState(() {
        _isLoading = false;
        _permissionGranted = false;
      });
      return;
    }

    // Check ARCore availability
    try {
      final supported = await ArCoreController.checkArCoreAvailability();
      final installed = await ArCoreController.checkIsArCoreInstalled();
      if (!mounted) return;
      setState(() {
        _arSupported = (supported == true) && (installed == true);
        _permissionGranted = true;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _arSupported = false;
        _permissionGranted = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _onArCoreViewCreated(ArCoreController controller) async {
    _arController = controller;

    // Setup callbacks
    controller.onTrackingImage = _onImageTracked;

    // Load all 5 AR card images as augmented image database
    try {
      final Map<String, Uint8List> imageMap = {};
      for (final entry in _cardMaterialMap.entries) {
        final bytes = await rootBundle.load('assets/ARCard/ARCard${entry.value}.png');
        imageMap[entry.key] = bytes.buffer.asUint8List();
      }
      await controller.loadMultipleAugmentedImage(bytesMap: imageMap);
    } catch (e) {
      debugPrint('ARCore image database load error: $e');
    }
  }

  void _onImageTracked(ArCoreAugmentedImage augImage) {
    if (!mounted) return;

    final trackingState = augImage.trackingMethod;
    final cardKey = augImage.name.toLowerCase();
    final materialName = _cardMaterialMap[cardKey] ?? augImage.name;
    final imageIndex = augImage.index;

    if (trackingState == TrackingMethod.FULL_TRACKING) {
      // Card newly detected
      if (!_loadedNodeIndices.contains(imageIndex)) {
        _loadedNodeIndices.add(imageIndex);
        _place3DObject(materialName, imageIndex);
      }
      if (mounted) {
        setState(() {
          _detectedMaterial = materialName;
          _isTracking = true;
        });
      }
    } else if (trackingState == TrackingMethod.NOT_TRACKING) {
      // Card lost
      if (_loadedNodeIndices.contains(imageIndex)) {
        _loadedNodeIndices.remove(imageIndex);
        _arController?.removeNodeWithIndex(imageIndex);
      }
      if (mounted && _detectedMaterial == materialName) {
        setState(() {
          _isTracking = false;
          _detectedMaterial = null;
        });
      }
    }
  }

  Future<void> _place3DObject(String materialName, int imageIndex) async {
    try {
      final glbFile = _materialGlbMap[materialName] ?? 'assets/3d/Integer.glb';
      // arcore_flutter_plugin reads from flutter assets
      final node = ArCoreReferenceNode(
        name: 'arpy_$materialName',
        object3DFileName: glbFile,
        scale: vector.Vector3(0.15, 0.15, 0.15),
        position: vector.Vector3(0, 0.05, 0), // slight offset above card
      );
      await _arController?.addArCoreNodeToAugmentedImage(node, imageIndex);
    } catch (e) {
      debugPrint('Place 3D error: $e');
    }
  }

  @override
  void dispose() {
    _arController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ─── Main AR View / Status Screens ───
            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: Colors.white))
            else if (!_permissionGranted)
              _buildNoPermission()
            else if (!_arSupported)
              _buildArNotSupported()
            else
              ArCoreView(
                type: ArCoreViewType.AUGMENTEDIMAGES,
                onArCoreViewCreated: _onArCoreViewCreated,
                enablePlaneRenderer: false,
                enableUpdateListener: false,
                debug: false,
              ),

            // ─── Top Status Banner ───
            if (_permissionGranted && _arSupported && !_isLoading)
              Positioned(
                top: 12,
                left: 56,
                right: 56,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                  decoration: BoxDecoration(
                    color: _isTracking
                        ? const Color(0xFF4CAF50)
                        : Colors.black.withAlpha((0.72 * 255).round()),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    _isTracking
                        ? '✓ ${_detectedMaterial!} Terdeteksi!'
                        : 'Arahkan kamera ke kartu AR',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // ─── Back Button ───
            Positioned(
              top: 10,
              left: 12,
              child: FloatingActionButton(
                mini: true,
                heroTag: 'ar_back',
                backgroundColor: Colors.white.withAlpha((0.85 * 255).round()),
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: AppColors.primaryDarkBlue),
              ),
            ),

            // ─── Card Guide Panel ───
            if (_permissionGranted && _arSupported && !_isLoading)
              Positioned(
                bottom: 90,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 64,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _cardMaterialMap.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final material = _cardMaterialMap.values.elementAt(i);
                      final isActive = _detectedMaterial == material;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF4CAF50)
                              : Colors.black.withAlpha((0.65 * 255).round()),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isActive ? Colors.white : Colors.white24,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              material,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              isActive ? 'Tracking ✓' : 'AR Card',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

            // ─── Open Material Button ───
            if (_isTracking && _detectedMaterial != null)
              Positioned(
                bottom: 18,
                left: 20,
                right: 20,
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ARResultScreen(materialName: _detectedMaterial!),
                        )),
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
                      backgroundColor: AppColors.secondaryLightBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 6,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoPermission() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 64),
            const SizedBox(height: 16),
            Text(
              'Izin Kamera Diperlukan',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Aktifkan izin kamera di pengaturan untuk menggunakan AR.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: openAppSettings,
              child: const Text('Buka Pengaturan'),
            ),
          ],
        ),
      );

  Widget _buildArNotSupported() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.view_in_ar_outlined, color: Colors.white54, size: 64),
            const SizedBox(height: 16),
            Text(
              'ARCore Tidak Tersedia',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Perangkat ini tidak mendukung ARCore atau Google Play Services for AR belum terinstall.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      );
}
