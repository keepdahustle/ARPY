import 'package:flutter/material.dart';
import 'ar_result_screen.dart';

/// ARCore integration removed. This placeholder screen informs users
/// that native AR has been removed and provides a link back to the
/// in-app AR result (model viewer) page.
class ARCoreNDKScreen extends StatelessWidget {
  const ARCoreNDKScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR Viewer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Fitur AR native (ARCore) telah dihapus dari aplikasi ini.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
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
