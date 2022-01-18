import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hitech_agro/services/farm_service.dart';
import 'package:hitech_agro/app_models.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

////////////////////////////////////////////////////////////////////////////////
class TypeaheadInputFarm extends StatelessWidget {
  final FocusNode focusNode = FocusNode();
	final String errorText;
	final String parentGuid;
	final String initialValue;

	final TextEditingController _typeAheadController = TextEditingController();

	final void Function(AgrFarm) onChanged;

  TypeaheadInputFarm({Key key, @required this.parentGuid, this.initialValue, @required this.onChanged, this.errorText}) 
		: super(key: key) {
		_typeAheadController.text = initialValue ?? '';
	}

	//////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {
    return Padding(
			padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
			child: TypeAheadFormField(
				onSuggestionSelected: (dynamic branch) {
					this._typeAheadController.text = branch.name;
					onChanged(branch);
				},
				hideOnEmpty: true,
				hideOnError: true,
				hideOnLoading: true, 
				hideSuggestionsOnKeyboardHide: true, 
				suggestionsBoxDecoration: SuggestionsBoxDecoration(elevation: 0),
				//keepSuggestionsOnSuggestionSelected: true, 
				animationDuration: const Duration(milliseconds: 0),
				getImmediateSuggestions: true, 
				textFieldConfiguration: TextFieldConfiguration(
					controller: this._typeAheadController,
					focusNode: focusNode,
					autofocus: false,
					decoration: InputDecoration(
            labelText: parentGuid == null ? 'Выбор хозяйства' : 'Выбор коровника', hintStyle: TextStyle(fontSize: 16),
            prefixIcon: Icon(MdiIcons.barn, color: Color(0xFF025FA3)),
						//suffixIcon: Icon(Icon.clos),
            )
          ),
				suggestionsCallback: (pattern) {
					var retval = parentGuid == null
												? FarmService().filterFarms(pattern, includeBranches: false) 
												: FarmService().filterBranches(parentGuid, pattern);


					print('Filtered typeahead farm parentId=$parentGuid count: ${retval.length}');
					return retval;
				},
				itemBuilder: (context, branch) {
					return ListTile(
						title: Text(branch.name),
					);
				},
			)
		);
  }
}


