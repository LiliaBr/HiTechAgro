import 'package:flutter/material.dart';
import 'package:hitech_agro/services/farm_service.dart';

import 'package:hitech_agro/extensions/email_validator.dart';
import 'package:hitech_agro/extensions/phone_validator.dart';

import 'package:hitech_agro/ui/widgets/internal_page_scaffold.dart';
import 'package:hitech_agro/app_models.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';



class EditContactInfoPage extends StatefulWidget {
  _EditContactInfoPage createState() => _EditContactInfoPage();
}

////////////////////////////////////////////////////////////////////////////////
class _EditContactInfoPage extends State<EditContactInfoPage> {
	AgrContactPerson contactPerson;

	Map<String,String> errors = {};

	TextEditingController nameController = TextEditingController();
	TextEditingController positionController = TextEditingController();

	TextEditingController phoneController = TextEditingController();
	TextEditingController emailController = TextEditingController();

	TextEditingController phone2Controller = TextEditingController();
	TextEditingController email2Controller = TextEditingController();

  AgrFarm selectedFarm;
  AgrFarm selectedBranch;

  String selectedFarmType;
  Map<String, String> farmTypes = {
		'farm': 'Хозяйство',
		'branch': 'Коровник'
	}; 

	//////////////////////////////////////////////////////////////////////////////
  initState() {
    super.initState();
  }

	//////////////////////////////////////////////////////////////////////////////
	didChangeDependencies() {
		if (contactPerson == null) {
			contactPerson = ModalRoute.of(context).settings.arguments;
			nameController.text = contactPerson.name;
			emailController.text = contactPerson.email;		
			phoneController.text = contactPerson.phone;

			email2Controller.text = contactPerson.email2;		
			phone2Controller.text = contactPerson.phone2;
			positionController.text = contactPerson.position;
		}

		super.didChangeDependencies();
	}

	//////////////////////////////////////////////////////////////////////////////
	saveContact() async {

		if (nameController.text.trim() == '') 				return setState(()  => errors['name'] = 'Укажите ФИО руководителя');		
    
		if (positionController.text.trim() == '')
      return setState(() => errors['position'] = 'Укажите должность');

		if (emailController.text.trim() == '') 				return setState(()  => errors['email'] = 'Укажите контактный email');		
		if (!emailController.text.isValidEmail()) 		return setState(()  => errors['email'] = 'Укажите корректный email');				

		if (phoneController.text.trim() == '') 				return setState(()  => errors['phone'] = 'Укажите контактный телефон');		
		if (!phoneController.text.isValidPhone()) 		return setState(()  => errors['phone'] = 'Укажите корректный телефон');				

    if (phone2Controller.text != '' && !phone2Controller.text.isValidPhone())
      return setState(() => errors['phone2'] = 'Укажите корректный телефон');

    if (email2Controller.text != '' && !email2Controller.text.isValidEmail())
      return setState(() => errors['email2'] = 'Укажите корректный email');

		contactPerson
			..updatedAt = DateTime.now()
			..name = nameController.text
			..email = emailController.text
			..phone = phoneController.text
			..email2 = email2Controller.text
			..phone2 = phone2Controller.text
			..position = positionController.text;

		contactPerson = await contactPerson.save();
		Navigator.of(context).pop(contactPerson);
	}

	//////////////////////////////////////////////////////////////////////////////
  textField(String title, IconData icon,{keyboardType, TextEditingController controller, String errorText}){
    return Container(
        child: TextField(
					controller: controller,

          keyboardType: keyboardType,
            decoration: InputDecoration(
							errorText: errorText,
              labelText: title, hintStyle: TextStyle(fontSize: 16),
              prefixIcon: Icon(icon, color: Color(0xFF025FA3)),
            ),
     ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  slidableFarm(AgrFarm farm, int index) {
		String farmName;
		String branchName;

		if (farm.parentGuid != null) {
			branchName = farm.name;
			final parent = FarmService().findByGuid(farm.parentGuid);
			if (parent != null) {
				farmName = parent.name;
			}
		} else {
			farmName = farm.name;
		}

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        Container(
          height: double.infinity,
          color: Colors.red,
          child: InkWell(
            onTap: () {
							setState(() {
									contactPerson.farms.removeAt(index);
							});
						},
            child: Center(child: Text('Удалить', style: TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.bold)))
          )
        ) 
      ],
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300],width: 1)
          ),
        ), 
        child: ListTile(
          title: Text((farmName ?? 'Не определено') + (branchName != null ? (': ' + branchName) : '')),
        ),
      ),    
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  buildFarmsTable(){
		int index = 0;
		if ((contactPerson.farms ?? []).length == 0) return SizedBox.shrink();

    return Padding(padding: EdgeInsets.all(10.0),
      child: Container(
        child: Column(
					key: ValueKey((contactPerson.farms ?? []).length),
          children: [
            Text('Назначенные хозяйства', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),  
				    Column(
              children: (contactPerson.farms ?? []).map<Widget>((farm) => slidableFarm(farm, index++)).toList()
            ),
				]),
      )
    );
  }
  //////////////////////////////////////////////////////////////////////////////
  buildActionButton(String text, {Function onPressed}){
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextButton(
        
				onPressed: onPressed,

        child: Container(
          padding: EdgeInsets.only(top: 10, bottom:10),
          width: double.infinity,
          child: Text(text, textAlign: TextAlign.center)),
      ));
  }

  //////////////////////////////////////////////////////////////////////////////
  assignFarmButton() {
		
    return Container(
      child: TextButton(
        onPressed: () async{
            var farm = await Navigator.pushNamed(context, '/assign_farm');
            if (farm != null) {
              setState(() {
								contactPerson.farms ??= [];
                contactPerson.farms.add(farm);
              });
            }
        },
    
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom:5),
          width: 200,
          child: Text('Назначить хозяйство', style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center)),
      ));
  }  

 /////////////////////////////////////////////////////////////////////////////// 
  Widget build(BuildContext context) {
    return InternalPageScaffold(
			header: Text('Изменение контактной информации'),
      body: SingleChildScrollView(
				child: Container(
        margin: EdgeInsets.all(10),
        child: Wrap(
          runSpacing: 20,
          children: [
            textField('ФИО', MdiIcons.accountTie, controller: nameController, errorText: errors['name']),
						textField('Должность', MdiIcons.accountTie, controller: positionController, errorText: errors['position']),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: textField('Контактный Email', Icons.mail, keyboardType: TextInputType.emailAddress, controller: emailController, errorText: errors['email'])),
                Padding(padding: EdgeInsets.only(right: 10)),
                Expanded(child: textField('Контактный телефон', Icons.phone, keyboardType: TextInputType.phone, controller: phoneController, errorText: errors['phone'])),
            ]),	

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: textField('Контактный Email 2', Icons.mail, keyboardType: TextInputType.emailAddress, controller: email2Controller, errorText: errors['email2'])),
                Padding(padding: EdgeInsets.only(right: 10)),
                Expanded(child: textField('Контактный телефон 2', Icons.phone, keyboardType: TextInputType.phone, controller: phone2Controller, errorText: errors['phone2'])),
            ]),	

						Align(alignment: Alignment.topRight, child: assignFarmButton()),

             buildFarmsTable(),
             Row(children: [
               Expanded(child: buildActionButton('Сохранить', onPressed: () {
								 saveContact();
							 })),
               Padding(padding: EdgeInsets.only(right: 10)),
               Expanded(child: buildActionButton('Отмена', onPressed: () {
									Navigator.of(context).pop();
							 })),
             ],)
             
             
             ]))
    ));
  }
}