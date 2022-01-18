import 'package:json_annotation/json_annotation.dart';
import 'package:hitech_agro/app_models.dart';

part 'agr_cow.g.dart';

////////////////////////////////////////////////////////////////////////////////
@JsonSerializable(nullable: true)
class AgrCow {
	
  int id;
	String guid;

	int farmId;
	
	int inspectionId;
	int rating;
	
  String number;
	String comments;
	String tag;
	
	List <AgrCowDisease> diseases;
  AgrCow();

  factory AgrCow.fromJson(Map<String, dynamic> json) => _$AgrCowFromJson(json);
  Map<String, dynamic> toJson() => _$AgrCowToJson(this);
}
