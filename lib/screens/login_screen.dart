import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_animations.dart';
import '../utils/storage_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_card.dart';
import 'register_screen.dart';
import '../widgets/modern_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _fadeController;
  bool _isPasswordVisible = false;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _checkExistingLogin();
    _fadeController.forward();
  }

  Future<void> _checkExistingLogin() async {
    final isLoggedIn = await StorageService.getLoginStatus();
    if (isLoggedIn && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate login process with animation
    _animationController.forward();
    await Future.delayed(const Duration(seconds: 2));
    
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    
    // Validation
    if (email.isEmpty || !email.contains('@')) {
      if (mounted) {
        setState(() {
          _errorMessage = "Email salah. Mohon pastikan Anda mengetik email dengan benar";
          _isLoading = false;
        });
      }
      return;
    }
    
    if (password.length < 6) {
      if (mounted) {
        setState(() {
          _errorMessage = "Password harus minimal 6 karakter";
          _isLoading = false;
        });
      }
      return;
    }
    
    // Save login data using SharedPreferences
    try {
      final account = await StorageService.getAccountByEmail(email);
      if (account == null) {
        setState(() {
          _errorMessage = 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
          _isLoading = false;
        });
        return;
      }

      if (account['password'] != password) {
        setState(() {
          _errorMessage = 'Password salah. Mohon cek kembali.';
          _isLoading = false;
        });
        return;
      }

      // Successful login: persist profile to current user data
      await StorageService.saveUserData(
        email: account['email'] ?? email,
        username: account['username'] ?? (email.split('@')[0]),
        fullName: account['fullName'] ?? (email.split('@')[0]),
        school: account['school'] ?? '',
        profileImageUrl: null,
      );
      await StorageService.setLoginStatus(true);

      if (mounted) {
        ModernDialog.showSnack(context, 'Login berhasil');
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Terjadi kesalahan. Silakan coba lagi.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
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
                        'Masuk',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDarkBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Email field
                    CustomTextField(
                      hintText: 'nama@email.com',
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!value.contains('@')) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Password field
                    CustomTextField(
                      hintText: '••••••••',
                      prefixIcon: Icons.lock_outlined,
                      controller: _passwordController,
                      isPassword: true,
                      isPasswordVisible: _isPasswordVisible,
                      onTogglePassword: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ModernDialog.showSnack(context, 'Fitur reset password akan segera tersedia');
                        },
                        child: Text(
                          'Lupa Password?',
                          style: GoogleFonts.poppins(
                            color: AppColors.secondaryLightBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                          CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
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
                                  'Masuk',
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
                    
                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: GoogleFonts.poppins(
                            color: AppColors.textMedium,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              AppAnimations.slidePageRoute(
                                page: const RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Daftar',
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
