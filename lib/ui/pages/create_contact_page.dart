import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:hitech_agro/app_models.dart';
import 'package:hitech_agro/ui/widgets/internal_page_scaffold.dart';
import 'package:hitech_agro/extensions/email_validator.dart';
import 'package:hitech_agro/extensions/phone_validator.dart';
import 'package:hitech_agro/ui/widgets/select_farm_field.dart';
import 'package:hitech_agro/ui/widgets/select_branch_field.dart';

class CreateContactPage extends StatefulWidget {
  _CreateContactPage createState() => _CreateContactPage();
}

class _CreateContactPage extends State<CreateContactPage> {
  AgrFarm selectedFarm;
  AgrFarm selectedBranch;
  Map<String, String> errors = {};

  //////////////////////////////////////////////////////////////////////////////
  String selectedFarmType;
  TextEditingController nameController = TextEditingController();
	TextEditingController positionController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController phone2Controller = TextEditingController();
  TextEditingController email2Controller = TextEditingController();

  //////////////////////////////////////////////////////////////////////////////
  Map<String, String> farmTypes = {'farm': 'Хозяйство', 'branch': 'Коровник'};
	
	////////////////////////////////////////////////////////////////////////////////
  createContact() async {
    setState(() => errors = {});

    if (nameController.text.trim() == '')
      return setState(() => errors['name'] = 'Укажите ФИО контактного лица');

    if (positionController.text.trim() == '')
      return setState(() => errors['position'] = 'Укажите должность');

    if (emailController.text.trim() == '')
      return setState(() => errors['email'] = 'Укажите контактный email');

    if (!emailController.text.isValidEmail())
      return setState(() => errors['email'] = 'Укажите корректный email');

    if (phoneController.text.trim() == '')
      return setState(() => errors['phone'] = 'Укажите контактный телефон');

    if (phone2Controller.text != '' && !phone2Controller.text.isValidPhone())
      return setState(() => errors['phone2'] = 'Укажите корректный телефон');

    if (email2Controller.text != '' && !email2Controller.text.isValidEmail())
      return setState(() => errors['email2'] = 'Укажите корректный email');

    if (selectedFarmType == null)
      return setState(() => errors['farmType'] = 'Укажите тип объекта');

    if (selectedFarm == null)
      return setState(() => errors['farm'] = 'Выберите хозяйство');

    if (selectedFarmType == 'branch') {
      if (selectedBranch == null)
        return setState(() => errors['branch'] = 'Выберите коровник');
    }

    var person = AgrContactPerson()
      ..guid = Uuid().v4()
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..name = nameController.text
      ..email = emailController.text
      ..phone = phoneController.text
      ..email2 = emailController.text
      ..phone2 = phoneController.text
			..position = positionController.text
      ..farms = [];

    if (selectedFarmType == 'farm') {
      person.farms.add(selectedFarm);
    } else {
      person.farms.add(selectedBranch);
    }

    person = await person.save();
    Navigator.of(context).pop(person);
  }

////////////////////////////////////////////////////////////////////////////////
  dropDownButton(
      {String value,
      String hintText,
      IconData icon,
      Function(String) onChange,
      Map<String, String> options,
      String errorText}) {
    return Container(
      height: errorText != null ? 80 : 60,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          errorText: errorText,
          hintText: hintText,
          //helperText: 'Выберите тип объекта',
          prefixIcon: Icon(icon, color: Color(0xFF025FA3)),
        ),
        key: ValueKey(value),
        isExpanded: true,
        value: value,
        onChanged: onChange,
        items: options.keys.toList().map((key) {
          return DropdownMenuItem(
            value: key,
            child: Text(options[key]),
          );
        }).toList(),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  textField(String title, IconData icon,
      {keyboardType, TextEditingController controller, String errorText}) {
    return Container(
      //height: 50,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          errorText: errorText,
          labelText: title,
          hintStyle: TextStyle(fontSize: 16),
          prefixIcon: Icon(icon, color: Color(0xFF025FA3)),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  addButton() {
    return TextButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text('Создать', textAlign: TextAlign.center),
        ),
        onPressed: createContact);
  }

////////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {
    return InternalPageScaffold(
        header: Text('Добавить контакт'),
        body: SingleChildScrollView(
					child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Wrap(runSpacing: 20, 
					children: [
            textField('ФИО контактного лица', MdiIcons.accountTie,
                controller: nameController, errorText: errors['name']),
						textField('Должность', MdiIcons.accountTie, controller: positionController, errorText: errors['position']),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: textField('Контактный Email', Icons.mail,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      errorText: errors['email'])),
              Padding(padding: EdgeInsets.only(right: 20)),
              Expanded(
                  child: textField('Контактный телефон', Icons.phone,
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      errorText: errors['phone'])),
            ]),
						Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: textField('Контактный Email 2' , Icons.mail,
                      keyboardType: TextInputType.emailAddress,
                      controller: email2Controller,
                      errorText: errors['email2'])),
              Padding(padding: EdgeInsets.only(right: 20)),
              Expanded(
                  child: textField('Контактный телефон 2', Icons.phone,
                      keyboardType: TextInputType.phone,
                      controller: phone2Controller,
                      errorText: errors['phone2'])),
            ]),
            dropDownButton(
                hintText: 'Выберите тип объекта',
                value: selectedFarmType,
                errorText: errors['farmType'],
                icon: MdiIcons.barn,
                options: farmTypes,
                onChange: (String option) {
                  setState(() => selectedFarmType = option);
                }),
            selectedFarmType != null
                ? SelectFarmField(
                    initialValue: selectedFarm,
                    onChange: (farm) {
                      setState(() {
                        selectedFarm = farm;
                        selectedBranch = null;
                      });
                    })
                : Padding(padding: EdgeInsets.only(right: 0)),
            selectedFarmType == 'branch'
                ? SelectBranchField(
                    key: ValueKey(selectedFarm),
                    farm: selectedFarm,
                    initialValue: selectedBranch,
                    onChange: (farm) {
                      setState(() {
                        selectedBranch = farm;
                      });
                    })
                : Padding(padding: EdgeInsets.only(right: 0)),
            addButton(),
          ]),
		)));
  }
}
