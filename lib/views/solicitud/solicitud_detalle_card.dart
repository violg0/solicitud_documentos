// lib/widgets/solicitud_detalle_card.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:flutter/material.dart';
import 'package:solicitud_documentos/models/documento.dart';
import 'package:solicitud_documentos/models/estados.dart';
import 'package:solicitud_documentos/models/motivo.dart';
import 'package:solicitud_documentos/models/rol.dart';
import 'package:solicitud_documentos/models/solicitud.dart';
import 'package:solicitud_documentos/models/usuario.dart';
import 'package:solicitud_documentos/repository/motivo_repository.dart';
import 'package:solicitud_documentos/repository/solicitud_repository.dart';
import 'package:solicitud_documentos/service/firebase/usuario_service.dart';
import 'package:solicitud_documentos/validators/solicitud_validators.dart';
import 'package:uuid/uuid.dart';

class SolicitudDetalleCard extends StatefulWidget {
  const SolicitudDetalleCard({
    super.key,
    required this.solicitud,
    required this.documento,
    required this.usuario,
    required this.solicitudRepository,
    required this.motivoRepository,
    this.pendienteSync = false,
    this.usuarioService,
  });

  final Solicitud solicitud;
  final Documento documento;
  final Usuario usuario; // current user: uid + rol
  final SolicitudRepository solicitudRepository;
  final MotivoRepository motivoRepository;

  /// Para mostrar el nombre del solicitante / de quien entregó en vez del uid.
  /// Solo revisor y secretaria pueden leer perfiles ajenos (ver las reglas);
  /// si es null o la búsqueda falla, se muestra el uid.
  final UsuarioService? usuarioService;

  /// true si la solicitud sigue pendiente de subir a Firestore (Drift).
  final bool pendienteSync;

  @override
  State<SolicitudDetalleCard> createState() => _SolicitudDetalleCardState();
}

class _SolicitudDetalleCardState extends State<SolicitudDetalleCard> {
  late Solicitud _solicitud = widget.solicitud; // local copy, estado changes
  bool _procesando = false; // true mientras se cambia el estado
  late Future<List<Motivo>> _motivos = _cargarMotivos();
  late final Future<String> _solicitante = _nombreDe(widget.solicitud.idUsuario);
  // Se calcula una sola vez; la entrega solo ocurre en este estado final.
  Future<String>? _entregador;

  Future<List<Motivo>> _cargarMotivos() async {
    final lista = await widget.motivoRepository.obtenerPorSolicitud(
      _solicitud.id,
    );
    return lista..sort((a, b) => a.fechaCreacion.compareTo(b.fechaCreacion));
  }

  // Nombre (o correo si no hay nombre) del usuario `uid`. Ante cualquier fallo
  // (sin conexión, sin permiso, no existe) devuelve el uid: nunca rompe.
  Future<String> _nombreDe(String uid) async {
    final servicio = widget.usuarioService;
    if (servicio == null) return uid;
    try {
      final u = await servicio
          .obtenerPorId(uid)
          .timeout(const Duration(seconds: 8));
      if (u == null) return uid;
      if (u.nombre.trim().isNotEmpty) return u.nombre.trim();
      if (u.email.trim().isNotEmpty) return u.email.trim();
      return uid;
    } catch (_) {
      return uid;
    }
  }

  // Muestra "etiqueta: <nombre>"; mientras busca no pinta el uid crudo.
  Widget _lineaUsuario(String etiqueta, Future<String> nombre) =>
      FutureBuilder<String>(
        future: nombre,
        builder: (context, snap) =>
            Text('$etiqueta: ${snap.data ?? 'cargando…'}'),
      );

  // Las fechas se guardan en UTC; se muestran en la hora del dispositivo.
  String _fecha(DateTime d) => d.toLocal().toString().substring(0, 16);

