import 'package:flutter/material.dart';


////////////////////////////////////////////////////////////////////////////////
class SelectOtherDiseaseDropdown extends StatefulWidget {
  final Function(String) onChange;
  final String initialValue;
  SelectOtherDiseaseDropdown(
      {@required this.initialValue, @required this.onChange});
  _SelectOtherDiseaseDropdown createState() => _SelectOtherDiseaseDropdown();
}

////////////////////////////////////////////////////////////////////////////////
class _SelectOtherDiseaseDropdown extends State<SelectOtherDiseaseDropdown> {
  
	

  String selectedOtherDisease;
  Map<String, String> otherDisease = {
    'Бл': 'Блок',
    'Бр': 'Брак',
    'П': 'Повязка',
    'П1': 'Протокол 1',
    'П2': 'Протокол 2',
    'П3': 'Протокол 3'
  };

  //////////////////////////////////////////////////////////////////////////////
  initState() {
    selectedOtherDisease = widget.initialValue;
    super.initState();
  }

	
  ////////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          hintText: "Прочее",
        ),
        key: ValueKey(selectedOtherDisease),
        isExpanded: true,
        value: selectedOtherDisease,
        onChanged: (type) {
          setState(() {
            selectedOtherDisease = type;
            widget.onChange(type);
          });
        },
        items: otherDisease.keys.toList().map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(otherDisease[type]),
          );
        }).toList(),
      ),
    );
  }
}
