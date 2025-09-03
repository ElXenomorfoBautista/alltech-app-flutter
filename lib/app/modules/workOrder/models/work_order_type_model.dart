class WorkOrderType {
  final int id;
  final String name;
  final String? code;
  final String? description;

  WorkOrderType({
    required this.id,
    required this.name,
    this.code,
    this.description,
  });

  factory WorkOrderType.fromJson(Map<String, dynamic> json) => WorkOrderType(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        description: json['description'],
      );
}
