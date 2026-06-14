import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CertificateService {
  // Generates a simple, modern achievement certificate PDF for the provided full name.
  // Returns the PDF as Uint8List.
  static Future<Uint8List> generateCertificatePdf(String fullName) async {
    final pdf = pw.Document();

    // Background image will provide certificate styling; no extra colors needed here.

    // Load background image from assets
    final bgData = await rootBundle.load('assets/images/BackgroundSertifikatARPY.png');
    final bgBytes = bgData.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) {
          return pw.Stack(
            children: [
              // Full-page background image
              pw.Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: pw.Image(pw.MemoryImage(bgBytes), fit: pw.BoxFit.cover),
              ),

              // Overlay content (name, description, signature)
              pw.Center(
                child: pw.Container(
                  margin: const pw.EdgeInsets.symmetric(horizontal: 120),
                  padding: const pw.EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  // keep container transparent by not setting a color
                  child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      // 'Diberikan kepada' label (small)
                      pw.Text('Diberikan kepada', style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 12)),
                      pw.SizedBox(height: 8),

                      // Recipient name
                      pw.Text(fullName,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontSize: 36, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                      pw.SizedBox(height: 16),

                      // Description
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                        child: pw.Text(
                          'Sebagai pengakuan telah menyelesaikan pencapaian pada aplikasi ARPY dan menunjukkan komitmen dalam pembelajaran Augmented Reality.',
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey800),
                        ),
                      ),
                      pw.SizedBox(height: 40),

                      // Signature row
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(children: [
                            pw.Text('_________________________', style: const pw.TextStyle(color: PdfColors.grey800)),
                            pw.Text('ARPY TEAM', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey800))
                          ]),

                          pw.Column(children: [
                            pw.Text('Tanggal: ${_formatDate(DateTime.now())}', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey800))
                          ])
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    return '$day/$month/$year';
  }
}
