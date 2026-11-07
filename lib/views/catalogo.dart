import 'package:flutter/material.dart';
import 'package:solicitud_documentos/service/firebase/crash_service.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/documento.dart';
import '../service/firebase/documento_service.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key, required this.crashService});

  final CrashService crashService;

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  //variables: servicio y el future del get con 4 reusltados visuales
  late final DocumentoService _documentoService;
  late Future<List<Documento>> _futureDocumentos;

  // estado reintentar
  void retryDocumentos() {
    setState(() {
      _futureDocumentos = _documentoService.listar();
    });
  }

  //estado inicial
  @override
  void initState() {
    super.initState();
    _documentoService = DocumentoService(crashService: widget.crashService);
    _futureDocumentos = _documentoService.listar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de documentos'),
        actions: [
          if (kDebugMode)
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'nonFatal') {
                  try {
                    throw StateError('QA non-fatal test');
                  } catch (e, s) {
                    await widget.crashService.recordNonFatal(
                      e,
                      s,
                      reason: 'QA test',
                    );
                  }
                } else {
                  widget.crashService.simulateFatalCrash();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'nonFatal', child: Text('Log non-fatal')),
                PopupMenuItem(value: 'fatal', child: Text('Force fatal crash')),
              ],
            ),
        ],
      ),
      body: FutureBuilder<List<Documento>>(
        future: _futureDocumentos,
        builder: (context, snapshot) {
          // 1. CARGANDO
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. ERROR
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: retryDocumentos,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // 3. VACÍO
          final documentos = snapshot.data ?? [];
          if (documentos.isEmpty) {
            return const Center(child: Text('No hay documentos disponibles'));
          }

          // 4. DATOS
          return ListView.builder(
            itemCount: documentos.length,
            itemBuilder: (context, index) {
              final doc = documentos[index];
              return ListTile(
                title: Text(doc.nombre),
                subtitle: Text(doc.descripcion),
                enabled: doc.habilitado,
                trailing: doc.habilitado ? null : const Text('No disponible'),
              );
            },
          );
        },
      ),
    );
  }
}
