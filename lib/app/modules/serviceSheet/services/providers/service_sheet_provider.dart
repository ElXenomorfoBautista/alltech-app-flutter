import 'dart:convert';
import 'package:get/get.dart';

import '../../../../core/base_provider.dart';

class ServiceSheetProvider extends BaseProvider {
  /// Obtiene las service sheets del usuario con filtros completos
  Future<Response> getServiceSheetsUser() async {
    try {
      final filter = {
        "fields": {
          "id": true,
          "tenantId": true,
          "folio": true,
          "priority": true,
          "customerSignature": true,
          "satisfactionSurvey": true,
          "statusId": true,
          "executionResponsibleId": true,
          "approvalResponsibleId": true,
          "workOrderId": true,
          "createdOn": true,
          "modifiedOn": true
        },
        "include": [
          {
            "relation": "status",
            "scope": {
              "fields": ["id", "name"]
            }
          },
          {
            "relation": "approvalResponsible",
            "scope": {
              "fields": [
                "id",
                "firstName",
                "middleName",
                "lastName",
                "email",
                "phone"
              ]
            }
          },
          {
            "relation": "executionResponsible",
            "scope": {
              "fields": [
                "id",
                "firstName",
                "middleName",
                "lastName",
                "email",
                "phone"
              ]
            }
          },
          {
            "relation": "serviceSheetItems",
            "scope": {
              "fields": ["id", "serviceSheetId", "workOrderItemId"],
              "include": [
                {
                  "relation": "workOrderItem",
                  "scope": {
                    "fields": [
                      "id",
                      "description",
                      "quantity",
                      "price",
                      "itemTypeId",
                      "workOrderId"
                    ],
                    "include": [
                      {
                        "relation": "itemType",
                        "scope": {
                          "fields": ["id", "name"]
                        }
                      }
                    ]
                  }
                }
              ]
            }
          },
          {
            "relation": "workOrder",
            "scope": {
              "fields": ["id", "purchaseOrderId", "folio"],
              "include": [
                {
                  "relation": "type",
                  "scope": {
                    "fields": ["id", "name"]
                  }
                }
              ]
            }
          }
        ]
      };

      final filterStr = jsonEncode(filter);
      return await get('/service-sheets/user?filter=$filterStr');
    } catch (e) {
      return handleError(e);
    }
  }

  /// Obtiene una service sheet específica por ID con todos los detalles
  Future<Response> getServiceSheetById(int id) async {
    try {
      final filter = {
        "include": [
          {
            "relation": "status",
            "scope": {
              "fields": ["id", "name"]
            }
          },
          {
            "relation": "approvalResponsible",
            "scope": {
              "fields": [
                "id",
                "firstName",
                "middleName",
                "lastName",
                "email",
                "phone"
              ]
            }
          },
          {
            "relation": "executionResponsible",
            "scope": {
              "fields": [
                "id",
                "firstName",
                "middleName",
                "lastName",
                "email",
                "phone"
              ]
            }
          },
          {
            "relation": "serviceSheetItems",
            "scope": {
              "include": [
                {
                  "relation": "workOrderItem",
                  "scope": {
                    "include": [
                      {
                        "relation": "itemType",
                        "scope": {
                          "fields": ["id", "name"]
                        }
                      }
                    ]
                  }
                }
              ]
            }
          },
          {
            "relation": "workOrder",
            "scope": {
              "include": [
                {
                  "relation": "type",
                  "scope": {
                    "fields": ["id", "name"]
                  }
                }
              ]
            }
          }
        ]
      };

      final filterStr = jsonEncode(filter);
      return await get('/service-sheets/$id?filter=$filterStr');
    } catch (e) {
      return handleError(e);
    }
  }

  /// Crea una nueva service sheet
  Future<Response> create(Map<String, dynamic> data) async {
    try {
      return await post('/service-sheets', data);
    } catch (e) {
      return handleError(e);
    }
  }
}
