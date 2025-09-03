import 'item_type_model.dart';

class WorkOrderItem {
  final int id;
  String description;
  int quantity;
  double price;
  int itemTypeId;
  int workOrderId;
  ItemType? itemType;

  WorkOrderItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.price,
    required this.itemTypeId,
    required this.workOrderId,
    required this.itemType,
  });

  factory WorkOrderItem.fromJson(Map<String, dynamic> json) => WorkOrderItem(
        id: json['id'],
        description: json['description'],
        quantity: json['quantity'],
        price: double.parse(json['price'].toString()),
        itemTypeId: json['itemTypeId'],
        workOrderId: json['workOrderId'],
        itemType: json["itemType"] != null
            ? ItemType.fromJson(json['itemType'])
            : null,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
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

  // Método de conveniencia para obtener el subtotal
  double get subtotal => quantity * price;

  // Método de conveniencia para obtener el nombre del tipo
  String get itemTypeName => itemType?.name ?? 'Tipo desconocido';

  // Método de conveniencia para obtener el código del tipo
  String get itemTypeCode => itemType?.code ?? '';

  @override
  String toString() {
    return 'WorkOrderItemCreate{description: $description, quantity: $quantity, price: $price, itemTypeId: $itemTypeId}';
  }
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
        description: json['description'],
        quantity: json['quantity'],
        price: double.parse(json['price'].toString()),
        itemTypeId: json['itemTypeId'],
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

  @override
  String toString() {
    return 'WorkOrderItemCreate{description: $description, quantity: $quantity, price: $price, itemTypeId: $itemTypeId}';
  }
}
