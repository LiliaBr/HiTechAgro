import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

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

////////////////////////////////////////////////////////////////////////////////
class ReportProtocolPage extends StatefulWidget {
  @override
  ReportProtocolPageState createState() => ReportProtocolPageState();
}

////////////////////////////////////////////////////////////////////////////////
class ReportProtocolPageState extends State<ReportProtocolPage> {
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
  buildHoofImg(String cowNumber, Map<String, dynamic> diseases) {
    String getDiseasesStr(String region) {
      if (diseases[region] == null) return '';

      List<String> retval = [];
      for (var i = 0; i < min(3, diseases[region].length); i++) {
        retval.add(diseases[region][i].alias);
      }
      return retval.join('\n');
    }

    return buildHoofImgEx(
        cowNumber: cowNumber,
        comments: diseases['comments'],
        tag: diseases['tag'],
        fl: getDiseasesStr('hoofFL'),
        fr: getDiseasesStr('hoofFR'),
        bl: getDiseasesStr('hoofBL'),
        br: getDiseasesStr('hoofBR'));
  }
	

  //////////////////////////////////////////////////////////////////////////////
  buildHoofImgEx(
      {@required String cowNumber,
      @required String fl,
      @required String fr,
      @required String bl,
      @required String br,
      String comments = '',
      String tag = '',
      showComment = false,
      double scale = 1}) {

		List<String> commentsArr = [];	
		if (showComment) {
			commentsArr.add(comments);
		} else {
			if (comments.isNotEmpty) commentsArr.add('!');
		}
		
		if (tag.isNotEmpty) commentsArr.add(tag);

    return pw.Stack(alignment: pw.Alignment.center, children: [
      pw.Container(
          margin: pw.EdgeInsets.all(2),
          width: 108 * scale,
          height: 60 * scale,
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1.0)),
          child: pw.Wrap(children: [
            pw.Row(children: [
              pw.Expanded(
                  flex: 3,
                  child: pw.Container(
                      padding: pw.EdgeInsets.only(left: 5),
                      height: 30 * scale,
                      decoration: pw.BoxDecoration(
                          border: pw.Border(
                              right: pw.BorderSide(color: PdfColors.black))),
                      child: pw.Text(fl,
                          style: pw.TextStyle(
                              fontSize: 8, fontWeight: pw.FontWeight.bold)))),
              pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                      height: 30 * scale,
                      decoration: pw.BoxDecoration(
                          border: pw.Border(
                              right: pw.BorderSide(color: PdfColors.black))),
                      child: pw.Text(commentsArr.join('\n'),
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 8, fontWeight: pw.FontWeight.bold)))),
              pw.Expanded(
                  flex: 3,
                  child: pw.Container(
                      padding: pw.EdgeInsets.only(right: 5),
                      height: 30 * scale,
                      child: pw.Text(fr,
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontSize: 8, fontWeight: pw.FontWeight.bold))))
            ]),
            pw.Row(children: [
              pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                      padding: pw.EdgeInsets.only(left: 5),
                      height: 30 * scale,
                      decoration: pw.BoxDecoration(
                          border: pw.Border(
                              right: pw.BorderSide(color: PdfColors.black),
                              top: pw.BorderSide(color: PdfColors.black))),
                      child: pw.Text(bl,
                          style: pw.TextStyle(
                              fontSize: 8, fontWeight: pw.FontWeight.bold)))),
              pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                      padding: pw.EdgeInsets.only(right: 5),
                      height: 30 * scale,
                      decoration: pw.BoxDecoration(
                          border: pw.Border(
                              top: pw.BorderSide(color: PdfColors.black))),
                      child: pw.Text(br,
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontSize: 8, fontWeight: pw.FontWeight.bold))))
            ])
          ])),
      pw.Container(
          alignment: pw.Alignment.center,
          width: 50 * scale,
          height: 14 * scale,
          decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
              border: pw.Border.all(color: PdfColors.black, width: 1.0)),
          child: pw.Text(cowNumber,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)))
    ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  describeDesiases(Map<String, String> aliasNames) {
    final List<pw.TableRow> body = [];

    for (var alias in aliasNames.keys) {
      body.add(
        pw.TableRow(children: [
          pw.Container(
              width: 60,
              child: pw.Text(alias ?? '---',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold))),
          pw.Container(
              //color: PdfColors.red,
              width: PdfPageFormat.a4.width / 3,
              child: pw.Text(aliasNames[alias] ?? '---',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)))
        ]),
      );
    }

    return pw.Container(child: pw.Table(children: body));
  }

  //////////////////////////////////////////////////////////////////////////////
  diseaseMapTable(Map<String, Map<String, dynamic>> diseaseMap) {
    List<pw.Widget> rows = [];

    final List<dynamic> cowsWithoutDiseases = diseaseMap.values.where((cow) => cow['healthy'] == true).toList();
		final List<dynamic> cowsWithDiseases = diseaseMap.values.where((cow) => cow['healthy'] != true).toList();

    cowsWithoutDiseases.sort((a, b) => a['number'].compareTo(b['number']));
    cowsWithDiseases.sort((a, b) => a['number'].compareTo(b['number']));

		final List<dynamic> cows = [...cowsWithoutDiseases, ...cowsWithDiseases];


    const colCount = 5;

    for (var y = 0; y < (cows.length / colCount).ceil(); y++) {
      List<pw.Widget> row = [];

      for (var x = 0; x < colCount; x++) {
        final index = y * colCount + x;
        if (index < cows.length) {
          final String cowNumber = cows[index]['number'];
          row.add(buildHoofImg(cowNumber, diseaseMap[cowNumber]));
        } else {
          row.add(pw.SizedBox.shrink());
        }
      }

      rows.add(pw.Row(children: row));
    }

    return rows;
  }

  //////////////////////////////////////////////////////////////////////////////
  buildPdfDage() {
    Map<String, String> aliasNames = {};
    Map<String, Map<String, dynamic>> cowDiseaseMap = {};

    for (var cow in inspection.cows) {
			if  (cow.diseases.length > 0) {
				for (var disease in cow.diseases) {
					AgrDisease _disease = DiseaseService().findDiseaseById(disease.diseaseId);
					if (_disease == null) continue;

					AgrDiseaseLocation location = _disease.locations.firstWhere(
							(location) => location.id == disease.locationId,
							orElse: () => null);
					if (location == null) continue;

					cowDiseaseMap[cow.number] = cowDiseaseMap[cow.number] ?? {};
					
					cowDiseaseMap[cow.number]['number'] = cow.number ?? '';
					cowDiseaseMap[cow.number]['comments'] = cow.comments ?? '';
					cowDiseaseMap[cow.number]['tag'] = cow.tag ?? '';
					cowDiseaseMap[cow.number]['healthy'] = false;
					cowDiseaseMap[cow.number][location.region] = cowDiseaseMap[cow.number][location.region] ?? [];
					cowDiseaseMap[cow.number][location.region].add(_disease);

					aliasNames[_disease.alias] = _disease.name;
				}
			} else if (inspection.type == 'pruning') {
				cowDiseaseMap[cow.number] = cowDiseaseMap[cow.number] ?? {};
				cowDiseaseMap[cow.number]['number'] = cow.number ?? '';
				cowDiseaseMap[cow.number] = cowDiseaseMap[cow.number] ?? {};
				cowDiseaseMap[cow.number]['comments'] = cow.comments ?? '';
				cowDiseaseMap[cow.number]['tag'] = cow.tag ?? '';
				cowDiseaseMap[cow.number]['healthy'] = true;
			}
    }


    return pw.Padding(
        padding: pw.EdgeInsets.all(20),
        child: pw
            .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('Дата: ${inspection.createdAt.format(noTime: true)}',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text('Организация: ${inspection.farm?.name ?? '---'}',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text('ФИО: ${inspection.createdBy?.name ?? "---"}',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 15),
          ...diseaseMapTable(cowDiseaseMap),
          pw.SizedBox(height: 15),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
							crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                describeDesiases(aliasNames),
                buildHoofImgEx(
                    cowNumber: '№ коровы',
                    fl: '\nЛевая передняя',
                    fr: '\nПравая передняя',
                    bl: '\n\n\n\n\n\n\n\nЛевая задняя',
                    br: '\n\n\n\n\n\n\n\nПравая задняя',
                    comments: '\nПрочее',
                    showComment: true,
                    scale: 2),
              ]),
          pw.SizedBox(height: 20),
          pw.Container(
              alignment: pw.Alignment.bottomLeft,
              child: pw.Text('Подпись:',
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)))
        ]));
  }

////////////////////////////////////////////////////////////////////////////////
  Widget build(context) {
    if (themeData == null) {
      return LoadProgressIndicator();
    }

    final doc = pw.Document();

    doc.addPage(pw.MultiPage(
        pageTheme: pw.PageTheme(
            theme: themeData,
            pageFormat:
                PdfPageFormat(PdfPageFormat.a4.width, PdfPageFormat.a4.height)),
        build: (pw.Context context) {
          return [
            pw.Partitions(children: [pw.Partition(child: buildPdfDage())])
          ];
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
        pdfFileName:
            '${inspection.farm.name}${inspection.typeStr}${inspection.createdAt.format(noTime: true)}',
      ),
    );
  }

  void updateInspection() {}
}
