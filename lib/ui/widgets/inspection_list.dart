import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hitech_agro/services/db_service.dart';
import 'package:hitech_agro/ui/dialogs/download_report_dialog.dart';
import 'package:intl/intl.dart';

import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import "package:hitech_agro/app_models.dart";
import "package:hitech_agro/app_state.dart";
import 'package:hitech_agro/ui/widgets/load_progress_indicator.dart';
import 'package:hitech_agro/ui/widgets/empty_list_view.dart';
import 'package:hitech_agro/ui/widgets/error_list_view.dart';

import 'package:hitech_agro/extensions/datetime_format.dart';

import 'package:hitech_agro/services/inspection_service.dart';

import 'package:hitech_agro/ui/widgets/sliver_grid_delegate_with_fixed_height.dart';

////////////////////////////////////////////////////////////////////////////////
class InspectionList extends StatefulWidget {
  InspectionList({Key key}) : super(key: key);

  @override
  _InspectionListState createState() => _InspectionListState();
}

////////////////////////////////////////////////////////////////////////////////
class _InspectionListState extends State<InspectionList>
    with AutomaticKeepAliveClientMixin<InspectionList> {
  Future<List<AgrCowInspection>> inspectionListFuture;
  var eventListener;

  AgrCowInspection inspection;

  @override
  bool wantKeepAlive = true;

  Map<String, dynamic> filter = {};

  Key key;

  //////////////////////////////////////////////////////////////////////////////
  final fieldText = TextEditingController();

  //////////////////////////////////////////////////////////////////////////////
  initState() {
    super.initState();
  }

  //////////////////////////////////////////////////////////////////////////////
  didChangeDependencies() {
    loadInspections();

    eventListener = DbService().on('inspectionUpdated', null, (event, object) {
      if (mounted) {
        loadInspections(false);
        setState(() {});
      }
    });

    super.didChangeDependencies();
  }

  //////////////////////////////////////////////////////////////////////////////
  dispose() {
    eventListener.cancel();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<void> loadInspections([bool renewKey = true]) async {
    List<String> where = [];
    List<dynamic> whereArgs = [];
    String farmGuid = AppState().getFarm()?.guid;

    if (farmGuid != null) {
      where.add("(farm_guid = '$farmGuid' OR parent_farm_guid = '$farmGuid')");
    }

    if ((filter['q'] ?? '') != '') {
      String q = filter['q'];

      where.add("farm_name like '%${q.toLowerCase()}%'");
    }

    if (filter['dateRange'] != null && filter['dateRange'] is List) {
      where.add(
          "updated_at between '${filter['dateRange'][0].toIso8601String()}' and  '${filter['dateRange'][1].toIso8601String()}'");
    }

    inspectionListFuture = DbService().getObjects<AgrCowInspection>(
        where: where.join(' AND '),
        whereArgs: whereArgs,
        orderBy: 'updated_at desc');

//		print((await DbService().database.rawQuery("select  json_extract(data, '\$.farm') from agr_inspection")).first.values);

    if (renewKey) {
      setState(() {
        key = UniqueKey();
      });
    }
    return inspectionListFuture;
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<void> refreshInspections() {
    setState(() {});

    InspectionService().refresh();

    return loadInspections(false);
  }

  //////////////////////////////////////////////////////////////////////////////
  void datePicker(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return AlertDialog(
                title: Container(
              width: constraints.maxWidth / 2,
              height: constraints.maxHeight / 2,
              child: SfDateRangePicker(
                todayHighlightColor: Color(0xFF025FA3),
                backgroundColor: Colors.white,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value?.startDate != null &&
                      args.value?.endDate != null) {
                    this.setState(() {
                      filter['dateRange'] = [
                        args.value.startDate,
                        args.value.endDate
                      ];
                    });

                    loadInspections();

                    Navigator.of(dialogContext).pop();
                  }
                },
                onSubmit: (Object obj) {
                  print(obj);
                },
                selectionMode: DateRangePickerSelectionMode.range,
              ),
            ));
          });
        });
  }

  //////////////////////////////////////////////////////////////////////////////
  searchField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: TextField(
          textCapitalization: TextCapitalization.words,
          onSubmitted: (String q) {
            setState(() {
              filter['q'] = q;
              loadInspections();
            });
          },
          decoration: InputDecoration(
            hintText: 'Поиск',
            hintStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
            contentPadding: EdgeInsets.only(top: 10),
            isDense: true,
            prefixIcon: Icon(Icons.search, color: Color(0xFF025FA3), size: 30),
            suffixIcon: InkWell(
                onTap: () {
                  fieldText.clear();
                  setState(() {
                    filter['q'] = '';
                    loadInspections();
                  });
                },
                child: Icon(
                  Icons.clear,
                  color: Color(0xFF025FA3),
                  size: 30,
                )),
          ),
          controller: fieldText,
        ));
  }

  //////////////////////////////////////////////////////////////////////////////
  calendarSearch() {
    var rangeStr = 'Выберите дату';
    final DateFormat _dateFormatter = new DateFormat('dd MMM yyyy', 'ru_RU');
    if (filter['dateRange'] != null && filter['dateRange'] is List) {
      rangeStr =
          "${_dateFormatter.format(filter['dateRange'][0])} - ${_dateFormatter.format(filter['dateRange'][1])}";
    }
    return InkWell(
      onTap: () => datePicker(context),
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        height: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Color(0xFF025FA3).withOpacity(0.2))),
        child: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Row(
            children: [
              Expanded(
                  flex: 6,
                  child: Row(children: [
                    Icon(MdiIcons.calendarMonth, color: Color(0xFF025FA3)),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Text(rangeStr,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[600])),
                  ])),
              Expanded(
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                InkWell(
                  child: Icon(Icons.clear, color: Color(0xFF025FA3)),
                  onTap: () {
                    setState(() {
                      filter['dateRange'] = null;
                      loadInspections();
                    });
                  },
                )
              ])),
            ],
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  selectedFarmInfoBlock() {
    if (AppState().getFarm() == null) return SizedBox.shrink();

    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 10),
        margin: EdgeInsets.only(left: 5, bottom: 10),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Text(AppState().getFarm().name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.only(right: 10)),
            Icon(Icons.info_outline, size: 30)
          ],
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed('/information'),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  createInspectionButton({double scale = 1}) {
    return IconButton(
        icon: Icon(Icons.control_point, color: Color(0xFFFF9900)),
        iconSize: 35 * scale,
        onPressed: () async {
          DbService().syncEnabled = false;
          await Navigator.of(context).pushNamed('/create_inspection');
          DbService().syncEnabled = true;
          loadInspections();
        });
  }

  //////////////////////////////////////////////////////////////////////////////
  searchBox() {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Expanded(flex: 1, child: calendarSearch()),
          Expanded(
              flex: 1,
              child: Row(children: [
                Expanded(flex: 3, child: searchField()),
                Expanded(child: createInspectionButton(scale: 1.4))
              ]))
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  inspectionName(AgrCowInspection inspection) {
    return Row(
      children: [
        inspection.type == 'rating'
            ? Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  MdiIcons.star,
                  color: Color(0xFFFF9900),
                  size: 25,
                ))
            : SizedBox.shrink(),
        inspection.type == 'pruning'
            ? Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  MdiIcons.boxCutter,
                  color: Color(0xFFFF9900),
                  size: 25,
                ))
            : SizedBox.shrink(),
        Text('#${inspection.id ?? inspection.name}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  inspectionDateLabel(IconData icon, String date) {
    return Row(children: [
      Icon(icon),
      SizedBox(width: 10),
      Text(date, style: TextStyle(fontSize: 16)),
    ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  inspectionCowCountLabel(String text) {
    return Row(children: [
      Icon(
        IcoFontIcons.cow,
      ),
      SizedBox(width: 10),
      Text(text, style: TextStyle(fontSize: 16))
    ]);
  }

  //////////////////////////////////////////////////////////////////////////////
  inspectionCowTotalsProgressBar(double perc) {
    return LinearPercentIndicator(
        lineHeight: 18.0,
        percent: perc / 100,
        center: Text( 
					'$perc%',
            style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        progressColor: Color(0xFF025FA3).withOpacity(0.7));
  }

  //////////////////////////////////////////////////////////////////////////////
  inspectionCreatedByLabel(IconData icon, String user) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 10),
        Text(user, style: TextStyle(fontSize: 16))
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  inspectionFarmName(String nameFarm) {
    return Text(nameFarm,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  //////////////////////////////////////////////////////////////////////////////
  downloadReportButton(AgrCowInspection inspection) {
    return IconButton(
		//	padding: EdgeInsets.only(bottom: 10),
    //  alignment: Alignment.bottomRight,
        onPressed: () => downloadReportDialog(inspection),
        icon: Icon(MdiIcons.fileUploadOutline, size: 45, color: Colors.grey));
  }

  //////////////////////////////////////////////////////////////////////////////
  downloadReportDialog(AgrCowInspection inspection) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return DownloadReportDialog(inspection);
        });
  }

  //////////////////////////////////////////////////////////////////////////////
  inspectionCard(context, AgrCowInspection inspection) {
    return Padding(
        padding: EdgeInsets.fromLTRB(2, 5, 2, 0),
        child: InkWell(
          child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  offset: const Offset(5.0, 5.0),
                  blurRadius: 5.0,
                  spreadRadius: 5.0,
                )
              ]),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Wrap(runSpacing: 15, children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          inspectionName(inspection),
                          Wrap(
                              direction: Axis.vertical,
                              spacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                inspectionFarmName(inspection.farm.name),
                                Icon(Icons.cloud,
                                    size: 16,
                                    color: inspection.$dirty
                                        ? Color(0xFFFF9900)
                                        : Colors.grey)
                              ])
                        ]),
                    inspectionCowCountLabel(
                        '${inspection.cows.length} коров в осмотре'),
                    Wrap(children: [
                      inspectionCowTotalsProgressBar(
												inspection.type == 'pruning'
												?  inspection.inspectedCowPercPruning
                        :  inspection.inspectedCowPerc),
                      Center(
                          child: Text(
														inspection.type == 'pruning'
														? '${inspection.cows?.length ?? 0} из ${inspection.cows?.length ?? 0}'
                            : '${inspection.cows?.length ?? 0} из ${inspection.totalCowCount ?? 0}',
                              style: TextStyle(fontSize: 14))),
                    ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
											//	crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Wrap(
                              direction: Axis.vertical,
                              spacing: 10,
                              children: [
                                inspectionCreatedByLabel(MdiIcons.accountTie,
                                    inspection.createdBy?.name ?? 'Без имени'),
                                inspectionDateLabel(MdiIcons.calendarMonth,
                                    inspection.createdAt?.format() ?? ''),
                              ]),
                          downloadReportButton(inspection)
                        ]),
                  ]),
                ),
              )),
          onTap: () async {
            DbService().syncEnabled = false;
            await Navigator.pushNamed(context, '/inspection',
                arguments: inspection);
            DbService().syncEnabled = true;
            loadInspections();
          },
        ));
  }

  //////////////////////////////////////////////////////////////////////////////
  _buildInspections(inspectionList) {
    return inspectionList.length == 0
        ? EmptyListView('Список осмотров пуст')
        : GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                    crossAxisCount: MediaQuery.of(context).size.width > 1006
										? 3
										: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    height: 250.0),
            itemCount: inspectionList.length,
            itemBuilder: (context, index) {
              return inspectionCard(context, inspectionList[index]);
            });
  }

  //////////////////////////////////////////////////////////////////////////////
  Widget build(context) {
    super.build(context);

    return Scaffold(
        body: Column(
      children: [
        selectedFarmInfoBlock(),
        searchBox(),
        Expanded(
          child: FutureBuilder<List<AgrCowInspection>>(
              key: key,
              future: inspectionListFuture,
              builder: (_context, result) {
                if (result.hasData) {
                  return RefreshIndicator(
                      onRefresh: refreshInspections,
                      child: _buildInspections(result.data));
                } else if (result.hasError) {
                  return ErrorListView(
                    result.error,
                    onRetry: () {
                      setState(() {
                        loadInspections();
                      });
                    },
                  );
                } else {
                  return LoadProgressIndicator();
                }
              }),
        ),
      ],
    ));
  }
}
