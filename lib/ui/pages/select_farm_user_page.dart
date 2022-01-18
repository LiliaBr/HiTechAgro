import 'package:flutter/material.dart';
import "package:hitech_agro/app_models.dart";
import 'package:hitech_agro/services/farm_user_service.dart';

////////////////////////////////////////////////////////////////////////////////
class SelectFarmUserPage extends StatefulWidget {
	_SelectFarmUserPage createState() => _SelectFarmUserPage();
}

////////////////////////////////////////////////////////////////////////////////
class _SelectFarmUserPage extends State<SelectFarmUserPage> {
	User selectedFarmUser;
	List<User> userList;

	String title;
	FocusNode focusNode = FocusNode();
	@override

  void didChangeDependencies() {
		title = 'Выберите оператора';
		userList = FarmUserService().getList();
		userList.sort((a, b) => a.name.compareTo(b.name));
    super.didChangeDependencies();
  }

	//////////////////////////////////////////////////////////////////////////////
	@override
	Widget build(BuildContext context) {

		return Scaffold(
			 appBar: AppBar( 
         title: Text(title),),
			 body: Container(
					child: ListView.builder(
							itemCount: userList.length,
							itemBuilder: (BuildContext context, int index) {
									return ListTile(title: Text(userList[index].name), onTap: () {
											Navigator.of(context).pop(userList[index]);
									},);
							})
				)
		);
	}
}