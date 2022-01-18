import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'dart:async';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:touchable/touchable.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:hitech_agro/ui/widgets/internal_page_scaffold.dart';
import 'package:hitech_agro/ui/widgets/hoof_interactive_svg.dart';
import 'package:hitech_agro/ui/widgets/sliver_grid_delegate_with_fixed_height.dart';
import 'package:hitech_agro/ui/widgets/select_other_disease_dropdown.dart';
import 'package:hitech_agro/ui/dialogs/add_cow_dialog.dart';
import 'package:hitech_agro/app_models.dart';
import 'package:hitech_agro/services/disease_service.dart';

import 'package:hitech_agro/extensions/datetime_format.dart';

import 'package:hitech_agro/ui/pages/inspection_page.dart';

////////////////////////////////////////////////////////////////////////////////
class InspectionCowPage extends StatefulWidget {
    @override
  _InspectionCowPageState createState()=> _InspectionCowPageState();
}

////////////////////////////////////////////////////////////////////////////////
class _InspectionCowPageState extends State <InspectionCowPage> {

	Map<String, bool> activeHoofs = {};
	String selectedRegion = 'hoofBL';
	AgrCow cow;
	int cowIndex;

	InspectionPageState inspectionPage;
	TextEditingController totalCowCountController = TextEditingController();

	Timer _commentsDebounce;

	AgrCowInspection inspection;

	final Map<String, String> regions = {
		'hoofBL': 'Левая задняя',
		'hoofBR': 'Правая задняя',
		'hoofFL': 'Левая передняя',
		'hoofFR': 'Правая передняя',
	};

  //////////////////////////////////////////////////////////////////////////////
	didChangeDependencies() {
		if (inspection == null) {
			Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
			inspection = arguments['inspection'];
			cow = arguments['cow'];			
			inspectionPage = arguments['inspectionPage'];		
			cowIndex = inspection.cows.indexWhere((c) => c == cow);
			totalCowCountController.text = inspection.totalCowCount != null ? inspection.totalCowCount.toString() : '';
			
		}

		super.didChangeDependencies();
	}	
	
	//////////////////////////////////////////////////////////////////////////////
	Future<void> updateInspection() async {
			inspection.cows[cowIndex] = cow;
			inspection = await inspection.save();

			inspectionPage.refreshInspection();

			setState(() {
					cow = inspection.cows[cowIndex];
			});
	}

