// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://atmd.uniblok.ru:8385//api/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<User> getProfile() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('user/0',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = User.fromJson(_result.data);
    return value;
  }

  @override
  Future<User> login(user) async {
    ArgumentError.checkNotNull(user, 'user');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(user?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = User.fromJson(_result.data);
    return value;
  }

  @override
  Future<User> logout() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('logout',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = User.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<AgrFarm>> listFarms({filter}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(filter ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('agrotech/farm/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => AgrFarm.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<User>> listFarmUsers({filter}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(filter ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('agrotech/farm/users',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => User.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<AgrDisease>> listDiseases({filter}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(filter ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('agrotech/disease/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => AgrDisease.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<AgrCowInspection>> listInspections(farmId, {filter}) async {
    ArgumentError.checkNotNull(farmId, 'farmId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(filter ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        'agrotech/farm/$farmId/inspection',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map(
            (dynamic i) => AgrCowInspection.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<AgrCowInspection> createInspection(farmId, inspection) async {
    ArgumentError.checkNotNull(farmId, 'farmId');
    ArgumentError.checkNotNull(inspection, 'inspection');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = inspection;
    final _result = await _dio.request<Map<String, dynamic>>(
        'agrotech/farm/$farmId/inspection',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AgrCowInspection.fromJson(_result.data);
    return value;
  }

  @override
  Future<AgrCowInspection> updateInspection(
      farmId, inspectionId, inspection) async {
    ArgumentError.checkNotNull(farmId, 'farmId');
    ArgumentError.checkNotNull(inspectionId, 'inspectionId');
    ArgumentError.checkNotNull(inspection, 'inspection');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = inspection;
    final _result = await _dio.request<Map<String, dynamic>>(
        'agrotech/farm/$farmId/inspection/$inspectionId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AgrCowInspection.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<AgrContactPerson>> listContactPersons(farmId, {filter}) async {
    ArgumentError.checkNotNull(farmId, 'farmId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(filter ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        'agrotech/farm/$farmId/contactPerson',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map(
            (dynamic i) => AgrContactPerson.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<AgrCowInspection> getInspection(farmId, inspectionId, {filter}) async {
    ArgumentError.checkNotNull(farmId, 'farmId');
    ArgumentError.checkNotNull(inspectionId, 'inspectionId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(filter ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'agrotech/farm/$farmId/inspection/$inspectionId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AgrCowInspection.fromJson(_result.data);
    return value;
  }

  @override
  Future<AgrCowInspection> readInspectionCow(farmId, inspectionId, cow) async {
    ArgumentError.checkNotNull(farmId, 'farmId');
    ArgumentError.checkNotNull(inspectionId, 'inspectionId');
    ArgumentError.checkNotNull(cow, 'cow');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(cow?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        'agrotech/farm/$farmId/inspection/$inspectionId/cow',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AgrCowInspection.fromJson(_result.data);
    return value;
  }

  @override
  Future<AgrCow> addInspectionCow(farmId, inspectionId, cow) async {
    ArgumentError.checkNotNull(farmId, 'farmId');
    ArgumentError.checkNotNull(inspectionId, 'inspectionId');
    ArgumentError.checkNotNull(cow, 'cow');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(cow?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        'agrotech/farm/$farmId/inspection/$inspectionId/cow',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AgrCow.fromJson(_result.data);
    return value;
  }

  @override
  Future<AgrCow> updateInspectionCow(farmId, inspectionId, cowId, cow) async {
    ArgumentError.checkNotNull(farmId, 'farmId');
    ArgumentError.checkNotNull(inspectionId, 'inspectionId');
    ArgumentError.checkNotNull(cowId, 'cowId');
    ArgumentError.checkNotNull(cow, 'cow');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(cow?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        'agrotech/farm/$farmId/inspection/$inspectionId/cow/:cowId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AgrCow.fromJson(_result.data);
    return value;
  }

  @override
  Future<void> deleteInspectionCow(farmId, inspectionId, cowId) async {
    ArgumentError.checkNotNull(farmId, 'farmId');
    ArgumentError.checkNotNull(inspectionId, 'inspectionId');
    ArgumentError.checkNotNull(cowId, 'cowId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    await _dio.request<void>(
        'agrotech/farm/$farmId/inspection/$inspectionId/cow/$cowId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'DELETE',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    return null;
  }

  @override
  Future<AgrFarm> createFarm(farm) async {
    ArgumentError.checkNotNull(farm, 'farm');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(farm?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('agrotech/farm/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AgrFarm.fromJson(_result.data);
    return value;
  }

  @override
  Future<AgrFarm> updateFarm(farmId, farm) async {
    ArgumentError.checkNotNull(farmId, 'farmId');
    ArgumentError.checkNotNull(farm, 'farm');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(farm?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        'agrotech/farm/$farmId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AgrFarm.fromJson(_result.data);
    return value;
  }

  @override
  Future<AgrContactPerson> createContactPerson(farm) async {
    ArgumentError.checkNotNull(farm, 'farm');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(farm?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        'agrotech/farm/0/contactPerson',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AgrContactPerson.fromJson(_result.data);
    return value;
  }

  @override
  Future<AgrContactPerson> updateContactPerson(id, farm) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(farm, 'farm');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(farm?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        'agrotech/farm/0/contactPerson/$id',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AgrContactPerson.fromJson(_result.data);
    return value;
  }
}
