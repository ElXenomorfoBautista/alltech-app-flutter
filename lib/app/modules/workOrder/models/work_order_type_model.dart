class WorkOrderType {
  final int id;
  final String name;

  WorkOrderType({
    required this.id,
    required this.name,
  });

  factory WorkOrderType.fromJson(Map<String, dynamic> json) => WorkOrderType(
        id: json['id'],
        name: json['name'],
      );
}
