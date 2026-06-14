import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_animations.dart';
import '../utils/storage_service.dart';
import '../utils/certificate_service.dart';
import 'package:printing/printing.dart';
import 'edit_profile_screen.dart';
import 'help_screen.dart';
import 'login_screen.dart';
import '../widgets/modern_dialog.dart';

class ProfileScreen extends StatefulWidget {
  final bool showBackButton;
  
  const ProfileScreen({super.key, this.showBackButton = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  int _completedQuizzes = 0;
  int _completedProjects = 0;
  int _totalPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProgress();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await StorageService.getUserData();
      setState(() {
        _userData = data ?? {};
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _userData = {};
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProgress() async {
    try {
      // Count passed (unique) quizzes using best attempt per material.
      final passedQuizCount = await StorageService.getUniquePassedQuizCount(minCorrect: 4);

      // Load project progress
      final projectProgress = await StorageService.getProjectProgress();

      // Count completed projects (status = 'submitted')
      final completedProjects = projectProgress.where((p) => p['status'] == 'submitted').length;

      // Calculate points:
      // 1 passed quiz = 15 poin
      int quizPoints = passedQuizCount * 15;
      
      // Project points: base 40 poin + bonus berdasarkan estimatedDays
      // 2 hari = 40, 4 hari = 50, 6+ hari = 60
      int projectPoints = 0;
      for (var project in projectProgress) {
        if (project['status'] == 'submitted') {
          // Get estimatedDays from project data if available
          int estimatedDays = project['estimatedDays'] ?? 2;
          int projectPointValue = 40; // Default
          
          if (estimatedDays >= 6) {
            projectPointValue = 60;
          } else if (estimatedDays >= 4) {
            projectPointValue = 50;
          } else {
            projectPointValue = 40;
          }
          projectPoints += projectPointValue;
        }
      }
      
      int totalPoints = quizPoints + projectPoints;

      setState(() {
        _completedQuizzes = passedQuizCount;
        _completedProjects = completedProjects;
        _totalPoints = totalPoints;
      });
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _refreshProfile() async {
    await _loadUserData();
    await _loadProgress();
  }

  Future<void> _handleLogout() async {
    // Use modern dialog
    await ModernDialog.showConfirm(
      context,
      title: 'Logout',
      message: 'Apakah Anda yakin ingin keluar dari aplikasi?',
      confirmLabel: 'Logout',
      cancelLabel: 'Batal',
      onConfirm: () async {
        await StorageService.logout();
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            AppAnimations.fadePageRoute(page: const LoginScreen()),
            (route) => false,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final userName = _userData?['fullName'] ?? 'Pengguna';
    final email = _userData?['email'] ?? 'email@example.com';
    final school = _userData?['school'] ?? 'Belum diisi';
    final username = _userData?['username'] ?? 'user';

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: AppColors.primaryDarkBlue,
        backgroundColor: Colors.white,
        child: Column(
        children: [
          // Header with modern gradient shape
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryLightBlue,
                  AppColors.secondaryLightBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    // Back button (only show if from home)
                    if (widget.showBackButton)
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    
                    const SizedBox(height: 12),
                    
                    // Modern rounded card container
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.95 * 255).round()),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.08 * 255).round()),
                            spreadRadius: 2,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                        child: Column(
                          children: [
                            // Avatar with edit icon
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primaryLightBlue.withAlpha((0.3 * 255).round()),
                                        AppColors.secondaryLightBlue.withAlpha((0.3 * 255).round()),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: AppColors.primaryLightBlue.withAlpha((0.5 * 255).round()),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    size: 56,
                                    color: AppColors.primaryDarkBlue,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        AppAnimations.zoomFadePageRoute(
                                          page: const EditProfileScreen(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.primaryLightBlue,
                                            AppColors.secondaryLightBlue,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primaryDarkBlue.withAlpha((0.3 * 255).round()),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.mode_edit_rounded,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Name - with proper constraint
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                userName,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDarkBlue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            
                            // Email - with proper constraint
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                email,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.textMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistics cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(_completedQuizzes.toString(), 'Quiz Selesai', AppColors.secondaryIndigo),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(_completedProjects.toString(), 'Project', AppColors.primaryTeal),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(_totalPoints.toString(), 'Points', AppColors.primaryLightBlue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Certificate Button (placed between stats and profile info)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final user = await StorageService.getUserData();
                        final fullName = (user != null && user['fullName'] != null) ? user['fullName'] as String : 'Nama Lengkap';
                        ModernDialog.showSnack(context, 'Mempersiapkan sertifikat...');
                        try {
                          final pdfBytes = await CertificateService.generateCertificatePdf(fullName);
                          await Printing.sharePdf(bytes: pdfBytes, filename: 'ARPY_Certificate_${fullName.replaceAll(' ', '_')}.pdf');
                          ModernDialog.showSnack(context, 'Sertifikat berhasil dibuat dan dibagikan.');
                        } catch (e) {
                          ModernDialog.showSnack(context, 'Gagal membuat sertifikat: ${e.toString()}');
                        }
                      },
                      icon: const Icon(Icons.picture_as_pdf),
                      label: Text(
                        'Buat Sertifikat',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLightBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User Information Section
                  Text(
                    'Informasi Profil',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lightGrey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('USERNAME', username),
                        const SizedBox(height: 16),
                        _buildInfoRow('NAMA LENGKAP', userName),
                        const SizedBox(height: 16),
                        _buildInfoRow('EMAIL', email),
                        const SizedBox(height: 16),
                        _buildInfoRow('SEKOLAH / UNIVERSITAS', school),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Settings Section
                  Text(
                    'Pengaturan',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingItem(
                    icon: Icons.edit_note,
                    label: 'Edit Profile',
                    onTap: () {
                        Navigator.of(context).push(
                        AppAnimations.zoomFadePageRoute(
                        page: const EditProfileScreen(),
                      ),
                      );
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.privacy_tip,
                    label: 'Kebijakan Privasi',
                    onTap: () {
                      ModernDialog.showSnack(context, 'Fitur Kebijakan Privasi akan segera tersedia');
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.help_center,
                    label: 'Bantuan & Dukungan',
                    onTap: () {
                      Navigator.push(
                        context,
                        AppAnimations.zoomFadePageRoute(
                          page: const HelpScreen(showBackButton: true),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha((0.2 * 255).round())),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textMedium,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryLightBlue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: AppColors.primaryDarkBlue, size: 22),
        title: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textLight),
        onTap: onTap,
      ),
    );
  }
}
