import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ContactPersonPage extends StatefulWidget {
  ContactPersonPage({Key key}) : super(key: key);
  _ContactPersonPage createState() => _ContactPersonPage();
}

class _ContactPersonPage extends State<ContactPersonPage> {
  Key key;
	
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

////////////////////////////////////////////////////////////////////////////////
  drawLoginButton(context) {
    return Container(
      width: 300,
      child: TextButton(
        child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text('Выйти', textAlign: TextAlign.center)),
        
        onPressed: () => Navigator.pushNamed(context, '/login'),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  textField(String title,IconData prefixIcon, {keyboardType, controller}) {
    return Container(
      width: 300,
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: TextField(
				controller: controller,
				keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: title,
          hintStyle: TextStyle(fontSize: 16),
          prefixIcon: Icon(prefixIcon, color: Color(0xFF025FA3)),
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Form(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                textField('Email', MdiIcons.accountTie, keyboardType: TextInputType.emailAddress, controller: emailController,),
                textField('Пароль', Icons.lock, controller: passwordController,),
                SizedBox(height: 40),
                drawLoginButton(context),
              ]))
        ]),
      ),
    );
  }
}
