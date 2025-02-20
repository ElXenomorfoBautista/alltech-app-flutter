import 'item_type_model.dart';

class WorkOrderItem {
  final int id;
  String description;
  int quantity;
  double price;
  int itemTypeId;
  int workOrderId;
  ItemType itemType;

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
        itemType: ItemType.fromJson(json['itemType']),
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
}
