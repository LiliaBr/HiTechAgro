import 'package:flutter/material.dart';

////////////////////////////////////////////////////////////////////////////////
class TextInputWithRouteSelector<T> extends StatefulWidget {
	final String route;
	final Object arguments;
	final String labelText;
	final String helperText;
	final String errorText;
	final IconData icon;
	final T initialValue;
	final Function(T) getTitle;
	final Function(T) onChange;
	TextInputWithRouteSelector({@required this.route, @required this.getTitle, this.initialValue, this.arguments, this.labelText, this.helperText, this.errorText, this.icon, this.onChange});


	_TextInputWithRouteSelector<T> createState() => _TextInputWithRouteSelector<T>();
}

////////////////////////////////////////////////////////////////////////////////
class _TextInputWithRouteSelector<T> extends State<TextInputWithRouteSelector<T>> {
	TextEditingController controller = TextEditingController();

	T currentValue;

	initState() {
		super.initState();
		currentValue = widget.initialValue;
		controller.text = widget.getTitle(currentValue);
	}

	Widget build(BuildContext context) {
		return Container(
			height: widget.errorText != null ? 80 : 60,
			child: TextField(
		  			controller: controller, 
		  			onTap: () async {
		  				final retval = await Navigator.of(context).pushNamed( widget.route, arguments: widget.arguments);

		  				if (retval != null && retval is T) {
		  					setState(() {
		  						currentValue = retval;
		  						controller.text = widget.getTitle(currentValue);
		  					});
		  					if (widget.onChange != null)  {
		  						widget.onChange(retval);
		  					}
		  				}
		  			},
		  			readOnly: true,
		  			decoration: InputDecoration(
		  				labelText: widget.labelText,
		  				helperText: widget.helperText,
		  				errorText: widget.errorText,
		  				prefixIcon: widget.icon != null ? Icon(widget.icon, color: Color(0xFF025FA3)) : null,
            ),
		   ));
		}
}
