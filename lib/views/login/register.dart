// lib/pages/register_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solicitud_documentos/models/rol.dart';
import 'package:solicitud_documentos/service/firebase/auth_service.dart';
import 'package:solicitud_documentos/views/login/auth_errors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.authService});

  final AuthService authService;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nombre = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _error;
  bool _cargando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (_nombre.text.trim().isEmpty || _password.text.length < 6) {
      setState(
        () => _error = 'Nombre obligatorio y contraseña de mínimo 6 caracteres',
      );
      return;
    }
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      await widget.authService.register(
        nombre: _nombre.text,
        email: _email.text,
        password: _password.text,
        // Quien se autorregistra siempre es estudiante; revisor y secretaria
        // solo se asignan manualmente desde la consola de Firebase.
        rol: Rol.estudiante,
      );
      if (mounted) Navigator.pop(context); // AuthGate ya muestra el catálogo
    } on FirebaseAuthException catch (e) {
      _error = mensajeErrorAuth(e);
    } catch (_) {
      _error = mensajeErrorGenerico;
    }
    if (mounted) setState(() => _cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nombre,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            if (_error != null) Text(_error!),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _cargando ? null : _registrar,
              child: Text(_cargando ? 'Registrando...' : 'Registrarme'),
            ),
          ],
        ),
      ),
    );
  }
}
