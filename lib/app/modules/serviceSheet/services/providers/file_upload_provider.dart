import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

import '../../../../core/base_provider.dart';
import '../../../../services/storage_service.dart';

class FileUploadProvider extends BaseProvider {
  final StorageService _storage = Get.find<StorageService>();

  Map<String, String> getHeaders() {
    final token = _storage.getAccessToken();
    return {
      'Authorization': 'Bearer $token',
      'Accept': '*/*',
    };
  }

  // Método para cargar múltiples archivos
  Future<Response> uploadMultipleFiles(
      {required List<File> files,
      required int serviceSheetId,
      List<String>? customNames}) async {
    try {
      // Crear el request multipart
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${httpClient.baseUrl}/uploads/serviceSheets/$serviceSheetId'),
      );

      // Añadir encabezados de autorización
      request.headers.addAll(getHeaders());

      // Añadir todos los archivos al request
      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final fileName = customNames != null && i < customNames.length
            ? customNames[i]
            : path.basename(file.path);

        // Determinar el tipo MIME del archivo
        final mimeType =
            lookupMimeType(file.path) ?? 'application/octet-stream';
        final contentType = mimeType.split('/');

        final multipartFile = await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: fileName,
          contentType: MediaType(contentType[0], contentType[1]),
        );

        request.files.add(multipartFile);
      }

      // Enviar el request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Procesar la respuesta
      return Response(
        statusCode: response.statusCode,
        bodyString: response.body,
      );
    } catch (e) {
      return handleError(e);
    }
  }
}
