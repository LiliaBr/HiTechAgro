import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hitech_agro/app_models.dart';
import 'package:hitech_agro/services/farm_user_service.dart';

////////////////////////////////////////////////////////////////////////////////
class DropdownSelectUser extends StatefulWidget {
	final String title;
	final String helperText;

	final Function (User) onChanged;

	DropdownSelectUser({@required this.title, @required this.onChanged, this.helperText});
	_DropdownSelectUser createState() => _DropdownSelectUser();
}

////////////////////////////////////////////////////////////////////////////////
class _DropdownSelectUser extends State<DropdownSelectUser> {
	User selectedUser;

	Widget build(BuildContext context) {
		return Padding(
				padding: const EdgeInsets.only(top: 10, bottom: 0),
				child: Container(
						child: DropdownButtonFormField<User>(
							decoration: InputDecoration(
								hintText: widget.title,
								helperText: widget.helperText,
								prefixIcon: Icon(MdiIcons.accountTie, color: Color(0xFF025FA3)),
							),

							icon: Icon(Icons.expand_more_outlined, color: Color(0xFF025FA3)),
							isExpanded: true,
							value: selectedUser,
							onChanged: widget.onChanged,
							items: FarmUserService().getList().map((user) {
								return DropdownMenuItem(
									value: user,
									child: Text(user.name),
								);
							}).toList(),
						),
				),
			);
	}
}