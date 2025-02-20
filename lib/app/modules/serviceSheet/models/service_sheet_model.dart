// service_sheet_model.dart
import '../../users/models/uuser_model.dart';
import '../../workOrder/models/status_model.dart';
import 'service_sheet_item_model.dart';

class ServiceSheet {
  int? id;
  String? folio;
  int? priority;
  int? statusId;
  int? executionResponsibleId;
  int? approvalResponsibleId;
  int? workOrderId;
  Status? status;
  User? executionResponsible;
  User? approvalResponsible;
  List<ServiceSheetItem>? serviceSheetItems;
  DateTime? createdOn;

  ServiceSheet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    folio = json['folio'];
    priority = json['priority'];
    statusId = json['statusId'];
    executionResponsibleId = json['executionResponsibleId'];
    approvalResponsibleId = json['approvalResponsibleId'];
    workOrderId = json['workOrderId'];
    createdOn = DateTime.parse(json['createdOn']);
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    executionResponsible = json['executionResponsible'] != null
        ? User.fromJson(json['executionResponsible'])
        : null;
    approvalResponsible = json['approvalResponsible'] != null
        ? User.fromJson(json['approvalResponsible'])
        : null;
    if (json['serviceSheetItems'] != null) {
      serviceSheetItems = List<ServiceSheetItem>.from(
          json['serviceSheetItems'].map((x) => ServiceSheetItem.fromJson(x)));
    }
  }
}
