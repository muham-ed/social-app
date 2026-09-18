import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _idCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(LoginRequested(
          emailOrUsername: _idCtrl.text.trim(),
          password: _passCtrl.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is AuthAuthenticated) context.go('/home');
          },
          builder: (context, state) {
            final loading = state is AuthLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    const Text('أهلاً بك 👋',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('سجّل دخولك للمتابعة', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 40),
                    AppTextField(
                      controller: _idCtrl,
                      hint: 'البريد الإلكتروني أو اسم المستخدم',
                      icon: Icons.person_outline,
                      validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passCtrl,
                      hint: 'كلمة المرور',
                      icon: Icons.lock_outline,
                      obscure: true,
                      validator: (v) => v == null || v.length < 6 ? '6 أحرف على الأقل' : null,
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      label: 'تسجيل الدخول',
                      loading: loading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text('ليس لديك حساب؟ أنشئ واحد'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}