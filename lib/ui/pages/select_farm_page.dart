import 'package:flutter/material.dart';
import "package:hitech_agro/app_models.dart";
import 'package:hitech_agro/services/farm_service.dart';

////////////////////////////////////////////////////////////////////////////////
class SelectFarmPage extends StatefulWidget {
	_SelectFarmPage createState() => _SelectFarmPage();
}

////////////////////////////////////////////////////////////////////////////////
class _SelectFarmPage extends State<SelectFarmPage> {
	AgrFarm selectedFarm;
	List<AgrFarm> farmList;

	String title;
	FocusNode focusNode = FocusNode();
	@override

  void didChangeDependencies() {
		Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;

		if (arguments['parentGuid'] != null) {
			title = 'Выберите коровник';
			farmList = FarmService().filterBranches(arguments['parentGuid'], '');
		} else {
			title = 'Выберите хозяйство';
			farmList = FarmService().getList();
		}
		farmList.sort((a, b) => a.name.compareTo(b.name));
    super.didChangeDependencies();
  }

	//////////////////////////////////////////////////////////////////////////////
	@override
	Widget build(BuildContext context) {

		return Scaffold(
			 appBar: AppBar( title: Text(title),),
			 body: Container(
					child: ListView.builder(
							itemCount: farmList.length,
							itemBuilder: (BuildContext context, int index) {
									return ListTile(title: Text(farmList[index].name), onTap: () {
											Navigator.of(context).pop(farmList[index]);
									},);
							})
				)
		);
	}
}