import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class ModernDialog {
  static Future<void> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'OK',
    String cancelLabel = 'Batal',
    VoidCallback? onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryLightBlue, AppColors.secondaryLightBlue],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(title,
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(message, style: GoogleFonts.poppins(color: Colors.grey[800])),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(cancelLabel, style: GoogleFonts.poppins()),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDarkBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    if (onConfirm != null) onConfirm();
                  },
                  child: Text(confirmLabel, style: GoogleFonts.poppins(color: Colors.white)),
                ),
                const SizedBox(width: 12),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  static void showSnack(BuildContext context, String message, {bool isError = false}) {
    final snack = SnackBar(
      content: Text(message, style: GoogleFonts.poppins()),
      backgroundColor: isError ? AppColors.errorRed : AppColors.primaryDarkBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
