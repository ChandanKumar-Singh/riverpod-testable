import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfileModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
