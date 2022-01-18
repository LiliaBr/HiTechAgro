import 'package:flutter/material.dart';
import 'package:hitech_agro/ui/dialogs/confirm_dialog.dart';

import 'package:hitech_agro/ui/widgets/internal_page_scaffold.dart';
import "package:hitech_agro/app_models.dart";

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:hitech_agro/ui/widgets/empty_list_view.dart';
import 'package:hitech_agro/ui/widgets/error_list_view.dart';

import 'package:hitech_agro/extensions/datetime_format.dart';
import 'package:hitech_agro/ui/dialogs/add_cow_dialog.dart';

////////////////////////////////////////////////////////////////////////////////
class InspectionPage extends StatefulWidget {
  @override
  InspectionPageState createState()=> InspectionPageState();
}

////////////////////////////////////////////////////////////////////////////////
class InspectionPageState extends State <InspectionPage> {
	AgrCowInspection inspection;
	List<AgrCow> cows;

	Key key;
	TextEditingController textSearchController = TextEditingController();
	TextEditingController totalCowCountController = TextEditingController();


	Map<String, dynamic> filter = {
		'limit': -1,
	};

  @override
  void dispose() {
    super.dispose();
  }
	
	//////////////////////////////////////////////////////////////////////////////
	didChangeDependencies() {
		
		inspection = ModalRoute.of(context).settings.arguments;
		cows = inspection.cows;

		super.didChangeDependencies();
	}

	//////////////////////////////////////////////////////////////////////////////
	filterCows() {
		setState(() {
			if (textSearchController.text.isEmpty) {
				cows = this.inspection.cows;
			}

			cows = this.inspection.cows.where((cow) {
				return textSearchController.text.matchAsPrefix(cow.number) != null;
			}).toList();
		});
	}

	//////////////////////////////////////////////////////////////////////////////
	refreshInspection() async {
			inspection = await inspection.reload();
			cows = inspection.cows;

			//print(inspection.cows[0].diseases);
			setState(() {});
	}

	//////////////////////////////////////////////////////////////////////////////
	Future<void> updateInspection() async {
	}

	//////////////////////////////////////////////////////////////////////////////
  removeCow(AgrCow cow) {
		showDialog(context: context, builder: (BuildContext dialogContext) {
			return ConfirmDialog('Корова будет удалена из осмотра, продолжить?', () async {
				try {
					inspection.cows.removeWhere((c) => c == cow);
					inspection = await inspection.save();
					setState(() {
						cows = inspection.cows;
					});
					Navigator.of(dialogContext).pop();
				} catch (error) {
					ErrorListView.showErrorDialog(context, 'Ошибка', error);
				}
			});
		});
	}

