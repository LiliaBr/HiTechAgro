import 'package:flutter/material.dart';
import 'package:hitech_agro/ui/pages/assign_farm_page.dart';
import 'package:hitech_agro/ui/pages/create_inspection_page.dart';
import 'package:hitech_agro/ui/pages/farm_information_page.dart';
import 'ui/widgets/inspection_list.dart';
import 'ui/pages/inspection_cow_page.dart';
import 'ui/pages/inspection_page.dart';

import 'package:hitech_agro/ui/pages/inspection_cow_page.dart';
import 'package:hitech_agro/ui/pages/login_page.dart';
import 'package:hitech_agro/ui/pages/contact_person_page.dart';
import 'package:hitech_agro/ui/pages/crossroads_page.dart';
import 'package:hitech_agro/ui/pages/create_farm_page.dart';
import 'package:hitech_agro/ui/pages/edit_contact_info_page.dart';
import 'package:hitech_agro/ui/pages/create_contact_page.dart';

import 'package:hitech_agro/ui/pages/select_farm_page.dart';
import 'package:hitech_agro/ui/pages/select_farm_user_page.dart';

import 'package:hitech_agro/ui/pages/report_analyze_page.dart';
import 'package:hitech_agro/ui/pages/report_protocol_page.dart';

import 'package:hitech_agro/ui/pages/report_rating_analyze_page.dart';
import 'package:hitech_agro/ui/pages/report_rating_protocol_page.dart';

import 'package:hitech_agro/ui/pages/report_analyze_pruning_page.dart';


class AppRoutes {
  static final Map<String, Widget Function(BuildContext)> _routes = {
	 '/crossroads': (context) => CrossroadsPage(),
   '/login': (context) => LoginPage(),
	 
   '/inspection_list': (context) => InspectionList(),
   '/inspection': (context) => InspectionPage(),
   '/inspection_cow': (context) => InspectionCowPage(),
   '/contact_person' : (context) => ContactPersonPage(),
   '/edit_contact_person' : (context) => EditContactInfoPage(),

   '/create_contact' : (context) => CreateContactPage(),
   '/create_farm': (context) => CreateFarmPage(),
   '/create_inspection': (context) => CreateInspectionPage(),

	 '/select_farm':  (context) => SelectFarmPage(),
	 '/select_farm_user':  (context) => SelectFarmUserPage(),
   '/assign_farm':  (context) => AssignFarmPage(),
   '/information':  (context) => FarmInformationPage(),

	 '/report_analyze':  (context) => ReportAnalyzePage(),
	 '/report_protocol':  (context) => ReportProtocolPage(),

	 '/report_rating_analyze':  (context) => ReportRatingAnalyzePage(),
	 '/report_rating_protocol':  (context) => ReportRatingProtocolPage(),

   '/report_analyze_pruning':  (context) => ReportAnalyzePruningPage(),
  };

  static Map<String, Widget Function(BuildContext)> get() => _routes;
}


