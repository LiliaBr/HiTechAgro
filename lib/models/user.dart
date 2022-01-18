import 'package:json_annotation/json_annotation.dart';
import 'package:hitech_agro/app_models.dart';

part 'user.g.dart';

////////////////////////////////////////////////////////////////////////////////
@JsonSerializable(nullable: true)
class User extends AgrBaseModel  {
  int id;
  String email;
	String guid;
  String name;
  String password;
	
	DateTime createdAt;
	DateTime updatedAt;

	String role;
	List<String> authItems;
	Map<String, bool> _authItemIndex = {};

  Map<String, List<String>> errors;

	@JsonKey(ignore: true)
	bool $dirty;

  User({this.id, this.email, this.name}) : super('agr_farm_user');
  User.credentials(this.email, this.password) : super('agr_farm_user');

	//////////////////////////////////////////////////////////////////////////////
	checkAccess(operation) {
		if (_authItemIndex.isEmpty) {
				for (var item in authItems) {
					_authItemIndex[item] = true;
				}
		}

		return _authItemIndex[operation] == true;
	}
	
	//////////////////////////////////////////////////////////////////////////////
	roleIs(role) {
		return this.role == role;
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<User> save({isSynced: false}) {
		return DbService().putObject<User>(this, isSynced: isSynced);
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<User> reload() {
		return DbService().getObjectByGuid<User>(this.guid);
	}

	//////////////////////////////////////////////////////////////////////////////	
	@override 
	dynamic fromJson(Map<String, dynamic> json) {
		User retval =  User.fromJson(json);
		retval.$dirty = json['\$need_sync'] ?? false;
		return retval;
	}	
	
	//////////////////////////////////////////////////////////////////////////////	
	@override
	Map<String, dynamic> toDbJson(Map<String, dynamic> json, [extra = const {}]) {
		return super.toDbJson(json, {
				'name': (json['name'] ?? '').toLowerCase(),
				'email': (json['email'] ?? '').toLowerCase(),
				...extra
		});
	}

	//////////////////////////////////////////////////////////////////////////////
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
