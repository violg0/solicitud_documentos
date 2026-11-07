import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:solicitud_documentos/service/firebase/crash_service.dart';

import 'firebase_options.dart';
import 'views/catalogo.dart';

// import de CatalogoScreen como ya lo tenías

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const crashService = CrashService();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await crashService.configure(); // solo si Firebase quedó listo
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null) {
      unawaited(crashService.setUserIdentifier(usuario.uid));
    }
  } catch (e) {
    debugPrint('No se pudo inicializar Firebase: $e');
  }

  runApp(const MyApp(crashService: crashService));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.crashService});

  final CrashService crashService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiendaTech',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: CatalogoScreen(crashService: crashService),
    );
  }
}
