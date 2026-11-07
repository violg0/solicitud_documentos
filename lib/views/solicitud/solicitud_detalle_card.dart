// lib/widgets/solicitud_detalle_card.dart
import 'package:flutter/material.dart';
import 'package:solicitud_documentos/models/documento.dart';
import 'package:solicitud_documentos/models/estados.dart';
import 'package:solicitud_documentos/models/motivo.dart';
import 'package:solicitud_documentos/models/solicitud.dart';
import 'package:solicitud_documentos/models/usuario.dart';
import 'package:solicitud_documentos/repository/solicitud_repository.dart';
import 'package:solicitud_documentos/validators/solicitud_validators.dart';

class SolicitudDetalleCard extends StatefulWidget {
  const SolicitudDetalleCard({
    super.key,
    required this.solicitud,
    required this.documento,
    required this.usuario,
    required this.solicitudRepository,
    required this.motivoRepository,
  });

  final Solicitud solicitud;
  final Documento documento;
  final Usuario usuario; // current user: uid + rol
  final SolicitudRepository solicitudRepository;
  final MotivoRepository motivoRepository;

  @override
  State<SolicitudDetalleCard> createState() => _SolicitudDetalleCardState();
}

class _SolicitudDetalleCardState extends State<SolicitudDetalleCard> {
  late Solicitud _solicitud = widget.solicitud; // local copy, estado changes
  late Future<List<Motivo>> _motivos = _cargarMotivos();

  Future<List<Motivo>> _cargarMotivos() async {
    final lista = await widget.motivoRepository.listarPorSolicitud(
      _solicitud.id,
    );
    return lista..sort((a, b) => a.fechaCreacion.compareTo(b.fechaCreacion));
  }

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
    final mensaje = await _pedirMensaje();
    if (mensaje == null) return; // user went back
    try {
      await widget.solicitudRepository.cambiarEstado(
        _solicitud,
        nuevo,
        widget.usuario,
      );
      await widget.motivoRepository.guardar(
        Motivo(
          id: '', // Firestore generates it
          idSolicitud: _solicitud.id,
          mensaje: mensaje,
          estado: nuevo,
          fechaCreacion: DateTime.now(),
        ),
      );
      if (!mounted) return;
      setState(() {
        _solicitud = Solicitud(
          id: _solicitud.id,
          idDocumento: _solicitud.idDocumento,
          idUsuario: _solicitud.idUsuario,
          periodo: _solicitud.periodo,
          estado: nuevo,
        );
        _motivos = _cargarMotivos();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Image.network(
          doc.imagen,
          height: 160,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.description, size: 80),
        ),
        const SizedBox(height: 12),
        Text(doc.nombre, style: Theme.of(context).textTheme.headlineSmall),
        Text(doc.descripcion),
        const Divider(height: 32),
        Text('Período: ${_solicitud.periodo}'),
        Text('Solicitante: ${_solicitud.idUsuario}'),
        Chip(label: Text(_solicitud.estado.name)),
        if (acciones.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final e in acciones)
                FilledButton(onPressed: () => _cambiar(e), child: Text(e.name)),
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
            if (snap.hasError)
              return const Text('No se pudo cargar el historial');
            final motivos = snap.data!;
            if (motivos.isEmpty) return const Text('Sin cambios registrados');
            return Column(
              children: [
                for (final m in motivos)
                  ListTile(
                    title: Text(m.estado.name),
                    subtitle: Text(m.mensaje),
                    trailing: Text(m.fechaCreacion.toString().substring(0, 16)),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
