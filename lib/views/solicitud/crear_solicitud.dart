import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:solicitud_documentos/repository/solicitud_repository.dart';

import '../../models/documento.dart';
import '../../models/estados.dart';
import '../../models/periodos_academicos.dart';
import '../../models/solicitud.dart';
import '../../models/usuario.dart';

class CrearSolicitudScreen extends StatefulWidget {
  final SolicitudRepository solicitudRepository;

  const CrearSolicitudScreen({
    super.key,
    required this.usuario,
    required this.documento,
    required this.solicitudRepository,
  });
  final Usuario usuario;
  final Documento documento;

  @override
  State<CrearSolicitudScreen> createState() => _CrearSolicitudScreenState();
}

class _CrearSolicitudScreenState extends State<CrearSolicitudScreen> {
  String? periodoSeleccionado;
  bool _enviando = false;
  final _observacion = TextEditingController();

  @override
  void dispose() {
    _observacion.dispose();
    super.dispose();
  }

  Future<void> _enviarSolicitud() async {
    if (periodoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar el periodo académico')),
      );
      return;
    }

    setState(() => _enviando = true);

    final ahora = DateTime.now().toUtc(); // una sola hora, en UTC
    final solicitud = Solicitud(
      id: const Uuid().v4(),
      idUsuario: widget.usuario.uid,
      idDocumento: widget.documento.id,
      periodo: periodoSeleccionado!,
      observacionEstudiante: _observacion.text.trim(),
      estado: EstadoSolicitud.solicitada,
      fechaCreacion: ahora,
      fechaModificacion: ahora,
    );

    try {
      await widget.solicitudRepository.crearSolicitud(solicitud, widget.documento);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo enviar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear solicitud')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.documento.nombre, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(widget.documento.descripcion),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Periodo académico'),
              initialValue: periodoSeleccionado,
              items: periodosAcademicos
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (value) => setState(() => periodoSeleccionado = value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _observacion,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observación (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _enviando ? null : _enviarSolicitud,
              child: _enviando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Enviar solicitud'),
            ),
          ],
        ),
      ),
    );
  }
}