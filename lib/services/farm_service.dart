import 'package:hitech_agro/app_models.dart';
import 'package:hitech_agro/api/rest_client.dart';

////////////////////////////////////////////////////////////////////////////////
class FarmService {
  Future<void> _ready;

	List<AgrFarm> _farmList;
  List<AgrFarm> _branchList;	
	
	Map<String, AgrFarm> _farmIndex = {};

  //////////////////////////////////////////////////////////////////////////////
  static final FarmService _singleton = FarmService._internal();

  //////////////////////////////////////////////////////////////////////////////
  factory FarmService() {
    return _singleton;
  }

  //////////////////////////////////////////////////////////////////////////////
  FarmService._internal();

	//////////////////////////////////////////////////////////////////////////////	
	syncData() async {
		const CHUNK_SIZE = 50;
		var farms;

		do {
			try {
				AgrFarm lastUpdated = await DbService().getLastUpdated<AgrFarm>();
				Map<String, dynamic> filter = {
						'order': 'updated_at asc',
						'limit': CHUNK_SIZE,
				};

				if (lastUpdated != null) {
						filter['updatedSince'] = lastUpdated.updatedAt;
				}

				farms = await RestClient().listFarms(filter: filter);
				for (var farm in farms) {
					await farm.save(isSynced: true);
				}
			} catch (err) {
				print(err);
				break;
			}
		} while (farms.length == CHUNK_SIZE);
	}


  //////////////////////////////////////////////////////////////////////////////
  Future<List<AgrFarm>> ready() async {
		if (_ready == null) {
			refresh();
		}
		await _ready;

		_farmList = await DbService().getObjects<AgrFarm>(orderBy: 'farm_name asc');

		_branchList = [];
		for (var farm in _farmList) {
			_farmIndex[farm.guid] = farm;			
			
			for (int i = 0; i < farm.branches.length; i++) {
				_branchList.add(farm.branches[i]);
			}
		}
		
		return _farmList;
	}
	
	//////////////////////////////////////////////////////////////////////////////
	Future<void>  refresh() async {
			_farmList = null;
			_farmIndex = {};
			_ready = syncData();
			return _ready;
	}

	//////////////////////////////////////////////////////////////////////////////
	List<AgrFarm> getList () {
		return _farmList;
	}

	//////////////////////////////////////////////////////////////////////////////
	AgrFarm findByGuid(String guid) {
		return _farmList.firstWhere((farm) => farm.guid == guid, orElse: () => null);
	}

	//////////////////////////////////////////////////////////////////////////////
	List<AgrFarm> filterFarms(String q, {includeBranches = true}) {
			//todo: thix this == null
			if (_farmList == null || _farmList.isEmpty) return [];

			return _farmList.where((farm) {
					if (farm.name.toLowerCase().contains(q.toLowerCase())) return true;
					
					if (includeBranches) {
						for (int i = 0; i < farm.branches.length; i++) {
							AgrFarm branch = farm.branches[i];
							if (branch.name.toLowerCase().contains(q.toLowerCase())) return true;
						}
					}

					return false;
			}, ).toList();
	}


	//////////////////////////////////////////////////////////////////////////////
	List<AgrFarm> filterBranches(String farmGuid, String q) {
			final farm = _farmIndex[farmGuid];
			if (farm == null) return [];

			return farm.branches.where((branch) {
				return (branch.name.toLowerCase().contains(q.toLowerCase()));
			}).toList();
	} 
}

