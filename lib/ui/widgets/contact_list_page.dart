import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hitech_agro/ui/widgets/sliver_grid_delegate_with_fixed_height.dart';

import 'package:hitech_agro/ui/widgets/load_progress_indicator.dart';
import 'package:hitech_agro/ui/widgets/empty_list_view.dart';
import 'package:hitech_agro/ui/widgets/error_list_view.dart';


import 'package:hitech_agro/app_state.dart';
import 'package:hitech_agro/app_models.dart';

////////////////////////////////////////////////////////////////////////////////  
class ContactList extends StatefulWidget {
	ContactList({Key key}): super(key: key);

	_ContactListState createState() => _ContactListState();
}

////////////////////////////////////////////////////////////////////////////////  
class _ContactListState extends State<ContactList> with AutomaticKeepAliveClientMixin<ContactList> {
	Key key;
	var eventListener;

	TextEditingController searchFieldController = TextEditingController();
	Future<List<AgrContactPerson>> _contactListFuture;

  //////////////////////////////////////////////////////////////////////////////
  @override
  bool wantKeepAlive = true;	

	Map<String, dynamic> filter = {
		'order': 'name asc',
		'debug': true,
	};

	initState() {
		super.initState();
	}

	//////////////////////////////////////////////////////////////////////////////  
	didChangeDependencies() {
		super.didChangeDependencies();

    eventListener = DbService().on('contactPersonUpdated', null, (event, object) {
      if (mounted) {
        loadContacts(false);
        setState(() {});
      }
    });

		loadContacts();
	}

  //////////////////////////////////////////////////////////////////////////////
  dispose() {
    eventListener.cancel();
    super.dispose();
  }


	//////////////////////////////////////////////////////////////////////////////  
	Future<void> loadContacts([bool renewKey = true]) {
		if (renewKey) {
			setState(() => key = UniqueKey());
		}

		List<String> where = [];
		List<dynamic> whereArgs = [];

		String farmGuid = AppState().getFarm()?.guid;

		if (farmGuid != null) {
			where.add("(farm_guid like '$farmGuid' OR parent_farm_guid = '$farmGuid')");
		}

		if ((searchFieldController.text ?? '') != '') {
				String q = searchFieldController.text;
				where.add("name like '%${q.toLowerCase()}%'");
		}

		_contactListFuture = DbService().getObjects<AgrContactPerson>(where: where.join(' AND '), whereArgs: whereArgs, orderBy: 'updated_at desc');

		return _contactListFuture;
	}

  //////////////////////////////////////////////////////////////////////////////
  searchBox(){
    return Padding(padding: EdgeInsets.only(left: 5, top: 5),
			child: Row(
      children: [
        Expanded( child: searchField()),
        Expanded( child: iconButton()),
      ]
    ));
  }

  //////////////////////////////////////////////////////////////////////////////
  iconButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.control_point, 
          color: Color(0xFFFF9900)),
          iconSize: 35, 
          onPressed:() async {
						DbService().syncEnabled = false;
						await Navigator.pushNamed(context, '/create_contact');
						DbService().syncEnabled = true;
						loadContacts(false);

					}
        ),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  searchField(){
    return  Container(
			margin: EdgeInsets.only(right: 7),
      child: TextField(
				controller: searchFieldController,
				onSubmitted: (String q) {
					setState(() {
					loadContacts(false);
				  });
				},
        decoration: InputDecoration(
          hintText: 'Поиск', 
					contentPadding: EdgeInsets.only(top: 10),
          prefixIcon: Icon(Icons.search, color: Color(0xFF025FA3)),
          suffixIcon: InkWell( 
        onTap: (){
					searchFieldController.text = '';
					  setState(() {
						  loadContacts(false);
							});
					},
          child: Icon(Icons.clear, color: Color(0xFF025FA3))),
        )
      )
    );
  }

	//////////////////////////////////////////////////////////////////////////////  
  contactData(AgrContactPerson contact){
		String farm = (contact?.farms ?? []).map((farm) => farm.name).toList().join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
				Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						Expanded(child: Text(contact.name ?? '', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
						Icon(Icons.cloud,size: 16,
									color: contact.$dirty
										? Color(0xFFFF9900)
										: Colors.grey)
							]),

        Text(farm, style: TextStyle(fontSize: 16)),
				Text(contact.position ?? '', style: TextStyle(fontSize: 16)),
        Padding(padding: EdgeInsets.only( bottom: 10))
          ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////  
  contactPhoneData(IconData icon, AgrContactPerson contact){
		List<String> phones = [];
		
		phones.add((contact.phone ?? '').isEmpty ? 'не указан' : contact.phone);
		if ((contact.phone2 ?? '').isNotEmpty) {
			phones.add(contact.phone2);
		}

    return Row(
      children: [
        Padding(padding: EdgeInsets.only(right: 10),
          child: Icon(icon,
          color: Color(0xFF025FA3),
          size: 25)),
        Text(phones.join('/ '), 
            style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 16,
              decoration: TextDecoration.underline),
          )
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  contactEmailData(IconData icon, AgrContactPerson contact) {
		List<String> emails = [];

		emails.add((contact.email ?? '').isEmpty ? 'не указан' : contact.email);
		if ((contact.email2 ?? '').isNotEmpty) {
			emails.add(contact.email2);
		}
    return  Row(
			children: [
				Padding(padding: EdgeInsets.only(right: 10),
					child: Icon(icon, color: Color(0xFF025FA3),size: 25)),
				Expanded(
					child: Text(emails.join('/ '),
						overflow: TextOverflow.ellipsis,
						maxLines: 1, 
						style: TextStyle(
							fontWeight: FontWeight.w500, fontSize: 16,
							decoration: TextDecoration.underline),
						)
					),
				],
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  contactCard(AgrContactPerson contact){
    return Padding(padding: EdgeInsets.fromLTRB(2, 5, 2, 0),
      child: InkWell( 
        child: Container(
        decoration: BoxDecoration( 
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200],
              offset: const Offset( 5.0, 5.0,),
                blurRadius: 5.0,
                spreadRadius: 5.0,
            )]),
        child: Card(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)),
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,						
                  children: [
                    contactData(contact),
                    contactPhoneData(MdiIcons.phoneMessageOutline, contact),
                    contactEmailData(MdiIcons.emailSendOutline, contact),
                  ]),
          )),
      ),
      onTap: () async {
				 DbService().syncEnabled = false;
				 await Navigator.of(context).pushNamed('/edit_contact_person', arguments: contact);
				 DbService().syncEnabled = true;
				 loadContacts(false);
			})
    );
  }
  
  //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(context) {
		super.build(context);

    return Scaffold(
      body: Column(
        children: [
          searchBox(),
          Expanded(
            child: FutureBuilder<List<AgrContactPerson>>(
              key: key,
              future: _contactListFuture,
              builder: (_context, result) {
                if (result.hasData) {
                    return RefreshIndicator(onRefresh: () => loadContacts(false),
                        child: (result.data.length == 0) 
                        ? EmptyListView('Список контактов пуст')
                        : GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                            crossAxisCount: MediaQuery.of(context).size.width > 1006
														? 3
														: 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                            height: 170.0),
                            itemCount: result.data.length,
                            itemBuilder: (context, index) {
                              return contactCard(result.data[index]);
                            }
                    ));
                } else if (result.hasError) {
                        return ErrorListView(result.error, onRetry: () {
                          setState(() {
                            loadContacts();
                          });
                        },);
                    } else {
                        return LoadProgressIndicator();
                    }
              }
            ))
      ])
    );
  }
}