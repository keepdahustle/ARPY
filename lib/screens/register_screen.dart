import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_card.dart';
import '../utils/storage_service.dart';
import '../widgets/modern_dialog.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;
  bool _isLoading = false;
  
  late AnimationController _fadeController;
  late AnimationController _buttonController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _buttonController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _buttonController.forward();
    await Future.delayed(const Duration(seconds: 2));
    
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    if (username.isEmpty) {
      setState(() {
        _errorMessage = "Username tidak boleh kosong";
        _isLoading = false;
      });
      return;
    }
    
    if (!email.contains('@')) {
      setState(() {
        _errorMessage = "Format email tidak valid";
        _isLoading = false;
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = "Password minimal 6 karakter";
        _isLoading = false;
      });
      return;
    }
    
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = "Password dan konfirmasi password tidak cocok";
        _isLoading = false;
      });
      return;
    }
    
    // Save account locally and persist as current user
    try {
      // Check if account exists
      final existing = await StorageService.getAccountByEmail(email);
      if (existing != null) {
        setState(() {
          _errorMessage = 'Akun dengan email tersebut sudah terdaftar.';
          _isLoading = false;
        });
        return;
      }

      // Save account (note: passwords stored in plain text here for demo only)
      await StorageService.saveAccount(
        email: email,
        password: password,
        username: username,
        fullName: username,
        school: '',
      );

      // Do NOT auto-login. Prompt user to login.
      if (mounted) {
        setState(() => _isLoading = false);
        ModernDialog.showConfirm(
          context,
          title: 'Pendaftaran Berhasil',
          message: 'Akun $username berhasil didaftarkan. Silakan masuk untuk melanjutkan.',
          confirmLabel: 'Masuk',
          cancelLabel: 'Tutup',
          onConfirm: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal mendaftar. Silakan coba lagi.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeController,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    // ARPY Logo with animation
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
                      ),
                      child: Image.network(
                        'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/ARPY-Logo-iHhElAnuiM1Ik5hDUYZKKSf5AiY7rQ.png',
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Error message
                    if (_errorMessage != null) ...[
                      ErrorCard(message: _errorMessage!),
                      const SizedBox(height: 20),
                    ],
                    
                    // Title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Daftar',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDarkBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Username field
                    CustomTextField(
                      controller: _usernameController,
                      hintText: 'Masukkan Username',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    
                    // Email field
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Masukkan Email',
                      prefixIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    
                    // Password field
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Masukkan Password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      isPasswordVisible: _isPasswordVisible,
                      onTogglePassword: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Confirm Password field
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Masukkan Konfirmasi Password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      isPasswordVisible: _isConfirmPasswordVisible,
                      onTogglePassword: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Register button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                          CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Daftar',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun? ',
                          style: GoogleFonts.poppins(
                            color: AppColors.textMedium,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Masuk',
                            style: GoogleFonts.poppins(
                              color: AppColors.secondaryLightBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}