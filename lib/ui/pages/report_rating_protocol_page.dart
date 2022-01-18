import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:hitech_agro/services/disease_service.dart';
import 'package:hitech_agro/ui/widgets/internal_page_scaffold.dart';
import "package:hitech_agro/app_models.dart";
import 'package:hitech_agro/ui/widgets/load_progress_indicator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hitech_agro/extensions/datetime_format.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
////////////////////////////////////////////////////////////////////////////////
class ReportRatingProtocolPage extends StatefulWidget {
  @override
  ReportRatingProtocolPageState createState() =>
      ReportRatingProtocolPageState();
}

////////////////////////////////////////////////////////////////////////////////
class ReportRatingProtocolPageState extends State<ReportRatingProtocolPage> {
  AgrCowInspection inspection;
  pw.ThemeData themeData;
  @override
  void dispose() {
    super.dispose();
  }

  initState() {
    super.initState();
    loadFonts();
  }

  //////////////////////////////////////////////////////////////////////////////
  didChangeDependencies() {
    inspection = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  loadFonts() async {
    final baseFont = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final boldFont = await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    setState(() {
      themeData = pw.ThemeData.withFont(
        base: pw.Font.ttf(baseFont),
        bold: pw.Font.ttf(boldFont),
      );
    });
  }
  //////////////////////////////////////////////////////////////////////////////
  buildHoofImgEx({@required String cowNumber, 
			String fl = '', String fr = '', 
			String bl = '', String br = '', 
			String comments = '', 
			String tag = '', 
			showComment = false,
			double scale = 1}) {

    return pw.Stack(alignment: pw.Alignment.center, children: [
      pw.Container(
          margin: pw.EdgeInsets.all(2),
          width: 108*scale,
          height: 60*scale,
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1.0)),
          child: pw.Wrap(children: [
            pw.Row(children: [
              pw.Expanded(
                  flex: 3,
                  child: pw.Container(
                      padding: pw.EdgeInsets.only(left: 5),
                      height: 30*scale,
                      decoration: pw.BoxDecoration(
                          border: pw.Border(
                              right: pw.BorderSide(color: PdfColors.black))),
                      child: pw.Text(fl, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)))),
              pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                      height: 30*scale,
                      decoration: pw.BoxDecoration(
                          border: pw.Border(
                              right: pw.BorderSide(color: PdfColors.black))),
                      child: pw.Text(showComment ? comments : ((comments.isNotEmpty || tag.isNotEmpty) ? '!' : ''), textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)))),
              pw.Expanded(
                  flex: 3,
                  child: pw.Container(
                      padding: pw.EdgeInsets.only(right: 5),
                      height: 30*scale,
                      child: pw.Text(fr, textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))))
            ]),
            pw.Row(children: [
              pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                      padding: pw.EdgeInsets.only(left: 5),
                      height: 30*scale,
                      decoration: pw.BoxDecoration(
                          border: pw.Border(
                              right: pw.BorderSide(color: PdfColors.black),
                              top: pw.BorderSide(color: PdfColors.black))),
                      child: pw.Text(bl, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)))),
              pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                      padding: pw.EdgeInsets.only(right: 5),
                      height: 30*scale,
                      decoration: pw.BoxDecoration(
                          border: pw.Border(
                              top: pw.BorderSide(color: PdfColors.black))),
                      child: pw.Text(br, textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))))
            ])
          ])),
      pw.Container(
          alignment: pw.Alignment.center,
          width: 50*scale,
          height: 14*scale,
          decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
              border: pw.Border.all(color: PdfColors.black, width: 1.0)),
          child: pw.Text(cowNumber, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)))
    ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  buildHoofImg(AgrCow cow, {
		double scale = 1,
		}) {
		return buildHoofImgEx(cowNumber: cow.number, showComment: true, comments: cow.rating.toString());
  }

 //////////////////////////////////////////////////////////////////////////////
	describeDesiases() {
		final List<pw.TableRow> body = [];

		List<AgrDisease> diseases = DiseaseService().getList();
		for (var disease in diseases) {
			body.add(
				pw.TableRow(children: [
					pw.Container(
							width: 100,
							child: pw.Text(disease.alias ?? '---',
									style: pw.TextStyle(
											fontSize: 14, fontWeight: pw.FontWeight.bold))),
					pw.Container(
							//color: PdfColors.red,
							width: PdfPageFormat.a4.width/3,
							child: pw.Text(disease.name ?? '---',
									style: pw.TextStyle(
											fontSize: 14, fontWeight: pw.FontWeight.bold)))
				]),
			);
		}

		return pw.Container(child: pw.Table(children: body));
	}
  //////////////////////////////////////////////////////////////////////////////
  buildPdfDage() {
    List<pw.Widget> rows = [];

    Map<int, List<String>> cowsRating = {
      2: [],
      3: [],
      4: [],
      5: [],
    };

    List<AgrCow> cows = [...inspection.cows];
    cows.sort((a, b) => a.rating.compareTo(b.rating));

    for (var y = 0; y < ((cows.length + 4) / 5).floor(); y++) {
      List<pw.Widget> row = [];
      for (var x = 0; x < 5; x++) {
        final index = y * 5 + x;
        if (index < cows.length) {
          AgrCow cow = cows[index];
          cowsRating[cow.rating] = cowsRating[cow.rating] ?? [];
          cowsRating[cow.rating].add(cow.number);
          row.add(buildHoofImg(cow));
        }
      }

      rows.add(pw.Row(children: row));
    }

    return pw.Padding(
        padding: pw.EdgeInsets.all(10),
        child: pw
            .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('Дата: ${inspection.createdAt.format(noTime: true)}',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text('Организация: ${inspection.farm?.name ?? '---'}',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text('ФИО: ${inspection.createdBy?.name ?? "---"}',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 15),
          ...rows,
					pw.SizedBox(height: 15),
					 pw.Row(
							mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
							crossAxisAlignment: pw.CrossAxisAlignment.start,
							children: [
      						describeDesiases(),
								 buildHoofImgEx(cowNumber: '№ коровы', fl: '\nЛевая передняя', fr: '\nПравая передняя', 
					 					bl: '\n\n\n\n\n\n\n\nЛевая задняя', br: '\n\n\n\n\n\n\n\nПравая задняя', 
					 					comments: '\nПрочее',
					 					showComment: true,
					 					scale: 2)
					]),
          pw.SizedBox(height: 10),
          pw.Text('Подпись:',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold))
        ]));
  }

////////////////////////////////////////////////////////////////////////////////
  Widget build(context) {
    if (themeData == null) {
      return LoadProgressIndicator();
    }

    final doc = pw.Document();

    doc.addPage(pw.MultiPage(
				maxPages: 200,
				pageTheme: pw.PageTheme(
					theme: themeData,
					pageFormat: PdfPageFormat(
						PdfPageFormat.a4.width, PdfPageFormat.a4.height

					)
				),
        build: (pw.Context context) {
					return [pw.Partitions(children: [
						pw.Partition(child: buildPdfDage())
					])];
        }));


    return InternalPageScaffold(
      baseRoute: '/',
      header: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text('Протокол ${inspection.id}',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Row(children: [
            Icon(MdiIcons.calendarMonth, color: Color(0xFF025FA3), size: 25),
            Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
            Text(
                (inspection.updatedAt?.format() ??
                    inspection.createdAt.format(noTime: true)),
                style: TextStyle(fontSize: 16)),
          ]),
        ],
      ),
      body: PdfPreview(
				allowSharing: true,
        build: (format) => doc.save(),
				pdfFileName: '${inspection.farm.name}${inspection.typeStr}${inspection.createdAt.format(noTime: true)}',
      ),
    );
  }
}
