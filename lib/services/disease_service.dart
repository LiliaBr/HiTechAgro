import 'package:hitech_agro/app_models.dart';
import 'package:hitech_agro/api/rest_client.dart';

////////////////////////////////////////////////////////////////////////////////
class DiseaseService {
	Future<void> _ready;

  List<AgrDisease> _diseaseList;
	
	Map<int, AgrDisease> _diseaseIndex = {};
	Map<int, AgrDiseaseLocation> _diseaseLocationIndex = {};	
	List<AgrDiseaseLocation> _diseaseLocationList = [];	

  ////////////////////////////////////////////////////////////////////////////
  static final DiseaseService _singleton = DiseaseService._internal();

  ////////////////////////////////////////////////////////////////////////////
  factory DiseaseService() {
    return _singleton;
  }

  ////////////////////////////////////////////////////////////////////////////
  DiseaseService._internal();

	//////////////////////////////////////////////////////////////////////////////
	Future<void>  refresh() async {
			_diseaseList = null;
			_ready = syncData();
	}

  ////////////////////////////////////////////////////////////////////////////
  Future<void> ready() async {
		if (_ready == null) {
			refresh();
		}
		await _ready;

    if (_diseaseList == null) {
			_diseaseList = await DbService().getObjects<AgrDisease>(orderBy: 'name asc');

			for (var disease in _diseaseList) {
				_diseaseIndex[disease.id] = disease;

				for (var location in disease.locations) {
					_diseaseLocationIndex[location.id] = location;
				}

				_diseaseLocationList = _diseaseLocationIndex.values.toList();
				
				if (_diseaseLocationList.isNotEmpty) {
					_diseaseLocationList.sort((a, b) {
						if (a.segment.indexOf(RegExp(r'[^0-9]')) >= 0 && b.segment.indexOf(RegExp(r'[^0-9]')) >= 0) {
							return a.segment.compareTo(b.segment);
						} else if (a.segment.indexOf(RegExp(r'[^0-9]')) >= 0 && b.segment.indexOf(RegExp(r'[^0-9]')) < 0) {
							return -1;
						} else if (a.segment.indexOf(RegExp(r'[^0-9]')) < 0 && b.segment.indexOf(RegExp(r'[^0-9]')) >= 0) {
							return 1;
						} else {
							int aPos = int.tryParse(a.segment.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
							int bPos = int.tryParse(b.segment.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
							return aPos.compareTo(bPos);							
						}
					});
				}
			}
    }
  }

	//////////////////////////////////////////////////////////////////////////////	
	syncData() async {
		const CHUNK_SIZE = 50;
		var diseases;

		do {
			try {
				AgrDisease lastUpdated = await DbService().getLastUpdated<AgrDisease>();
				Map<String, dynamic> filter = {
						'order': 'updated_at asc',
						'limit': CHUNK_SIZE,
				};

				if (lastUpdated != null) {
						filter['updatedSince'] = lastUpdated.updatedAt;
				}

				diseases = await RestClient().listDiseases(filter: filter);
				for (var disease in diseases) {
					await disease.save(isSynced: true);
				}
			} catch (err) {
				print(err);
				break;
			}
		} while (diseases.length == CHUNK_SIZE);
	}

  ////////////////////////////////////////////////////////////////////////////
  List<AgrDisease> getList() => _diseaseList;

	////////////////////////////////////////////////////////////////////////////
  List<AgrDiseaseLocation> findLocationsByRegion(String region) {
		if (_diseaseLocationList.isEmpty) return [];
		return _diseaseLocationList.where((location) => location?.region == region).toList();
	}

  ////////////////////////////////////////////////////////////////////////////
  AgrDisease findDiseaseById(int id) {
		if (id == null) return null;

    if (_diseaseList == null) {
      throw ('DiseaseService.ready must be called and awaited before issuing futher service methods');
    }
		return _diseaseIndex[id];
  }

  ////////////////////////////////////////////////////////////////////////////
  AgrDiseaseLocation findLocationById(int id) {
		if (id == null) return null;

    if (_diseaseLocationList == null) {
      throw ('DiseaseService.ready must be called and awaited before issuing futher service methods');
    }
		return _diseaseLocationIndex[id];
  }

	
}
