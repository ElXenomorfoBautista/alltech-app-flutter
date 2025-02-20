class Status {
  final int id;
  final String name;

  Status({
    required this.id,
    required this.name,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json['id'],
        name: json['name'],
      );
}
