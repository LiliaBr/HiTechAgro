import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hitech_agro/ui/pages/contact_person_page.dart';
//import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import 'package:hitech_agro/ui/widgets/empty_list_view.dart';
import 'package:hitech_agro/ui/widgets/error_list_view.dart';
import 'package:hitech_agro/ui/widgets/load_progress_indicator.dart';


import 'package:hitech_agro/ui/widgets/inspection_list.dart';
import 'package:hitech_agro/ui/widgets/contact_list_page.dart';

import 'package:hitech_agro/app_state.dart';
import 'package:hitech_agro/app_global.dart';
import 'package:hitech_agro/app_models.dart';
import 'package:hitech_agro/services/farm_service.dart';

class HomePage extends StatefulWidget {

@override
_HomePageState createState() => _HomePageState();
}

////////////////////////////////////////////////////////////////////////////////
class _HomePageState extends State<HomePage>  with SingleTickerProviderStateMixin, RouteAware {

  final GlobalKey<ScaffoldState> _key = new GlobalKey();
  TabController _tabController;
	Future<List<AgrFarm>> _farmServiceReady;

	Key drawerKey;
  int selectedTab = 0;
  Map<String, bool> farmExpanded = {};
	Map<String, String> filter = {
		'q': '',
	};

	//////////////////////////////////////////////////////////////////////////////
	initState() {
		super.initState();
		 _tabController = TabController(vsync: this, length: 3, initialIndex: 0);

		 _farmServiceReady = FarmService().ready();

		 DbService().on('farmUpdated', null, (event, object) {
			 refreshFarms();
			 _farmServiceReady = FarmService().ready();

			 if (mounted) {
				 setState(() {});
			 }
		 });
	}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppGlobal.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  //////////////////////////////////////////////////////////////////////////////
  @override
  void dispose() {
    _tabController.dispose();
		 AppGlobal.routeObserver.unsubscribe(this);

    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
	loadFarms([bool renewKey = true]) {
		if (renewKey) {
			setState(() {
				drawerKey = UniqueKey();
			});
		}

		setState(() {
			_farmServiceReady = FarmService().ready();
		});
	}

	//////////////////////////////////////////////////////////////////////////////
	refreshFarms() {
			_farmServiceReady = FarmService().ready();
			return FarmService().refresh();
	}

  @override
  void didPush() {
    // Route was pushed onto navigator and is now topmost route.
		print('didPush');
  }

  void didPop() {
    // Route was pushed onto navigator and is now topmost route.
		print('didPop');
  }

  @override
  void didPopNext() {
		print('didPopNext');
    // Covering route was popped off the navigator.
  }

  //////////////////////////////////////////////////////////////////////////////
  buildMenuItem(AgrFarm farm) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5),
      child: Column(
        children: [
          ExpansionTile(
						key: ValueKey('${farm.guid}:${farmExpanded[farm.guid]}'),
            initiallyExpanded: farmExpanded[farm.guid] ?? false,
            onExpansionChanged: (state) {
                setState(() {
									if (state)  {
										farmExpanded = {};
										AppState().setFarm(farm);
									}
									farmExpanded[farm.guid] = state;
								});
            },

            title: Text(farm.name, style: TextStyle(	
								color: farm.guid == AppState().getFarm()?.guid ? Colors.blue : null, 
								fontSize: 16, fontWeight: FontWeight.bold)),

            children: farm.branches.map<Widget>((branch) {
							return ListTile(
                 title: buildMenuSubitem(branch)
               );
						}).toList()
          ),
          Divider()
        ]
      ),
    );
  }
 
  //////////////////////////////////////////////////////////////////////////////
  buildMenuSubitem(AgrFarm farm){
    return InkWell(
      onTap: () {
					AppState().setFarm(farm);
					Navigator.of(context).pop();
			},
      child: Row(
        children: [
          Icon(Icons.remove, size: 30, color: Colors.grey[600]),
          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

          child: Text(farm.name, style: TextStyle(fontSize: 16, 
						color: farm.guid == AppState().getFarm()?.guid ? Colors.blue : null)))

        ],
      )
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  searchField() {
    return Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(
        child: TextFormField(
					initialValue: filter['q'],
					onChanged: (String q) {
						setState(() {
							filter['q'] = q;
						});
					},
          decoration: InputDecoration(
            labelText: 'Поиск', 
            labelStyle: TextStyle( color: Colors.white, fontWeight: FontWeight.bold),
            prefixIcon: InkWell( 
              onTap: (){},
              child: Icon(Icons.search, color: Colors.white)),
            suffixIcon: Visibility(
								visible: filter['q'] != '',
								child: InkWell(
								onTap: () {
                  
									setState(() {
										filter['q'] = '';
									});								
								},
                
								child: Icon(Icons.clear, color: Colors.white))
						),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.white, width: 2)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.white, width: 2),
            ),
          ),
        )
      )
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  Widget setAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
			centerTitle: false,
      title: Padding(padding: EdgeInsets.only(top: 35, bottom: 15,),
				child: InkWell(
					onTap: () {
							setState(() {
								farmExpanded = {};
								AppState().setFarm(null);
							});						
					},
					child: SvgPicture.asset("assets/img/logo.svg", width: 200,))),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10,),
          child: IconButton(
            icon: Icon(MdiIcons.menuOpen, size: 35, color: Color(0xFF025FA3)), 
            onPressed: (){_key.currentState.openEndDrawer();}
                
          ),
        )
      ],
    );
  }

