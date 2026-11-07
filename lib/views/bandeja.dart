// lib/pages/bandeja_solicitudes_screen.dart
import 'package:flutter/material.dart';

import '../models/documento.dart';
import '../models/estados.dart';
import '../models/solicitud.dart';
import '../models/usuario.dart';
import '../repository/documento_repository.dart'; // ajusta rutas
import '../repository/motivo_repository.dart';
import '../repository/solicitud_repository.dart';
import 'solicitud/solicitud_detalle_card.dart';

class BandejaSolicitudesScreen extends StatefulWidget {
  const BandejaSolicitudesScreen({
    super.key,
    required this.usuario,
    required this.solicitudRepository,
    required this.documentoRepository,
    required this.motivoRepository,
  });

  final Usuario usuario;
  final SolicitudRepository solicitudRepository;
  final DocumentoRepository documentoRepository;
  final MotivoRepository motivoRepository;

  @override
  State<BandejaSolicitudesScreen> createState() =>
      _BandejaSolicitudesScreenState();
}

class _BandejaSolicitudesScreenState extends State<BandejaSolicitudesScreen> {
  static const _colores = {
    EstadoSolicitud.solicitada: Colors.blue,
    EstadoSolicitud.enRevision: Colors.orange,
    EstadoSolicitud.aprobada: Colors.green,
    EstadoSolicitud.rechazada: Colors.red,
    EstadoSolicitud.entregada: Colors.teal,
    EstadoSolicitud.cancelada: Colors.grey,
  };

  late Future<(List<Solicitud>, Map<String, Documento>)> _datos = _cargar();

  Future<(List<Solicitud>, Map<String, Documento>)> _cargar() async {
    final r = await Future.wait([
      widget.solicitudRepository.obtenerSolicitudes(),
      widget.documentoRepository.obtenerTodos(),
    ]);
    final docs = {for (final d in r[1] as List<Documento>) d.id: d};
    return (r[0] as List<Solicitud>, docs);
  }

  Future<void> _abrir(Solicitud s, Documento doc) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Detalle de la solicitud')),
          body: SolicitudDetalleCard(
            solicitud: s,
            documento: doc,
            usuario: widget.usuario,
            solicitudRepository: widget.solicitudRepository,
            motivoRepository: widget.motivoRepository,
          ),
        ),
      ),
    );
    // Al volver, el estado pudo cambiar: recargamos la bandeja
    if (mounted) setState(() => _datos = _cargar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bandeja de solicitudes')),
      body: FutureBuilder(
        future: _datos,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return const Center(child: Text('No se pudo cargar la bandeja'));
          }
          final (solicitudes, docs) = snap.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() => _datos = _cargar());
              await _datos;
            },
            child: ListView(
              children: [
                for (final estado in EstadoSolicitud.values)
                  ..._grupo(estado, solicitudes, docs),
              ],
            ),
          );
        },
      ),
    );
  }

  // Un grupo por estado, más recientes primero. Si no hay solicitudes, no se pinta.
  List<Widget> _grupo(
    EstadoSolicitud estado,
    List<Solicitud> todas,
    Map<String, Documento> docs,
  ) {
    final lista = todas.where((s) => s.estado == estado).toList()
      ..sort((a, b) => b.fechaModificacion.compareTo(a.fechaModificacion));
    if (lista.isEmpty) return [];
    final color = _colores[estado]!;

    return [
      ExpansionTile(
        initiallyExpanded:
            estado == EstadoSolicitud.aprobada, // lo pendiente de entregar
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text(
            '${lista.length}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          estado.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          for (final s in lista)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                title: Text(docs[s.idDocumento]?.nombre ?? 'Documento'),
                subtitle: Text(
                  'Período ${s.periodo} · '
                  '${s.fechaModificacion.toString().substring(0, 16)}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: docs[s.idDocumento] == null
                    ? null
                    : () => _abrir(s, docs[s.idDocumento]!),
              ),
            ),
        ],
      ),
    ];
  }
}
