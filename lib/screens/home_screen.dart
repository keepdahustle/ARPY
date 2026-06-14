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

<<<<<<< HEAD
class _HomeScreenState extends State<HomeScreen> {
  String _displayName = 'User';
=======
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _displayName = 'User';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
>>>>>>> improve/home-screen-ui

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _loadUser();
=======
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _loadUser();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
>>>>>>> improve/home-screen-ui
  }

  Future<void> _loadUser() async {
    final data = await StorageService.getUserData();
    if (mounted) {
      setState(() {
<<<<<<< HEAD
        _displayName = (data?['username'] as String?) ?? (data?['fullName'] as String?) ?? 'User';
=======
        _displayName =
            (data?['username'] as String?) ??
            (data?['fullName'] as String?) ??
            'User';
>>>>>>> improve/home-screen-ui
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
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
=======
      backgroundColor: AppColors.backgroundWhite,
      body: Column(
        children: [
          // Gradient Header
          _buildHeader(),

          // Scrollable Body
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Stats Row
                      _buildQuickStats(),
                      const SizedBox(height: 24),

                      // AR Card Download Section
                      _buildSectionHeader('Kartu AR', null),
                      const SizedBox(height: 12),
                      const ARCardWidget(),
                      const SizedBox(height: 28),

                      // Scan History Section
                      _buildSectionHeader('Histori Scan', () {
                        // Navigate to full history
                      }),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: ScanHistoryCard(
                              title: 'Integer',
                              tag: 'Tipe Data',
                              description: 'Penjelasan Tipe Data Integer',
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ScanHistoryCard(
                              title: 'Float',
                              tag: 'Tipe Data',
                              description: 'Penjelasan Tipe Data Float',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Tips Banner
                      _buildTipsBanner(),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Gradient header with logo, greeting, and avatar
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryLightBlue, AppColors.secondaryLightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: logo + avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ARPY Logo
                  Image.network(
                    'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/ARPY-Logo-iHhElAnuiM1Ik5hDUYZKKSf5AiY7rQ.png',
                    height: 36,
                    fit: BoxFit.contain,
                  ),

                  // Avatar button
>>>>>>> improve/home-screen-ui
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
<<<<<<< HEAD
                          builder: (context) => const ProfileScreen(showBackButton: true),
=======
                          builder: (_) =>
                              const ProfileScreen(showBackButton: true),
>>>>>>> improve/home-screen-ui
                        ),
                      );
                    },
                    child: Container(
<<<<<<< HEAD
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
=======
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.25 * 255).round()),
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(
                          color: Colors.white.withAlpha((0.6 * 255).round()),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 24,
>>>>>>> improve/home-screen-ui
                      ),
                    ),
                  ),
                ],
              ),
<<<<<<< HEAD
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
=======

              const SizedBox(height: 20),

              // Greeting
              Text(
                'Halo, $_displayName! 👋',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Siap belajar Python hari ini?',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white.withAlpha((0.85 * 255).round()),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
>>>>>>> improve/home-screen-ui
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  /// Section header with optional "Lihat Semua" action
  Widget _buildSectionHeader(String title, VoidCallback? onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDarkBlue,
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              'Lihat Semua',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryLightBlue,
              ),
            ),
          ),
      ],
    );
  }

  /// Quick stats cards row
  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.qr_code_scanner_rounded,
            label: 'Total Scan',
            value: '2',
            color: AppColors.primaryDarkBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.emoji_events_rounded,
            label: 'Poin',
            value: '0',
            color: AppColors.primaryTeal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.task_alt_rounded,
            label: 'Task',
            value: '0',
            color: AppColors.secondaryIndigo,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).round()),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withAlpha((0.12 * 255).round()),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDarkBlue,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.textMedium,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Tips / info banner
  Widget _buildTipsBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoBlueBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.secondaryLightBlue.withAlpha((0.35 * 255).round()),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondaryLightBlue.withAlpha(
                (0.2 * 255).round(),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: AppColors.primaryDarkBlue,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Download kartu AR lalu arahkan kamera ke kartu untuk melihat visualisasi 3D!',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textMedium,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
>>>>>>> improve/home-screen-ui
}
