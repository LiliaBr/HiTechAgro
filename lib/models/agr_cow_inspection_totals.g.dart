// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agr_cow_inspection_totals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgrCowInspectionTotals _$AgrCowInspectionTotalsFromJson(
    Map<String, dynamic> json) {
  return AgrCowInspectionTotals()
    ..inspectionId = json['inspectionId'] as int
    ..cowCount = json['cowCount'] as int
    ..diseasedCowCount = json['diseasedCowCount'] as int;
}

Map<String, dynamic> _$AgrCowInspectionTotalsToJson(
        AgrCowInspectionTotals instance) =>
    <String, dynamic>{
      'inspectionId': instance.inspectionId,
      'cowCount': instance.cowCount,
      'diseasedCowCount': instance.diseasedCowCount,
    };
