// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    email: json['email'] as String,
    name: json['name'] as String,
  )
    ..guid = json['guid'] as String
    ..password = json['password'] as String
    ..createdAt = json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String)
    ..updatedAt = json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String)
    ..role = json['role'] as String
    ..authItems = (json['authItems'] as List)?.map((e) => e as String)?.toList()
    ..errors = (json['errors'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, (e as List)?.map((e) => e as String)?.toList()),
    );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'guid': instance.guid,
      'name': instance.name,
      'password': instance.password,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'role': instance.role,
      'authItems': instance.authItems,
      'errors': instance.errors,
    };
