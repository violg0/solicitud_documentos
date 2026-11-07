import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'service/firebase/auth_service.dart';
import 'service/firebase/crash_service.dart';
import 'service/firebase/usuario_service.dart';
import 'views/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final crashService = CrashService();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await crashService.configure();
  } catch (e) {
    debugPrint('No se pudo inicializar Firebase: $e');
  }

  final usuarioService = UsuarioService(crashService: crashService);
  final authService = FirebaseAuthService(usuarioService);

  runApp(MyApp(
    authService: authService,
    usuarioService: usuarioService,
    crashService: crashService,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.authService,
    required this.usuarioService,
    required this.crashService,
  });

  final AuthService authService;
  final UsuarioService usuarioService;
  final CrashService crashService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solicitudes de documentos académicos',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: AuthGate(
        authService: authService,
        usuarioService: usuarioService,
        crashService: crashService,
      ),
    );
  }
}