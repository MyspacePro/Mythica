import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:mythica/navigation/app_shell.dart';
import 'package:mythica/features/auth/provider/auth_provider.dart';
import 'package:mythica/core/theme/app_colors.dart';
import 'package:mythica/features/auth/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// ✅ NAVIGATION
  void _goToAppShell() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }

  void _goToSignUpScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  /// ✅ LOGIN
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();

    final success = await auth.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Login failed')),
      );
    } else {
      _goToAppShell(); // ✅ FIXED
    }

    setState(() => _isLoading = false);
  }

  /// ✅ SOCIAL LOGIN HANDLER
  Future<void> _handleSocialLogin(
    Future<bool> Function() method,
  ) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    final success = await method();

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Login failed')),
      );
    } else if (auth.requiresProfileCompletion) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete your profile')),
      );
    } else {
      _goToAppShell(); // ✅ FIXED
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Floating Books
          Positioned(
            top: 100,
            left: 20,
            child: Image.asset(
              "assets/books/Book1.png",
              width: 50,
            ).animate(onPlay: (c) => c.repeat()).moveY(
                  begin: -10,
                  end: 10,
                  duration: 3.seconds,
                ),
          ),

          Positioned(
            bottom: 200,
            right: 30,
            child: Image.asset(
              "assets/books/Book2.png",
              width: 60,
            ).animate(onPlay: (c) => c.repeat()).moveY(
                  begin: 15,
                  end: -15,
                  duration: 4.seconds,
                ),
          ),

          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryDark,
                  AppColors.secondaryDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 80),

                    /// LOGO
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book,
                            color: AppColors.premiumYellow, size: 30),
                        SizedBox(width: 10),
                        Text(
                          "Mythica",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightText,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    Image.asset("assets/image/abc.png", height: 180),

                    const SizedBox(height: 50),

                    /// FORM
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 35),
                      decoration: const BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _emailController,
                              hint: "Email",
                              icon: Icons.email,
                            ),

                            const SizedBox(height: 20),

                            _buildTextField(
                              controller: _passwordController,
                              hint: "Password",
                              icon: Icons.lock,
                              isPassword: true,
                            ),

                            const SizedBox(height: 30),

                            _gradientButton(),

                            const SizedBox(height: 20),

                            /// SIGNUP
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                      color: AppColors.lightText),
                                ),
                                GestureDetector(
                                  onTap: _goToSignUpScreen,
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: AppColors.premiumYellow,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 25),

                            /// GOOGLE
                            _socialButton(
                              "Login with Google",
                              () => _handleSocialLogin(
                                  context.read<AuthProvider>().signInWithGoogle),
                            ),

                            const SizedBox(height: 12),

                            /// MICROSOFT
                            _socialButton(
                              "Login with Outlook",
                              () => _handleSocialLogin(context
                                  .read<AuthProvider>()
                                  .signInWithMicrosoft),
                            ),

                            const SizedBox(height: 12),

                            /// GUEST
                            _socialButton(
                              "Continue as Guest",
                              () async {
                                await context
                                    .read<AuthProvider>()
                                    .continueAsGuest();
                                if (!mounted) return;
                                _goToAppShell();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// LOADING OVERLAY
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha:0.4),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  /// TEXT FIELD
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      validator: (value) {
        final text = value?.trim() ?? '';

        if (hint == 'Email') {
          if (text.isEmpty) return 'Email required';
          if (!_emailRegex.hasMatch(text)) return 'Invalid email';
        }

        if (hint == 'Password') {
          if (text.isEmpty) return 'Password required';
          if (text.length < 6) return 'Min 6 characters';
        }

        return null;
      },
      style: const TextStyle(color: AppColors.lightText),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.premiumYellow),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppColors.premiumYellow,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              )
            : null,
        hintText: hint,
        filled: true,
        fillColor: AppColors.secondaryDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  /// LOGIN BUTTON
  Widget _gradientButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleLogin,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.premiumYellow,
              AppColors.premiumYellowDark,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            _isLoading ? "Please wait..." : "LOGIN",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  /// SOCIAL BUTTON
  Widget _socialButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.secondaryDark,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.premiumYellowDark),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.lightText),
          ),
        ),
      ),
    );
  }
}