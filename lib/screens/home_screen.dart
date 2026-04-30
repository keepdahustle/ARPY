import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/storage_service.dart';
import '../widgets/ar_card_widget.dart';
import '../widgets/scan_history_card.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _displayName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final data = await StorageService.getUserData();
    if (mounted) {
      setState(() {
        _displayName = (data?['username'] as String?) ?? (data?['fullName'] as String?) ?? 'User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/ARPY-Logo-iHhElAnuiM1Ik5hDUYZKKSf5AiY7rQ.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(showBackButton: true),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Extra top spacing to push greeting & cards lower (logo remains)
                    const SizedBox(height: 36),

                    // Greeting
                    Text(
                      'Halo, $_displayName!',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDarkBlue,
                      ),
                    ),
                    Text(
                      'Selamat datang di Augmented Reality Python',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // AR Card Download
                    const ARCardWidget(),
                    const SizedBox(height: 32),
                    
                    // Scan History Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Histori Scan',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDarkBlue,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to full history
                          },
                          child: Text(
                            'Lihat Semua',
                            style: GoogleFonts.poppins(
                              color: AppColors.secondaryLightBlue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // History Cards Grid
                    Row(
                      children: [
                        Expanded(
                          child: ScanHistoryCard(
                            title: 'Integer',
                            tag: 'Tipe Data',
                            description: 'Penjelasan Tipe Data Integer',
                            onTap: () {
                              // Navigate to Integer visualization
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ScanHistoryCard(
                            title: 'Float',
                            tag: 'Tipe Data',
                            description: 'Penjelasan Tipe Data Float',
                            onTap: () {
                              // Navigate to Float visualization
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60), // Space for NavBar (reduced so content sits closer)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
