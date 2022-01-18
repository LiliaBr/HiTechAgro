import 'package:flutter/material.dart';

import 'package:hitech_agro/app_models.dart';


import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hitech_agro/ui/widgets/text_input_with_route_selector.dart';

////////////////////////////////////////////////////////////////////////////////
class SelectFarmField extends StatefulWidget {

final Function onChange;
final AgrFarm initialValue;
final String errorText;

	SelectFarmField({this.onChange, this.initialValue, this.errorText});

	_SelectFarmField createState() => _SelectFarmField();
}

////////////////////////////////////////////////////////////////////////////////
class _SelectFarmField extends State<SelectFarmField> {

  AgrFarm selectedFarm;
  
  initState() {
    super.initState();
    selectedFarm = widget.initialValue;
  }

  Widget build(BuildContext context) {
    return Container(
				key: UniqueKey(),
        height: widget.errorText != null ? 80 : 60,
        child: TextInputWithRouteSelector(
          errorText: widget.errorText,
					route: '/select_farm',
					initialValue: selectedFarm, 
					arguments: {
						'parentId': null,
					},
					icon: MdiIcons.barn,
					getTitle: (farm) => farm?.name ?? 'Выберите хозяйство', onChange: (farm) {
							setState(() {
								selectedFarm = farm;
                widget.onChange(farm);
							});
          })
				);
}
}