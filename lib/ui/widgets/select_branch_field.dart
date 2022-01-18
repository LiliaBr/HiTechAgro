import 'package:flutter/material.dart';

import 'package:hitech_agro/app_models.dart';


import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hitech_agro/ui/widgets/text_input_with_route_selector.dart';

////////////////////////////////////////////////////////////////////////////////
class SelectBranchField extends StatefulWidget {

  final Function onChange;
  final AgrFarm initialValue;
  final AgrFarm farm;
  final String errorText;
  final Key key;
	SelectBranchField({this.key, this.onChange,this.initialValue, this.farm, this.errorText});

////////////////////////////////////////////////////////////////////////////////
	_SelectBranchField createState() => _SelectBranchField();
}

////////////////////////////////////////////////////////////////////////////////
class _SelectBranchField extends State<SelectBranchField> {
  AgrFarm selectedBranch;

  //////////////////////////////////////////////////////////////////////////////
  initState() {
    super.initState();

    selectedBranch = widget.initialValue;
  }

  //////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {    
    if (widget.farm == null) return SizedBox.shrink();

    return Container(
      key: widget.key,
			height: widget.errorText != null ? 80 : 60,
      child: TextInputWithRouteSelector(
        errorText: widget.errorText,
        route: '/select_farm',
        initialValue: selectedBranch, 
        arguments: {
          'parentGuid': widget.farm.guid,
        },
        icon: MdiIcons.barn,
        getTitle: (farm) => farm?.name ?? 'Выберите коровник', onChange: (farm) {
            setState(() {
              selectedBranch = farm;
              widget.onChange(farm);
            });
      }));
    }
}