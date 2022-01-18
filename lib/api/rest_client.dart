import 'package:flutter/material.dart';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import 'package:hitech_agro/app_global.dart';
import 'package:hitech_agro/app_models.dart';

part 'rest_client.g.dart';

const String PROD_BASE_URL = "https://atmd.uniblok.ru:8385/";
const String DEBUG_BASE_URL = "https://atmd.uniblok.ru:8385/";

const String PROD_API_URL = "$PROD_BASE_URL/api/";
const String DEBUG_API_URL = "$DEBUG_BASE_URL/api/";

////////////////////////////////////////////////////////////////////////////////
getLocalTimezone() async {
  try {
    return await FlutterNativeTimezone.getLocalTimezone();
  } catch (err) {
    return 'Europe/Moscow';
  }
}

////////////////////////////////////////////////////////////////////////////////
class ApiResponse {
  int statusCode;
  Map<String, String> headers;
  String body;
  dynamic json;
  Map errors;

  ApiResponse(this.statusCode, this.headers, this.body) {
    json = Map;
    try {
      json = jsonDecode(body);

      if (json is Map && json['formData'] is bool) {
        errors = json['errors'];
      }
    } catch (err) {
      developer.log(err.toString());
    }
  }
}

////////////////////////////////////////////////////////////////////////////////
@RestApi(baseUrl: DEBUG_API_URL)
abstract class RestClient {
  static RestClient _singleton;

  //////////////////////////////////////////////////////////////////////////////
  factory RestClient() {
    if (_singleton != null) {
      return _singleton;
    }

    final Dio dio = Dio();

    ////////////////////////////////////////////////////////////////////////////
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      try {
        developer.log('Sending request to ${options.baseUrl}${options.path}', name: 'rest');
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        String cookie = localStorage.getString('cookie');

        if (cookie != null) {
          Cookie cookieMap = Cookie.fromSetCookieValue(cookie);
          options.headers['cookie'] = cookieMap.toString();
        }
        options.headers['x-user-timezone'] = await getLocalTimezone();

        return options;
      } catch (err) {
        developer.log('Dio request interceptor error',
            error: err, name: 'rest');
        return options;
      }
    }));

    //////////////////////////////////////////////////////////////////////////
    dio.interceptors.add(InterceptorsWrapper(onError: (DioError error) async {
      print('HTTP request error');
      developer.log('HTTP request error', error: error, name: 'rest');

      if (error.response?.statusCode == 401) {
        AppGlobal.navKey.currentState.pushReplacementNamed('/login');
      }

      return error;
    }));

    //////////////////////////////////////////////////////////////////////////
    dio.interceptors.add(InterceptorsWrapper(onResponse: (Response response) async {
      developer.log('HTTP response ${response.request.uri.toString()} received',
          name: 'rest');
      developer.log(response.toString(), name: 'rest', level: 2);
      if (response.statusCode == 401) {
        AppGlobal.navKey.currentState.pushReplacementNamed('/login');
      } else if (response.statusCode == 200 &&
          response.headers['set-cookie'] != null) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();

        developer.log(
            'Set-cookie received: ' + response.headers['set-cookie'][0],
            name: 'rest');
        localStorage.setString('cookie', response.headers['set-cookie'][0]);
      }
      return response;
    }));

    _singleton = _RestClient(dio);
    return _singleton;
  }

  get baseUrl {
    return DEBUG_BASE_URL;
  }

  static get baseServerUrl {
    return DEBUG_BASE_URL;
  }

	static Map<String, dynamic> getFormErrors(err) {
		if (err.response != null &&
				err.response.data is Map &&
				err.response.data['formData'] == true) {
				return err.response.data['errors'];
		}
 		return null;
	}

  @GET("user/0")
  Future<User> getProfile();

  @POST("login")
  Future<User> login(@Body() User user);

  @POST("logout")
  Future<User> logout();

  @GET("agrotech/farm/")
  Future<List<AgrFarm>> listFarms({@Queries() Map<String, dynamic> filter});	

  @GET("agrotech/farm/users")
  Future<List<User>> listFarmUsers({@Queries() Map<String, dynamic> filter});	


  @GET("agrotech/disease/")
  Future<List<AgrDisease>> listDiseases({@Queries() Map<String, dynamic> filter});	

	@GET("agrotech/farm/{farmId}/inspection")
	Future<List<AgrCowInspection>> listInspections(@Path() int farmId, {@Queries() Map<String, dynamic> filter});	

	@POST("agrotech/farm/{farmId}/inspection")
	Future<AgrCowInspection> createInspection(@Path() int farmId, @Body() inspection);	

	@POST("agrotech/farm/{farmId}/inspection/{inspectionId}")
	Future<AgrCowInspection> updateInspection(@Path() int farmId, @Path() int inspectionId, @Body() inspection);	

	@GET("agrotech/farm/{farmId}/contactPerson")
	Future<List<AgrContactPerson>> listContactPersons(@Path() int farmId, {@Queries() Map<String, dynamic> filter});	

	@GET("agrotech/farm/{farmId}/inspection/{inspectionId}")
	Future<AgrCowInspection> getInspection(@Path() int farmId, @Path() int inspectionId, {@Queries() Map<String, dynamic> filter});	

	@GET("agrotech/farm/{farmId}/inspection/{inspectionId}/cow")
	Future<AgrCowInspection> readInspectionCow(@Path() int farmId, @Path() int inspectionId, @Body() AgrCow cow);	

	@POST("agrotech/farm/{farmId}/inspection/{inspectionId}/cow")
	Future<AgrCow> addInspectionCow(@Path() int farmId, @Path() int inspectionId, @Body() AgrCow cow);	

	@POST("agrotech/farm/{farmId}/inspection/{inspectionId}/cow/:cowId")
	Future<AgrCow> updateInspectionCow(@Path() int farmId, @Path() int inspectionId, @Path() int cowId, @Body() AgrCow cow);	

	@DELETE("agrotech/farm/{farmId}/inspection/{inspectionId}/cow/{cowId}")
	Future<void> deleteInspectionCow(@Path() int farmId, @Path() int inspectionId, @Path() int cowId);	

	@POST("agrotech/farm/")
	Future<AgrFarm> createFarm(@Body() AgrFarm farm);	

	@POST("agrotech/farm/{farmId}")
	Future<AgrFarm> updateFarm(@Path() int farmId, @Body() AgrFarm farm);	

	@POST("agrotech/farm/0/contactPerson")
	Future<AgrContactPerson> createContactPerson(@Body() AgrContactPerson farm);	

	@POST("agrotech/farm/0/contactPerson/{id}")
	Future<AgrContactPerson> updateContactPerson(@Path() int id, @Body() AgrContactPerson farm);	
}

////////////////////////////////////////////////////////////////////////////////
Future<ApiResponse> restSendFile(
    String endpoint, File file, BuildContext context) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  String cookie = localStorage.getString('cookie');

  var postUri = Uri.parse(DEBUG_API_URL + endpoint);
  var request = new http.MultipartRequest("POST", postUri);

  if (cookie != null) {
    Cookie cookieMap = Cookie.fromSetCookieValue(cookie);
    request.headers['cookie'] = cookieMap.toString();
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Disposition'] = 'form-date; name="file"';
    request.headers['x-user-timezone'] = await getLocalTimezone();
  }

  request.files.add(new http.MultipartFile.fromBytes(
      'file', await file.readAsBytes(),
      filename: file.path.split('/').last,
      contentType: new MediaType('image', 'jpeg')));

  final response = await request.send();
  final body = await response.stream.bytesToString();
  return ApiResponse(response.statusCode, response.headers, body);
}
