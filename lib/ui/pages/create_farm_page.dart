import 'package:flutter/material.dart';
import 'package:hitech_agro/services/farm_service.dart';
import 'package:hitech_agro/services/farm_user_service.dart';
import 'package:hitech_agro/ui/widgets/text_input_with_route_selector.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

import 'package:hitech_agro/ui/widgets/internal_page_scaffold.dart';
import 'package:hitech_agro/extensions/email_validator.dart';
import 'package:hitech_agro/extensions/phone_validator.dart';
import 'package:hitech_agro/app_models.dart';
import 'package:uuid/uuid.dart';

////////////////////////////////////////////////////////////////////////////////
class CreateFarmPage extends StatefulWidget {
  _CreateFarmPage createState() => _CreateFarmPage();
}

////////////////////////////////////////////////////////////////////////////////
class _CreateFarmPage extends State<CreateFarmPage> {
	AgrFarm farm;

	AgrFarm selectedFarm;
	User selectedManager;
	Map<String, String> errors = {};

	TextEditingController farmNameController			 = TextEditingController();
	TextEditingController farmAddressController    = TextEditingController();
	TextEditingController farmLeaderNameController = TextEditingController();
	TextEditingController farmPhoneController			 = TextEditingController();
	TextEditingController farmEmailController			 = TextEditingController();
	TextEditingController cowCountController 			 = TextEditingController();

	//////////////////////////////////////////////////////////////////////////////  
  String selectedFarmType;
	String selectedAccommodationType;
	String selectedHasBath;
	
	//////////////////////////////////////////////////////////////////////////////  
  Map<String, String> farmTypes = {
			'farm': 'Хозяйство',
			'branch': 'Коровник'
	};
	
	//////////////////////////////////////////////////////////////////////////////  
  Map<String, String> accommodationTypes = {
			'connected': 	  'Привязное',
			'unconnected': 'Беспривязное'
	};

	//////////////////////////////////////////////////////////////////////////////  
  Map<String, String> bathOptions = {
			'true': 	  'Да',
			'false': 		'Нет'
	};

	//////////////////////////////////////////////////////////////////////////////  
  initState() {
    super.initState();
  }
	
	//////////////////////////////////////////////////////////////////////////////  
	didChangeDependencies() {
		super.didChangeDependencies();

		farm = ModalRoute.of(context).settings.arguments;
		if (farm == null) {
			farm = AgrFarm();
		} else {
			if (farm.parentGuid != null) {
				selectedFarm = FarmService().findByGuid(farm.parentGuid);
			}

			if (farm.managerId != null) {
				selectedManager = FarmUserService().findById(farm.managerId);
			}

			selectedFarmType = farm.parentId != null ? 'branch' : 'farm';
			farmNameController.text = farm.name;

			farmAddressController.text = farm.address ?? '';
			farmLeaderNameController.text = farm.leaderName ?? '';
			farmEmailController.text = farm.email ?? '';
			farmPhoneController.text = farm.phone ?? '';

			cowCountController.text = farm.cowCount != null ? farm.cowCount.toString() : '';

			selectedAccommodationType = farm.accomodationType;
			selectedHasBath = farm.hasBath.toString();			
			farmLeaderNameController.text = farm.leaderName ?? '';
		}
	}

	//////////////////////////////////////////////////////////////////////////////  
	createFarm() async {
		setState(() => errors = {});
		if (selectedFarmType == null) 										return setState(()  => errors['farmType'] = 'Укажите тип объекта');		
		if (farmNameController.text.trim() == '') 				return setState(()  => errors['farmName'] = 'Укажите наименование хозяйтсва');		
		if (farmAddressController.text.trim() == '') 			return setState(()  => errors['address'] = 'Укажите адрес хозяйтсва');		
		if (selectedManager == null) 											return setState(()  => errors['manager'] = 'Выберите менеджера');		
		if (farmLeaderNameController.text.trim() == '') 	return setState(()  => errors['leaderName'] = 'Укажите ФИО руководителя');		

		if (farmEmailController.text.trim() == '') 				return setState(()  => errors['email'] = 'Укажите контактный email');		
		if (!farmEmailController.text.isValidEmail()) 		return setState(()  => errors['email'] = 'Укажите корректный email');				

		if (farmPhoneController.text.trim() == '') 				return setState(()  => errors['phone'] = 'Укажите контактный телефон');		
		if (!farmPhoneController.text.isValidPhone()) 		return setState(()  => errors['phone'] = 'Укажите корректный телефон');				

		if (farm.guid == null) {
				farm
				 ..guid = Uuid().v4()
				 ..createdAt = DateTime.now()
				 ..branches = [];
		}

		farm
			..updatedAt = DateTime.now()
			..name = farmNameController.text
			..address = farmAddressController.text
			..managerId = selectedManager.id
			..manager = selectedManager
			..leaderName = farmLeaderNameController.text
			..email = farmEmailController.text
			..phone = farmPhoneController.text;

			farm = await farm.save();
			
			Navigator.of(context).pop(farm);			
	}

