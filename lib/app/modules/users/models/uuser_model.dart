class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String username;
  final String? email;
  final String? phone;
  final int defaultTenant;
  final DateTime? lastLogin;
  final String? imagePath;
  final String? qrPath;
  static const String _baseUrl = 'http://localhost:3000';
  static const String _uploadPath = '/uploads/getImage';
  User({
    this.id,
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.username,
    this.email,
    this.phone,
    required this.defaultTenant,
    this.lastLogin,
    this.imagePath,
    this.qrPath,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        middleName: json['middleName'],
        username: json['username'] ?? '',
        email: json['email'],
        phone: json['phone'],
        defaultTenant: json['defaultTenant'] ?? 0,
        lastLogin: json['lastLogin'] != null
            ? DateTime.parse(json['lastLogin'])
            : null,
        imagePath: json['imagePath'],
        qrPath: json['qrPath'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'middleName': middleName,
        'username': username,
        'email': email,
        'phone': phone,
        'defaultTenant': defaultTenant,
        'lastLogin': lastLogin?.toIso8601String(),
        'imagePath': imagePath,
        'qrPath': qrPath,
      };

  // Para validaciones de formato
  static bool isValidEmail(String? email) {
    if (email == null) return true;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String? phone) {
    if (phone == null) return true;
    return RegExp(r'^\+[1-9]{1}[0-9]{3,14}$').hasMatch(phone);
  }

  static bool isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9]{4,20}$').hasMatch(username);
  }

  String? get imageUrl {
    if (imagePath == null) return null;

    // Reemplazamos los slashes por %2F
    final encodedPath = imagePath!.replaceAll('/', '%2F');

    return '$_baseUrl$_uploadPath/$encodedPath';
  }

  String get fullName {
    final middle =
        middleName != null && middleName!.isNotEmpty ? ' $middleName ' : ' ';
    return '$firstName$middle$lastName'.trim();
  }
}
