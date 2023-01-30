// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'responses.g.dart';

@JsonSerializable()
class DataResponse {
  @JsonKey(name: 'latitude')
  double? latitude;
  @JsonKey(name: 'longitude')
  double? longitude;
  @JsonKey(name: 'msg')
  String? msg;

  DataResponse(this.latitude, this.longitude, this.msg);

  // toJson
  Map<String, dynamic> toJson() => _$DataResponseToJson(this);

//fromJson
  factory DataResponse.fromJson(Map<String, dynamic> json) =>
      _$DataResponseFromJson(json);
}
