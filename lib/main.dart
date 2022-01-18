import 'package:flutter/material.dart';
import 'themeData.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:hitech_agro/app_global.dart';
import 'package:hitech_agro/ui/pages/crossroads_page.dart';
import "package:hitech_agro/app_routes.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: AppRoutes.get(),
      theme: hmTheme,
      debugShowCheckedModeBanner: false,
			navigatorObservers:[ AppGlobal.routeObserver ],

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
			supportedLocales: [
				const Locale('ru')
			],
			locale: const Locale('ru'),
      home: CrossroadsPage(),
    );
  }
}
