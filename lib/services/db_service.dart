
import 'dart:convert';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hitech_agro/app_models.dart';
import 'package:eventify/eventify.dart';
export 'package:eventify/eventify.dart';

////////////////////////////////////////////////////////////////////////////////
class DbService  extends EventEmitter {
	Map<String, AgrBaseModel> factories = {
		'AgrCowInspection': AgrCowInspection(),
		'AgrFarm': 					AgrFarm(),
		'AgrDisease':  			AgrDisease(),
		'AgrContactPerson': AgrContactPerson(),
		'User': 						User(),
	};

	Map<String, String> dbModelMap = {
		'agr_farm': 						'AgrFarm',
		'agr_inspection': 			'AgrCowInspection',
		'agr_farm_contact_person': 	'AgrContactPerson',
	};

  //////////////////////////////////////////////////////////////////////////////
  static final DbService _singleton = DbService._internal();

  //////////////////////////////////////////////////////////////////////////////
  factory DbService() {
    return _singleton;
  }

  //////////////////////////////////////////////////////////////////////////////
  DbService._internal();

	Database database;
	Future<Database> databaseFuture;
	bool syncEnabled = true;

	//////////////////////////////////////////////////////////////////////////////
	Future<void> ready() async {

		if (database == null) {
			
			var databasesPath = await getDatabasesPath();
			String path = join(databasesPath, 'hitech.db');		

//			await deleteDatabase(path);

			database = await openDatabase(path, version: 1,
					onCreate: (Database db, int version) async {

						////////////////////////////////////////////////////////////////////
						await db.execute('CREATE TABLE agr_inspection (rid INTEGER PRIMARY KEY, id INT, guid TEXT, created_at TEXT, updated_at TEXT, sync_at TEXT, need_sync INT,'
														 'farm_id INT, farm_guid TEXT, parent_farm_id INT, parent_farm_guid TEXT, farm_name TEXT, data TEXT);');

						await db.execute('CREATE UNIQUE INDEX agr_inspection_guid_idx ON agr_inspection(guid);');
						await db.execute('CREATE INDEX agr_inspection_updated_at_idx ON agr_inspection(updated_at);');
						await db.execute('CREATE INDEX agr_inspection_farm_id_idx ON agr_inspection(farm_id);');
						await db.execute('CREATE INDEX agr_inspection_parent_farm_id_idx ON agr_inspection(parent_farm_id);');
						await db.execute('CREATE INDEX agr_inspection_parent_farm_guid_idx ON agr_inspection(parent_farm_guid);');						
						await db.execute('CREATE INDEX agr_inspection_farm_name_idx ON agr_inspection(farm_name);');												
						await db.execute('CREATE INDEX agr_inspection_sync_at_idx ON agr_inspection(sync_at);');

						////////////////////////////////////////////////////////////////////
						await db.execute('CREATE TABLE agr_farm (rid INTEGER PRIMARY KEY, id INT, guid TEXT, created_at TEXT, updated_at TEXT, sync_at TEXT, need_sync INT,'
														 'farm_id INT, farm_guid TEXT, parent_farm_id INT, parent_farm_guid TEXT, farm_name TEXT, data TEXT);');

						await db.execute('CREATE UNIQUE INDEX agr_farm_guid_idx ON agr_farm(guid);');
						await db.execute('CREATE INDEX agr_farm_updated_at_idx ON agr_farm(updated_at);');
						await db.execute('CREATE INDEX agr_farm_farm_id_idx ON agr_farm(farm_id);');
						await db.execute('CREATE INDEX agr_farm_farm_guid_idx ON agr_farm(farm_guid);');
						await db.execute('CREATE INDEX agr_farm_parent_farm_id_idx ON agr_farm(parent_farm_id);');
						await db.execute('CREATE INDEX agr_farm_parent_farm_guid_idx ON agr_farm(parent_farm_guid);');
						await db.execute('CREATE INDEX agr_farm_farm_name_idx ON agr_farm(farm_name);');												
						await db.execute('CREATE INDEX agr_farm_sync_at_idx ON agr_farm(sync_at);');

						////////////////////////////////////////////////////////////////////
						await db.execute('CREATE TABLE agr_disease (rid INTEGER PRIMARY KEY, id INT, guid TEXT, created_at TEXT, updated_at TEXT, sync_at TEXT, need_sync INT,'
														 'name TEXT, data TEXT);');

						await db.execute('CREATE UNIQUE INDEX agr_disease_guid_idx ON agr_disease(guid);');
						await db.execute('CREATE INDEX agr_disease_updated_at_idx ON agr_disease(updated_at);');
						await db.execute('CREATE INDEX agr_disease_name_idx ON agr_disease(name);');												
						await db.execute('CREATE INDEX agr_disease_sync_at_idx ON agr_disease(sync_at);');

						////////////////////////////////////////////////////////////////////
						await db.execute('CREATE TABLE agr_farm_contact_person (rid INTEGER PRIMARY KEY, id INT, guid TEXT, created_at TEXT, updated_at TEXT, sync_at TEXT, need_sync INT,'
														 'farm_guid TEXT, parent_farm_guid TEXT, name TEXT, email TEXT, data TEXT);');

						await db.execute('CREATE UNIQUE INDEX agr_farm_contact_person_guid_idx ON agr_farm_contact_person(guid);');
						await db.execute('CREATE INDEX agr_farm_contact_person_updated_at_idx ON agr_farm_contact_person(updated_at);');
						await db.execute('CREATE INDEX agr_farm_contact_person_farm_guid_idx ON agr_farm_contact_person(farm_guid);');
						await db.execute('CREATE INDEX agr_farm_contact_person_parent_farm_guid_idx ON agr_farm_contact_person(parent_farm_guid);');
						await db.execute('CREATE INDEX agr_farm_contact_person_name_idx ON agr_farm_contact_person(name);');												
						await db.execute('CREATE INDEX agr_farm_contact_person_email_idx ON agr_farm_contact_person(email);');						
						await db.execute('CREATE INDEX agr_farm_contact_person_sync_at_idx ON agr_farm_contact_person(sync_at);');

						////////////////////////////////////////////////////////////////////
						await db.execute('CREATE TABLE agr_farm_user (rid INTEGER PRIMARY KEY, id INT, guid TEXT, created_at TEXT, updated_at TEXT, sync_at TEXT, need_sync INT,'
														 'name TEXT, email TEXT, data TEXT);');

						await db.execute('CREATE UNIQUE INDEX agr_farm_user_guid_idx ON agr_farm_user(guid);');
						await db.execute('CREATE INDEX agr_farm_user_updated_at_idx ON agr_farm_user(updated_at);');
						await db.execute('CREATE INDEX agr_farm_user_name_idx ON agr_farm_user(name);');												
						await db.execute('CREATE INDEX agr_farm_user_email_idx ON agr_farm_user(email);');						
						await db.execute('CREATE INDEX agr_farm_user_sync_at_idx ON agr_farm_user(sync_at);');
				});	
		}

		await database.execute('PRAGMA case_sensitive_like=OFF;');

		_periodicSync();

		return database;
	}

