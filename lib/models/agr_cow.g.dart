// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agr_cow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgrCow _$AgrCowFromJson(Map<String, dynamic> json) {
  return AgrCow()
    ..id = json['id'] as int
    ..guid = json['guid'] as String
    ..farmId = json['farmId'] as int
    ..inspectionId = json['inspectionId'] as int
    ..rating = json['rating'] as int
    ..number = json['number'] as String
    ..comments = json['comments'] as String
    ..tag = json['tag'] as String
    ..diseases = (json['diseases'] as List)
        ?.map((e) => e == null
            ? null
            : AgrCowDisease.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$AgrCowToJson(AgrCow instance) => <String, dynamic>{
      'id': instance.id,
      'guid': instance.guid,
      'farmId': instance.farmId,
      'inspectionId': instance.inspectionId,
      'rating': instance.rating,
      'number': instance.number,
      'comments': instance.comments,
      'tag': instance.tag,
      'diseases': instance.diseases,
    };
