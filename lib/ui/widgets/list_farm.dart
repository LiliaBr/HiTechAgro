import 'package:flutter/material.dart';

class ListFarm extends StatefulWidget {
  @override
  _ListFarmState createState() => _ListFarmState();
}

class _ListFarmState extends State <ListFarm> {

////////////////////////////////////////////////////////////////////////////////

  cardFarm() {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5),
      child: Column(
        children: [
          ExpansionTile(
            title: Text('Покровское', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              children: [
                ListTile(
                  title: nameFarm(Icons.remove, 'Роботы')
                ),
                ListTile(
                  title: nameFarm(Icons.remove, 'Доильный зал'),
                ),
              ],                
          ),
          Divider()
        ]
      ),
    );
  }
  
  //////////////////////////////////////////////////////////////////////////////
  
  nameFarm(IconData icon, String name){
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon,size: 30, color: Colors.grey[600]),
          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Text(name, style: TextStyle(fontSize: 16, )))
        ],
      )
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  
  searchField(){
    return Padding(padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
      child: Container(
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Поиск',
            suffixIcon: Icon(Icons.search),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.grey[300]),
            ),
          )
        )
      )
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            searchField(),
            cardFarm(),
            cardFarm(),
            cardFarm(),
            cardFarm(),
            cardFarm(),
            cardFarm(),
            cardFarm(),
            cardFarm(),
            cardFarm(),
          ]
        )      
      )    
    );
  }
}