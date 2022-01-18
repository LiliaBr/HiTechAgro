import 'package:json_annotation/json_annotation.dart';
import 'package:hitech_agro/app_models.dart';
import 'package:intl/intl.dart';

part 'agr_cow_inspection.g.dart';

////////////////////////////////////////////////////////////////////////////////
@JsonSerializable(nullable: true)
class AgrCowInspection extends AgrBaseModel {
  static final DateFormat _dateFormatter =
      DateFormat('dd.MM.yyyy HH:mm', 'ru_RU');

  @JsonKey(ignore: true)
  bool $dirty;

  int id;
  String guid;
  int farmId;
  String farmGuid;

  DateTime createdAt;
  DateTime updatedAt;
  DateTime date;

  String name;

  String description;
  String type;

  User createdBy;
  AgrFarm farm;

  List<AgrCow> cows;

  AgrCowInspectionTotals inspectionTotals;
  int totalCowCount;

  //////////////////////////////////////////////////////////////////////////////
  get dateStr {
    if (date == null) return '';
    return _dateFormatter.format(date.toLocal());
  }

  //////////////////////////////////////////////////////////////////////////////
  get inspectedCowPerc {
    if (totalCowCount == null || totalCowCount == 0) return 0.0;
    return ((cows.length / totalCowCount) * 1000).round() / 10;
  }

  //////////////////////////////////////////////////////////////////////////////
  get inspectedCowPercPruning {
    if (cows.length == null || cows.length == 0) return 0.0;
    return 100.0;
  }

	//////////////////////////////////////////////////////////////////////////////
	get numberOfCases {
			var retval = 0;
			for (var cow in cows) {
					if ((cow.diseases?.length ?? 0) > 0) retval++;
			}
			return retval;
	}

  //////////////////////////////////////////////////////////////////////////////
  get typeStr {
    switch (type) {
      case 'hoofs':
        return 'Зальный осмотр';
        break;

      case 'rating':
        return 'Бальный осмотр';
        break;

      case 'pruning':
        return 'Обрезка';
        break;
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  AgrCowInspection() : super('agr_inspection') {
    $dirty = false;
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<AgrCowInspection> save({isSynced: false, forceSync: true}) {
    return DbService().putObject<AgrCowInspection>(this,
        isSynced: isSynced, forceSync: forceSync);
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<AgrCowInspection> reload() {
    return DbService().getObjectByGuid<AgrCowInspection>(this.guid);
  }

  //////////////////////////////////////////////////////////////////////////////
  factory AgrCowInspection.fromJson(Map<String, dynamic> json) =>
      _$AgrCowInspectionFromJson(json);
  Map<String, dynamic> toJson() => _$AgrCowInspectionToJson(this);

  //////////////////////////////////////////////////////////////////////////////
  @override
  dynamic fromJson(Map<String, dynamic> json) {
    AgrCowInspection retval = AgrCowInspection.fromJson(json);
    retval.$dirty = json['\$need_sync'] ?? false;
    return retval;
  }

  //////////////////////////////////////////////////////////////////////////////
  @override
  Map<String, dynamic> toDbJson(Map<String, dynamic> json, [extra = const {}]) {
    if (json['id'] == 51) {
      json['id'] = json['id'];
    }
    return super.toDbJson(json, {
      'farm_id': json['farm'] != null ? json['farm'].id : null,
      'farm_guid': json['farm'] != null ? json['farm'].guid : null,
      'parent_farm_id': json['farm'] != null ? json['farm'].parentId : null,
      'parent_farm_guid': json['farm'] != null ? json['farm'].parentGuid : null,
      'farm_name': json['farm'] != null
          ? ((json['farm'].name ?? '') as String).toLowerCase()
          : null,
      ...extra
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<AgrBaseModel> syncDb() async {
    AgrCowInspection model = (this.id == null)
        ? await RestClient().createInspection(this.farmId ?? 0, this)
        : await RestClient().updateInspection(this.farmId ?? 0, this.id, this);
    final inspection = await model.save(isSynced: true, forceSync: true);

    if (this.id == null) {
      this.id = inspection.id;
    }

    if (this.farmId == null) {
      this.id = inspection.farmId;
    }

    print(
        'Emit inspectionUpdated. guid=${inspection.guid}, id=${inspection.id}');
    DbService().emit('inspectionUpdated', null, inspection);
    return inspection;
  }
}
