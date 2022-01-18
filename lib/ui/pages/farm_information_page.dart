import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:hitech_agro/models/agr_contact_person.dart';
import 'package:hitech_agro/ui/widgets/internal_page_scaffold.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import "package:hitech_agro/app_models.dart";
import "package:hitech_agro/app_state.dart";

// import 'package:hitech_agro/app_state.dart';
// import 'package:hitech_agro/app_models.dart';
////////////////////////////////////////////////////////////////////////////////
class FarmInformationPage extends StatefulWidget {
  _FarmInformationPage createState() => _FarmInformationPage();
}

class _FarmInformationPage extends State<FarmInformationPage> {

	AgrContactPerson contactPerson;

////////////////////////////////////////////////////////////////////////////////

  infoLine(IconData icon, String title, String nameOptions) {
    return Padding(
      padding: const EdgeInsets.only(left: 11),
      child: Row(
        children: [
          Icon(icon, size: 25, color: Color(0xFF025FA3)),
          Padding(padding: EdgeInsets.only(left: 10)),
					Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
					Padding(padding: EdgeInsets.only(left: 10)),
          Text(nameOptions)
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  contactData(String name, String farm,) {
    return Wrap(
			spacing: 15, 
			direction: Axis.horizontal, 
			children: [
				Icon(MdiIcons.accountTie, size: 65, color: Colors.grey.withOpacity(0.3)),
				Wrap(
					direction: Axis.vertical,
					alignment: WrapAlignment.start,
					spacing: 15,
					children: [
						Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
						Text(farm, style: TextStyle()),
						])
    ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  contactPhoneData(String phone) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Icon(
            MdiIcons.phoneMessageOutline,
            color: Color(0xFF025FA3),
            size: 25,
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 5, left: 10),
              child: Text(
                phone,
                style: TextStyle(decoration: TextDecoration.underline),
              )),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  contactEmailData(String email) {

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Icon(
            MdiIcons.emailSendOutline,
            color: Color(0xFF025FA3),
            size: 25,
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 5, left: 10),
              child: Text(
                email,
                style: TextStyle(decoration: TextDecoration.underline),
              )),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {
		AgrFarm farm = AppState().getFarm();
    return InternalPageScaffold(
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(farm.name),
          IconButton(
              onPressed: () async {
								await Navigator.of(context).pushNamed('/create_farm', arguments: farm);
								setState(() {});
							},
              icon: Icon(Icons.edit, size: 30, color: Color(0xFF025FA3)))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            //margin: EdgeInsets.only(left: 10),
            children: [
              infoLine(IcoFontIcons.addressBook, 'Адрес:', farm.address != null ? farm.address : 'Не указано'),
							SizedBox(height: 20),

              farm.parentId != null ? Wrap(direction: Axis.vertical, spacing: 20, children: [
                infoLine(
                    IcoFontIcons.cow, 'Количество голов: ', farm.cowCount.toString()),

                infoLine(
                    MdiIcons.gate,
										'Тип содержания:',
                    farm.accomodationTypeStr == null
                        ? 'Не указано'
                        : farm.accomodationTypeStr),

                infoLine(Boxicons.bx_water, 'Наличие ванн:', 
                    farm.hasBath == true ? 'Да' : 'Нет'),
              ]) : SizedBox.shrink(),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              Wrap(
                  runAlignment: WrapAlignment.center,
                  direction: Axis.vertical,
                  spacing: 15,
                  children: [
                    contactData(farm.leaderName == null ? 'не указан' : farm.leaderName, 'Контактное лицо'),
                    contactPhoneData(farm.phone == null ? 'не указан' : farm.phone),
                    contactEmailData(farm.email == null ? 'не указан' : farm.email),
                  ]),
            ]),
      ),
    );
  }
}
