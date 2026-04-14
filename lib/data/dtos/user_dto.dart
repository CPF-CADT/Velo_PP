import '../../model/user.dart';

class UserDto {
  final String id;
  final String displayName;
  final String email;
  final String phone;

  const UserDto({
    required this.id,
    required this.displayName,
    required this.email,
    required this.phone,
  });

  User toModel() {
    return User(id: id, displayName: displayName, email: email, phone: phone);
  }

  factory UserDto.fromModel(User model) {
    return UserDto(
      id: model.id,
      displayName: model.displayName,
      email: model.email,
      phone: model.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'display_name': displayName,
      'email': email,
      'phone': phone,
    };
  }

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      id: map['id']?.toString() ?? '',
      displayName: map['display_name'] ?? map['displayName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}
