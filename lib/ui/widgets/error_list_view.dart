import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

////////////////////////////////////////////////////////////////////////////////
class ErrorListView extends StatelessWidget {
	final dynamic error;
	final Function onRetry;

	ErrorListView(this.error, {this.onRetry});

  ///////////////////////////////////////////////////////////////////////////////
  static showErrorDialog(context, title, error, {Function onConfirm}) {
      _showUpdateErrorDialog(message, onConfirm) {
        return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title.toUpperCase(),
                    style: TextStyle(fontSize: 16)),
                //backgroundColor: SdColors.cardBackground,
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Align(
                          child: Text(message,
                              /*textAlign: TextAlign.center,*/ style:
                                  TextStyle())),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Понятно'.toUpperCase(),
                        style: TextStyle()),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onConfirm != null) {
                        onConfirm();
                      }
                    },
                  ),
                ],
              );
            });
      }


      if (error is DioError) {
        DioError dioError = error;
        if (dioError?.response?.statusCode == 400 &&
            dioError?.response?.data['message'] != null) {
          _showUpdateErrorDialog(dioError?.response?.data['message'], onConfirm);
          return null;
        }
      } else if (error is String) {
                 _showUpdateErrorDialog(error, onConfirm);
                 return null;
            }

      _showUpdateErrorDialog(
          "Произошла непредвиденная ошибка\n\nПопробуйте еще раз", onConfirm);
  }

	//////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    String errorStr = error.toString();

    if (error is DioError) {
      if (error?.response?.data is Map) {
        if (error.response.data['message'] != null) {
          errorStr = error.response.data['message'];
        }
      }

      if ((error?.response?.statusCode == 400) &&
          error.response.data['formData'] != null &&
          (error.response.data['errors'] is Map)) {
        errorStr = '';
        Map<String, dynamic> errors = error.response.data['errors'];

        for (var field in errors.keys) {
          if (errors[field] is List) {
            errorStr += errors[field][0] + '\n';
          } else {
            errorStr += errors[field] + '\n';
          }
        }

        if (errorStr == '') {
          errorStr = error.toString();
        }
      }
    }

		/*return LayoutBuilder( builder: (context, constraints) {		
			return SingleChildScrollView(
					physics: AlwaysScrollableScrollPhysics(),
					child: Column(	
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: <Widget>[		
						Container(
							child: 
								ConstrainedBox(
								constraints: BoxConstraints(
									maxWidth: constraints.maxWidth,
									maxHeight: constraints.maxHeight,
								),
								child: Center(
									child: Wrap(
									crossAxisAlignment: WrapCrossAlignment.center,
									direction: Axis.vertical,
									children: [
										Icon(MdiIcons.alertBoxOutline, color: Colors.grey, size: 70),
										Padding(
											padding: EdgeInsets.only(top: 30),
											child: Text('Ошибка', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 22)),),
										Padding(
											padding: EdgeInsets.only(top: 20),
											child: Text(errorStr, style: TextStyle(color: Colors.grey)),)
								],),)
							),
						),
					],
				),
			);
		});*/


		return LayoutBuilder( builder: (context, constraints) {		
			return RefreshIndicator(
					onRefresh: onRetry,
					child: SingleChildScrollView(
						physics: AlwaysScrollableScrollPhysics(),
						child: Column(	
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.center,
						children: <Widget>[		
							Container(
								child: 
									ConstrainedBox(
									constraints: BoxConstraints(
										maxWidth: constraints.maxWidth,
										maxHeight: constraints.maxHeight,
									),
									child: Center(
											child: Column(
										mainAxisAlignment: MainAxisAlignment.center,
										crossAxisAlignment: CrossAxisAlignment.center,
//										direction: Axis.vertical,
										children: [
											Icon(MdiIcons.alertBoxOutline, size: 70),
											Padding(
												padding: EdgeInsets.only(top: 30),
												child: Text('Ошибка', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),),
											Padding(
												padding: EdgeInsets.all(30),
													child: Text(errorStr, textAlign: TextAlign.center, softWrap: true, overflow: TextOverflow.clip),)
									],),)
								),
							),
						],
					)),
			);
		});		
	}
}
