import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_animations.dart';
import '../models/quiz_question.dart';
import 'quiz_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final String materialName;
  final int score;
  final int totalQuestions;
  final PythonMaterial material;

  const QuizResultScreen({
    super.key,
    required this.materialName,
    required this.score,
    required this.totalQuestions,
    required this.material,
  });

  String _getGrade() {
    final percentage = (score / totalQuestions) * 100;
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    return 'E';
  }

  String _getMotivationalMessage() {
    final percentage = (score / totalQuestions) * 100;
    if (percentage >= 90) {
      return 'Luar biasa! Kamu sangat memahami materi ini! 🎉';
    } else if (percentage >= 80) {
      return 'Bagus sekali! Pemahaman kamu sudah cukup baik. 👍';
    } else if (percentage >= 70) {
      return 'Baik! Terus pelajari materi untuk meningkatkan pemahaman. 📚';
    } else if (percentage >= 60) {
      return 'Cukup, tapi ada beberapa yang perlu diperdalam. 💪';
    } else {
      return 'Jangan menyerah! Pelajari kembali materi ini. ✨';
    }
  }

  Color _getGradeColor() {
    final percentage = (score / totalQuestions) * 100;
    if (percentage >= 80) return AppColors.primaryTeal;
    if (percentage >= 60) return AppColors.secondaryIndigo;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions) * 100;
    final grade = _getGrade();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Hasil Quiz',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryDarkBlue,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // Score Circle
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        _getGradeColor(),
                        _getGradeColor().withAlpha((0.6 * 255).round()),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$score/$totalQuestions',
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha((0.3 * 255).round()),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Nilai: $grade',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Motivational Message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withAlpha((0.3 * 255).round()),
                    ),
                  ),
                  child: Text(
                    _getMotivationalMessage(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryDarkBlue,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Statistics
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Benar',
                        value: '$score',
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Salah',
                        value: '${totalQuestions - score}',
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Material Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Materi: $materialName',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        material.description,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          height: 1.5,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Buttons
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Pop result screen and quiz screen, then push fresh quiz
                      Navigator.pop(context); // Pop result
                      Navigator.pop(context); // Pop quiz
                      Navigator.push(
                        context,
                        AppAnimations.zoomFadePageRoute(
                          page: QuizScreen(material: material),
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      'Ulangi Quiz',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryLightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Pop result, quiz, and materials screens to return to TasksScreen
                      Navigator.pop(context); // Pop result
                      Navigator.pop(context); // Pop quiz
                      Navigator.pop(context); // Pop materials
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: Text(
                      'Kembali ke Tugas',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryLightBlue,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.secondaryLightBlue,
                        width: 2,
                      ),
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
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha((0.3 * 255).round())),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
