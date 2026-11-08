import 'package:flutter/material.dart';

import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../models/estados.dart';
import '../../models/documento.dart';
import '../../models/motivo.dart';
import '../../models/solicitud.dart';
import '../../models/usuario.dart';
import '../../repository/documento_repository.dart';
import '../../repository/motivo_repository.dart';
import '../../repository/solicitud_repository.dart';
import '../../service/firebase/auth_service.dart';
import '../../service/firebase/crash_service.dart';
import '../documentos/catalogo_appbar.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SolicitudesScreen extends StatefulWidget {
  const SolicitudesScreen({
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

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  late Future<(List<Solicitud>, Map<String, Documento>)> _futureDatos;
  String? filtro;

  Future<void> guardarFiltro() async {
    final prefs = await SharedPreferences.getInstance();
    if (filtro == null) {
      await prefs.remove('filtro');
    } else {
      await prefs.setString('filtro', filtro!);
    }
  }

  Future<void> cargarFiltro() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final guardado = prefs.getString('filtro');
    setState(() {
      // Se ignora un valor guardado que ya no corresponda a ningún estado.
      filtro = EstadoSolicitud.values.any((e) => e.name == guardado)
          ? guardado
          : null;
    });
  }

  /// [nuevo] es el nombre de un [EstadoSolicitud], o null para "Todas".
  void cambiarFiltro(String? nuevo) {
    setState(() => filtro = nuevo);
    unawaited(guardarFiltro());
  }

  @override
  void initState() {
    super.initState();
    cargarFiltro();
    unawaited(widget.solicitudRepository.syncPending());
    _futureDatos = _cargarDatos();
  }

  Future<(List<Solicitud>, Map<String, Documento>)> _cargarDatos() async {
    final resultados = await Future.wait([
      widget.solicitudRepository.obtenerSolicitudes(
        idUsuario: widget.usuario.uid,
      ),
      widget.documentoRepository.obtenerTodos(),
    ]);
    final documentos = resultados[1] as List<Documento>;
    return (
      resultados[0] as List<Solicitud>,
      {for (final documento in documentos) documento.id: documento},
    );
  }

  void retrySolicitudes() {
    setState(() => _futureDatos = _cargarDatos());
  }

  Future<String?> _pedirMotivoCancelacion() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Cancelar esta solicitud?'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Motivo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Volver'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  // Mismo patrón que SolicitudDetalleCard._cambiar: primero el estado y luego
  // el motivo que lo explica.
  Future<void> _cancelar(Solicitud solicitud) async {
    final mensaje = await _pedirMotivoCancelacion();
    if (mensaje == null) return; // el usuario eligió "Volver"
    try {
      await widget.solicitudRepository.cambiarEstado(
        solicitud,
        EstadoSolicitud.cancelada,
        widget.usuario,
      );
      await widget.motivoRepository.crear(
        Motivo(
          id: const Uuid().v4(),
          idSolicitud: solicitud.id,
          mensaje: mensaje,
          estado: EstadoSolicitud.cancelada,
          fechaCreacion: DateTime.now(),
        ),
      );
      if (!mounted) return;
      retrySolicitudes(); // la fila pasa a "cancelada"
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  Widget _filtros() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('Todas'),
              selected: filtro == null,
              onSelected: (_) => cambiarFiltro(null),
            ),
          ),
          for (final estado in EstadoSolicitud.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(estado.name),
                selected: filtro == estado.name,
                onSelected: (_) => cambiarFiltro(estado.name),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CatalogoAppBar(
        usuario: widget.usuario,
        authService: widget.authService,
        crashService: widget.crashService,
        solicitudRepository: widget.solicitudRepository,
        documentoRepository: widget.documentoRepository,
        motivoRepository: widget.motivoRepository,
      ),
      body: Column(
        children: [
          _filtros(),
          Expanded(
            child: FutureBuilder<(List<Solicitud>, Map<String, Documento>)>(
              future: _futureDatos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('No se pudieron cargar tus solicitudes'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: retrySolicitudes,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final (solicitudes, documentos) = snapshot.data!;
                var mias = solicitudes
                    .where((s) => s.idUsuario == widget.usuario.uid)
                    .toList();

                if (filtro != null) {
                  mias = mias.where((s) => s.estado.name == filtro).toList();
                }

                if (mias.isEmpty) {
                  return const Center(child: Text('No tienes solicitudes'));
                }

                return ListView.builder(
                  itemCount: mias.length,
                  itemBuilder: (context, i) {
                    final s = mias[i];
                    // Solo una solicitud propia en estado "solicitada" se
                    // puede cancelar; en las demás el tap no hace nada.
                    final cancelable =
                        s.estado == EstadoSolicitud.solicitada &&
                        s.idUsuario == widget.usuario.uid;
                    return ListTile(
                      title: Text(
                        documentos[s.idDocumento]?.nombre ??
                            'Documento no disponible',
                      ),
                      subtitle: Text('Período ${s.periodo} · ${s.estado.name}'),
                      onTap: cancelable ? () => _cancelar(s) : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
