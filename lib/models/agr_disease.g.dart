// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agr_disease.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgrDisease _$AgrDiseaseFromJson(Map<String, dynamic> json) {
  return AgrDisease()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..description = json['description'] as String
    ..alias = json['alias'] as String
    ..guid = json['guid'] as String
    ..createdAt = json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String)
    ..updatedAt = json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String)
    ..locations = (json['locations'] as List)
        ?.map((e) => e == null
            ? null
            : AgrDiseaseLocation.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$AgrDiseaseToJson(AgrDisease instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'alias': instance.alias,
      'guid': instance.guid,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'locations': instance.locations,
    };
