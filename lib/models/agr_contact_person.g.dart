// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agr_contact_person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgrContactPerson _$AgrContactPersonFromJson(Map<String, dynamic> json) {
  return AgrContactPerson()
    ..id = json['id'] as int
    ..guid = json['guid'] as String
    ..createdAt = json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String)
    ..updatedAt = json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String)
    ..name = json['name'] as String
    ..description = json['description'] as String
    ..phone = json['phone'] as String
    ..email = json['email'] as String
    ..phone2 = json['phone2'] as String
    ..email2 = json['email2'] as String
    ..position = json['position'] as String
    ..farms = (json['farms'] as List)
        ?.map((e) =>
            e == null ? null : AgrFarm.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$AgrContactPersonToJson(AgrContactPerson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': instance.guid,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
      'phone': instance.phone,
      'email': instance.email,
      'phone2': instance.phone2,
      'email2': instance.email2,
      'position': instance.position,
      'farms': instance.farms,
    };
