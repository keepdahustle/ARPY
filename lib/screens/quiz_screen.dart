import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_animations.dart';
import '../utils/storage_service.dart';
import '../widgets/modern_dialog.dart';
import '../models/quiz_question.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final PythonMaterial material;
  
  const QuizScreen({
    super.key,
    required this.material,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _hasAnswered = false;
  bool _isCorrect = false;
  int _correctAnswers = 0;
  late List<QuizQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _questions = widget.material.questions;
  }

  void _selectAnswer(int index) {
    if (_hasAnswered) return;
    
    setState(() {
      _selectedAnswerIndex = index;
      _hasAnswered = true;
      _isCorrect = index == _questions[_currentQuestionIndex].correctAnswerIndex;
      if (_isCorrect) _correctAnswers++;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _hasAnswered = false;
        _isCorrect = false;
      });
    } else {
      _completeQuiz();
    }
  }

  Future<void> _completeQuiz() async {
    // Save result to storage
    final percentage = (_correctAnswers / _questions.length) * 100;
    await StorageService.saveQuizResult(
      materialName: widget.material.name,
      score: _correctAnswers,
      totalQuestions: _questions.length,
      percentage: percentage,
      completedAt: DateTime.now(),
    );

    if (mounted) {
      Navigator.push(
        context,
        AppAnimations.zoomFadePageRoute(
          page: QuizResultScreen(
            materialName: widget.material.name,
            score: _correctAnswers,
            totalQuestions: _questions.length,
            material: widget.material,
          ),
        ),
      );
    }
  }

  void _showExitConfirmation() {
    ModernDialog.showConfirm(
      context,
      title: 'Keluar dari Quiz?',
      message: 'Jika Anda keluar sekarang, progress quiz akan hilang dan tidak dapat disimpan.',
      confirmLabel: 'Keluar',
      cancelLabel: 'Lanjutkan Quiz',
      onConfirm: () {
        // Close dialog then exit quiz
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return WillPopScope(
      onWillPop: () async {
        _showExitConfirmation();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _showExitConfirmation,
          ),
          title: Text(
            widget.material.name,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryDarkBlue,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              Text(
                'Soal ${_currentQuestionIndex + 1} dari ${_questions.length}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / _questions.length,
                backgroundColor: AppColors.lightGrey,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.secondaryLightBlue,
                ),
                minHeight: 4,
              ),
              const SizedBox(height: 32),
              
              // Question
              Text(
                currentQuestion.question,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDarkBlue,
                ),
              ),
              const SizedBox(height: 24),
              
              // Answer options
              Expanded(
                child: ListView.builder(
                  itemCount: currentQuestion.options.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedAnswerIndex == index;
                    final isCorrectAnswer = index == currentQuestion.correctAnswerIndex;
                    
                    Color borderColor = AppColors.lightGrey;
                    Color backgroundColor = Colors.white;
                    Widget? trailingIcon;
                    
                    if (_hasAnswered) {
                      if (isSelected) {
                        if (_isCorrect) {
                          borderColor = AppColors.primaryTeal;
                          backgroundColor = AppColors.primaryTeal.withAlpha((0.1 * 255).round());
                          trailingIcon = const Icon(Icons.check_circle, color: AppColors.primaryTeal);
                        } else {
                          borderColor = Colors.red;
                          backgroundColor = Colors.red.withAlpha((0.1 * 255).round());
                          trailingIcon = const Icon(Icons.cancel, color: Colors.red);
                        }
                      } else if (isCorrectAnswer) {
                        borderColor = AppColors.primaryTeal;
                        backgroundColor = AppColors.primaryTeal.withAlpha((0.1 * 255).round());
                        trailingIcon = const Icon(Icons.check_circle, color: AppColors.primaryTeal);
                      }
                    } else if (isSelected) {
                      borderColor = AppColors.secondaryLightBlue;
                    }
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _selectAnswer(index),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(color: borderColor, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Radio<int>(
                                value: index,
                                groupValue: _selectedAnswerIndex,
                                onChanged: _hasAnswered ? null : (value) => _selectAnswer(value!),
                                activeColor: AppColors.secondaryLightBlue,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  currentQuestion.options[index],
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: AppColors.primaryDarkBlue,
                                  ),
                                ),
                              ),
                              if (trailingIcon != null) trailingIcon,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Explanation
              if (_hasAnswered) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _isCorrect 
                        ? AppColors.primaryTeal.withAlpha((0.1 * 255).round())
                        : Colors.red.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isCorrect ? AppColors.primaryTeal : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isCorrect ? '✓ Jawaban Benar!' : '✗ Jawaban Salah!',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _isCorrect ? AppColors.primaryTeal : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Penjelasan: ${currentQuestion.explanation}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          height: 1.5,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              // Next button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _hasAnswered ? _nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hasAnswered 
                        ? AppColors.secondaryLightBlue 
                        : AppColors.lightGrey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentQuestionIndex < _questions.length - 1 
                        ? 'Soal Berikutnya' 
                        : 'Selesai',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
