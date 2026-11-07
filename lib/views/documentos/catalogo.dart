import 'package:flutter/material.dart';
import 'package:solicitud_documentos/views/documentos/catalogo_appbar.dart';

import 'dart:async';

import '../../models/documento.dart';
import '../../models/usuario.dart';
import '../../service/api/documento_service.dart';
import '../../service/firebase/auth_service.dart';
import '../../service/firebase/crash_service.dart';

import 'package:flutter/foundation.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({
    super.key,
    required this.usuario,
    required this.authService,
    required this.crashService,
  });

  final Usuario usuario;
  final AuthService authService;
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
      _futureDocumentos = _documentoService.getDocumentos();
    });
  }

  //estado inicial
  @override
  void initState() {
    super.initState();
    _documentoService = DocumentoService(
      'https://6aee1a6ca677fe0fc14fc05f.mockapi.io/documentos',
    );
    _futureDocumentos = _documentoService.getDocumentos();
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
