import 'package:flutter/material.dart';

import 'dart:async';

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
  late Future<List<Solicitud>> _futureSolicitudes;
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
    setState(() {
      filtro = prefs.getString('filtro');
    });
  }

  @override
  void initState() {
    super.initState();
    cargarFiltro();
    unawaited(widget.solicitudRepository.syncPending());
    _futureSolicitudes = widget.solicitudRepository.obtenerSolicitudes(
      idUsuario: widget.usuario.uid,
    );
  }

  void retrySolicitudes() {
    setState(() {
      _futureSolicitudes = widget.solicitudRepository.obtenerSolicitudes(
        idUsuario: widget.usuario.uid,
      );
    });
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
    body: FutureBuilder<List<Solicitud>>(
      future: _futureSolicitudes,
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

        var mias = (snapshot.data ?? [])
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
            return ListTile(
              title: Text('Período ${s.periodo}'),
              subtitle: Text(s.estado.name),
            );
          },
        );
      },
    ),
  );
  }
}