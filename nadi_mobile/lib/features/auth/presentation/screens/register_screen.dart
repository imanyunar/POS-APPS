import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/features/auth/presentation/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    HapticFeedback.lightImpact();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) return;
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok')),
      );
      return;
    }
    ref.read(authProvider.notifier).register(name, email, password);
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
                  const SizedBox(height: 48),

                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: ServeColors.textPrimary),
                  ),
                  const SizedBox(height: 24),

                  Text('Daftar\nServe',
                      style: ServeTypography.h1(color: ServeColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(
                    'Mulai kelola bisnis F&B Anda.',
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

                  Text('Nama',
                      style: ServeTypography.labelMedium(
                          color: ServeColors.textSecondary)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    style: ServeTypography.bodyLarge(
                        color: ServeColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Nama bisnis atau pemilik',
                      prefixIcon: Icon(Icons.person_outline_rounded,
                          size: 20, color: ServeColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 16),

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
                    textInputAction: TextInputAction.next,
                    style: ServeTypography.bodyLarge(
                        color: ServeColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Minimal 8 karakter',
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
                  const SizedBox(height: 16),

                  Text('Konfirmasi Password',
                      style: ServeTypography.labelMedium(
                          color: ServeColors.textSecondary)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _register(),
                    style: ServeTypography.bodyLarge(
                        color: ServeColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Ulangi password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded,
                          size: 20, color: ServeColors.textMuted),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: ServeColors.textMuted,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  FilledButton(
                    onPressed: authState.status == AuthStatus.loading
                        ? null
                        : _register,
                    child: authState.status == AuthStatus.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Daftar'),
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'Sudah punya akun? ',
                        style: ServeTypography.bodyMedium(
                            color: ServeColors.textSecondary),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => context.pop(),
                              child: Text('Masuk',
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
