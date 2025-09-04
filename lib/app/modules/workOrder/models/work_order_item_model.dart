import 'item_type_model.dart';

class WorkOrderItem {
  final int? id; // Cambiado a opcional
  String description;
  int quantity;
  double price;
  int itemTypeId;
  int workOrderId;
  ItemType? itemType;

  WorkOrderItem({
    this.id, // Ahora es opcional
    required this.description,
    required this.quantity,
    required this.price,
    required this.itemTypeId,
    required this.workOrderId,
    this.itemType,
  });

  factory WorkOrderItem.fromJson(Map<String, dynamic> json) => WorkOrderItem(
        id: json['id'], // Puede ser null
        description: json['description'] ?? '',
        quantity: json['quantity'] ?? 0,
        price: double.tryParse(json['price'].toString()) ?? 0.0,
        itemTypeId: json['itemTypeId'] ?? 0,
        workOrderId: json['workOrderId'] ?? 0,
        itemType: json["itemType"] != null
            ? ItemType.fromJson(json['itemType'])
            : null,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['description'] = description;
    data['quantity'] = quantity;
    data['price'] = price;
    data['itemTypeId'] = itemTypeId;
    data['workOrderId'] = workOrderId;
    if (itemType != null) {
      data['itemType'] = itemType!.toJson();
    }
    return data;
  }

  /// Mapa para envío al servidor (sin id ni relaciones)
  Map<String, dynamic> toCreateJson() {
    return {
      'description': description,
      'quantity': quantity,
      'price': price,
      'itemTypeId': itemTypeId,
    };
  }

  // Método de conveniencia para obtener el subtotal
  double get subtotal => quantity * price;

  // Método de conveniencia para obtener el nombre del tipo
  String get itemTypeName => itemType?.name ?? 'Tipo desconocido';

  // Método de conveniencia para obtener el código del tipo
  String get itemTypeCode => itemType?.code ?? '';

  // Verificar si es un servicio o producto
  bool get isService =>
      itemType?.code?.toLowerCase() == 'servicio' ||
      itemType?.name?.toLowerCase().contains('servicio') == true;

  bool get isProduct => !isService;

  @override
  String toString() {
    return 'WorkOrderItem{id: $id, description: $description, quantity: $quantity, price: $price, itemTypeId: $itemTypeId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkOrderItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class WorkOrderItemCreate {
  String description;
  int quantity;
  double price;
  int itemTypeId;
  ItemType? itemType; // Para mostrar información adicional en la UI

  WorkOrderItemCreate({
    required this.description,
    required this.quantity,
    required this.price,
    required this.itemTypeId,
    this.itemType,
  });

  factory WorkOrderItemCreate.fromJson(Map<String, dynamic> json) =>
      WorkOrderItemCreate(
        description: json['description'] ?? '',
        quantity: json['quantity'] ?? 0,
        price: double.tryParse(json['price'].toString()) ?? 0.0,
        itemTypeId: json['itemTypeId'] ?? 0,
        itemType: json["itemType"] != null
            ? ItemType.fromJson(json['itemType'])
            : null,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['description'] = description;
    data['quantity'] = quantity;
    data['price'] = price;
    data['itemTypeId'] = itemTypeId;
    // No incluimos itemType en el JSON que se envía al servidor
    return data;
  }

  // Método de conveniencia para obtener el subtotal
  double get subtotal => quantity * price;

  // Método de conveniencia para obtener el nombre del tipo
  String get itemTypeName => itemType?.name ?? 'Tipo desconocido';

  // Método de conveniencia para obtener el código del tipo
  String get itemTypeCode => itemType?.code ?? '';

  /// Convierte a WorkOrderItem (después de crear en servidor)
  WorkOrderItem toWorkOrderItem({int? id, int? workOrderId}) {
    return WorkOrderItem(
      id: id,
      description: description,
      quantity: quantity,
      price: price,
      itemTypeId: itemTypeId,
      workOrderId: workOrderId ?? 0,
      itemType: itemType,
    );
  }

  @override
  String toString() {
    return 'WorkOrderItemCreate{description: $description, quantity: $quantity, price: $price, itemTypeId: $itemTypeId}';
  }
}
