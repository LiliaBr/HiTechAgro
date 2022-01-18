import 'package:json_annotation/json_annotation.dart';
//import 'package:hitech_agro/app_models.dart';
//import 'package:intl/intl.dart';

part 'agr_cow_inspection_totals.g.dart';

////////////////////////////////////////////////////////////////////////////////
@JsonSerializable(nullable: true)
class AgrCowInspectionTotals {
  int inspectionId;
  int cowCount;
	int diseasedCowCount;

  AgrCowInspectionTotals();

  factory AgrCowInspectionTotals.fromJson(Map<String, dynamic> json) {
		if (json['cowCount'] is String) json['cowCount'] = int.tryParse(json['cowCount']);
		if (json['diseasedCowCount'] is String) json['diseasedCowCount'] = int.tryParse(json['diseasedCowCount']);

		return _$AgrCowInspectionTotalsFromJson(json);
	}

  Map<String, dynamic> toJson() => _$AgrCowInspectionTotalsToJson(this);
}
