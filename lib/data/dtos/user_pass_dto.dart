import '../../model/user_pass.dart';

class UserPassDto {
  final String id;
  final String userId;
  final String passId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const UserPassDto({
    required this.id,
    required this.userId,
    required this.passId,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  UserPass toModel() {
    return UserPass(
      id: id,
      userId: userId,
      passId: passId,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
    );
  }

  factory UserPassDto.fromModel(UserPass pass) {
    return UserPassDto(
      id: pass.id,
      userId: pass.userId,
      passId: pass.passId,
      startDate: pass.startDate,
      endDate: pass.endDate,
      isActive: pass.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'pass_id': passId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive,
    };
  }

  factory UserPassDto.fromMap(Map<String, dynamic> map) {
    return UserPassDto(
      id: map['id']?.toString() ?? '',
      userId: map['user_id'] ?? map['userId'] ?? '',
      passId: map['pass_id'] ?? map['passId'] ?? '',
      startDate: DateTime.tryParse(map['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(map['end_date'] ?? '') ?? DateTime.now(),
      isActive: map['is_active'] ?? map['isActive'] ?? false,
    );
  }
}
