import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {

  UserModel({required this.id, required this.name, this.email, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  final String id;
  final String name;
  final String? email;
  final String? token;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
