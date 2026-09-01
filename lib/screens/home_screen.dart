import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/storage_service.dart';
import '../widgets/ar_card_widget.dart';
import '../widgets/scan_history_card.dart';
import 'profile_screen.dart';
import 'ar_result_screen.dart';
import 'quiz_materials_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _displayName = 'User';
  int _passedQuizzes = 0;
  int _completedProjects = 0;
  int _totalPoints = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
    _loadStats();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final data = await StorageService.getUserData();
    if (mounted) {
      setState(() {
        _displayName = (data?['username'] as String?) ?? (data?['fullName'] as String?) ?? 'User';
      });
    }
  }

  Future<void> _loadStats() async {
    try {
      final passed = await StorageService.getUniquePassedQuizCount(minCorrect: 4);
      final projects = await StorageService.getProjectProgress();
      final completedProj = projects.where((p) => p['status'] == 'submitted' || p['status'] == 'completed').length;
      int points = passed * 15;
      for (final p in projects) {
        if (p['status'] == 'submitted' || p['status'] == 'completed') {
          int days = p['estimatedDays'] ?? 2;
          points += (days >= 6 ? 60 : (days >= 4 ? 50 : 40));
        }
      }
      if (mounted) {
        setState(() {
          _passedQuizzes = passed;
          _completedProjects = completedProj;
          _totalPoints = points;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const QuizMaterialsScreen(),
                          ),
                        );
                      }),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: ScanHistoryCard(
                              title: 'Integer',
                              tag: 'Tipe Data',
                              description: 'Penjelasan Tipe Data Integer',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ARResultScreen(materialName: 'Integer'),
                                  ),
                                );
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ARResultScreen(materialName: 'Float'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ScanHistoryCard(
                              title: 'String',
                              tag: 'Tipe Data',
                              description: 'Manipulasi & Sequence Teks',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ARResultScreen(materialName: 'String'),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ScanHistoryCard(
                              title: 'Boolean',
                              tag: 'Tipe Data',
                              description: 'Evaluasi Logika True/False',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ARResultScreen(materialName: 'Boolean'),
                                  ),
                                );
                              },
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
                  Image.asset(
                    'assets/images/arpy_logo.png',
                    height: 36,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Text(
                      'ARPY',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Avatar button
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(showBackButton: true),
                        ),
                      );
                    },
                    child: Container(
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
                      ),
                    ),
                  ),
                ],
              ),

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
                'Siap belajar Python dengan Augmented Reality?',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white.withAlpha((0.85 * 255).round()),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            icon: Icons.quiz_rounded,
            label: 'Quiz Lulus',
            value: '$_passedQuizzes',
            color: AppColors.primaryDarkBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.emoji_events_rounded,
            label: 'Total Poin',
            value: '$_totalPoints',
            color: AppColors.primaryTeal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.code_rounded,
            label: 'Proyek',
            value: '$_completedProjects',
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
              color: AppColors.secondaryLightBlue.withAlpha((0.2 * 255).round()),
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
                  'Tips AR',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pilih kartu target di scanner AR lalu arahkan kamera ke kartu fisik untuk melihat objek 3D secara interaktif!',
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
}