////////////////////////////////////////////////////////////////////////////////
  buildProfileDrawer(){
		final double drawerHeaderHeight = 188;
    //final double drawerEdgeDragWidth = 10;
    return Container(
      width: 400,
      child: Drawer(
				child: LayoutBuilder(
					builder: (drawerContext, constraints) {
						return Column(
							children: [
								 new SizedBox(
                		height: drawerHeaderHeight,
									child: DrawerHeader(
									decoration: BoxDecoration(
										color: Color(0xFFFF9900)),
									child: Column(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
												  children: [
												    InkWell(
															onTap: () {
              									setState(() {
																	farmExpanded = {};
																	AppState().setFarm(null);
																});
															},
															child: Text('Хозяйства', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white)),
														),
                            InkWell(
                              child: Icon(Icons.control_point,
                              color: Colors.white,
                              size: 30,),
                              onTap: ()  async {
																DbService().syncEnabled = false;
																var farm = await Navigator.of(context).pushNamed('/create_farm');
																DbService().syncEnabled = true;

																Navigator.of(drawerContext).pop();

																if (farm is AgrFarm)  {
																	await loadFarms();
																	AppState().setFarm(farm);
																	if (farm.parentGuid != null) {
																		setState(() {
																			farmExpanded = {};
																			farmExpanded[farm.parentGuid] = true;
																		});
																	} else {
																		setState(() {
																			farmExpanded = {};
																			farmExpanded[farm.guid] = true;
																		});
																	}
																}
															}
                            )
												  ],
												),
											
											searchField(),
										],
									),
								)),
								Container(
									height: constraints.maxHeight - drawerHeaderHeight,
                    //width: 500,
									child: FutureBuilder<List<AgrFarm>>(
									key: drawerKey,
									future: _farmServiceReady,
									builder: (_context, result) {
										if (result.hasData) {
												final List<AgrFarm> farms = FarmService().filterFarms(filter['q']);
												return RefreshIndicator(
													onRefresh: () {
														refreshFarms();
														setState(() => {});
														return FarmService().ready();
													},
													child: result.data.length == 0 
														? EmptyListView('Список хозяйств пуст')
														: ListView.builder(
															itemCount: farms.length,

															padding: EdgeInsets.zero,
															itemBuilder: (context, index) => buildMenuItem(farms[index])
														)
												);  
										} else if (result.hasError) {
												return ErrorListView(result.error, onRetry: () {
													setState(() {
														loadFarms();
													});
												});
										} else {
												return LoadProgressIndicator();
										}
									}
							))						
						]);
					})),
    );
	}

	//////////////////////////////////////////////////////////////////////////////
  bottomBar(){
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
        items: [ 

          BottomNavigationBarItem( 
          icon: Icon(OMIcons.search), label: 'Осмотры'),

          BottomNavigationBarItem( 
          icon: Icon(OMIcons.contactMail), label: 'Контакты'),

          BottomNavigationBarItem( 
          icon: Icon(MdiIcons.accountOutline), label: 'Профиль'),
        ],
      currentIndex: _tabController.index,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      onTap: (int index) {
      		_tabController.index = index;
			},
      
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
						key: _key,
						endDrawer: buildProfileDrawer(),
						appBar: PreferredSize(
							preferredSize: Size.fromHeight(80.0), 
							child: setAppBar()),

						body: TabBarView(
										key: ValueKey(AppState().getFarm()?.guid),
										physics: NeverScrollableScrollPhysics(),
										controller: _tabController,
										children: [
												InspectionList(),
												ContactList(),
												ContactPersonPage(),
										]),
						bottomNavigationBar: bottomBar(),
				)
				
		);
  }
}