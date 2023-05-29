import 'dart:developer';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'api_constance.dart';
import '../global/global_variables.dart';

abstract class BaseDioHelper {
  Future<dynamic> post({
    ProgressCallback? progressCallback,
    required String endPoint,
    CancelToken? cancelToken,
    bool isMultiPart = false,
    String? base,
    String? token,
    dynamic data,
    dynamic query,
    Duration? timeOut,
  });

  Future<dynamic> get({
    required String endPoint,
    CancelToken? cancelToken,
    bool isMultiPart = false,
    String? base,
    String? token,
    dynamic data,
    dynamic query,
    Duration? timeOut,
  });

  Future<dynamic> patch({
    required String endPoint,
    CancelToken? cancelToken,
    bool isMultiPart = false,
    String? base,
    String? token,
    dynamic data,
    dynamic query,
    Duration? timeOut,
  });
}

class DioHelper implements BaseDioHelper {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstance.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: ApiConstance.connectionTimeOut,
    ),
  );

  @override
  Future get({
    required String endPoint,
    CancelToken? cancelToken,
    bool isMultiPart = false,
    String? base,
    data,
    Duration? timeOut,
    String? token,
    query,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = timeOut;
    }

    dio.options.headers = {
      if (isMultiPart) 'Content-Type': 'multipart/form-data',
      if (!isMultiPart) 'Content-Type': 'application/json',
      if (!isMultiPart) 'Accept': 'application/json',
      if (token != null) 'token': token,
    };

    // we use this method to get the Cookies from the old version authentication to get permission.
    dio.interceptors.add(CookieManager(GlobalVariables().cookiesForNewVersion));

    log('URL => ${dio.options.baseUrl + endPoint}');
    log('Header => ${dio.options.headers.toString()}');
    log('Body => $data');
    log('Query => $query');

    return await request(
        call: () async => await dio.get(
              endPoint,
              cancelToken: cancelToken,
              queryParameters: query,
            ));
  }

  @override
  Future post({
    ProgressCallback? progressCallback,
    required String endPoint,
    CancelToken? cancelToken,
    bool isMultiPart = false,
    String? base,
    String? token,
    data,
    query,
    Duration? timeOut,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = timeOut;
    }

    dio.options.headers = {
      if (isMultiPart) 'Content-Type': 'multipart/form-data',
      if (!isMultiPart) 'Content-Type': 'application/json',
      if (!isMultiPart) 'Accept': 'application/json',
      if (token != null) 'Authorization': token,
    };

    // we use this method to get the Cookies from the old version authentication to get permission.
    dio.interceptors.add(CookieManager(GlobalVariables().cookiesForNewVersion));

    log('URL => ${dio.options.baseUrl + endPoint}');
    log('Header => ${dio.options.headers.toString()}');
    log('Body => $data');
    log('Query => $query');

    return await request(
        call: () async => await dio.post(
              endPoint,
              data: data,
              queryParameters: query,
              onSendProgress: progressCallback,
              cancelToken: cancelToken,
            ));
  }

  @override
  Future patch({
    ProgressCallback? progressCallback,
    required String endPoint,
    CancelToken? cancelToken,
    bool isMultiPart = false,
    String? base,
    String? token,
    data,
    query,
    Duration? timeOut,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = timeOut;
    }

    dio.options.headers = {
      if (isMultiPart) 'Content-Type': 'multipart/form-data',
      if (!isMultiPart) 'Content-Type': 'application/json',
      if (!isMultiPart) 'Accept': 'application/json',
      if (token != null) 'Authorization': token,
    };

    // we use this method to get the Cookies from the old version authentication to get permission.
    dio.interceptors.add(CookieManager(GlobalVariables().cookiesForNewVersion));

    log('URL => ${dio.options.baseUrl + endPoint}');
    log('Header => ${dio.options.headers.toString()}');
    log('Body => $data');
    log('Query => $query');

    return await request(
        call: () async => await dio.patch(
              endPoint,
              data: data,
              queryParameters: query,
              onSendProgress: progressCallback,
              cancelToken: cancelToken,
            ));
  }
}

extension on BaseDioHelper {
  Future request({
    required Future<Response> Function() call,
  }) async {
    try {
      final r = await call.call();
      log('Response_Code => ${r.statusCode}');
      log('Response_Data => ${r.data}');

      return r;
    } on DioError catch (e) {
      log('Status_Code => ${e.response!.statusCode}');
      log('Error_Message => ${e.message}');
      log('Error_Error => ${e.error.toString()}');
      log('Error_Type => ${e.type.toString()}');

      throw PrimaryServerException(
        code: e.response?.statusCode ?? 100,
        error: e.error.toString(),
        message: e.response!.data['exception'] ??
            e.response!.data['exc_type'] ??
            e.message, // Here we change it with different APIs
      );
    } catch (e) {
      PrimaryServerException exception = e as PrimaryServerException;

      throw PrimaryServerException(
        error: exception.error,
        code: exception.code,
        message: exception.message,
      );
    }
  }
}
