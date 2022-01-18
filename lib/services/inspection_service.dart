import 'package:hitech_agro/app_models.dart';
import 'package:hitech_agro/api/rest_client.dart';

////////////////////////////////////////////////////////////////////////////////
class InspectionService {
	//////////////////////////////////////////////////////////////////////////////
  static final InspectionService _singleton = InspectionService._internal();

  //////////////////////////////////////////////////////////////////////////////
  factory InspectionService() {
    return _singleton;
  }

  //////////////////////////////////////////////////////////////////////////////
  InspectionService._internal();

	//////////////////////////////////////////////////////////////////////////////	
	syncData() async {
		const CHUNK_SIZE = 50;
		var inspections;

		do {
			try {
				AgrCowInspection lastUpdated = await DbService().getLastUpdated<AgrCowInspection>();
				Map<String, dynamic> filter = {
						'order': 'updated_at asc',
						'limit': CHUNK_SIZE,
				};

				if (lastUpdated != null) {
						filter['updatedSince'] = lastUpdated.updatedAt;
				}

				inspections = await RestClient().listInspections(0, filter: filter);
				for (var inspection in inspections) {
					await inspection.save(isSynced: true);
				}
			} catch (err) {
				print(err);
				break;
			}
		} while (inspections.length == CHUNK_SIZE);
	}

  //////////////////////////////////////////////////////////////////////////////
  Future<void> ready() async {
		return syncData();
	}
	
	//////////////////////////////////////////////////////////////////////////////
	Future<void>  refresh() {
			return ready();
	}
}

