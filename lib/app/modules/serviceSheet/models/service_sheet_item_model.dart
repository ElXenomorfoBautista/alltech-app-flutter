// service_sheet_item_model.dart
import '../../workOrder/models/work_order_item_model.dart';

class ServiceSheetItem {
  int? id;
  int? serviceSheetId;
  int? workOrderItemId;
  WorkOrderItem? workOrderItem;
  DateTime? createdOn;
  DateTime? modifiedOn;

  ServiceSheetItem({
    this.id,
    this.serviceSheetId,
    this.workOrderItemId,
    this.workOrderItem,
    this.createdOn,
    this.modifiedOn,
  });

  ServiceSheetItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceSheetId = json['serviceSheetId'];
    workOrderItemId = json['workOrderItemId'];
    workOrderItem = json['workOrderItem'] != null
        ? WorkOrderItem.fromJson(json['workOrderItem'])
        : null;
    createdOn =
        json['createdOn'] != null ? DateTime.parse(json['createdOn']) : null;
    modifiedOn =
        json['modifiedOn'] != null ? DateTime.parse(json['modifiedOn']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['serviceSheetId'] = serviceSheetId;
    data['workOrderItemId'] = workOrderItemId;
    if (workOrderItem != null) {
      data['workOrderItem'] = workOrderItem!.toJson();
    }
    return data;
  }
}
