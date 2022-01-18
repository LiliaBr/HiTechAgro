// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agr_farm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgrFarm _$AgrFarmFromJson(Map<String, dynamic> json) {
  return AgrFarm()
    ..id = json['id'] as int
    ..parentId = json['parentId'] as int
    ..parentGuid = json['parentGuid'] as String
    ..createdAt = json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String)
    ..updatedAt = json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String)
    ..manager = json['manager'] == null
        ? null
        : User.fromJson(json['manager'] as Map<String, dynamic>)
    ..managerId = json['managerId'] as int
    ..leaderName = json['leaderName'] as String
    ..name = json['name'] as String
    ..description = json['description'] as String
    ..alias = json['alias'] as String
    ..address = json['address'] as String
    ..phone = json['phone'] as String
    ..email = json['email'] as String
    ..cowCount = json['cowCount'] as int
    ..accomodationType = json['accomodationType'] as String
    ..hasBath = json['hasBath'] as bool
    ..guid = json['guid'] as String
    ..branches = (json['branches'] as List)
        ?.map((e) =>
            e == null ? null : AgrFarm.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$AgrFarmToJson(AgrFarm instance) => <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'parentGuid': instance.parentGuid,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'manager': instance.manager,
      'managerId': instance.managerId,
      'leaderName': instance.leaderName,
      'name': instance.name,
      'description': instance.description,
      'alias': instance.alias,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'cowCount': instance.cowCount,
      'accomodationType': instance.accomodationType,
      'hasBath': instance.hasBath,
      'guid': instance.guid,
      'branches': instance.branches,
    };
