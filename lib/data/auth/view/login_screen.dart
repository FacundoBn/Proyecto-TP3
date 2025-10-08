import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../auth/state/auth_provider.dart';
class LoginScreen extends StatefulWidget { const LoginScreen({super.key}); @override State<LoginScreen> createState() => _LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController(text: 'admin@demo.com');
  final passCtrl = TextEditingController(text: '123456');
  @override void dispose() { emailCtrl.dispose(); passCtrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              AppTextField(controller: emailCtrl, label: 'Email'),
              const SizedBox(height: 12),
              AppTextField(controller: passCtrl, label: 'Clave', obscure: true),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Ingresar', loading: auth.loading,
                onPressed: () async {
                  final ok = await context.read<AuthProvider>().login(emailCtrl.text, passCtrl.text);
                  if (!mounted) return;
                  if (ok) context.go('/home');
                  else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email o clave incorrectos')));
                },
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: ()=>context.go('/register'), child: const Text('Crear cuenta nueva')),
            ]),
          ),
        ),
      ),
    );
  }
}
