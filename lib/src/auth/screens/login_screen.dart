import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../auth_controller.dart';
import '../../common/toast.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = ref.read(authControllerProvider.notifier);
    final ok = await auth.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      AppToast.show('Welcome back!', type: ToastType.success);
      // Pop back to AuthGate if we were pushed here
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  void _togglePassword() => setState(() => _obscure = !_obscure);

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    const accent = Color(0xFFFF7A00);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=900&q=80',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.85),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _iconBadge(accent),
                    const SizedBox(height: 28),
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to continue your food journey.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    _frostedContainer(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _inputField(
                              controller: _emailController,
                              hint: 'example@email.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Enter your email'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _inputField(
                              controller: _passwordController,
                              hint: '••••••••',
                              obscure: _obscure,
                              validator: (v) => v != null && v.length >= 6
                                  ? null
                                  : 'Password must be at least 6 characters',
                              suffix: IconButton(
                                onPressed: _togglePassword,
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  AppToast.show(
                                    'Forgot password coming soon',
                                    type: ToastType.info,
                                  );
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: Colors.orangeAccent),
                                ),
                              ),
                            ),
                            if (authState.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  authState.errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            _gradientButton(
                              text: authState.isLoading
                                  ? 'Loading...'
                                  : 'Login',
                              accent: accent,
                              onPressed: authState.isLoading ? null : _submit,
                            ),
                            const SizedBox(height: 16),
                            _dividerText('or continue with'),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _socialButton(
                                    label: 'Google',
                                    icon: Icons.g_mobiledata,
                                    onPressed: () {
                                      AppToast.show(
                                        'Google sign-in coming soon',
                                        type: ToastType.info,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _socialButton(
                                    label: 'Apple',
                                    icon: Icons.apple,
                                    onPressed: () {
                                      AppToast.show(
                                        'Apple sign-in coming soon',
                                        type: ToastType.info,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Don't have an account?  Sign Up",
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _frostedContainer({required Widget child}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: child,
      ),
    ),
  );
}

Widget _inputField({
  required TextEditingController controller,
  required String hint,
  bool obscure = false,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
  Widget? suffix,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscure,
    validator: validator,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: Colors.black.withOpacity(0.35),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffix,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.orangeAccent),
      ),
    ),
  );
}

Widget _gradientButton({
  required String text,
  required Color accent,
  required VoidCallback? onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, Colors.deepOrange],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
}

Widget _dividerText(String text) {
  return Row(
    children: [
      const Expanded(child: Divider(color: Colors.white24, thickness: 0.8)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(text, style: const TextStyle(color: Colors.white60)),
      ),
      const Expanded(child: Divider(color: Colors.white24, thickness: 0.8)),
    ],
  );
}

Widget _socialButton({
  required String label,
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    height: 48,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.35),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    ),
  );
}

Widget _iconBadge(Color accent) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.35),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withOpacity(0.15)),
    ),
    child: Icon(Icons.cookie_outlined, color: accent),
  );
}
