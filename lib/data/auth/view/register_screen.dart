import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../auth/state/auth_provider.dart';
class RegisterScreen extends StatefulWidget { const RegisterScreen({super.key}); @override State<RegisterScreen> createState() => _RegisterScreenState(); }
class _RegisterScreenState extends State<RegisterScreen> {
  final emailCtrl = TextEditingController(); final passCtrl = TextEditingController(); final pass2Ctrl = TextEditingController();
  @override void dispose() { emailCtrl.dispose(); passCtrl.dispose(); pass2Ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              AppTextField(controller: emailCtrl, label: 'Email'),
              const SizedBox(height: 12),
              AppTextField(controller: passCtrl, label: 'Clave', obscure: true),
              const SizedBox(height: 12),
              AppTextField(controller: pass2Ctrl, label: 'Repetir clave', obscure: true),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Registrarme', loading: auth.loading,
                onPressed: () async {
                  if (passCtrl.text != pass2Ctrl.text) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Las claves no coinciden'))); return; }
                  if (emailCtrl.text.trim().isEmpty || passCtrl.text.trim().isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completar email y clave'))); return; }
                  final ok = await context.read<AuthProvider>().registerAndLogin(emailCtrl.text, passCtrl.text);
                  if (!mounted) return;
                  if (ok) context.go('/home'); else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo registrar')));
                },
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: ()=>context.go('/login'), child: const Text('Ya tengo cuenta. Ingresar')),
            ]),
          ),
        ),
      ),
    );
  }
}
