// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agr_disease_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgrDiseaseLocation _$AgrDiseaseLocationFromJson(Map<String, dynamic> json) {
  return AgrDiseaseLocation()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..description = json['description'] as String
    ..region = json['region'] as String
    ..segment = json['segment'] as String;
}

Map<String, dynamic> _$AgrDiseaseLocationToJson(AgrDiseaseLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'region': instance.region,
      'segment': instance.segment,
    };
