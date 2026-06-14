import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_animations.dart';
import '../utils/storage_service.dart';
import 'quiz_materials_screen.dart';
import 'projects_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int _completedQuizzes = 0;
  int _completedProjects = 0;
  int _totalPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      // Load unique passed quizzes (best attempt per material)
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

  Future<void> _refreshTasks() async {
    await _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: RefreshIndicator(
        onRefresh: _refreshTasks,
        color: AppColors.primaryDarkBlue,
        backgroundColor: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Text(
                'Tugas & Proyek',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDarkBlue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tingkatkan skill Anda dengan kuis dan proyek',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textMedium,
                ),
              ),
              const SizedBox(height: 24),
              
              // Quiz Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryIndigo.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.secondaryIndigo.withAlpha((0.2 * 255).round()),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryIndigo.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.quiz,
                            color: AppColors.secondaryIndigo,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ayo Mulai Quiz!',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDarkBlue,
                                ),
                              ),
                              Text(
                                'Jawab dan kerjakan pertanyaan menarik!',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Quiz options
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '6 Materi: Integer, Boolean, String, Float, Set, Dictionary',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.secondaryIndigo,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            AppAnimations.zoomFadePageRoute(
                              page: const QuizMaterialsScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryIndigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Mulai Quiz',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              
              // Projects Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryTeal.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primaryTeal.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.code,
                            color: AppColors.primaryTeal,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Yuk Ikuti Proyek!',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDarkBlue,
                                ),
                              ),
                              Text(
                                'Implementasikan apa yang sudah dipelajari',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Project list
                    Text(
                      '4 Mini Projects tersedia',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            AppAnimations.zoomFadePageRoute(
                              page: const ProjectsScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Lihat Proyek',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              
              // Learning Progress Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.infoBlueBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryLightBlue.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progres Pembelajaran',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDarkBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildProgressItem('Kuis Selesai', _completedQuizzes.toString(), AppColors.secondaryIndigo),
                        _buildProgressItem('Proyek Selesai', _completedProjects.toString(), AppColors.primaryTeal),
                        _buildProgressItem('Points', _totalPoints.toString(), AppColors.primaryLightBlue),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textMedium,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

