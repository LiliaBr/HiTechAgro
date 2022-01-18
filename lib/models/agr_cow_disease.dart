import 'package:json_annotation/json_annotation.dart';

part 'agr_cow_disease.g.dart';

////////////////////////////////////////////////////////////////////////////////
@JsonSerializable(nullable: true)
class AgrCowDisease {
	
  int id;
	int cowId;
	int inspectionId;
	int diseaseId;
	int locationId;
	
  AgrCowDisease();

  factory AgrCowDisease.fromJson(Map<String, dynamic> json) => _$AgrCowDiseaseFromJson(json);
  Map<String, dynamic> toJson() => _$AgrCowDiseaseToJson(this);
}
