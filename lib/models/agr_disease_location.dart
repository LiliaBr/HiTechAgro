import 'package:json_annotation/json_annotation.dart';

part 'agr_disease_location.g.dart';

////////////////////////////////////////////////////////////////////////////////
@JsonSerializable(nullable: true)
class AgrDiseaseLocation {
	
  int id;
	String name;
	String description;	
	
	String region;
	String segment;
	
  AgrDiseaseLocation();

  factory AgrDiseaseLocation.fromJson(Map<String, dynamic> json) => _$AgrDiseaseLocationFromJson(json);
  Map<String, dynamic> toJson() => _$AgrDiseaseLocationToJson(this);
}
