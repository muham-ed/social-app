import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(RegisterRequested(
          name: _name.text.trim(),
          username: _username.text.trim(),
          email: _email.text.trim(),
          password: _pass.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: BlocConsumer<AuthBloc, AuthState>(
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
                children: [
                  AppTextField(controller: _name, hint: 'الاسم الكامل', icon: Icons.badge_outlined,
                      validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null),
                  const SizedBox(height: 16),
                  AppTextField(controller: _username, hint: 'اسم المستخدم', icon: Icons.alternate_email,
                      validator: (v) => v == null || v.length < 3 ? '3 أحرف على الأقل' : null),
                  const SizedBox(height: 16),
                  AppTextField(controller: _email, hint: 'البريد الإلكتروني', icon: Icons.email_outlined,
                      validator: (v) => v == null || !v.contains('@') ? 'بريد غير صالح' : null),
                  const SizedBox(height: 16),
                  AppTextField(controller: _pass, hint: 'كلمة المرور', icon: Icons.lock_outline, obscure: true,
                      validator: (v) => v == null || v.length < 6 ? '6 أحرف على الأقل' : null),
                  const SizedBox(height: 28),
                  PrimaryButton(label: 'إنشاء حساب', loading: loading, onPressed: _submit),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}