	//////////////////////////////////////////////////////////////////////////////  
	createBranch() async {
		setState(() => errors = {});
		
		if (selectedFarmType == null) return setState(()  => errors['farmType'] = 'Укажите тип объекта');	
		if (selectedFarm == null)			return setState(()  => errors['farm'] = 'Выберите хозяйство');	
		
		if (farmNameController.text.trim() == '') 					return setState(()  => errors['farmName'] = 'Укажите наименование коровника');		
		if (int.tryParse(cowCountController.text) == null)	return setState(()  => errors['cowCount'] = 'Укажите контактный телефон');		


		if (selectedAccommodationType == null) return setState(()  => errors['accomodationType'] = 'Укажите тип содержания');
		if (selectedHasBath == null) return setState(()  => errors['hasBath'] = 'Укажите наличие ванн');

		if (farmAddressController.text.trim() == '') 			return setState(()  => errors['address'] = 'Укажите адрес хозяйтсва');				

		if (selectedManager == null) 											return setState(()  => errors['manager'] = 'Выберите менеджера');		
		if (farmLeaderNameController.text.trim() == '') 	return setState(()  => errors['leaderName'] = 'Укажите ФИО руководителя');		

		if (farmEmailController.text.trim() == '') 				return setState(()  => errors['email'] = 'Укажите контактный email');		
		if (!farmEmailController.text.isValidEmail()) 		return setState(()  => errors['email'] = 'Укажите корректный email');				

		if (farmPhoneController.text.trim() == '') 				return setState(()  => errors['phone'] = 'Укажите контактный телефон');		
		if (!farmPhoneController.text.isValidPhone()) 		return setState(()  => errors['phone'] = 'Укажите корректный телефон');				

		if (farm.guid == null) {
				farm
					..guid = Uuid().v4()
					..createdAt = DateTime.now();
		}

		farm
			..parentGuid = selectedFarm.guid
			..updatedAt = DateTime.now()
			..name = farmNameController.text
			..cowCount = int.tryParse(cowCountController.text)
			..accomodationType = selectedAccommodationType
			..hasBath = selectedHasBath == 'true'
			..address = farmAddressController.text
			..managerId = selectedManager.id
			..manager = selectedManager
			..leaderName = farmLeaderNameController.text
			..email = farmEmailController.text
			..phone = farmPhoneController.text;
		
		int branchIndex = selectedFarm.branches.indexWhere((branch) => branch.guid == farm.guid);

		if (branchIndex >= 0) {
			selectedFarm.branches[branchIndex] = farm;
		} else {
			selectedFarm.branches.add(farm);
		}

		try {
			selectedFarm = await selectedFarm.save();
			Navigator.of(context).pop(farm);
		} catch (err) {
			selectedFarm.branches.removeLast();
		}
	}

