import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_animations.dart';
import '../utils/storage_service.dart';
import '../models/quiz_question.dart';
import 'quiz_screen.dart';

class QuizMaterialsScreen extends StatefulWidget {
  const QuizMaterialsScreen({super.key});

  @override
  State<QuizMaterialsScreen> createState() => _QuizMaterialsScreenState();
}

class _QuizMaterialsScreenState extends State<QuizMaterialsScreen> {
  List<Map<String, dynamic>> _completedQuizzes = [];

  @override
  void initState() {
    super.initState();
    _loadCompletedQuizzes();
  }

  Future<void> _loadCompletedQuizzes() async {
    final bestMap = await StorageService.getBestScoresByMaterial();
    final list = bestMap.entries.map((e) => {
          'material': e.key,
          'score': e.value['score'] ?? 0,
          'totalQuestions': e.value['totalQuestions'] ?? 0,
          'percentage': e.value['percentage'] ?? 0.0,
        }).toList();
    setState(() {
      _completedQuizzes = list;
    });
  }

  bool _isQuizCompleted(String materialName) {
    try {
      final q = _completedQuizzes.firstWhere((quiz) => quiz['material'] == materialName);
      final score = q['score'] ?? 0;
      return (score is int ? score : int.tryParse(score.toString()) ?? 0) >= 4;
    } catch (e) {
      return false;
    }
  }

  Map<String, dynamic>? _getQuizResult(String materialName) {
    try {
      return _completedQuizzes.firstWhere((quiz) => quiz['material'] == materialName);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final materials = QuizDataManager.getAllMaterials();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pilih Materi',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDarkBlue,
          ),
        ),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryDarkBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: materials.length,
        itemBuilder: (context, index) {
          final material = materials[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildMaterialCard(context, material),
          );
        },
      ),
    );
  }

  Widget _buildMaterialCard(BuildContext context, PythonMaterial material) {
    final isCompleted = _isQuizCompleted(material.name);
    final quizResult = _getQuizResult(material.name);
    final score = quizResult?['score'] ?? 0;
    final totalQuestions = quizResult?['totalQuestions'] ?? 0;

    return GestureDetector(
      onTap: () => _confirmAndStartQuiz(material),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: isCompleted
              ? Border.all(
                  color: AppColors.primaryTeal.withAlpha((0.3 * 255).round()),
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha((0.1 * 255).round()),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Row(
                children: [
                  // Material Icon with completion badge
                  Stack(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.primaryTeal.withAlpha((0.1 * 255).round())
                              : AppColors.secondaryLightBlue.withAlpha((0.1 * 255).round()),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            material.icon,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      // Completion checkmark
                      if (isCompleted)
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primaryTeal,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryTeal.withAlpha((0.3 * 255).round()),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Material Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                material.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDarkBlue,
                                ),
                              ),
                            ),
                            if (isCompleted)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryTeal.withAlpha((0.1 * 255).round()),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Selesai',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          material.description,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textMedium,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              '${material.questions.length} Pertanyaan',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.secondaryLightBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isCompleted) ...[
                              const SizedBox(width: 12),
                              const Text(
                                '•',
                                style: TextStyle(
                                  color: AppColors.primaryTeal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Skor: $score/$totalQuestions',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.primaryTeal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Arrow Icon
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: isCompleted
                        ? AppColors.primaryTeal
                        : AppColors.primaryLightBlue,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAndStartQuiz(PythonMaterial material) async {
    final totalQuestions = material.questions.length;

    final shouldStart = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Konfirmasi', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text('Anda akan mengerjakan Quiz dengan total $totalQuestions soal. Apakah Anda ingin melanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Batal', style: GoogleFonts.poppins(color: AppColors.textMedium)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Mulai', style: GoogleFonts.poppins(color: AppColors.primaryLightBlue, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (shouldStart == true) {
      // small delay of 0.7s before starting quiz
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      Navigator.push(
        context,
        AppAnimations.zoomFadePageRoute(
          page: QuizScreen(material: material),
        ),
      );
    }
  }
}