  //////////////////////////////////////////////////////////////////////////////
  numberCow(String numberCow){
    return Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: 
          Text(numberCow, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  menuIconButton(IconData icon, Color color, Function onPressed, {double scale = 1}){
    return IconButton(
            icon: Icon(icon,
            color: color),
            iconSize: 35*scale, 
            onPressed: onPressed,     
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  closeInspectionDialog(){
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
                              onPressed:() {
                                  int value = int.tryParse(totalCowCountController.text);
                                  if (value == null) return;

                                  inspection.totalCowCount = value;
                                  updateInspection();
                                    Navigator.of(dialogContext).pop();
                                  Navigator.of(context).pop();
                              }
                    ))]
        );
      }
    );
  }
	
  //////////////////////////////////////////////////////////////////////////////
  addCowDialog(){
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AddCowDialog(this.inspection, onAdd: (cow) async {
					inspection.cows.insert(0, cow);
					Navigator.of(dialogContext).pop();
					inspection = await inspection.save();
					inspectionPage.refreshInspection();

					await Navigator.of(context).pushReplacementNamed('/inspection_cow', arguments: {
						'inspection': inspection,
						'cow': inspection.cows[0],
						'inspectionPage': inspectionPage,
					});					
				});
      }
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  deleteCowDialog(){
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Подтверждение удаления', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                SizedBox(height: 20),
                Text('Вы действительно\nхотите удалить корову\n№${cow.number}?', textAlign: TextAlign.center,),
                SizedBox(height: 10),
								Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
										TextButton(
											child: Container(
													padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
													child: Text('нет', textAlign: TextAlign.center)),
                    style:  ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)), 
                                    
										  onPressed:() {
											  Navigator.of(dialogContext).pop();
											}
                    ),
                    TextButton(
                      child: Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                        child: Text('да', textAlign: TextAlign.center)),
                    
										  onPressed:() async {
                        inspection.cows.removeAt(cowIndex);
												await inspection.save();
												inspectionPage.refreshInspection();

												Navigator.of(dialogContext).pop();

												Navigator.of(context).pop();
											}
                    ),
                  ]),
								SizedBox(height: 20),
              ]));
      }
    );
  }

  //////////////////////////////////////////////////////////////////////////////

  regionSelectTabs(){
		Map<String, Widget> options = {};

		regions.keys.toList().forEach((region) {
				int diseaseCount = 0;
				cow.diseases.forEach((disease) { 
					if (disease.locationId == null) return;
					AgrDiseaseLocation location = DiseaseService().findLocationById(disease.locationId);
					if (location != null && location.region == region) {
						diseaseCount++;
					}
				});
							
				options[region] = Row(children: [
					Text(regions[region], textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, 
					fontSize: MediaQuery.of(context).size.width>1006
					? 14
					: 16)),
					Visibility(
						visible: diseaseCount > 0,
						child: Padding(
							padding: EdgeInsets.only(left: 5),
							child: Badge(
								toAnimate: false,
								elevation: 0,
								badgeColor: Color(0xFFFF9900),
								badgeContent: Text(diseaseCount.toString(), style: TextStyle(color: Colors.white, fontSize: 10)),
								shape: BadgeShape.circle,
						)))
			]);
		});

    return Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
      child: CustomSlidingSegmentedControl<String>(
        innerPadding: 2,
				padding: 5,
				initialValue: selectedRegion,
        backgroundColor: Color(0xFF025FA3).withOpacity(0.2),
          children:  options,
        thumbColor: Colors.white,
        elevation: 0,
        duration: Duration(milliseconds: 200),
        radius: 5.0,
        onValueChanged: (region) {
          setState(() {
						selectedRegion = region;
					});
        }
      ),     
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  drawHoofSvg(context) {
		var width = MediaQuery.of(context).size.width>1006
		? MediaQuery.of(context).size.width*0.6
		: MediaQuery.of(context).size.width*0.8,
		height = 451*(width/832);
		return Padding(padding: EdgeInsets.only(left: 10, right: 10, top:10, bottom: 10),
      child: Container(
				width: width,
				height: height,
		    child: CanvasTouchDetector(
    		builder: (context) => CustomPaint(
      		painter: HoofInteractiveSvg(context, this, onSelect: (segment) {
							setState(() {
								activeHoofs = {};
								activeHoofs[segment] = true;
							});

							showDeseaseSelectForm(segment);
					}, activeHoofs: activeHoofs),
  		),
		)));
  }

	//////////////////////////////////////////////////////////////////////////////
	showDeseaseSelectForm(String selectedSegment) {
		List<AgrDisease> diseases = DiseaseService().getList();
		//selectedRegion;
		diseases = diseases.where((AgrDisease disease) {
				if (disease.locations.isEmpty) return false;

				AgrDiseaseLocation location = disease.locations.firstWhere((location) {
						return location.region == selectedRegion && location.segment == selectedSegment;
				}, orElse: () => null);
				
				return location != null;
		}).toList();

		showModalBottomSheet(
			//todo Сделать заголовок фприбитым к верху
				context: context, 
				builder: (dialogContext) {
				return Wrap(
				  children: [
            ListTile(
                tileColor: Color(0xFF025FA3).withOpacity(0.2),
                title: Text("${regions[selectedRegion]} $selectedSegment", style: TextStyle(fontWeight: FontWeight.w600))
              ),
				    SingleChildScrollView(child: Column(
				    			mainAxisSize: MainAxisSize.min,
				    			children: [
				    				
				    				...diseases.map<Widget>((disease) {
				    					return Container(
				    						decoration: BoxDecoration(
				    							border: Border(
				    								bottom: BorderSide(color: Colors.grey[300],
				    								width: 0.5)
				    							),
				    						), 
				    						child: ListTile(
				    							onTap: () {
				    								AgrDiseaseLocation location = disease.locations.firstWhere((location) {
				    										return location.region == selectedRegion && location.segment == selectedSegment;
				    								}, orElse: () => null);
				    								AgrCowDisease cowDisease = AgrCowDisease()
				    																							..locationId = location.id
				    																							..diseaseId = disease.id;
				    								setState(() {
				    										cow.diseases.add(cowDisease);
				    								});
				    								
				    								updateInspection();

				    								Navigator.of(dialogContext).pop();
				    							},
				    							title: Text(disease.name, style: TextStyle(fontSize: 14),),
				    							trailing: Icon(MdiIcons.chevronRight, color: Colors.white),
				    						),
				    				);
				    			}).toList()]
				    )),
				  ],
				);
		});
	}

	//////////////////////////////////////////////////////////////////////////////
	isLocationDiseased(AgrDiseaseLocation location) {
		return cow.diseases.indexWhere((disease) => disease.locationId == location.id) >= 0;
	}

  //////////////////////////////////////////////////////////////////////////////
  zoneHoofButton(BuildContext context){
		final List<AgrDiseaseLocation> cells = DiseaseService().findLocationsByRegion(selectedRegion);

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),					
				itemCount: cells.length,			
				gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
					crossAxisCount: MediaQuery.of(context).size.width>1006
					? 9
					: 10,
					crossAxisSpacing: 5,
					mainAxisSpacing: 5,
					height: 40.0),
				itemBuilder: (context, index) {
					AgrDiseaseLocation location = cells[index];
          return Container(
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[ 
                Container(
                  decoration: BoxDecoration(
                  color: Color(0xFF025FA3).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5)),
                    child: InkWell(
                      splashColor: Color(0xFF025FA3).withOpacity(0.2),
                      onTap: () {
                        AgrDiseaseLocation location = cells[index];
                        showDeseaseSelectForm(location.segment);											
                      },
                      child: Center(
                        child: Text(location.segment, style: TextStyle(
                          fontWeight: FontWeight.w600))
                      )
                    )
                ),
                 isLocationDiseased(location) ? 
                Positioned(
                  right: -3,
                  top: -3,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[ 
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8))),
                      Padding(padding: const EdgeInsets.only(top: 3, right: 3),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF9900),
                            borderRadius: BorderRadius.circular(5))),
                      )])): SizedBox.shrink(),
                  ]) 
          );
				}
    );
  }


  
  //////////////////////////////////////////////////////////////////////////////
  slidableDisease(AgrCowDisease cowDisease) {
		final int diseaseId = cowDisease.diseaseId;
		final AgrDisease disease = DiseaseService().findDiseaseById(diseaseId);
    return Slidable(
			key: UniqueKey(),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        Container(
          height: double.infinity,
          color: Colors.red,
          child: InkWell(
            onTap: (){
							setState(() {
									cow.diseases.removeWhere((disease) => disease == cowDisease);
							});
							
							updateInspection();
						},
            child: Center(child: Text('Удалить', style: TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.bold)))
          )
        ) 
      ],
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300],
            width: 1)
          ),
        ), 
        child: ListTile(
          title: Text(disease?.name ?? 'Не найдена'),
        ),
      ),    
    );
  }
  
  //////////////////////////////////////////////////////////////////////////////
  buildDisasesTable(){
		final diseases = cow.diseases.where((disease) {
				final int locationId = disease.locationId;
				if (locationId == null) return false;
				AgrDiseaseLocation location = DiseaseService().findLocationById(locationId);
				return location.region == selectedRegion;
		}).toList();
		
		if (diseases.isEmpty) {
			return SizedBox.shrink();
		}

    return Padding(padding: EdgeInsets.all(10.0),
      child: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF025FA3).withOpacity(0.3), width: 2))),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.all(10.0),
                          child: Text('Местоположение', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                          child: Text('Заболевание', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),  
                ],
              ),
            ),
             Row(
							children: [
								Expanded(
								flex: 1,
									child: Column(
										children: diseases.map<Widget>((disease) {
											final int locationId = disease.locationId;
											AgrDiseaseLocation location = DiseaseService().findLocationById(locationId);
											return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[300],
                            width: 1)
                          ),
                        ), 
                      child: ListTile(title: Text(location?.segment ?? 'Не найдена')));
										}).toList(),
									),
								),
								Expanded(
								flex: 3,
									child: Column(
										children: diseases.map<Widget>((disease) {
											return slidableDisease(disease);
										}).toList()
									),
								),
							]),
          ],
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////

  commentTextField(){
    return Container(
      width: double.infinity,
        padding: EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
        child: TextFormField(
					initialValue: cow.comments,
					onChanged: (String text) {
						cow.comments = text;

						if (_commentsDebounce?.isActive ?? false) _commentsDebounce.cancel();
    						_commentsDebounce = Timer(const Duration(milliseconds: 1000), () {
										updateInspection();
				    		});						
					},
					 	keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
          	decoration: InputDecoration(
						
            labelText: 'Комментарий',
          ),
          maxLines: 3,
        )
    );
  }
