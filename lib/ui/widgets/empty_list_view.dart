import 'package:flutter/material.dart';

////////////////////////////////////////////////////////////////////////////////
class EmptyListView extends StatelessWidget {
	final String title;
	EmptyListView(this.title);

	//////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {
			return LayoutBuilder(
					builder: (context, constraints) {
						return SingleChildScrollView(
							physics: AlwaysScrollableScrollPhysics(),
							child: Column(
						
							mainAxisAlignment: MainAxisAlignment.center,
							crossAxisAlignment: CrossAxisAlignment.center,
							children: <Widget>[						
								Container(
									width: double.infinity,
									height: constraints.maxHeight,
									child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												Text(title, textAlign: TextAlign.center)
											]))]));
					});
	}
}
