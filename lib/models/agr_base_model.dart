import 'dart:convert';

////////////////////////////////////////////////////////////////////////////////
abstract class AgrBaseModel {
	final String tableName;

	AgrBaseModel(this.tableName);
	
	//////////////////////////////////////////////////////////////////////////////
	dynamic fromJson(Map<String, dynamic> json) {
		return null;
	}

	//////////////////////////////////////////////////////////////////////////////
	Map<String, dynamic> toJson() {
		return null;
	}

	//////////////////////////////////////////////////////////////////////////////
	dynamic fromJsonString(String str) {
		Map<String, dynamic> json = jsonDecode(str);
		return fromJson(json);
	}

	//////////////////////////////////////////////////////////////////////////////
	Map<String, dynamic> toDbJson(Map<String, dynamic> json, [extra = const {}]) {
		return {
					'id': 				json['id'],
					'guid': 			json['guid'],
					'created_at': json['createdAt'],
					'updated_at': json['updatedAt'],
					'data': 			jsonEncode(json),

					...extra
				};
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<AgrBaseModel> syncDb() async {
		print("FIXME: syncDb method not implemented ${this.runtimeType.toString()}");
		return null;
	}
}
