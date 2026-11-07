import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/documento.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class DocumentoService {
  final String baseUrl;

  DocumentoService(this.baseUrl);

  Future<List<Documento>> getDocumentos() async {
    try {
      //peticion http con limite de tiempo
      final response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Documento.fromJson(item)).toList();
      }

      if (response.statusCode == 404) {
        throw const ApiException('No se encontró el catálogo de documentos');
      }

      if (response.statusCode == 500) {
        throw const ApiException("Server does not exist");
      }
      throw ApiException('Error HTTP ${response.statusCode}');
    } on http.ClientException {
      throw const ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw const ApiException('El servidor ha esperado demasiado tiempo');
    }
  }
}