  //////////////////////////////////////////////////////////////////////////////  
  selectOptionDropdown({String value, String hintText, IconData icon, Function(String) onChange, Map<String, String> options, String errorText}){
    return Container(
      height: errorText != null ? 80 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5)),
        child: DropdownButtonFormField(
					decoration: InputDecoration(
						errorText: errorText,
						hintText: hintText,
						prefixIcon: Icon(icon, color: Color(0xFF025FA3)),
					),
					key: ValueKey(value),
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
  textField(String title, IconData icon, TextEditingController controller, {String errorText, keyboardType}){
    return Container(
				height: errorText != null ? 80 : 60,
				child: TextField(
					controller: controller,
					keyboardType: keyboardType,
					decoration: InputDecoration(
						errorText: errorText,
						labelText: title, hintStyle: TextStyle(fontSize: 16),
						prefixIcon: Icon(icon, color: Color(0xFF025FA3)),
					),
				)
    );
  }

////////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {
    return InternalPageScaffold(
			header:  Text(farm.guid == null ? "Создать хозяйство/коровник" : "Редактировать хозяйство/коровник"),
			body: SingleChildScrollView(
					child: Container(
					padding: EdgeInsets.only(left: 20, right: 20),
					child: Wrap(
						runSpacing: 20,
						children: [
								Row(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
									farm.guid == null ? Expanded(child: selectOptionDropdown(hintText: 'Выберите тип объекта', value: selectedFarmType, 
										errorText: errors['farmType'],
										icon: MdiIcons.barn, options: farmTypes, 
										onChange: (String option) {
											setState(() => selectedFarmType = option);
										})) : SizedBox.shrink(),

									farm.guid == null && selectedFarmType == 'branch'  ? Padding(padding: EdgeInsets.only(right: 20)) : SizedBox.shrink(),

									Expanded(flex: selectedFarmType == 'branch'  ? 1 : 0, 
										child: farm.guid == null && selectedFarmType == 'branch' 
										? TextInputWithRouteSelector(

											route: '/select_farm',
											errorText: errors['farm'],
											initialValue: selectedFarm, 
											icon: MdiIcons.barn,
											arguments: {
												'parentId': null,
											},
											getTitle: (farm) => farm?.name ?? 'Выберите хозяйство', onChange: (farm) {
													setState(() {
														selectedFarm = farm;
													});
										}) : SizedBox.shrink()),
								]),								

								Row(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
									Expanded(child: textField(selectedFarmType == 'branch' ? 'Укажите наименование коровника' : 'Укажите наименование хозяйства', IcoFontIcons.cow, 
										farmNameController, errorText: errors['farmName'],)),
										selectedFarmType == 'branch' ? Padding(padding: EdgeInsets.only(right: 20)) : SizedBox.shrink(),

									Expanded(flex: selectedFarmType == 'branch' ? 1 : 0, child: selectedFarmType == 'branch' 
										? textField('Голов', IcoFontIcons.cow, cowCountController, errorText: errors['cowCount'], keyboardType: TextInputType.number)
										: SizedBox.shrink()),

								]),


								selectedFarmType == 'branch' ? Row(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Expanded(child: selectOptionDropdown(hintText: 'Тип содержания', value: selectedAccommodationType, 
											errorText: errors['accomodationType'],
											icon: MdiIcons.gate, options: accommodationTypes, 
											onChange: (String option) {
												setState(() => selectedAccommodationType = option);
											})),
										Padding(padding: EdgeInsets.only(right: 20)),

										Expanded(child: selectOptionDropdown(hintText: 'Наличие ванны', value: selectedHasBath, errorText: errors['hasBath'],
											icon: Boxicons.bx_water, options: bathOptions, 
											onChange: (option) {
												setState(() => selectedHasBath = option);
											})),										
										//Expanded(child: textField('Наличие ванны', Boxicons.bx_water,  errorText: errors['hasBath']))
								]) : SizedBox.shrink(),

								textField('Укажите адрес объекта', Icons.location_on, farmAddressController, errorText: errors['address']),
								
								Container(
										child: TextInputWithRouteSelector(
											route: '/select_farm_user',
											errorText: errors['manager'],
											initialValue: selectedManager, 
											icon: MdiIcons.account,
											getTitle: (manager) => manager?.name ?? 'Выберите менеджера', onChange: (user) {
													setState(() {
														selectedManager = user;
													});
										})
								),
					
								//DropdownSelectUser(title: 'Выберете менеджера', onChanged: (user) {
								//}),


								textField('Укажите ФИО руководителя', MdiIcons.accountTie, farmLeaderNameController,  errorText: errors['leaderName']),
								Row(
								crossAxisAlignment: CrossAxisAlignment.start,
									children: [
									Expanded(child: textField('Контактный Email', Icons.mail, farmEmailController, errorText: errors['email'],keyboardType: TextInputType.emailAddress)),
									Padding(padding: EdgeInsets.only(right: 20)),
									Expanded(child: textField('Контактный телефон', Icons.phone, farmPhoneController, errorText: errors['phone'],keyboardType: TextInputType.phone)),
								]),

								Container(
									margin: EdgeInsets.only(top: 20, bottom: 20),
									child: 
									TextButton( 
											onPressed: () {
												if (selectedFarmType == 'branch') {
													createBranch();
												} else {
													createFarm();
												}
											},
											child: Container(
												padding: EdgeInsets.only(top: 10, bottom:10),
												width: double.infinity,
												child: Text(farm.id == null ? 'Создать' : 'Обновить', textAlign: TextAlign.center)),
										))
								])),
			));    
  }
}