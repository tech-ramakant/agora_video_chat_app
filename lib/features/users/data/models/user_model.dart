import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required int id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
    required String avatar,
  }) : super(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    avatar: avatar,
    // phone: "+1 555 ${id.toString().padLeft(4, '0')}",
    phone: "+1 555 1234567890",
  );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
