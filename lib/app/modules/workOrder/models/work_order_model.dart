import '../../auth/models/auth_response.dart';
import '../../users/models/uuser_model.dart';
import 'status_model.dart';
import 'work_order_item_model.dart';
import 'work_order_type_model.dart';

class WorkOrder {
  final DateTime? createdOn;
  final int? id;
  final String? folio;
  final String? purchaseOrderId;
  final int? tenantId;
  final int? typeId;
  final int? executionResponsibleId;
  final int? approvalResponsibleId;
  final int? statusId;
  final Tenant? tenant;
  final WorkOrderType? type;
  final User? executionResponsible;
  final User? approvalResponsible;
  final List<WorkOrderItem>? workOrderItems;
  final Status? status;

  WorkOrder({
    this.createdOn,
    this.id,
    this.folio,
    this.purchaseOrderId,
    this.tenantId,
    this.typeId,
    this.executionResponsibleId,
    this.approvalResponsibleId,
    this.statusId,
    this.tenant,
    this.type,
    this.executionResponsible,
    this.approvalResponsible,
    this.workOrderItems,
    this.status,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) => WorkOrder(
        createdOn: json['createdOn'] != null
            ? DateTime.parse(json['createdOn'])
            : null,
        id: json['id'],
        folio: json['folio'],
        purchaseOrderId: json['purchaseOrderId'],
        tenantId: json['tenantId'],
        typeId: json['typeId'],
        executionResponsibleId: json['executionResponsibleId'],
        approvalResponsibleId: json['approvalResponsibleId'],
        statusId: json['statusId'],
        tenant: json['tenant'] != null ? Tenant.fromJson(json['tenant']) : null,
        type:
            json['type'] != null ? WorkOrderType.fromJson(json['type']) : null,
        executionResponsible: json['executionResponsible'] != null
            ? User.fromJson(json['executionResponsible'])
            : null,
        approvalResponsible: json['approvalResponsible'] != null
            ? User.fromJson(json['approvalResponsible'])
            : null,
        workOrderItems: json['workOrderItems'] != null
            ? List<WorkOrderItem>.from(
                json['workOrderItems'].map((x) => WorkOrderItem.fromJson(x)))
            : null,
        status: json['status'] != null ? Status.fromJson(json['status']) : null,
      );

  Map<String, dynamic> toJson() => {
        'purchaseOrderId': purchaseOrderId,
        'statusId': statusId ?? 1,
        'tenantId': tenantId ?? 1,
        'typeId': typeId,
        'executionResponsibleId': executionResponsibleId,
        'approvalResponsibleId': approvalResponsibleId,
        'workOrderItems': workOrderItems
            ?.map((item) => {
                  'description': item.description,
                  'itemTypeId': item.itemTypeId,
                  'quantity': item.quantity,
                  'price': item.price,
                })
            .toList(),
      };
  static WorkOrder createNew({
    required String purchaseOrderId,
    required int typeId,
    required int executionResponsibleId,
    required int approvalResponsibleId,
    required List<WorkOrderItem> items,
  }) =>
      WorkOrder(
        purchaseOrderId: purchaseOrderId,
        typeId: typeId,
        executionResponsibleId: executionResponsibleId,
        approvalResponsibleId: approvalResponsibleId,
        statusId: 1,
        tenantId: 1,
        workOrderItems: items,
      );
}
