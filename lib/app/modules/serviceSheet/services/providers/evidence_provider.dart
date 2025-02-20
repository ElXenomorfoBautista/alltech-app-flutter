import 'dart:convert';

import 'package:get/get.dart';

import '../../../../core/base_provider.dart';

class EvidenceProvider extends BaseProvider {
  Future<Response> getEvidencesByEntity(int entityTypeId, int entityId) async {
    try {
      final filter = {
        "fields": {
          "createdOn": true,
          "createdBy": true,
          "id": true,
          "fileId": true,
          "entityTypeId": true,
          "entityId": true
        },
        "include": [
          {"relation": "file"}
        ]
      };

      final filterString = Uri.encodeComponent(jsonEncode(filter));
      return await get(
          '/evidences/entity/$entityTypeId/$entityId?filter=$filterString');
    } catch (e) {
      return handleError(e);
    }
  }
}
