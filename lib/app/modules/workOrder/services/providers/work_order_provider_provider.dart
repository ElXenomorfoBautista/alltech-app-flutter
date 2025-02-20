import 'dart:convert';

import 'package:get/get.dart';

import '../../../../core/base_provider.dart';

class WorkOrderProvider extends BaseProvider {
  Future<Response> getWorkOrdersUser({Map<String, dynamic>? filter}) async {
    try {
      final defaultFilter = {
        "order": 'createdOn DESC',
        "fields": {
          "id": true,
          "folio": true,
          "purchaseOrderId": true,
          "statusId": true,
          "tenantId": true,
          "typeId": true,
          "executionResponsibleId": true,
          "approvalResponsibleId": true,
          "createdOn": true
        },
        "include": [
          {
            "relation": "status",
            "scope": {
              "fields": ["id", "name"]
            }
          },
          {
            "relation": "tenant",
            "scope": {
              "fields": ["id", "name"]
            }
          },
          {
            "relation": "type",
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
            "relation": "workOrderItems",
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
      };

      final filterString =
          Uri.encodeComponent(jsonEncode(filter ?? defaultFilter));

      return await get('/work-orders?filter=$filterString');
    } catch (e) {
      return handleError(e);
    }
  }

  Future<Response> getWorkOrders() async {
    try {
      return await get('/work-orders');
    } catch (e) {
      return handleError(e);
    }
  }

  Future<Response> getWorkOrderById(int id) async {
    try {
      return await get('/work-orders/$id');
    } catch (e) {
      return handleError(e);
    }
  }

  Future<Response> createWorkOrder(Map<String, dynamic> data) async {
    try {
      return await post(
        '/work-orders',
        data,
      );
    } catch (e) {
      return handleError(e);
    }
  }
}
