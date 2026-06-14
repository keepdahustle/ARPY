// ignore_for_file: depend_on_referenced_packages, undefined_class, undefined_identifier, undefined_method, argument_type_not_assignable

import 'package:flutter/material.dart';
import 'ar_result_screen.dart';

/// ARCore integration removed. Keep a minimal screen that points users to
/// the in-app visualizer to view 3D content without native ARCore.
class ARCoreScreen extends StatelessWidget {
  const ARCoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR (Disabled)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Fitur AR native (ARCore) telah dihapus dari aplikasi.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ARResultScreen(materialName: 'Integer'),
                    ),
                  );
                },
                child: const Text('Buka Visualisasi (Model Viewer)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
