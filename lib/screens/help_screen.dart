import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../widgets/faq_item.dart';

class HelpScreen extends StatefulWidget {
  final bool showBackButton;
  
  const HelpScreen({super.key, this.showBackButton = false});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FAQItem> _filteredFAQs = [];
  
  final List<FAQItem> _allFAQs = [
    FAQItem(
      title: 'Cara Scan Kartu AR',
      content: 'Untuk menggunakan fitur AR:\n\n1. Tekan tombol kamera di beranda\n2. Arahkan kamera ke kartu AR\n3. Pastikan pencahayaan cukup\n4. Tunggu hingga kartu terdeteksi\n5. Model 3D akan muncul secara otomatis',
      icon: Icons.camera_alt,
    ),
    FAQItem(
      title: 'Cara Mengerjakan Kuis',
      content: 'Langkah mengerjakan kuis:\n\n1. Buka halaman Task\n2. Pilih kuis yang ingin dikerjakan\n3. Baca soal dengan teliti\n4. Pilih jawaban yang tepat\n5. Klik "Periksa Jawaban"\n6. Lanjut ke soal berikutnya',
      icon: Icons.quiz,
    ),
    FAQItem(
      title: 'Memulai dengan ARPY',
      content: 'ARPY adalah aplikasi pembelajaran Python menggunakan Augmented Reality. AR adalah cara mengubah dunia nyata dengan menambahkan elemen digital ke dalamnya. Berbeda dengan virtual reality yang membuat lingkungan virtual sepenuhnya, AR menggabungkan dunia nyata dengan elemen digital.',
      icon: Icons.info,
    ),
    FAQItem(
      title: 'Menggunakan Visualisasi AR',
      content: 'Cara menggunakan visualisasi AR:\n\n1. Scan kartu AR untuk melihat model 3D\n2. Model dapat diputar dengan gestur\n3. Gunakan tombol "Pelajari Materi" untuk membaca penjelasan\n4. Akses kuis terkait melalui tombol Quiz',
      icon: Icons.view_in_ar,
    ),
    FAQItem(
      title: 'Download & Persiapan Kartu AR',
      content: 'Persiapan kartu AR:\n\n1. Download kartu dari menu "Download Kartu AR"\n2. Cetak dengan ukuran sesuai panduan\n3. Potong kartu secara rapi\n4. Pastikan kartu tidak rusak atau terlipat\n5. Gunakan kertas berkualitas baik',
      icon: Icons.download,
    ),
    FAQItem(
      title: 'Kebijakan Privasi',
      content: 'ARPY menghormati privasi pengguna. Data yang dikumpulkan hanya digunakan untuk meningkatkan pengalaman pembelajaran. Kami tidak membagikan informasi pribadi kepada pihak ketiga tanpa persetujuan.',
      icon: Icons.privacy_tip,
    ),
    FAQItem(
      title: 'Hubungi Kami',
      content: 'Butuh bantuan lebih lanjut?\n\nEmail: arpydev@gmail.com\nTelepon: +62 8954 1274 7634\nJam operasional: 10:00 - 20:00 WIB\n\nTim support kami siap membantu Anda!',
      icon: Icons.contact_support,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredFAQs = _allFAQs;
  }

  void _filterFAQs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFAQs = _allFAQs;
      } else {
        _filteredFAQs = _allFAQs.where((faq) =>
          faq.title.toLowerCase().contains(query.toLowerCase()) ||
          faq.content.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Bantuan & Dukungan',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: Column(
        children: [
          // Decorative header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryDarkBlue,
                  AppColors.primaryDarkBlue.withAlpha((0.7 * 255).round()),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  Icon(
                    Icons.help_outline_rounded,
                    size: 48,
                    color: Colors.white.withAlpha((0.8 * 255).round()),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Temukan jawaban untuk pertanyaanmu',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withAlpha((0.9 * 255).round()),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Search bar with shadow
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterFAQs,
              decoration: InputDecoration(
                hintText: 'Cari topik bantuan...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primaryLightBlue,
                  size: 22,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _filterFAQs('');
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.grey[400],
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.primaryLightBlue,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          
          // FAQ List with header
          if (_filteredFAQs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pertanyaan yang Sering Diajukan',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarkBlue,
                  ),
                ),
              ),
            ),
          
          // FAQ List
          Expanded(
            child: _filteredFAQs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Topik tidak ditemukan',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Coba cari dengan kata kunci lain',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredFAQs.length,
                    itemBuilder: (context, index) {
                      return FAQItemWidget(faqItem: _filteredFAQs[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
