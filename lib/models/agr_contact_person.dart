import 'package:json_annotation/json_annotation.dart';
import 'package:hitech_agro/app_models.dart';

part 'agr_contact_person.g.dart';

////////////////////////////////////////////////////////////////////////////////
@JsonSerializable(nullable: true)
class AgrContactPerson extends AgrBaseModel {
  int id;
  String guid;
	DateTime createdAt;
	DateTime updatedAt;

  String name;
	String description;
	String phone;
	String email;

	String phone2;
	String email2;
	String position;
	
	List<AgrFarm> farms;

	@JsonKey(ignore: true)
	bool $dirty;

  AgrContactPerson() : super('agr_farm_contact_person');

	//////////////////////////////////////////////////////////////////////////////
	Future<AgrContactPerson> save({isSynced: false, forceSync: false}) {
		return DbService().putObject<AgrContactPerson>(this, isSynced: isSynced, forceSync: forceSync);
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<User> reload() {
		return DbService().getObjectByGuid<User>(this.guid);
	}

	//////////////////////////////////////////////////////////////////////////////	
	@override 
	dynamic fromJson(Map<String, dynamic> json) {
		AgrContactPerson retval =  AgrContactPerson.fromJson(json);
		retval.$dirty = json['\$need_sync'] ?? false;
		return retval;
	}	
	
	//////////////////////////////////////////////////////////////////////////////	
	@override
	Map<String, dynamic> toDbJson(Map<String, dynamic> json, [extra = const {}]) {
		return super.toDbJson(json, {
				'farm_guid': json['farms'] != null	? (json['farms'] as List<AgrFarm>)
																							.map((farm) => farm.guid)
																							.where((guid) => guid != null)
																							.toList()
																							.join('|') : null,

				'parent_farm_guid': json['farms'] != null	? (json['farms'] as List<AgrFarm>)
																							.map((farm) => farm.parentGuid)
																							.where((guid) => guid != null)
																							.toList()
																							.join('|') : null,

				'name': (json['name'] ?? '').toLowerCase(),
				'email': (json['email'] ?? '').toLowerCase(),
				...extra
		});
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<AgrBaseModel> syncDb() async {
		AgrContactPerson model = (this.id == null) ? await RestClient().createContactPerson(this)
																	    : await RestClient().updateContactPerson(this.id, this);

		final person = await model.save(isSynced: true, forceSync: true);

		if (this.id == null) {
			this.id = person.id;
		}
		
		print('Emit contactPersonUpdated. guid=${person.guid}, id=${person.id}');
		DbService().emit('contactPersonUpdated', null, person);	
		return person;
	}
	
  factory AgrContactPerson.fromJson(Map<String, dynamic> json) => _$AgrContactPersonFromJson(json);
	
	@override
  Map<String, dynamic> toJson() => _$AgrContactPersonToJson(this);
}
