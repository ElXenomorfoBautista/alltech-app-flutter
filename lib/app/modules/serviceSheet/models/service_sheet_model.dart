import '../../users/models/uuser_model.dart';
import '../../workOrder/models/status_model.dart';
import '../../workOrder/models/work_order_model.dart';
import 'service_sheet_item_model.dart';

class ServiceSheet {
  int? id;
  int? tenantId;
  String? folio;
  int? priority;
  String? customerSignature;
  Map<String, dynamic>? satisfactionSurvey;
  int? statusId;
  int? executionResponsibleId;
  int? approvalResponsibleId;
  int? workOrderId;
  DateTime? createdOn;
  DateTime? modifiedOn;
  int? createdBy;
  int? modifiedBy;
  bool? deleted;
  DateTime? deletedOn;
  int? deletedBy;

  // Relaciones
  Status? status;
  User? executionResponsible;
  User? approvalResponsible;
  WorkOrder? workOrder;
  List<ServiceSheetItem>? serviceSheetItems;

  ServiceSheet({
    this.id,
    this.tenantId,
    this.folio,
    this.priority,
    this.customerSignature,
    this.satisfactionSurvey,
    this.statusId,
    this.executionResponsibleId,
    this.approvalResponsibleId,
    this.workOrderId,
    this.createdOn,
    this.modifiedOn,
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedOn,
    this.deletedBy,
    this.status,
    this.executionResponsible,
    this.approvalResponsible,
    this.workOrder,
    this.serviceSheetItems,
  });

  ServiceSheet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenantId = json['tenantId'];
    folio = json['folio'];
    priority = json['priority'];
    customerSignature = json['customerSignature'];
    satisfactionSurvey = json['satisfactionSurvey'] != null
        ? Map<String, dynamic>.from(json['satisfactionSurvey'])
        : null;
    statusId = json['statusId'];
    executionResponsibleId = json['executionResponsibleId'];
    approvalResponsibleId = json['approvalResponsibleId'];
    workOrderId = json['workOrderId'];

    // Parse dates
    createdOn =
        json['createdOn'] != null ? DateTime.parse(json['createdOn']) : null;
    modifiedOn =
        json['modifiedOn'] != null ? DateTime.parse(json['modifiedOn']) : null;
    deletedOn =
        json['deletedOn'] != null ? DateTime.parse(json['deletedOn']) : null;

    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    deleted = json['deleted'] ?? false;
    deletedBy = json['deletedBy'];

    // Parse relations
    status = json['status'] != null ? Status.fromJson(json['status']) : null;

    executionResponsible = json['executionResponsible'] != null
        ? User.fromJson(json['executionResponsible'])
        : null;

    approvalResponsible = json['approvalResponsible'] != null
        ? User.fromJson(json['approvalResponsible'])
        : null;

    workOrder = json['workOrder'] != null
        ? WorkOrder.fromJson(json['workOrder'])
        : null;

