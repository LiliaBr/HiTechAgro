import 'package:flutter/material.dart';
import 'package:hitech_agro/app_state.dart';
import 'package:hitech_agro/services/farm_service.dart';

import 'package:hitech_agro/ui/widgets/internal_page_scaffold.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:flutter/rendering.dart';

import "package:hitech_agro/app_models.dart";
import "package:hitech_agro/extensions/datetime_format.dart";
import 'package:hitech_agro/ui/widgets/text_input_with_route_selector.dart';
import 'package:hitech_agro/ui/widgets/select_farm_field.dart';
import 'package:hitech_agro/ui/widgets/select_branch_field.dart';


import 'package:uuid/uuid.dart';

////////////////////////////////////////////////////////////////////////////////	
class CreateInspectionPage extends StatefulWidget{
  
  _CreateInspectionPage createState() => _CreateInspectionPage();
}

////////////////////////////////////////////////////////////////////////////////	
class _CreateInspectionPage extends State <CreateInspectionPage>{
  
  Key key;

	AgrCowInspection  inspection = AgrCowInspection();

  String selectedInspectionType;
	AgrFarm selectedFarm;
	AgrFarm selectedBranch;
	User selectedUser;

  Map<String, String> errors = {};

  Map<String, String> inspectionTypes = {
		'hoofs': 'Зальный осмотр',
		'rating': 'Бальный осмотр',
		'pruning': 'Обрезка'
  };

	//////////////////////////////////////////////////////////////////////////////	
	initState() {
		super.initState();

		if (AppState().getFarm() != null) {
			var farm = AppState().getFarm();
			if (farm.parentGuid != null) {
				selectedBranch = farm;
				selectedFarm = FarmService().findByGuid(farm.parentGuid);
			} else {
				selectedFarm = farm;
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////	
	didChangeDependencies() {
		super.didChangeDependencies();
	}

	//////////////////////////////////////////////////////////////////////////////
	createInspection() async {
    	errors = {};
			
			if (selectedInspectionType == null) 	return setState(()  => errors['farmType'] = 'Укажите тип осмотра');
			if (selectedFarm == null) 	return setState(()  => errors['farm'] = 'Укажите наименование хозяйства');
      if (selectedBranch == null) 	return setState(()  => errors['branch'] = 'Укажите наименование коровника');
      if (selectedUser == null) 	  return setState(()  => errors['manager'] = 'Выберите оператора');		

			setState(() => {});

			inspection
				..guid = Uuid().v4()
				..createdAt = DateTime.now()
				..updatedAt = DateTime.now()
				..farmId = selectedBranch.id
				..farmGuid = selectedBranch.guid
				..farm = selectedBranch
				..name = 'Новый осмотр'
				..type = selectedInspectionType
				..date = inspection.date ?? inspection.createdAt
				..cows = [];

			inspection = await inspection.save();

			Navigator.of(context).pushNamed('/inspection', arguments: inspection);
	}
  //////////////////////////////////////////////////////////////////////////////
  inspectionTypeDropdown({String value, String hintText, IconData icon, Function(String) onChange, Map<String, String> options, String errorText}){
     return Container(
      height: errorText != null ? 80 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5)),
        child: DropdownButtonFormField(
					decoration: InputDecoration(
            errorText: errorText,
						hintText: hintText,
            hintStyle: TextStyle(color: Colors.black87),
						//helperText: 'Выберите тип объекта',
						prefixIcon: Icon(icon, color: Color(0xFF025FA3)),
					),
					key: ValueKey(value),
          isExpanded: true,
          value: value,
          onChanged: onChange,
          items: options.keys.toList().map((key) {
            return DropdownMenuItem(
              value: key,
              child: Text(options[key]),
            );
          }).toList(),
        ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  void datePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
				return LayoutBuilder(
					builder: (BuildContext context, BoxConstraints constraints) {
						return AlertDialog(title:
							Container(
								width: constraints.maxWidth/2,
								height: constraints.maxHeight/2,
								child:           
									SfDateRangePicker(
										//locale: Locale("ru","RU"),
										todayHighlightColor: Color(0xFF025FA3),
										backgroundColor: Colors.white,
										onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
												if (args.value != null) {
													this.setState(() {
														inspection.date = args.value;
													});
													Navigator.of(dialogContext).pop();
												}
										},

										onSubmit: (Object obj) {
											print(obj);
										},
										selectionMode: DateRangePickerSelectionMode.single,
									),
							)
							);
					}
				);
      });
  }

  //////////////////////////////////////////////////////////////////////////////
  buildDateSelectField(){
		final dateStr = inspection.date != null ? inspection.date.format() : 'Выберите дату';

    return InkWell(
      onTap:() => datePicker(context),
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Color(0xFF025FA3).withOpacity(0.2))
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                 child: Row(
                  children: [
                    Icon(MdiIcons.calendarMonth, color: Color(0xFF025FA3)),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Text(dateStr, style: TextStyle(fontSize: 16),),
                  ])),
                
                 Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Icon(Icons.clear, color: Color(0xFF025FA3)),
                      onTap: () {
                      })])),
              ],
            ),
          ),
        ),
      )
    );
  }

  //////////////////////////////////////////////////////////////////////////////  
  buildUserSelectField(){
    return Container(
				key: UniqueKey(),
        height: errors['manager'] != null ? 80 : 60,
        child: TextInputWithRouteSelector(
          errorText: errors['manager'],
					route: '/select_farm_user',
					initialValue: selectedUser, 
					icon: MdiIcons.account,
					getTitle: (farm) => selectedUser?.name ?? 'Выберите оператора', onChange: (user) {
							setState(() {
								selectedUser = user;
							});
          })
			);
  }

  //////////////////////////////////////////////////////////////////////////////
  buildSubmitButton(){
    return TextButton(
      child: Container(
      width: double.infinity,
        child: Padding(padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(right: 10),
                child: Icon (Icons.control_point, color: Colors.white, size: 30)),
              Text('Добавить осмотр')]))),
			onPressed:() {
				createInspection();
			}
    );
  }


  //////////////////////////////////////////////////////////////////////////////

   Widget build(BuildContext context) {
    return InternalPageScaffold(
			header: Text('Добавить осмотр'),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          runSpacing: 20,
          children: [
            inspectionTypeDropdown(hintText: 'Выберите тип осмотра', value: selectedInspectionType,
            icon: Icons.control_point_duplicate_outlined,
            options: inspectionTypes,
						errorText: errors['farmType'],
            onChange: (String option) {
									setState(() => selectedInspectionType = option);
							}),

            SelectFarmField(initialValue: selectedFarm, errorText: errors['farm'], onChange: (farm) {
								setState(() {
									selectedFarm = farm;
									selectedBranch = null;
								});
						}),
            SelectBranchField(farm: selectedFarm, initialValue: selectedBranch, errorText: errors['branch'], onChange: (branch) {
								setState(() {
									selectedBranch = branch;
								});
						}),
            Row(
							crossAxisAlignment: CrossAxisAlignment.start,
              children:[ 
                Expanded(child: buildDateSelectField()),
                Expanded(child: buildUserSelectField())]),
            buildSubmitButton()
          ]),
      ),
    );
  }
}