import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solicitud_documentos/service/firebase/auth_service.dart';
import 'package:solicitud_documentos/service/firebase/crash_service.dart';
import 'package:solicitud_documentos/service/firebase/usuario_service.dart';
import 'package:solicitud_documentos/views/documentos/catalogo.dart';
import 'package:solicitud_documentos/views/login/login.dart';

import '../../models/usuario.dart';
import '../../repository/documento_repository.dart';
import '../../repository/motivo_repository.dart';
import '../../repository/solicitud_repository.dart';

// import de CatalogoScreen

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.authService,
    required this.usuarioService,
    required this.crashService,
    required this.solicitudRepository,
    required this.documentoRepository,
    required this.motivoRepository,
  });

  final AuthService authService;
  final UsuarioService usuarioService;
  final CrashService crashService;
  final SolicitudRepository solicitudRepository;
  final DocumentoRepository documentoRepository;
  final MotivoRepository motivoRepository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const _Cargando();
        }
        final user = authSnap.data;
        if (user == null) return LoginPage(authService: authService);

        unawaited(crashService.setUserIdentifier(user.uid));

        return StreamBuilder<Usuario?>(
          stream: usuarioService.observar(user.uid),
          builder: (context, perfilSnap) {
            final usuario = perfilSnap.data;
            if (usuario == null) {
              return const _Cargando(); // perfil aún no guardado
            }
            return CatalogoScreen(
              usuario: usuario,
              authService: authService,
              crashService: crashService,
              solicitudRepository: solicitudRepository,
              documentoRepository: documentoRepository,
              motivoRepository: motivoRepository,
            );
          },
        );
      },
    );
  }
}

class _Cargando extends StatelessWidget {
  const _Cargando();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