	////////////////////////////////////////////////////////////////////////////
	_periodicSync() {
		Timer(Duration(seconds: 10), () async {
				if (syncEnabled) {
					print('Check dirty DB objects');
					try {
							await syncDb();
					} catch (err) {
						print(err);
					}
				} else {
					print('Live sync disabled. skip time frame');
				}
				_periodicSync();
		});
	}

	//////////////////////////////////////////////////////////////////////////////
	AgrBaseModel getFactory<T extends AgrBaseModel>() {
		// fucking dart doesn't allow generics instantination
		return factories[T.toString()];
	}

	//////////////////////////////////////////////////////////////////////////////
	String getTableName<T extends AgrBaseModel>() {
		return getFactory<T>().tableName;
	}
	
	//////////////////////////////////////////////////////////////////////////////
	Future<int> countObjects<T extends AgrBaseModel>() async {
		final tableName = getTableName<T>();

		List<Map<String, dynamic>> result = await database.rawQuery('SELECT count(*) as count from $tableName');

		return result.toList()[0]['count'];
	}
	
	//////////////////////////////////////////////////////////////////////////////
	Map<String, dynamic> _dbRowToJson(Map row) {
		Map retval = jsonDecode(row['data']);
		retval['\$need_sync'] = (row['need_sync'] ?? 0) > 0;

		retval['updatedAt'] = row['updated_at'];

		return retval;
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<List<T>> getObjects<T extends AgrBaseModel>({int offset = 0, int limit = 50, orderBy = 'id desc',
			where, whereArgs}) async {
		print('Read objects ${T.toString()} from DB...');
		where = (where ?? '').length > 0 ? where : null;
		whereArgs = (whereArgs ?? []).length > 0 ? whereArgs : null;

		List<Map<String, dynamic>> result = await database.query(getTableName<T>(), 
				where: where, 
				whereArgs: whereArgs, 
				offset: offset, limit: limit,
				orderBy: orderBy);		

		return result.map<T>((item) {			
			return getFactory<T>().fromJson(_dbRowToJson(item));
		}).toList();
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<T> getObjectByGuid<T extends AgrBaseModel>(String guid) async {
		List<Map<String, dynamic>> result = await database.query(getTableName<T>(), 
				where: "guid = ?", 
				whereArgs: [guid], 
				offset: 0, limit: 1);		
		
		var rows = result.toList();
		if (rows.isEmpty) return null;

		return getFactory<T>().fromJson(_dbRowToJson(rows[0]));
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<T> getLastUpdated<T extends AgrBaseModel>() async {
		List<Map<String, dynamic>> result = await database.query(getTableName<T>(), 
				orderBy: 'updated_at desc',
				offset: 0, limit: 1,);		
		
		var rows = result.toList();
		if (rows.isEmpty) return null;

		return getFactory<T>().fromJson(_dbRowToJson(rows[0]));
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<bool> objectExists<T extends AgrBaseModel>(String guid) async {
		List<Map<String, dynamic>> result = await database.query(getTableName<T>(), 
				where: "guid = ?", 
				whereArgs: [guid], 
				offset: 0, limit: 1);		
		
		var rows = result.toList();
		return rows.isNotEmpty;
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<T> putObject<T extends AgrBaseModel>(T objectT, {bool isSynced = false, bool forceSync = false}) async {
			AgrBaseModel object = objectT;
			Map<String, dynamic> json = object.toJson();

			final tableName = getTableName<T>();

			if (json['guid'] == null) {
//todo  check what to do
			}

			Map<String, dynamic> record = getFactory<T>().toDbJson(json);

			if (isSynced) {
				record['sync_at'] = DateTime.now().toIso8601String();
				record['need_sync'] = 0;
			} else {
				record['need_sync'] = 1;
				record['updated_at'] = DateTime.now().toIso8601String();
			}

			List<Map<String, dynamic>> result = await database.query(tableName,  
					where: "guid = ?", 
					whereArgs: [json['guid']], 
					offset: 0, limit: 1);		
		
			var rows = result.toList();
			bool exists = rows.isNotEmpty;

			if (exists && isSynced) {
				var current = rows[0];
				if ((current['need_sync'] ?? 0) > 0 && !forceSync) {
						print('DB object ${T.toString()}, guid=${json['guid']} is dirty, skip store');
						return getFactory<T>().fromJson(_dbRowToJson(rows[0]));
				}

				String updatedAt = rows[0]['updated_at'];
				if (updatedAt == json['updatedAt']) {
						print('DB object ${T.toString()}, guid=${json['guid']} is up to date, skip store');
						return getFactory<T>().fromJson(_dbRowToJson(rows[0]));
				}
			}

			if (exists) {
				print('Update DB model ${T.toString()}, guid=${json['guid']}, updatedAt=${record['updated_at']}');
				await database.update(getTableName<T>(), record, where: 'guid = ?', whereArgs: [record['guid']]);				
			} else {
				print('Insert DB model ${T.toString()}, guid=${json['guid']}, updatedAt=${record['updated_at']}');
				await database.insert(getTableName<T>(), record);
			}
			return getObjectByGuid<T>(json['guid']);
	}

	Future<void> syncDb() async {    
		for (var tableName in dbModelMap.keys) {
			List<Map<String, dynamic>> rows = await database.query(tableName, where: 'need_sync <> 0');
			String modelName = dbModelMap[tableName];

			print('Number or dirty $modelName objects: ${rows.length}');
			var modelFactory = factories[modelName];

			for (var row in rows) {
				try {
					AgrBaseModel model = modelFactory.fromJson(_dbRowToJson(row));
					await model.syncDb();
				} catch (err) {
					print(err);
				}
			}
		}

	}
}
