import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:solicitud_documentos/views/login/auth_gate.dart';
import 'package:solicitud_documentos/views/bandeja.dart';

import 'firebase_options.dart';
import 'local/app_database.dart';
import 'local/documento_local_data_source.dart';
import 'local/motivo_local_data_source.dart';
import 'local/solicitud_local_data_source.dart';
import 'repository/documento_repository.dart';
import 'repository/motivo_repository.dart';
import 'repository/solicitud_repository.dart';
import 'service/api/documento_service.dart';
import 'service/firebase/motivo_service.dart';
import 'service/firebase/solicitud_service.dart';
import 'service/firebase/auth_service.dart';
import 'service/firebase/crash_service.dart';
import 'service/firebase/usuario_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final crashService = CrashService();
  var firebaseReady = false;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
    await crashService.configure();
  } catch (e) {
    debugPrint('No se pudo inicializar Firebase: $e');
  }

  final usuarioService = UsuarioService(crashService: crashService);
  final firebaseAuth = firebaseReady
      ? FirebaseAuthService(usuarioService)
      : null;

  final db = AppDatabase();
  final solicitudLocal = SolicitudLocalDataSource(db);
  final motivoLocal = MotivoLocalDataSource(db);
  final documentoRepository = DocumentoRepository(
    local: DocumentoLocalDataSource(db),
    remote: DocumentoService(
      'https://6aee1a6ca677fe0fc14fc05f.mockapi.io/documentos',
    ),
  );
  final solicitudRepository = SolicitudRepository(
    local: solicitudLocal,
    remote: SolicitudService(crashService: crashService),
    documentoRepository: documentoRepository,
  );
  final motivoRepository = MotivoRepository(
    local: motivoLocal,
    remote: MotivoService(crashService: crashService),
  );

  // Aislamiento por cuenta: al cerrar sesión se intenta subir lo pendiente de
  // esa cuenta (máx. 8 s) y se borra la copia local de solicitudes ya
  // sincronizadas y de motivos, para que otra cuenta en el mismo dispositivo
  // no vea esos datos. Las solicitudes que no lograron subir se conservan
  // (no se pierden) y siguen aisladas: solo su dueño las ve o las sincroniza.
  final authService = HybridAuthService(
    firebase: firebaseAuth,
    beforeLogout: (uid) async {
      if (uid != null) {
        try {
          await solicitudRepository
              .syncPending(idUsuario: uid)
              .timeout(const Duration(seconds: 8));
        } catch (_) {
          // Sin red: quedan pendientes y se conservan.
        }
      }
      await solicitudLocal.borrarSincronizadas();
      await motivoLocal.borrarTodos();
    },
  );

  runApp(
    MyApp(
      solicitudRepository: solicitudRepository,
      documentoRepository: documentoRepository,
      motivoRepository: motivoRepository,
      authService: authService,
      usuarioService: usuarioService,
      crashService: crashService,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
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
    return MaterialApp(
      title: 'Solicitudes de documentos académicos',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      navigatorObservers: [bandejaRouteObserver],
      home: AuthGate(
        authService: authService,
        usuarioService: usuarioService,
        crashService: crashService,
        solicitudRepository: solicitudRepository,
        documentoRepository: documentoRepository,
        motivoRepository: motivoRepository,
      ),
    );
  }
}
