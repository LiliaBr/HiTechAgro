import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import "package:hitech_agro/app_models.dart";
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uuid/uuid.dart';

////////////////////////////////////////////////////////////////////////////////
class AddCowDialog extends StatefulWidget {
  final AgrCowInspection inspection;
  final Function(AgrCow) onAdd;
	final AgrCow cow;

  AddCowDialog(this.inspection, {this.cow, @required this.onAdd});

  _AddCowDialog createState() => _AddCowDialog();
}

////////////////////////////////////////////////////////////////////////////////
class _AddCowDialog extends State<AddCowDialog> {
  double selectedRating = 1;
  
	AgrCow cow;

  TextEditingController cowNumberController = TextEditingController();

	//////////////////////////////////////////////////////////////////////////////
	initState() {
			super.initState();

			if (widget.cow != null) {
				selectedRating = widget.cow.rating/1.0 ?? 1.0;
				cowNumberController.text = widget.cow.number;
			}
	}

  //////////////////////////////////////////////////////////////////////////////
  addCow() async {
    AgrCow cow = widget.cow ?? AgrCow();

		cow
		..number = cowNumberController.text
		..rating = selectedRating.toInt()
		..diseases = [];

 		if (cow.guid == null) {
    	cow
      	..guid = Uuid().v4();
    	}

    widget.onAdd(cow);
  }

  //////////////////////////////////////////////////////////////////////////////
  ratingBar() {
    return Container(
      //margin: EdgeInsets.only(top: 10, bottom: 10),
      alignment: Alignment.center,
      child: RatingBar.builder(
          initialRating: selectedRating,
          minRating: 1,
          direction: Axis.horizontal,
          itemCount: 5,
          itemSize: 35,
          itemPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          onRatingUpdate: (double rating) {
            if (rating == null) return;
            setState(() {
              selectedRating = rating;
            });
          },
          itemBuilder: (context, index) {
            context = context;
            index = index;
            switch (index) {
              case 0:
                return Icon(MdiIcons.numeric1BoxOutline,
                    color: Color(0xFF025FA3));
              case 1:
                return Icon(MdiIcons.numeric2BoxOutline,
                    color: Color(0xFF025FA3));
              case 2:
                return Icon(MdiIcons.numeric3BoxOutline,
                    color: Color(0xFF025FA3));
              case 3:
                return Icon(MdiIcons.numeric4BoxOutline,
                    color: Color(0xFF025FA3));
              case 4:
                return Icon(MdiIcons.numeric5BoxOutline,
                    color: Color(0xFF025FA3));
              default:
                return null;
            }
          }),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Center(
          child: Text('Карточка коровы',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
      children: [
        TextFormField(
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          controller: cowNumberController,
          decoration: InputDecoration(
            labelText: '№ Животного',
            labelStyle: TextStyle(fontSize: 20),
            prefixIcon: Icon(IcoFontIcons.cow, color: Color(0xFF025FA3)),
          ),
          keyboardType: TextInputType.number,
        ),
        widget.inspection.type == 'rating' ? ratingBar() : SizedBox.shrink(),
        Container(
            width: 400,
            height: 55,
            margin: EdgeInsets.only(top: 20),
            child: TextButton(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.control_point,
                        color: Colors.white,
                        size: 30,
                      )),
                  Text(widget.cow != null ? 'Обновить' : 'Добавить', textAlign: TextAlign.center)
                ]),
                onPressed: () {
                  if (cowNumberController.text != '') {
                    addCow();
                  }
                }))
      ],
    );
  }
}
