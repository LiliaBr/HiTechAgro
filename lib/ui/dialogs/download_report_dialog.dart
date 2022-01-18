import 'package:flutter/material.dart';
import 'package:hitech_agro/app_models.dart';

class DownloadReportDialog extends StatefulWidget {
	final AgrCowInspection inspection;
	DownloadReportDialog(this.inspection);
  _DownloadReportDialog createState() => _DownloadReportDialog();
}

////////////////////////////////////////////////////////////////////////////////
class _DownloadReportDialog extends State<DownloadReportDialog> {

	@override
	Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Center(
				child: Text('Скачать отчеты', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
			children: [
				SizedBox(height: 20),

				TextButton(
					child: Padding(
					  padding: EdgeInsets.only(top: 5, bottom: 5),
					  child: Text('Протокол', style: TextStyle(fontSize: 16)),
					),
						onPressed: () {
						Navigator.of(context).pushNamed(widget.inspection.type == 'rating'  
							? '/report_rating_protocol'
							: '/report_protocol', arguments: widget.inspection);

						},
				),
				SizedBox(height: 10),

        TextButton(
          child: Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Text('Анализ', style: TextStyle(fontSize: 16)),
          ),
          onPressed: () {
						 if (widget.inspection.type == 'rating') {
                  Navigator.of(context).pushNamed('/report_rating_analyze', arguments: widget.inspection);
             } else if (widget.inspection.type == 'pruning') {
                  Navigator.of(context).pushNamed('/report_analyze_pruning', arguments: widget.inspection);
             } else {
									Navigator.of(context).pushNamed('/report_analyze', arguments: widget.inspection);
						 }
					}
				),
			]
		);
	}
}

//  if (widget.inspection.type == 'rating') {
//                   return Navigator.of(context)
//                       .pushNamed('/report_rating_analyze');
//                 }

//                 if (widget.inspection.type == 'pruning') {
//                   return Navigator.of(context).pushNamed('/report_analyze_pruning',
//                       arguments: widget.inspection);
//                 } else {
// 									return Navigator.of(context).pushNamed('/report_analyze', arguments: widget.inspection);
// 								}