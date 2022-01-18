import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ConfirmDialog extends StatelessWidget{
    final Function onConfirm;
    final String title;
    final String confirmMessage;

    ConfirmDialog(this.confirmMessage, this.onConfirm, {this.title = "Предупреждение"});

    @override
    Widget build(BuildContext context) {
			return SimpleDialog(
				contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
				title: Row(
						children: [
						Icon(MdiIcons.alertCircle, size: 30, color: Colors.red),
						Padding(padding: EdgeInsets.only(right: 20)),
						Text(title.toUpperCase(),
							style: TextStyle(
								fontSize: 20,	fontWeight: FontWeight.bold))
					]),
				children:[ 
					
					Text(confirmMessage, style: TextStyle(fontSize: 16, height: 1.5)),
					SizedBox(height: 20),
		      Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children:[
              TextButton(
						style:  ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
						child: Padding(
							padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
							child: Text('ОТМЕНА', style: TextStyle(fontSize: 16)),
						),
						onPressed: () => Navigator.pop(context),
					),

					TextButton(
							child: Padding(
								padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
								child: Text('ДА, ПРОДОЛЖИТЬ', style: TextStyle(fontSize: 16)),
							),
							onPressed: onConfirm)
						])
					,
				],
			);
  }
}