import 'package:hitech_agro/app_models.dart';
import 'package:hitech_agro/api/rest_client.dart';

////////////////////////////////////////////////////////////////////////////////
class FarmContactPersonService {
	Future<void> _ready;

  List<AgrContactPerson> _contactList;
	
	//////////////////////////////////////////////////////////////////////////////
  static final FarmContactPersonService _singleton = FarmContactPersonService._internal();

  //////////////////////////////////////////////////////////////////////////////
  factory FarmContactPersonService() {
    return _singleton;
  }

  //////////////////////////////////////////////////////////////////////////////
  FarmContactPersonService._internal();

  //////////////////////////////////////////////////////////////////////////////
  Future<List<AgrContactPerson>> ready() async {
		if (_ready == null) {
			refresh();
		}
		await _ready;

		_contactList = await DbService().getObjects<AgrContactPerson>(orderBy: 'name asc');
		
		return _contactList;
	}
	
	//////////////////////////////////////////////////////////////////////////////	
	syncData() async {
		const CHUNK_SIZE = 50;
		var contacts;

		do {
			try {
				AgrContactPerson lastUpdated = await DbService().getLastUpdated<AgrContactPerson>();
				Map<String, dynamic> filter = {
						'order': 'updated_at asc',
						'limit': CHUNK_SIZE,
				};

				if (lastUpdated != null) {
						filter['updatedSince'] = lastUpdated.updatedAt;
				}

				contacts = await RestClient().listContactPersons(0, filter: filter);
				for (var contact in contacts) {
					await contact.save(isSynced: true);
				}
			} catch (err) {
				print(err);
				break;
			}
		} while (contacts.length == CHUNK_SIZE);
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<void>  refresh() async {
			_contactList = [];
			_ready = syncData();
	}

	//////////////////////////////////////////////////////////////////////////////
	List<AgrContactPerson> getList () {
		return _contactList;
	}
}

