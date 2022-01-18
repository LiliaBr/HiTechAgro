import 'package:flutter/material.dart';

class InternalPageScaffold extends StatelessWidget{ 

final Widget body;
final Widget header;
final Widget bottom;
final List<Widget> actions;
final String baseRoute;

InternalPageScaffold({this.body, this.header, this.bottom, this.actions, this.baseRoute});

@override
  Widget build(context) {
    return Scaffold (
      appBar: PreferredSize (
        preferredSize: Size.fromHeight(80.0), 
					child: AppBar(
						leading: baseRoute != null ? BackButton(
							onPressed: () {
								Navigator.of(context).popUntil(ModalRoute.withName(baseRoute));
							}
						) : null,
            backgroundColor: Colors.transparent,
              elevation: 0,
              title: header,
							bottom: bottom,
              actions: actions
          ),
        ),
        body: body,
    );
  }
}
