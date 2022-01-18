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

////////////////////////////////////////////////////////////////////////////////
class ReportAnalyzePage extends StatefulWidget {
  @override
  ReportAnalyzePageState createState() => ReportAnalyzePageState();
}

////////////////////////////////////////////////////////////////////////////////
class ReportAnalyzePageState extends State<ReportAnalyzePage> {
  AgrCowInspection inspection;
  AgrFarm farm;
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
  grandTotalsTable() {
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
                child: pw.Text(
									inspection.type == 'pruning'
									? 'Всего ${inspection.cows?.length ?? 0} голов'
									: 'Всего ${inspection.totalCowCount ?? 0} голов',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)))
          ]),
          pw.TableRow(children: [
            pw.Row(children: [
              pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  padding: pw.EdgeInsets.only(left: 10),
                  width: 277.5,
                  height: 40,
                  decoration: pw.BoxDecoration(
                      border: pw.Border(right: pw.BorderSide())),
                  child: pw.Text('${cowsHealthy ?? 0} Здоровых голов',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold))),
              pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  padding: pw.EdgeInsets.only(left: 10),
                  width: 277.5,
                  height: 40,
                  child: pw.Text(
                      '${inspection.cows?.length ?? 0} Больных голов',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold))),
            ]),
          ]),
          pw.TableRow(children: [
            pw.Row(children: [
              pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  padding: pw.EdgeInsets.only(left: 10),
                  width: 277.5,
                  height: 40,
                  decoration: pw.BoxDecoration(
                      border: pw.Border(right: pw.BorderSide())),
                  child: pw.Text('${cowsHealthyPerc ?? 0}%')),
              pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  padding: pw.EdgeInsets.only(left: 10),
                  width: 277.5,
                  height: 40,
                  child: pw.Text('${inspection.inspectedCowPerc ?? 0}%')),
            ])
          ])
        ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  diseaseTotalsHeader(Map<String, int> diseasesBySide) {
    double frontPerc = inspection.cows.length != 0
        ? ((diseasesBySide['front'] / inspection.cows.length) * 1000).round() /
            10
        : 0;
    double backPerc = inspection.cows.length != 0
        ? ((diseasesBySide['back'] / inspection.cows.length) * 1000).round() /
            10
        : 0;

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
          pw.TableRow(children: [
            pw.Row(children: [
              pw.Container(
                  alignment: pw.Alignment.center,
                  //padding: pw.EdgeInsets.only(left: 10),
                  width: 277.5,
                  height: 40,
                  decoration: pw.BoxDecoration(
                      border: pw.Border(right: pw.BorderSide())),
                  child: pw.Text(
                      'Поражение тазовых конечностей ${backPerc ?? 0}%',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold))),
              pw.Container(
                  alignment: pw.Alignment.center,
                  //padding: pw.EdgeInsets.only(left: 10),
                  width: 277.5,
                  height: 40,
                  child: pw.Text(
                      'Поражение грудных конечностей ${frontPerc ?? 0}%',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold))),
            ]),
          ]),
        ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  renderDiseaseCell(Map<String, dynamic> cell) {
    double perc = inspection.cows.length != 0
        ? (((cell['count'] ?? 0) / inspection.cows.length) * 1000).round() / 10
        : 0;

    return pw.Container( 
				color: cell['side'] == 'front' ? PdfColors.grey : PdfColors.white,
        child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
          pw.Text(cell['alias'] ?? '---',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text('${cell['count']} гол.'),
          pw.Divider(),
          pw.Text('$perc%')
        ]));
  }

  //////////////////////////////////////////////////////////////////////////////
  diseaseMapBody(Map<String, Map<String, int>> diseaseMap) {
    final allDiseases = [];
    for (var side in ['all'/*'back', 'front'*/]) {
      if (diseaseMap[side] == null) continue;

      for (var key in diseaseMap[side].keys) {
        allDiseases
            .add({'side': side, 'alias': key, 'count': diseaseMap[side][key]});
      }
    }
    const colCount = 8;

    final List<pw.TableRow> body = [];
    for (var y = 0; y < allDiseases.length + (colCount - 1); y++) {
      final List<pw.Widget> children = [];

      for (var x = 0; x < colCount; x++) {
        final index = y * colCount + x;

        if (index < allDiseases.length) {
          children.add(renderDiseaseCell(allDiseases[index]));
        } else {
          children.add(pw.SizedBox.shrink());
        }
      }

      body.add(pw.TableRow(children: children));
    }

    return pw.Table(
        columnWidths: {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(1),
          2: pw.FlexColumnWidth(1),
          3: pw.FlexColumnWidth(1),
          4: pw.FlexColumnWidth(1),
          5: pw.FlexColumnWidth(1),
          6: pw.FlexColumnWidth(1),
          7: pw.FlexColumnWidth(1),
          8: pw.FlexColumnWidth(1),
        },
        border: pw.TableBorder.all(
            color: PdfColors.black, width: 1.0, style: pw.BorderStyle.solid),
        children: body);
  }

  //////////////////////////////////////////////////////////////////////////////
  tableHoofsHeader() {
    return pw.Table(
        border: pw.TableBorder.all(
            color: PdfColors.black, width: 1.0, style: pw.BorderStyle.solid),
        children: [
          pw.TableRow(children: [
            pw.Container(
                height: 40,
                alignment: pw.Alignment.center,
                child: pw.Text('Поражение конечностей'.toUpperCase(),
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)))
          ])
        ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  renderCellCountHoof(String hoofCount) {
    return pw.Column(children: [
      pw.Container(
          width: 120.5,
          child: pw.Text(hoofCount,
              textAlign: pw.TextAlign.center,
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold))),
    ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  renderCellCowCount(String count) {
    return pw.Column(children: [
      pw.Text(count,
          textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 14)),
    ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  tableHoofsBody(Map<int, int> totals) {
    return pw.Table(
        border: pw.TableBorder.all(
            color: PdfColors.black, width: 1.0, style: pw.BorderStyle.solid),
        children: [
          pw.TableRow(children: [
            renderCellCountHoof('С 1 - й окнечностью'),
            renderCellCountHoof('С 2 - мя окнечностями'),
            renderCellCountHoof('С 3 - мя окнечностями'),
            renderCellCountHoof('С 4 - мя окнечностями'),
          ]),
          pw.TableRow(children: [
            renderCellCowCount('${totals[1] ?? 0} гол.'),
            renderCellCowCount('${totals[2] ?? 0} гол.'),
            renderCellCowCount('${totals[3] ?? 0} гол.'),
            renderCellCowCount('${totals[4] ?? 0} гол.'),
          ])
        ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  describeDesiases(Map<String, String> aliasNames) {
    final List<pw.TableRow> body = [];

    for (var alias in aliasNames.keys) {
      body.add(
        pw.TableRow(children: [
          pw.Container(
              width: 100,
              child: pw.Text(alias ?? '---',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold))),
          pw.Container(
              width: 1000,
              child: pw.Text(aliasNames[alias] ?? '---',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)))
        ]),
      );
    }

    return pw.Container(child: pw.Table(children: body));
  }

  //////////////////////////////////////////////////////////////////////////////
  buildPDfPage() {
    Map<int, int> totalsByRegion = {};
    Map<String, Map<String, int>> diseaseMap = {
			'all': {}
		};
    //Map<String, >
    Map<String, String> aliasNames = {};
    Map<String, int> diseasesBySide = {
      'front': 0,
      'back': 0,
    };

    for (var cow in inspection.cows) {
      Map<String, int> regions = {};

      Map<String, int> _diseasesBySide = {};

      for (var disease in cow.diseases) {
        AgrDisease _disease =
            DiseaseService().findDiseaseById(disease.diseaseId);
        if (_disease == null) continue;
        AgrDiseaseLocation location = _disease.locations.firstWhere(
            (location) => location.id == disease.locationId,
            orElse: () => null);
        if (location == null) continue;

        regions[location.region] = regions[location.region] ?? 0;
        regions[location.region]++;
        Map<String, int> _diseaseMap;

        switch (location.region) {
          case 'hoofBL':
          case 'hoofBR':
            diseaseMap['back'] = diseaseMap['back'] ?? {};
            _diseaseMap = diseaseMap['back'];

            _diseasesBySide['back'] = _diseasesBySide['back'] ?? 0;
            _diseasesBySide['back']++;
            break;

          case 'hoofFL':
          case 'hoofFR':
            diseaseMap['front'] = diseaseMap['front'] ?? {};
            _diseaseMap = diseaseMap['front'];

            _diseasesBySide['front'] = _diseasesBySide['front'] ?? 0;
            _diseasesBySide['front']++;
            break;
          default:
            break;
        }

        _diseaseMap[_disease.alias] = _diseaseMap[_disease.alias] ?? 0;
        _diseaseMap[_disease.alias]++;

				diseaseMap['all'][_disease.alias] = diseaseMap['all'][_disease.alias] ?? 0;
				diseaseMap['all'][_disease.alias]++;

        aliasNames[_disease.alias] = _disease.name;
      }

      if (_diseasesBySide['front'] != null) diseasesBySide['front']++;
      if (_diseasesBySide['back'] != null) diseasesBySide['back']++;

      totalsByRegion[regions.length] = totalsByRegion[regions.length] ?? 0;
      totalsByRegion[regions.length]++;
    }

    return pw.Padding(
        padding: pw.EdgeInsets.all(20),
        child: pw.Wrap(children: [
          pw.Center(
              child: pw.Text('Анализ',
                style: pw.TextStyle(
                  fontSize: 30, decoration: pw.TextDecoration.underline))),
          pw.SizedBox(height: 50),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Организация: ${inspection.farm?.name ?? "---"}',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text('Дата: ${inspection.createdAt.format(noTime: true)}',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold))
              ]),
          pw.Divider(),
					pw.Text('ФИО: ${inspection.createdBy?.name ?? "---"}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 30),
          grandTotalsTable(),
          pw.Container(height: 20),
          diseaseTotalsHeader(diseasesBySide),
          diseaseMapBody(diseaseMap),
          pw.Container(height: 20),
          tableHoofsHeader(),
          tableHoofsBody(totalsByRegion),
          pw.Container(height: 20),
          describeDesiases(aliasNames),
          pw.Container(height: 20),
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

    doc.addPage(pw.Page(
        theme: themeData,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.FullPage(ignoreMargins: true, child: buildPDfPage());
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
