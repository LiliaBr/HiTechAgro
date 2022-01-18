import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hitech_agro/api/rest_client.dart';
import 'package:hitech_agro/ui/pages/login_page.dart';
import 'package:hitech_agro/ui/pages/home_page.dart';
import 'package:hitech_agro/models/user.dart';
import 'package:hitech_agro/app_state.dart';

import 'package:hitech_agro/services/db_service.dart';
import 'package:hitech_agro/services/disease_service.dart';
import 'package:hitech_agro/services/farm_service.dart';
import 'package:hitech_agro/services/farm_user_service.dart';
import 'package:hitech_agro/services/inspection_service.dart';
import 'package:hitech_agro/services/farm_contact_person_service.dart';

////////////////////////////////////////////////////////////////////////////////
class CrossroadsPage extends StatefulWidget {
  @override
  _CrossroadsPageState createState() => _CrossroadsPageState();
}

////////////////////////////////////////////////////////////////////////////////
class _CrossroadsPageState extends State<CrossroadsPage> {
  Future<User> _userProfile;
  AppState _appState = AppState();

  //////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();

    _userProfile = RestClient().getProfile().then((profile) async {
			await DbService().ready();

			await Future.wait([
				DiseaseService().ready(),
				FarmService().ready(),
				FarmUserService().ready(),
				InspectionService().ready(),
				FarmContactPersonService().ready(),
			]);

			return profile;
		});
  }

  //////////////////////////////////////////////////////////////////////////////
  switchToHome(profileResponse) {
    _appState.setProfile(profileResponse);
    return HomePage();
  }

  //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _appState,
        child: FutureBuilder<User>(
            future: _userProfile,
            builder: (context, result) {
              if (result.hasData) {
                return switchToHome(result.data);
              } else if (result.hasError) {
								print(result.error);
                return LoginPage();
              } else {
                return Scaffold(
                    body: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [CircularProgressIndicator()])));
              }
            }));
  }
}
