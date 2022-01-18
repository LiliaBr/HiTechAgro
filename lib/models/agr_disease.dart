import 'package:json_annotation/json_annotation.dart';
import 'package:hitech_agro/app_models.dart';

part 'agr_disease.g.dart';

////////////////////////////////////////////////////////////////////////////////
@JsonSerializable(nullable: true)
class AgrDisease extends AgrBaseModel {
  int id;
	String name;
	String description;	
	String alias;

	String guid;
	DateTime createdAt;
	DateTime updatedAt;

	List<AgrDiseaseLocation> locations;

	@JsonKey(ignore: true)
	bool $dirty;

  AgrDisease() : super('agr_disease');

	//////////////////////////////////////////////////////////////////////////////
	Future<AgrDisease> save({isSynced: false}) {
		return DbService().putObject<AgrDisease>(this, isSynced: isSynced);
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<AgrDisease> reload() {
		return DbService().getObjectByGuid<AgrDisease>(this.guid);
	}

	//////////////////////////////////////////////////////////////////////////////	
	@override 
	dynamic fromJson(Map<String, dynamic> json) {
		AgrDisease retval =  AgrDisease.fromJson(json);
		retval.$dirty = json['\$need_sync'] ?? false;
		return retval;
	}	
	
	//////////////////////////////////////////////////////////////////////////////	
	@override
	Map<String, dynamic> toDbJson(Map<String, dynamic> json, [extra = const {}]) {
		return super.toDbJson(json, {
				'name': (json['name'] ?? '').toLowerCase(),
				...extra
		});
	}

  factory AgrDisease.fromJson(Map<String, dynamic> json) => _$AgrDiseaseFromJson(json);
  Map<String, dynamic> toJson() => _$AgrDiseaseToJson(this);
}
