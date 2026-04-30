import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_colors.dart';
import 'modern_dialog.dart';

class ARCardWidget extends StatelessWidget {
  const ARCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).round()),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Download Kartu AR',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDarkBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Download dan cetak kartu augmented reality sesuai pembelajaran yang diminati. Lalu, scan kartu AR untuk mendapatkan visualisasi yang menyenangkan!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () async {
                  const url = 'https://drive.google.com/drive/folders/1jpvVGKHKq4zJAuUaBgm8koirwvKGsNZA?usp=sharing';
                  try {
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                        } else {
                          if (context.mounted) {
                            // Use modern snack
                            ModernDialog.showSnack(context, 'Tidak dapat membuka link', isError: true);
                          }
                    }
                  } catch (e) {
                    if (context.mounted) {
                          ModernDialog.showSnack(context, 'Error membuka link', isError: true);
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryDarkBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Download',
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryDarkBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Python illustration placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.download_for_offline,
                  color: AppColors.primaryTeal,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
