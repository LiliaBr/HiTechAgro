import 'package:flutter/material.dart';

class AppGlobal{
  static final navKey = new GlobalKey<NavigatorState>();

	static final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
}