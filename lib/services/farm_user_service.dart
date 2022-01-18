import 'package:hitech_agro/app_models.dart';
import 'package:hitech_agro/api/rest_client.dart';

////////////////////////////////////////////////////////////////////////////////
class FarmUserService {
	Future<void> _ready;

  List<User> _userList;
	
	//////////////////////////////////////////////////////////////////////////////
  static final FarmUserService _singleton = FarmUserService._internal();

  //////////////////////////////////////////////////////////////////////////////
  factory FarmUserService() {
    return _singleton;
  }

  //////////////////////////////////////////////////////////////////////////////
  FarmUserService._internal();

  //////////////////////////////////////////////////////////////////////////////
  Future<List<User>> ready() async {
		if (_ready == null) {
			refresh();
		}
		await _ready;

		_userList = await DbService().getObjects<User>(orderBy: 'name asc');
		
		return _userList;
	}
	
	//////////////////////////////////////////////////////////////////////////////	
	syncData() async {
		const CHUNK_SIZE = 50;
		var users;

		do {
			try {
				User lastUpdated = await DbService().getLastUpdated<User>();
				Map<String, dynamic> filter = {
						'order': 'updated_at asc',
						'limit': CHUNK_SIZE,
				};

				if (lastUpdated != null) {
						filter['updatedSince'] = lastUpdated.updatedAt;
				}

				users = await RestClient().listFarmUsers(filter: filter);
				for (var user in users) {
					await user.save(isSynced: true);
				}
			} catch (err) {
				print(err);
				break;
			}
		} while (users.length == CHUNK_SIZE);
	}
	
	//////////////////////////////////////////////////////////////////////////////
	User findById(int id) {
		return _userList.firstWhere((user) => user.id == id, orElse: () => null);
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<void>  refresh() async {
			_userList = [];
			_ready = syncData();
	}

	//////////////////////////////////////////////////////////////////////////////
	List<User> getList () {
		return _userList;
	}
}

