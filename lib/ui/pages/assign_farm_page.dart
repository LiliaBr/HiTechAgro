import 'package:flutter/material.dart';

import 'package:hitech_agro/ui/widgets/select_branch_field.dart';
import 'package:hitech_agro/ui/widgets/select_farm_field.dart';
import 'package:hitech_agro/ui/widgets/internal_page_scaffold.dart';
import 'package:hitech_agro/ui/widgets/select_farm_type_dropdown.dart';

import 'package:hitech_agro/app_models.dart';

////////////////////////////////////////////////////////////////////////////////
class AssignFarmPage extends StatefulWidget {

  _AssignFarmPage createState() => _AssignFarmPage();
}

////////////////////////////////////////////////////////////////////////////////
class _AssignFarmPage extends State<AssignFarmPage> {

	AgrContactPerson contactPerson;

  AgrFarm selectedFarm;
  AgrFarm selectedBranch;

  String selectedFarmType;

  Map<String, String> farmTypes = {
		'farm': 'Хозяйство',
		'branch': 'Коровник'
	};

	//////////////////////////////////////////////////////////////////////////////
  initState() {
    super.initState();
  }

  //////////////////////////////////////////////////////////////////////////////
  addFarmButton() {
      AgrFarm newFarm;

      if (selectedFarmType == 'farm')  {
          newFarm = selectedFarm;
      } else if (selectedFarmType == 'branch') {
        newFarm = selectedBranch;
      }

      if (newFarm == null) return SizedBox.shrink();

      return Container(
        //margin: EdgeInsets.only(top: 0),
        child: TextButton(
          
          onPressed: () {
            Navigator.of(context).pop(newFarm);
          },
          child: Container(
            padding: EdgeInsets.only(top: 5, bottom:5),
            width: 200,
            child: Text('Добавить', textAlign: TextAlign.center)),
    ));
  }  

  //////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {
    return InternalPageScaffold(
			header: Text('Назначить хозяйство'),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Wrap(
          runSpacing: 20,
          children: [

            SelectFarmTypeDropdown(initialValue: selectedFarmType, onChange: (type) {
            setState(() {
                selectedFarmType = type;
            });
          }),

        selectedFarmType != null
          ?  SelectFarmField(initialValue: selectedFarm, onChange: (farm) {
            setState(() {
                selectedFarm = farm;
                selectedBranch = null;
            });
          }) 
          : Padding(padding: EdgeInsets.only(right: 20)),
    
    
        selectedFarmType == 'branch'
          ? SelectBranchField(key: ValueKey(selectedFarm), farm: selectedFarm, initialValue: selectedBranch, onChange: (farm) {
            setState(() {
                selectedBranch = farm;
            });
          }) 
          : Padding(padding: EdgeInsets.only(right: 20)),

        Align(alignment: Alignment.topRight, child: addFarmButton()),
        ])),
    );
  }
}