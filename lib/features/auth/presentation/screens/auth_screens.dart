import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/state_providers.dart';
import '../../../../widgets/glass_widgets.dart';

// --- SPLASH SCREEN ---
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTransition();
  }

  void _startTransition() async {
    await Future.delayed(const Duration(seconds: 3));
    final authState = ref.read(authProvider);
    if (mounted) {
      if (authState.user != null) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.darkBg, Color(0xFF1E1E38)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Glow Outer circle
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryLight, width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.blur_linear_rounded, color: Colors.white, size: 54),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'GLASSBOARD',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'TRANSPARENT AUDITING & WORKFLOW DEP',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppColors.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 64),
              const SpinKitFadingCircle(
                color: AppColors.primaryLight,
                size: 32.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- LOGIN SCREEN ---
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(authProvider.notifier).login(
        _emailController.text,
        _passwordController.text,
      );
      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        final err = ref.read(authProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err ?? 'Sign in failed.'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  void _quickLogin(String email) {
    _emailController.text = email;
    _passwordController.text = 'password123';
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.darkBg, Color(0xFF131A26)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              // Brand
              const Icon(Icons.blur_linear_rounded, color: AppColors.primaryLight, size: 54),
              const SizedBox(height: 12),
              const Text(
                'GLASSBOARD',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),

              // Form Glass Card
              Form(
                key: _formKey,
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Sign in to trace dependency bottlenecks.',
                        style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
                      ),
                      const SizedBox(height: 24),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Corporate Email',
                          prefixIcon: Icon(Icons.email_outlined, color: AppColors.textDarkSecondary),
                        ),
                        validator: (value) => value == null || !value.contains('@') ? 'Enter a valid corporate email.' : null,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.textDarkSecondary),
                        ),
                        validator: (value) => value == null || value.length < 6 ? 'Password must exceed 5 characters.' : null,
                      ),
                      const SizedBox(height: 8),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                          child: const Text('Forgot Password?', style: TextStyle(color: AppColors.primaryLight, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Login button
                      GlassButton(
                        text: 'SIGN IN',
                        isLoading: authState.isLoading,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Hackathon Quick Switch Panel
              const Text(
                'HACKATHON ROLE QUICK LOGINS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: AppColors.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _buildQuickLoginChip('Lead Dev', 'ayush@glassboard.com', AppColors.primary),
                  _buildQuickLoginChip('Org Head', 'director@glassboard.com', AppColors.accent),
                  _buildQuickLoginChip('Admin', 'admin@glassboard.com', AppColors.warning),
                  _buildQuickLoginChip('Lead Design', 'sarah@glassboard.com', AppColors.success),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New to the portal? ', style: TextStyle(color: AppColors.textDarkSecondary, fontSize: 13)),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text('Register Here', style: TextStyle(color: AppColors.primaryLight, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLoginChip(String label, String email, Color color) {
    return ActionChip(
      onPressed: () => _quickLogin(email),
      backgroundColor: color.withOpacity(0.12),
      side: BorderSide(color: color.withOpacity(0.4)),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// --- REGISTER SCREEN ---
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'employee';
  String? _selectedModuleId = 'mod_dev';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(authProvider.notifier).register(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _selectedRole,
        _selectedRole == 'org_head' || _selectedRole == 'admin' ? null : _selectedModuleId,
      );
      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        final err = ref.read(authProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err ?? 'Signup failed.'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Back')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Create Profile',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Register to participate in multi-department workflow handshakes.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
              ),
              const SizedBox(height: 24),

              Form(
                key: _formKey,
                child: GlassCard(
                  child: Column(
                    children: [
                      // Full Name
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Display Name',
                          prefixIcon: Icon(Icons.person_outline, color: AppColors.textDarkSecondary),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Display name required.' : null,
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Corporate Email Address',
                          prefixIcon: Icon(Icons.email_outlined, color: AppColors.textDarkSecondary),
                        ),
                        validator: (value) => value == null || !value.contains('@') ? 'Enter a valid corporate email.' : null,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.textDarkSecondary),
                        ),
                        validator: (value) => value == null || value.length < 6 ? 'Password must exceed 5 characters.' : null,
                      ),
                      const SizedBox(height: 20),

                      // Role Select Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        dropdownColor: AppColors.darkCard,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'System Access Role',
                          prefixIcon: Icon(Icons.manage_accounts_rounded, color: AppColors.textDarkSecondary),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'employee', child: Text('Employee')),
                          DropdownMenuItem(value: 'lead', child: Text('Department Lead')),
                          DropdownMenuItem(value: 'org_head', child: Text('Organization Head')),
                          DropdownMenuItem(value: 'admin', child: Text('System Administrator')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedRole = val);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Module select (only for employees/leads)
                      if (_selectedRole == 'employee' || _selectedRole == 'lead')
                        DropdownButtonFormField<String>(
                          value: _selectedModuleId,
                          dropdownColor: AppColors.darkCard,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Department Module Assignment',
                            prefixIcon: Icon(Icons.domain_rounded, color: AppColors.textDarkSecondary),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'mod_design', child: Text('Design Studio')),
                            DropdownMenuItem(value: 'mod_dev', child: Text('Software Development')),
                            DropdownMenuItem(value: 'mod_qa', child: Text('Quality Assurance')),
                            DropdownMenuItem(value: 'mod_deploy', child: Text('Release Operations')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedModuleId = val);
                          },
                        ),
                      const SizedBox(height: 24),

                      GlassButton(
                        text: 'CREATE ACCOUNT',
                        isLoading: authState.isLoading,
                        onPressed: _submit,
                      )
                    ],
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

// --- FORGOT PASSWORD SCREEN ---
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Back')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.key_rounded, color: AppColors.primaryLight, size: 54),
            const SizedBox(height: 16),
            const Text(
              'Reset Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your registered email address and we will forward password reset credentials.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textDarkSecondary),
            ),
            const SizedBox(height: 32),
            GlassCard(
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Corporate Email',
                      prefixIcon: Icon(Icons.email_outlined, color: AppColors.textDarkSecondary),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GlassButton(
                    text: 'SEND RESET CODE',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reset credentials forwarded to email.'), backgroundColor: AppColors.success),
                      );
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
