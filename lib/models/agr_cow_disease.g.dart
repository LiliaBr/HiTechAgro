// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agr_cow_disease.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgrCowDisease _$AgrCowDiseaseFromJson(Map<String, dynamic> json) {
  return AgrCowDisease()
    ..id = json['id'] as int
    ..cowId = json['cowId'] as int
    ..inspectionId = json['inspectionId'] as int
    ..diseaseId = json['diseaseId'] as int
    ..locationId = json['locationId'] as int;
}

Map<String, dynamic> _$AgrCowDiseaseToJson(AgrCowDisease instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cowId': instance.cowId,
      'inspectionId': instance.inspectionId,
      'diseaseId': instance.diseaseId,
      'locationId': instance.locationId,
    };
