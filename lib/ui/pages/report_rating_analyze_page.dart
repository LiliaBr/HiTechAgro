import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
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
class ReportRatingAnalyzePage extends StatefulWidget {
  @override
  ReportRatingAnalyzePageState createState() => ReportRatingAnalyzePageState();
}

////////////////////////////////////////////////////////////////////////////////
class ReportRatingAnalyzePageState extends State<ReportRatingAnalyzePage> {
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
  table1() {
    var cowsHealthy = inspection.totalCowCount != 0 && inspection.cows.length != 0
		    ? (inspection.totalCowCount - inspection.cows.length) 
				: 0;
		var cowsHealthyPerc = inspection.totalCowCount != 0 && cowsHealthy != 0
        ? ((cowsHealthy / inspection.totalCowCount) * 1000).round() / 10
        : 0;

    return pw.Table(
        border: pw.TableBorder.all(
            color: PdfColors.black, width: 1.0, style: pw.BorderStyle.solid),
        children: [
          pw.TableRow(children: [
            pw.Container(
                height: 40,
                alignment: pw.Alignment.center,
                child: pw.Text('${inspection.totalCowCount ?? 0} Всего голов',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)))
          ]),
          pw.TableRow(children: [
            pw.Row(children: [
              pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  padding: pw.EdgeInsets.only(left: 10),
                  width: 241,
                  height: 40,
                  decoration: pw.BoxDecoration(
                      border: pw.Border(right: pw.BorderSide())),
                  child: pw.Text('${cowsHealthy ?? 0} Здоровых голов',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold))),
              pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  padding: pw.EdgeInsets.only(left: 10),
                  width: 241,
                  height: 40,
                  child: pw.Text(
                      '${inspection.cows?.length ?? 0} Хромых голов',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold))),
            ]),
          ]),
          pw.TableRow(children: [
            pw.Row(children: [
              pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  padding: pw.EdgeInsets.only(left: 10),
                  width: 241,
                  height: 40,
                  decoration: pw.BoxDecoration(
                      border: pw.Border(right: pw.BorderSide())),
                  child: pw.Text('${cowsHealthyPerc ?? 0}')),
              pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  padding: pw.EdgeInsets.only(left: 10),
                  width: 241,
                  height: 40,
                  child: pw.Text('${inspection.inspectedCowPerc ?? ""} %')),
            ])
          ])
        ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  table2() {
    return pw.Table(
        border: pw.TableBorder.all(
            color: PdfColors.black, width: 1.0, style: pw.BorderStyle.solid),
        children: [
          pw.TableRow(children: [
            pw.Container(
                height: 40,
                alignment: pw.Alignment.center,
                child: pw.Text(
                    'У ${inspection.cows?.length ?? 0} больных коров',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)))
          ]),
        ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  renderCell(int rating, int count) {
		double perc = inspection.cows.length != 0 ? (count/inspection.cows.length * 1000).round()/10 : 0;

    return pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
        children: [
          pw.Text(rating.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          pw.Text('$count шт'),
					pw.SizedBox(height: 5),
					pw.Text('$perc%'),
        ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  table3() {
		Map<int, int> rating = {};
		for (var cow in inspection.cows) {
				rating[cow.rating] = rating[cow.rating] ?? 0;
				rating[cow.rating]++;
		}

    return pw.Table(
        columnWidths: {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(1),
          2: pw.FlexColumnWidth(1),
          3: pw.FlexColumnWidth(1),
          4: pw.FlexColumnWidth(1),
        },
        border: pw.TableBorder.all(
            color: PdfColors.black, width: 1.0, style: pw.BorderStyle.solid),
        children: [
          pw.TableRow(children: [
            renderCell(1, rating[1] ?? 0),
            renderCell(2, rating[2] ?? 0),
            renderCell(3, rating[3] ?? 0),
            renderCell(4, rating[4] ?? 0),
            renderCell(5, rating[5] ?? 0),

          ]),
        ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  decipherDesiase(String raiting, String quantity) {
    return pw.Container(
        width: 150,
        child: pw.Table(children: [
          pw.TableRow(children: [
            pw.Column(children: [
              pw.Text(raiting,
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold))
            ]),
            pw.Column(children: [
              pw.Text(quantity,
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold))
            ])
          ])
        ]));
  }

  //////////////////////////////////////////////////////////////////////////////
  buildPDfPage() {
    return pw.Wrap(children: [
      pw.Center(
          child: pw.Text('Анализ бальный',
              style: pw.TextStyle(
                  fontSize: 30, decoration: pw.TextDecoration.underline))),
      pw.SizedBox(height: 50),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text('Организация: ${inspection.farm.name ?? '---'}',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.Text('Дата: ${inspection.createdAt.format(noTime: true)}',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      ]),
      pw.Divider(),
			pw.Text('ФИО: ${inspection.createdBy?.name ?? '---'}',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 40),
      table1(),
      pw.Container(height: 30),
      table2(),
      table3(),
      pw.Container(height: 30),
      pw.Text('Подпись:',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold))
    ]);
  }

////////////////////////////////////////////////////////////////////////////////
  Widget build(context) {
    if (themeData == null) {
      return LoadProgressIndicator();
    }

    final doc = pw.Document();

				doc.addPage(pw.Page(
						theme: themeData,
						pageFormat: PdfPageFormat.a4,
						build: (pw.Context context) {
							return buildPDfPage();
						}));

    return InternalPageScaffold(
      baseRoute: '/',
      header: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text('Отчет ${inspection.id}',
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

  void updateInspection() {}
}