////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(context) {
    return InternalPageScaffold(
			header: 
				numberCow('Корова №${cow.number}'),	
			bottom: PreferredSize(preferredSize: Size.fromHeight(5.0),
			child: 	Row(
						children: [
							SizedBox(width: 70),
							Icon(MdiIcons.calendarMonth, color: Color(0xFF025FA3), size: 20),
							Padding(padding: EdgeInsets.only(left: 5)),
							Text((inspection.date ?? inspection.createdAt).format(noTime: true), style: TextStyle(fontSize: 16)),

							Padding(padding: EdgeInsets.only(left: 10)),					
							Icon(MdiIcons.accountTie, color: Color(0xFF025FA3), size: 20),
							inspection.createdBy != null ? Padding(padding: EdgeInsets.fromLTRB(5, 10, 0, 10)) : SizedBox.shrink(),
							inspection.createdBy != null ? Text(inspection.createdBy.name ?? '', style: TextStyle(fontSize: 16)) : SizedBox.shrink(),
						])),

      body: SingleChildScrollView(
        child:
				MediaQuery.of(context).size.width > 1006

			?  Row(
				crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Expanded(
							child: Column(
								mainAxisAlignment: MainAxisAlignment.start,
							children: [
                regionSelectTabs(),
                drawHoofSvg(context),
								
						])),
						Expanded(
							child: Column(
							children: [
								SizedBox(height: 20),
								Container(
									padding: EdgeInsets.only(top: 10, left: 10, right: 10),
									height: 100,
									width: double.infinity,
									child: zoneHoofButton(context),
								),

								buildDisasesTable(),
						
						SelectOtherDiseaseDropdown(initialValue: cow.tag, onChange: (type) {
            setState(() {
                cow.tag = type;
								updateInspection();
								
              });
            }),
            commentTextField(),
							]))
					])
			: Column(
          children: [
            regionSelectTabs(),
            drawHoofSvg(context),
            Container(
							padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              height: 100,
              width: double.infinity,
              child: zoneHoofButton(context),
            ),
            buildDisasesTable(),
						
						SelectOtherDiseaseDropdown(initialValue: cow.tag, onChange: (type) {
            setState(() {
                cow.tag = type;
								updateInspection();
								
            });
          }),
            commentTextField(),
          ]
        ),
      ), 

			actions: [
				menuIconButton(Icons.control_point, Color(0xFFFF9900), addCowDialog, scale: 1.4),
				
				inspection.type == 'pruning'
				? SizedBox.shrink()
				: menuIconButton(Icons.power_settings_new, Color(0xFF025FA3), closeInspectionDialog),
				
				menuIconButton(MdiIcons.closeCircleOutline, Colors.red, deleteCowDialog),
			],
    );
  }
}