  Future<String?> _pedirMensaje() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mensaje del cambio'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<void> _cambiar(EstadoSolicitud nuevo) async {
    if (_procesando) return; // evita dobles toques mientras se procesa
    setState(() => _procesando = true);
    try {
      final mensaje = await _pedirMensaje();
      if (mensaje == null) return; // user went back
      // El mensaje también viaja como observacionRevision cuando el revisor
      // aprueba o rechaza.
      final actualizada = await widget.solicitudRepository.cambiarEstado(
        _solicitud,
        nuevo,
        widget.usuario,
        observacion: mensaje,
      );
      await widget.motivoRepository.crear(
        Motivo(
          id: const Uuid().v4(), // único, generado aquí como en Solicitud
          idSolicitud: _solicitud.id,
          mensaje: mensaje,
          estado: nuevo,
          fechaCreacion: DateTime.now().toUtc(),
        ),
      );
      if (!mounted) return;
      setState(() {
        _solicitud = actualizada;
        _motivos = _cargarMotivos();
      });
    } catch (e) {
      if (!mounted) return;
      // El servidor rechaza transiciones inválidas (p. ej. entregar dos veces
      // desde una pantalla desactualizada) y las solicitudes que aún no
      // existen en Firestore: se explica en vez de mostrar el error técnico.
      final mensaje = switch (e) {
        FirebaseException(code: 'permission-denied') =>
          'Esta solicitud ya cambió de estado. Vuelve a la bandeja y '
              'actualízala.',
        FirebaseException(code: 'not-found') =>
          'Esta solicitud aún no se sincroniza con el servidor. '
              'Inténtalo de nuevo cuando termine de sincronizar.',
        _ => e.toString().replaceFirst('Exception: ', ''),
      };
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensaje)));
    } finally {
      if (mounted) setState(() => _procesando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.documento;
    // Only the transitions this user can actually perform
    final acciones = EstadoSolicitud.values.where(
      (e) =>
          SolicitudValidators.validarCambioEstado(
            _solicitud,
            e,
            widget.usuario,
          ) ==
          null,
    );
    final esEstudiante = widget.usuario.rol == Rol.estudiante;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Image.network(
          doc.imagen,
          height: 160,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const Icon(Icons.description, size: 80),
        ),
        const SizedBox(height: 12),
        Text(doc.nombre, style: Theme.of(context).textTheme.headlineSmall),
        Text(doc.descripcion),
        const Divider(height: 32),
        Text('Período: ${_solicitud.periodo}'),
        if (_solicitud.observacionEstudiante.isNotEmpty)
          Text('Observación: ${_solicitud.observacionEstudiante}'),
        if (_solicitud.observacionRevision != null &&
            _solicitud.observacionRevision!.isNotEmpty)
          Text('Observación de revisión: ${_solicitud.observacionRevision}'),
        // El estudiante ya sabe que la solicitud es suya.
        if (!esEstudiante) _lineaUsuario('Solicitante', _solicitante),
        Text('Creada: ${_fecha(_solicitud.fechaCreacion)}'),
        Text('Última modificación: ${_fecha(_solicitud.fechaModificacion)}'),
        if (_solicitud.fechaEntrega != null)
          Text('Entregada: ${_fecha(_solicitud.fechaEntrega!)}'),
        if (_solicitud.entregadoPor != null)
          _lineaUsuario(
            'Entregada por',
            _entregador ??= _nombreDe(_solicitud.entregadoPor!),
          ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            Chip(label: Text(_solicitud.estado.etiqueta)),
            if (widget.pendienteSync)
              const Chip(
                avatar: Icon(Icons.schedule, size: 18),
                label: Text('Pendiente de sincronizar'),
              ),
          ],
        ),
        if (acciones.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final e in acciones)
                FilledButton(
                  onPressed: _procesando ? null : () => _cambiar(e),
                  child: Text(
                    e == EstadoSolicitud.cancelada
                        ? 'Cancelar solicitud'
                        : e.etiqueta,
                  ),
                ),
            ],
          ),
        ],
        const Divider(height: 32),
        Text('Historial', style: Theme.of(context).textTheme.titleMedium),
        FutureBuilder<List<Motivo>>(
          future: _motivos,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return const Text('No se pudo cargar el historial');
            }
            final motivos = snap.data!;
            if (motivos.isEmpty) return const Text('Sin cambios registrados');
            return Column(
              children: [
                for (final m in motivos)
                  ListTile(
                    title: Text(m.estado.etiqueta),
                    subtitle: Text(m.mensaje),
                    trailing: Text(_fecha(m.fechaCreacion)),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
