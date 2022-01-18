import 'package:flutter/material.dart';

import 'package:hitech_agro/app_models.dart';

////////////////////////////////////////////////////////////////////////////////
class AppState extends ChangeNotifier {

	static final AppState _singleton = AppState._internal();
  User _profile;
	AgrFarm _farm;

	AppState._internal() : super();

   factory AppState() {
    return _singleton;
  }

  //////////////////////////////////////////////////////////////////////////////
  @override
  dispose() {
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
  setProfile(User profile) {
    _profile = profile;
    notifyListeners();
  }

  //////////////////////////////////////////////////////////////////////////////
  setFarm(AgrFarm farm) {
    _farm = farm;
    notifyListeners();
  }

  //////////////////////////////////////////////////////////////////////////////
  User getProfile() => _profile;
  AgrFarm getFarm() => _farm;
}