  //////////////////////////////////////////////////////////////////////////////
  searchField(){
    return Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        child: TextField(
					controller: textSearchController,
          style: TextStyle( height: 0.5,),
					onChanged: (String q) {
							filterCows();
					},
          decoration: InputDecoration(
            labelText: 'Поиск', 
            prefixIcon: Icon(Icons.search, color: Color(0xFF025FA3)),
            suffixIcon: textSearchController.text.length > 0 ? InkWell( child: Icon(Icons.clear, color: Color(0xFF025FA3)),  onTap: () {
							setState(() {
								textSearchController.text = '';
								filterCows();
							});
						},) : SizedBox.shrink(),
          )
        )
      )
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  topMenuIconButton(IconData icon, Color color, Function onPressed, {	double scale = 1}){
    return IconButton(
      icon: Icon(icon), 
      color: color,
      iconSize: 35*scale, 
      onPressed: onPressed,     
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  addCowDialog(AgrCow editCow){
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AddCowDialog(this.inspection, cow: editCow, onAdd: (cow) async {
					if (editCow == null) {
							inspection.cows.insert(0, cow);
					}

					Navigator.of(dialogContext).pop();

					inspection.save(isSynced: false).then((dbInspection) async {
						setState(() {
							inspection = dbInspection;
							cows = inspection.cows;
						});

						if (inspection.type != 'rating') {
							await Navigator.of(context).pushNamed('/inspection_cow', arguments: {
								'inspection': inspection,
								'cow': inspection.cows[0],
								'inspectionPage': this,
							});
						}
						//refreshInspection();
					});

				});
      }
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  closeInspectionDialog(){
		totalCowCountController.text = inspection.totalCowCount?.toString() ?? '';
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return  SimpleDialog(
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Center(
              child: Text('Карточка коровы', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
                children: [
                  TextField(
										style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    controller: totalCowCountController,
                      decoration: InputDecoration(
                      labelText: 'Количество коров в хозяйстве',
											labelStyle: TextStyle(fontSize: 16),
                      prefixIcon: Icon(IcoFontIcons.cow, color: Color(0xFF025FA3)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  Container(
                    width: 300,
                    height: 55,
                    margin: EdgeInsets.only(top: 20),
                    child: TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.only(right: 10),
                            child: Icon (Icons.power_settings_new, color: Colors.white, size: 30,)),
                            Text('Завершить', textAlign: TextAlign.center)]),
                              onPressed:() async {
                                  int value = int.tryParse(totalCowCountController.text);
                                  if (value == null) return;

                                  inspection.totalCowCount = value;
                                  await inspection.save();

                                  Navigator.of(dialogContext).pop();
                                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                              }
                    ))]
        );
      }
    );
  }
	
  //////////////////////////////////////////////////////////////////////////////
  ratingBar(cow) {
		return Text(cow.rating.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF9900),));
  }

  //////////////////////////////////////////////////////////////////////////////
  buildCowListTile(AgrCow cow){
		final int diseaseCount = cow.diseases?.length ?? 0;

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        Container(
          height: double.infinity,
          color: Colors.red,
          child: InkWell(
            onTap: (){
							removeCow(cow);
						},
            child: Center(child: Text('Удалить', style: TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.bold)))
          )),
					Container(
          height: double.infinity,
          color: Color(0xFF025FA3),
          child: InkWell(
            onTap: (){
							addCowDialog(cow);
						},
            child: Center(child: Text('Редактировать', style: TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.bold)))
          )
        )  
      ],
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300],
            width: 0.5)
          ),
        ), 
        child: InkWell(
          onTap:() async {
						if (inspection.type == 'rating') return;
						await Navigator.pushNamed(context, '/inspection_cow', arguments: {'inspection': inspection, 'cow': cow, 'inspectionPage': this,});
						//refreshInspection();
					},
          child: ListTile(
            leading: Icon(IcoFontIcons.cow, color: Color(0xFF025FA3), size: 30),
            title: Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text('Корова №${cow.number}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
								inspection.type == 'rating' ? ratingBar(cow) : SizedBox.shrink()
							]
						),
            subtitle: inspection.type != 'rating' 
							? (diseaseCount > 0 ? Text('Зарегистрировано болезней: $diseaseCount') : Text('Болезни не обнаружены', style: TextStyle(color: Colors.green)))
							: null
              
          ),
        )     
      ),
    );
 }

////////////////////////////////////////////////////////////////////////////////
  Widget build(context) {
    return InternalPageScaffold( 
			baseRoute: '/',
      header: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Padding(padding: EdgeInsets.only(bottom: 5), child: Text('Осмотр ${inspection.id?.toString() ?? inspection.name}' , style: TextStyle(fontWeight: FontWeight.bold))),
					Row(
						children: [
							Icon(MdiIcons.calendarMonth, color: Color(0xFF025FA3), size: 25),
							Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
							Text((inspection.updatedAt?.format() ?? inspection.createdAt.format(noTime: true)), style: TextStyle(fontSize: 16)),
				    ]
          ),
        ],
      ),
			
      body: (cows.length == 0) 
				? Column(
					key: ValueKey(inspection),
					children: [
							searchField(),
							Expanded(child:  EmptyListView('Список коров пуст')),
					])
				: Column(
					key: ValueKey(inspection),
					children: [
						searchField(),
						Padding(padding: EdgeInsets.only(bottom: 10)),
						Expanded(child: ListView.builder(
							itemCount: (cows?.length ?? 0), 
							itemBuilder: (BuildContext context, int index) {
								return buildCowListTile(cows[index]);
							}
					))]
			),
      actions: [
				topMenuIconButton(Icons.control_point, Color(0xFFFF9900), () => addCowDialog(null), scale: 1.4),
				inspection.type == 'pruning'
				? SizedBox.shrink()
				: topMenuIconButton(Icons.power_settings_new, Color(0xFF025FA3), closeInspectionDialog),
			],
    );
  }
}