class ItemType {
  final bool? deleted;
  final DateTime? deletedOn;
  final int? deletedBy;
  final DateTime? createdOn;
  final DateTime? modifiedOn;
  final int? createdBy;
  final int? modifiedBy;
  final int? id;
  final String? name;
  final String? code;
  final String? description;

  ItemType({
    this.deleted,
    this.deletedOn,
    this.deletedBy,
    this.createdOn,
    this.modifiedOn,
    this.createdBy,
    this.modifiedBy,
    this.id,
    this.name,
    this.code,
    this.description,
  });

  factory ItemType.fromJson(Map<String, dynamic> json) => ItemType(
        deleted: json['deleted'],
        deletedOn: json['deletedOn'] != null
            ? DateTime.parse(json['deletedOn'])
            : null,
        deletedBy: json['deletedBy'],
        createdOn: json['createdOn'] != null
            ? DateTime.parse(json['createdOn'])
            : null,
        modifiedOn: json['modifiedOn'] != null
            ? DateTime.parse(json['modifiedOn'])
            : null,
        createdBy: json['createdBy'],
        modifiedBy: json['modifiedBy'],
        id: json['id'],
        name: json['name'],
        code: json['code'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['description'] = description;
    return data;
  }
}
