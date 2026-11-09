import 'dart:async';

import 'package:flutter/material.dart';
import 'package:solicitud_documentos/service/firebase/auth_service.dart';
import 'package:solicitud_documentos/service/firebase/crash_service.dart';
import 'package:solicitud_documentos/service/firebase/usuario_service.dart';
import 'package:solicitud_documentos/views/bandeja.dart';
import 'package:solicitud_documentos/views/documentos/catalogo.dart';
import 'package:solicitud_documentos/views/login/login.dart';

import '../../models/rol.dart';
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
    return StreamBuilder<AppAuthUser?>(
      stream: authService.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const _Cargando();
        }
        final user = authSnap.data;
        if (user == null) return LoginPage(authService: authService);

        unawaited(crashService.setUserIdentifier(user.uid));
        return _PerfilGate(
          authService: authService,
          uid: user.uid,
          crashService: crashService,
          solicitudRepository: solicitudRepository,
          documentoRepository: documentoRepository,
          motivoRepository: motivoRepository,
          usuarioService: usuarioService,
        );
      },
    );
  }
}

class _PerfilGate extends StatefulWidget {
  const _PerfilGate({
    required this.authService,
    required this.uid,
    required this.crashService,
    required this.solicitudRepository,
    required this.documentoRepository,
    required this.motivoRepository,
    required this.usuarioService,
  });

  final UsuarioService usuarioService;

  final AuthService authService;
  final String uid;
  final CrashService crashService;
  final SolicitudRepository solicitudRepository;
  final DocumentoRepository documentoRepository;
  final MotivoRepository motivoRepository;

  @override
  State<_PerfilGate> createState() => _PerfilGateState();
}

class _PerfilGateState extends State<_PerfilGate> {
  late Future<Usuario?> _perfil;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  void _cargarPerfil() {
    _perfil = widget.authService.obtenerPerfil(widget.uid);
  }

  void _reintentar() {
    setState(_cargarPerfil);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario?>(
      future: _perfil,
      builder: (context, perfilSnap) {
        if (perfilSnap.connectionState != ConnectionState.done) {
          return const _Cargando();
        }
        if (perfilSnap.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Perfil no disponible'),
              actions: [
                IconButton(
                  tooltip: 'Cerrar sesión',
                  icon: const Icon(Icons.logout),
                  onPressed: widget.authService.logout,
                ),
              ],
            ),
            body: _ErrorPerfil(
              mensaje: 'No se pudo consultar tu perfil en Firebase.',
              onRetry: _reintentar,
              onLogout: widget.authService.logout,
            ),
          );
        }
        final usuario = perfilSnap.data;
        if (usuario == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Perfil no disponible'),
              actions: [
                IconButton(
                  tooltip: 'Cerrar sesión',
                  icon: const Icon(Icons.logout),
                  onPressed: widget.authService.logout,
                ),
              ],
            ),
            body: _ErrorPerfil(
              mensaje: 'No existe un perfil para este usuario.',
              onRetry: _reintentar,
              onLogout: widget.authService.logout,
            ),
          );
        }
        if (usuario.rol == Rol.revisor || usuario.rol == Rol.secretaria) {
          return BandejaSolicitudesScreen(
            usuario: usuario,
            authService: widget.authService,
            solicitudRepository: widget.solicitudRepository,
            documentoRepository: widget.documentoRepository,
            motivoRepository: widget.motivoRepository,
            usuarioService: widget.usuarioService,
          );
        }
        return CatalogoScreen(
          usuario: usuario,
          authService: widget.authService,
          crashService: widget.crashService,
          solicitudRepository: widget.solicitudRepository,
          documentoRepository: widget.documentoRepository,
          motivoRepository: widget.motivoRepository,
        );
      },
    );
  }
}

class _ErrorPerfil extends StatelessWidget {
  const _ErrorPerfil({
    required this.mensaje,
    required this.onRetry,
    required this.onLogout,
  });

  final String mensaje;
  final VoidCallback onRetry;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 56),
            const SizedBox(height: 16),
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
            TextButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Volver al inicio de sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cargando extends StatelessWidget {
  const _Cargando();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
