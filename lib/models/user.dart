import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todos_example/models/address.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String name,
    required Address address,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
