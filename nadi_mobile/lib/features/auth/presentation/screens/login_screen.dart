import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    HapticFeedback.lightImpact();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) return;
    ref.read(authProvider.notifier).login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go('/dashboard');
      }
    });

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64),

                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: ServeColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.store_rounded,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 32),

                  Text('Masuk ke\nServe',
                      style: ServeTypography.h1(color: ServeColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(
                    'Kelola bisnis F&B Anda dari satu tempat.',
                    style: ServeTypography.bodyMedium(color: ServeColors.textSecondary),
                  ),
                  const SizedBox(height: 12),

                  if (authState.error != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ServeColors.dangerBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ServeColors.danger.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              size: 18, color: ServeColors.danger),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(authState.error!,
                                style: ServeTypography.bodySmall(
                                    color: ServeColors.danger)),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 28),

                  Text('Email',
                      style: ServeTypography.labelMedium(
                          color: ServeColors.textSecondary)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: ServeTypography.bodyLarge(
                        color: ServeColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'email@serve.app',
                      prefixIcon: Icon(Icons.mail_outline_rounded,
                          size: 20, color: ServeColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text('Password',
                      style: ServeTypography.labelMedium(
                          color: ServeColors.textSecondary)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _login(),
                    style: ServeTypography.bodyLarge(
                        color: ServeColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline_rounded,
                          size: 20, color: ServeColors.textMuted),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: ServeColors.textMuted,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  FilledButton(
                    onPressed: authState.status == AuthStatus.loading
                        ? null
                        : _login,
                    child: authState.status == AuthStatus.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Masuk'),
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'Belum punya akun? ',
                        style: ServeTypography.bodyMedium(
                            color: ServeColors.textSecondary),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => context.push('/auth/register'),
                              child: Text('Daftar sekarang',
                                  style: ServeTypography.bodyMedium(
                                      color: ServeColors.primary)),
                            ),
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
      ),
    );
  }
}
