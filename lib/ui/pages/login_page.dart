import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hitech_agro/app_models.dart';

////////////////////////////////////////////////////////////////////////////////
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

////////////////////////////////////////////////////////////////////////////////
class _LoginPageState extends State<LoginPage> {
	bool _hidePass = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

	//////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
  }

  Map<String, dynamic> errors;

  //////////////////////////////////////////////////////////////////////////////
  _doLogin(BuildContext context) async {
    setState(() {
      errors = null;
    });

    try {
      await RestClient().login(
          User.credentials(_emailController.text, _passwordController.text));
      Navigator.pushReplacementNamed(context, '/crossroads');
      return;
    } on DioError catch (err) {
      if (err.response?.statusCode == 400 &&
          err.response?.data['formData'] != null) {
        developer.log('Unexpected error: ' + err.toString());
        setState(() {
          errors = err.response.data['errors'];
        });
      }
    } on Exception catch (err) {
      developer.log('Unexpected error: ' + err.toString());
    }
  }


	//////////////////////////////////////////////////////////////////////////////
  drawLogoSvg() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 20, bottom: 50),
      child: SvgPicture.asset("assets/img/logo.svg", width: 300,),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  buildLoginForm(){
    return Form(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
						controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Ваша почта *',
              hintText: 'Введите имя пользователя или Email', hintStyle: TextStyle(fontSize: 10),
              prefixIcon: Icon(MdiIcons.accountTie),
							errorText:
									(this.errors is Map && this.errors['email'] is List)
											? this.errors['email'][0]
											: null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[600])
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 40),
          TextField(
						controller: _passwordController,
						onEditingComplete: () => _doLogin(context),
            obscureText: _hidePass,
            decoration: InputDecoration(
              labelText: 'Ваш пароль*',
              hintText: 'Введите пароль', hintStyle: TextStyle(fontSize: 10),
              prefixIcon: Icon(Icons.lock),
							errorText:
									(this.errors is Map && this.errors['password'] is List)
											? this.errors['password'][0]
											: null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[600])
              ),
            ),
          ),
          SizedBox(height: 40),
          drawLoginButton(context),
        ]
      )     
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  drawLoginForm(context) {
    return Container(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[ 
          Text('Вход в сервис', style: TextStyle(fontFamily: 'Podkova',fontSize: 30, fontWeight: FontWeight.bold)),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          Text('укажите необходимые данные \n обязательные поля помечены *', style: TextStyle(fontFamily: 'Podkova')),
          Padding(padding: EdgeInsets.only(bottom: 20)),
          buildLoginForm(),
        ]
      )
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  drawLoginButton(context) {
    return TextButton(
      child: Container(
        width: double.infinity,
          child: Padding(padding: EdgeInsets.only(top: 10, bottom:10),
           child: Text('Войти в сервис', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
           textAlign: TextAlign.center))),
            style:  ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFF9900)),
               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),
                ))
            ), 
						onPressed: () {
            	_doLogin(context);
						},
    );
  }


	//////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [ 
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/logAgro.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.1), BlendMode.dstATop),
              )
            ),
          ),
          Center( 
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                drawLogoSvg(),
                drawLoginForm(context),
              ]
            )
          )
        ]
      ),
    );    
  }
}