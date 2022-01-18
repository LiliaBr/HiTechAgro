// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agr_cow_inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgrCowInspection _$AgrCowInspectionFromJson(Map<String, dynamic> json) {
  return AgrCowInspection()
    ..id = json['id'] as int
    ..guid = json['guid'] as String
    ..farmId = json['farmId'] as int
    ..farmGuid = json['farmGuid'] as String
    ..createdAt = json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String)
    ..updatedAt = json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String)
    ..date =
        json['date'] == null ? null : DateTime.parse(json['date'] as String)
    ..name = json['name'] as String
    ..description = json['description'] as String
    ..type = json['type'] as String
    ..createdBy = json['createdBy'] == null
        ? null
        : User.fromJson(json['createdBy'] as Map<String, dynamic>)
    ..farm = json['farm'] == null
        ? null
        : AgrFarm.fromJson(json['farm'] as Map<String, dynamic>)
    ..cows = (json['cows'] as List)
        ?.map((e) =>
            e == null ? null : AgrCow.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..inspectionTotals = json['inspectionTotals'] == null
        ? null
        : AgrCowInspectionTotals.fromJson(
            json['inspectionTotals'] as Map<String, dynamic>)
    ..totalCowCount = json['totalCowCount'] as int;
}

Map<String, dynamic> _$AgrCowInspectionToJson(AgrCowInspection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': instance.guid,
      'farmId': instance.farmId,
      'farmGuid': instance.farmGuid,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'date': instance.date?.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
      'createdBy': instance.createdBy,
      'farm': instance.farm,
      'cows': instance.cows,
      'inspectionTotals': instance.inspectionTotals,
      'totalCowCount': instance.totalCowCount,
    };