    if (json['serviceSheetItems'] != null) {
      serviceSheetItems = List<ServiceSheetItem>.from(
          json['serviceSheetItems'].map((x) => ServiceSheetItem.fromJson(x)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['tenantId'] = tenantId;
    data['folio'] = folio;
    data['priority'] = priority;
    data['customerSignature'] = customerSignature;
    data['satisfactionSurvey'] = satisfactionSurvey;
    data['statusId'] = statusId;
    data['executionResponsibleId'] = executionResponsibleId;
    data['approvalResponsibleId'] = approvalResponsibleId;
    data['workOrderId'] = workOrderId;
    data['createdOn'] = createdOn?.toIso8601String();
    data['modifiedOn'] = modifiedOn?.toIso8601String();
    data['createdBy'] = createdBy;
    data['modifiedBy'] = modifiedBy;
    data['deleted'] = deleted;
    data['deletedOn'] = deletedOn?.toIso8601String();
    data['deletedBy'] = deletedBy;

    if (status != null) {
      data['status'] = status!.toJson();
    }
    if (executionResponsible != null) {
      data['executionResponsible'] = executionResponsible!.toJson();
    }
    if (approvalResponsible != null) {
      data['approvalResponsible'] = approvalResponsible!.toJson();
    }
    if (workOrder != null) {
      data['workOrder'] = workOrder!.toJson();
    }
    if (serviceSheetItems != null) {
      data['serviceSheetItems'] =
          serviceSheetItems!.map((x) => x.toJson()).toList();
    }

    return data;
  }

  /// Crea un nuevo ServiceSheet para envío al servidor
  Map<String, dynamic> toCreateJson() {
    return {
      'workOrderId': workOrderId,
      'tenantId': tenantId,
      'priority': priority,
      'statusId': statusId ?? 1, // Default: Pendiente
      'executionResponsibleId': executionResponsibleId,
      'approvalResponsibleId': approvalResponsibleId,
      if (customerSignature != null) 'customerSignature': customerSignature,
      if (satisfactionSurvey != null) 'satisfactionSurvey': satisfactionSurvey,
    };
  }

  // Métodos de conveniencia
  String get priorityText {
    switch (priority) {
      case 1:
        return 'Alta';
      case 2:
        return 'Media';
      case 3:
        return 'Baja';
      default:
        return 'N/A';
    }
  }

  String get statusName => status?.name ?? 'Sin estado';

  String get executionResponsibleName =>
      executionResponsible?.fullName ?? 'No asignado';

  String get approvalResponsibleName =>
      approvalResponsible?.fullName ?? 'No asignado';

  String get workOrderFolio => workOrder?.folio ?? 'N/A';

  bool get isHighPriority => priority == 1;

  bool get isCompleted =>
      statusName.toLowerCase().contains('completad') ||
      statusName.toLowerCase().contains('finished');

  bool get isPending =>
      statusName.toLowerCase().contains('pendiente') ||
      statusName.toLowerCase().contains('pending');

  bool get isInProgress =>
      statusName.toLowerCase().contains('proceso') ||
      statusName.toLowerCase().contains('progress');

  /// Calcula el total de todos los items
  double get totalAmount {
    if (serviceSheetItems == null || serviceSheetItems!.isEmpty) return 0.0;

    double total = 0.0;
    for (var item in serviceSheetItems!) {
      final workOrderItem = item.workOrderItem;
      if (workOrderItem != null) {
        final price = workOrderItem.price ?? 0.0;
        final quantity = workOrderItem.quantity ?? 0;
        total += price * quantity;
      }
    }
    return total;
  }

  /// Obtiene el conteo total de items
  int get itemsCount => serviceSheetItems?.length ?? 0;

  /// Verifica si el usuario actual puede ejecutar
  bool canExecute(int? currentUserId) {
    return executionResponsibleId == currentUserId && isPending;
  }

  /// Verifica si el usuario actual puede aprobar
  bool canApprove(int? currentUserId) {
    return approvalResponsibleId == currentUserId && !isPending;
  }

  /// Verifica si está vencida (más de X días sin cambios)
  bool isOverdue({int days = 7}) {
    if (createdOn == null) return false;
    final now = DateTime.now();
    final difference = now.difference(createdOn!);
    return difference.inDays > days && isPending;
  }

  /// Obtiene un resumen para compartir
  String get shareSummary {
    return '''
📋 *Hoja de Servicio: ${folio ?? 'Sin folio'}*

🏢 *Orden de Trabajo:* ${workOrderFolio}
📅 *Fecha:* ${createdOn != null ? _formatDate(createdOn!) : 'Sin fecha'}
⭕ *Estado:* ${statusName}
🔥 *Prioridad:* ${priorityText}

👤 *Ejecutor:* ${executionResponsibleName}
✅ *Aprobador:* ${approvalResponsibleName}

📦 *Items:* ${itemsCount}
💰 *Total:* \$${totalAmount.toStringAsFixed(2)}
''';
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    return '${localDate.day}/${localDate.month}/${localDate.year}';
  }

  @override
  String toString() {
    return 'ServiceSheet{id: $id, folio: $folio, priority: $priority, status: ${statusName}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceSheet && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
