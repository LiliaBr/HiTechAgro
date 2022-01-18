import 'package:json_annotation/json_annotation.dart';
import 'package:hitech_agro/app_models.dart';

part 'agr_farm.g.dart';

////////////////////////////////////////////////////////////////////////////////
@JsonSerializable(nullable: true)
class AgrFarm extends AgrBaseModel {
  int id;
  int parentId;
  String parentGuid;

  DateTime createdAt;
  DateTime updatedAt;
  User manager;
  int managerId;
  String leaderName;

  String name;
  String description;
  String alias;
  String address;
  String phone;
  String email;

  int cowCount;
  String accomodationType;
  bool hasBath;

  String guid;
  List<AgrFarm> branches;

  @JsonKey(ignore: true)
  bool $dirty;

  AgrFarm() : super('agr_farm');

  //////////////////////////////////////////////////////////////////////////////
  Future<AgrFarm> save({isSynced: false, forceSync: false}) {
    return DbService()
        .putObject<AgrFarm>(this, isSynced: isSynced, forceSync: forceSync);
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<AgrFarm> reload() {
    return DbService().getObjectByGuid<AgrFarm>(this.guid);
  }

  //////////////////////////////////////////////////////////////////////////////
  @override
  dynamic fromJson(Map<String, dynamic> json) {
    AgrFarm retval = AgrFarm.fromJson(json);
    retval.$dirty = json['\$need_sync'] ?? false;
    return retval;
  }

  //////////////////////////////////////////////////////////////////////////////
  @override
  Map<String, dynamic> toDbJson(Map<String, dynamic> json, [extra = const {}]) {
    return super.toDbJson(json, {
      'farm_id': json['id'],
      'parent_farm_id': json['parentId'],
      'parent_farm_guid': json['parentGuid'],
      'farm_name': (name ?? '').toLowerCase(),
      ...extra
    });
  }
  
	//////////////////////////////////////////////////////////////////////////////
  get  accomodationTypeStr {
    switch (accomodationType) {
      case 'connected':
        return 'Привязное';
        break;

      case 'unconnected':
        return 'Беспривязное';
        break;
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<AgrBaseModel> syncDb() async {
    AgrFarm model = (this.id == null)
        ? await RestClient().createFarm(this)
        : await RestClient().updateFarm(this.id, this);

    final farm = await model.save(isSynced: true, forceSync: true);

    if (this.id == null) {
      this.id = farm.id;

      for (var branch in this.branches ?? []) {
        if (branch.id == null) {
          final nbranch = (farm.branches ?? [])
              .firstWhere((e) => e.guid == branch.guid, orElse: () => null);

          if (nbranch != null) {
            branch.id = branch.id;
            branch.parentId = branch.parentId;
          }
        }
      }
    }

    print('Emit farmUpdated. guid=${farm.guid}, id=${farm.id}');
    DbService().emit('farmUpdated', null, farm);
    return farm;
  }

  factory AgrFarm.fromJson(Map<String, dynamic> json) =>
      _$AgrFarmFromJson(json);
  Map<String, dynamic> toJson() => _$AgrFarmToJson(this);
}
