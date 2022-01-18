import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';




////////////////////////////////////////////////////////////////////////////////
class SelectFarmTypeDropdown extends StatefulWidget {
  final Function(String) onChange;
  final String initialValue;
  SelectFarmTypeDropdown({@required this.initialValue, @required this.onChange});
	_SelectFarmTypeDropdown createState() => _SelectFarmTypeDropdown();
}

////////////////////////////////////////////////////////////////////////////////
class _SelectFarmTypeDropdown extends State<SelectFarmTypeDropdown> {

  // AgrFarm selectedFarm;
  // AgrFarm selectedBranch;

  String selectedFarmType;
  Map<String, String> farmTypes = {
		'farm': 'Хозяйство',
		'branch': 'Коровник'
	}; 
  
	//////////////////////////////////////////////////////////////////////////////
  initState() {
    selectedFarmType = widget.initialValue;
    super.initState();
  }

 ////////////////////////////////////////////////////////////////////////////////
 Widget build(BuildContext context) {
  return Container(
			//height: 60,
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(5)),
				child: DropdownButtonFormField(
					decoration: InputDecoration(
						hintText: "Выберите тип объекта",
						//helperText: 'Выберите тип объекта',
						prefixIcon: Icon(MdiIcons.barn, color: Color(0xFF025FA3)),
					),
					key: ValueKey(selectedFarmType),
					isExpanded: true,
					value: selectedFarmType,
					onChanged: (type) {
						setState(() {
							selectedFarmType = type;
              widget.onChange(type);
						});
					},
					items: farmTypes.keys.toList().map((type) {
						return DropdownMenuItem(
							value: type,
							child: Text(farmTypes[type]),
						);
					}).toList(),
				),
		);
  }
}