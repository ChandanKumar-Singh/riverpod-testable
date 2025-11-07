// import 'package:json_annotation/json_annotation.dart';

// part 'user.g.dart';

// @JsonSerializable()
// class UserData {
//   @JsonKey(name: "user")
//   final UserLoggedData userData;
//   @JsonKey(name: "access_token")
//   final String token;
//   @JsonKey(name: "expires_in")
//   final String time;

//   UserData({required this.userData, required this.token, required this.time});

//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return _$UserDataFromJson(json);
//   }

//   Map<String, dynamic> toJson() => _$UserDataToJson(this);

//   factory UserData.guest() =>
//       UserData(userData: UserLoggedData.guest(), token: 'guest', time: '');
// }

// @JsonSerializable()
// class UserLoggedData {
//   final String fullName;
//   final String? phone;
//   final String? email;
//   @JsonKey(name: 'profilePicture')
//   final String? profilePic;
//   @JsonKey(name: 'isEmailVerified')
//   final int? isEmailVerified;
//   @JsonKey(name: 'is_phone_verified')
//   final int? isPhoneVerified;
//   @JsonKey(name: 'zip_code')
//   final String? zipCode;
//   @JsonKey(name: 'fb_link')
//   final String? fbLink;
//   @JsonKey(name: 'insta_link')
//   final String? instaLink;
//   final String? city;
//   final String? state;
//   @JsonKey(name: "login_source")
//   final String? loginSource;
//   @JsonKey(name: "id")
//   final String id;
//   @JsonKey(name: "role")
//   final String? role;
//   final String? createdAt;
//   final String? updatedAt;
//   final bool isGuest;

//   const UserLoggedData({
//     required this.fullName,
//     this.phone,
//     required this.id,
//     required this.email,
//     this.profilePic,
//     this.isEmailVerified,
//     this.isPhoneVerified,
//     this.zipCode,
//     this.fbLink,
//     this.instaLink,
//     this.city,
//     this.state,
//     this.role,
//     this.loginSource = 'app',
//     this.createdAt,
//     this.updatedAt,
//     this.isGuest = false,
//   });
//   factory UserLoggedData.fromJson(Map<String, dynamic> json) {
//     return _$UserLoggedDataFromJson(json);
//   }

//   Map<String, dynamic> toJson() => _$UserLoggedDataToJson(this);

//   factory UserLoggedData.guest() =>
//       const UserLoggedData(id: 'guest', email: '', fullName: 'Guest');
// }

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.freezed.dart'; // For freezed generated code
part 'user.g.dart'; // For json_serializable generated code

@freezed
abstract class User with _$User {
  const factory User({required String id, required String name, int? age}) =
      _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
