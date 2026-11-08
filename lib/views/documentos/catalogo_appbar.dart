// lib/widgets/catalogo_app_bar.dart
import 'package:flutter/foundation.dart'; // kDebugMode
import 'package:flutter/material.dart';
import 'package:solicitud_documentos/models/usuario.dart';
import 'package:solicitud_documentos/models/rol.dart';
import 'package:solicitud_documentos/repository/documento_repository.dart';
import 'package:solicitud_documentos/repository/motivo_repository.dart';
import 'package:solicitud_documentos/repository/solicitud_repository.dart';
import 'package:solicitud_documentos/views/bandeja.dart';
import 'package:solicitud_documentos/views/solicitud/solicitudes.dart';
import 'package:solicitud_documentos/service/firebase/auth_service.dart';
import 'package:solicitud_documentos/service/firebase/crash_service.dart';

class CatalogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CatalogoAppBar({
    super.key,
    required this.usuario,
    required this.authService,
    required this.crashService,
    required this.solicitudRepository,
    required this.documentoRepository,
    required this.motivoRepository,
  });

  final Usuario usuario;
  final AuthService authService;
  final CrashService crashService;
  final SolicitudRepository solicitudRepository;
  final DocumentoRepository documentoRepository;
  final MotivoRepository motivoRepository;

  // Altura estándar del AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _qa(BuildContext context, String value) async {
    if (value == 'fatal') {
      crashService.simulateFatalCrash();
      return;
    }
    try {
      throw StateError('Test non-fatal error');
    } catch (e, s) {
      await crashService.recordNonFatal(e, s, reason: 'QA test');
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Error no fatal registrado')));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Catálogo'),
      actions: [
        if (usuario.rol == Rol.secretaria || usuario.rol == Rol.revisor)
          IconButton(
            tooltip: 'Bandeja',
            icon: const Icon(Icons.inbox),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BandejaSolicitudesScreen(
                  usuario: usuario,
                  solicitudRepository: solicitudRepository,
                  documentoRepository: documentoRepository,
                  motivoRepository: motivoRepository,
                ),
              ),
            ),
          ),
        if (usuario.rol == Rol.estudiante)
          IconButton(
            tooltip: 'Mis solicitudes',
            icon: const Icon(Icons.list_alt),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SolicitudesScreen(
                  usuario: usuario,
                  authService: authService,
                  crashService: crashService,
                  solicitudRepository: solicitudRepository,
                  documentoRepository: documentoRepository,
                  motivoRepository: motivoRepository,
                ),
              ),
            ),
          ),
        if (kDebugMode)
          PopupMenuButton<String>(
            tooltip: 'QA',
            onSelected: (v) => _qa(context, v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'non-fatal', child: Text('Log non-fatal')),
              PopupMenuItem(value: 'fatal', child: Text('Force fatal crash')),
            ],
          ),
        IconButton(
          tooltip: 'Cerrar sesión',
          icon: const Icon(Icons.logout),
          onPressed: authService.logout,
        ),
      ],
    );
  }
}
