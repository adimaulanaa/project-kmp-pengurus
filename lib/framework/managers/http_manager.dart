import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:kmp_pengurus_app/env.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';

abstract class HttpManager {
  Future<dynamic> get({
    required String url,
    Map<String, dynamic> query,
    required Map<String, String> headers,
  });
  Future<dynamic> download({
    required String url,
    String path,
    required Map<String, String> headers,
  });

  Future<dynamic> post({
    String url,
    Map body,
    Map<String, dynamic> query,
    Map<String, dynamic> headers,
    FormData formData,
    bool isUploadImage = false,
  });

  Future<dynamic> put({
    String url,
    Map body,
    Map<String, dynamic> query,
    Map<String, String> headers,
    FormData formData,
    bool isUploadImage = false,
  });

  Future<dynamic> delete({
    String url,
    Map<String, dynamic> query,
    Map<String, String> headers,
  });
}

class CustomInterceptors extends Interceptor {
  @override
  Future onRequest(options, handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return onRequest(options, handler);
  }

  @override
  Future onResponse(response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return onResponse(response, handler);
  }

  @override
  Future onError(DioError err, handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return onError(err, handler);
  }
}

class AppHttpManager implements HttpManager {
  static final AppHttpManager instance = AppHttpManager._instantiate();
  final String _baseUrl = Env().apiBaseUrl!;
  final Dio _dio = new Dio();

  Duration _httpTimeout = Duration(seconds: 20);
  Duration _httpUploadTimeout = Duration(seconds: 30);

  AppHttpManager() {
    _httpTimeout = Duration(seconds: Env().configHttpTimeout!);
    _httpUploadTimeout = Duration(seconds: Env().configHttpUploadTimeout!);
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(
      DioCacheManager(
        CacheConfig(baseUrl: _baseUrl),
      ).interceptor,
    );

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  AppHttpManager._instantiate();

  @override
  Future<dynamic> delete({
    String? url,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      if (Env().isInDebugMode) {
        print('Api Delete request url $url');
      }

      final response = await _dio
          .delete(_queryBuilder(url, query),
              options: Options(
                headers: _headerBuilder(headers),
              ))
          .timeout(_httpTimeout, onTimeout: () {
        throw NetworkException();
      });
      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  @override
  Future get({
    String? url,
    Map<String, dynamic>? query,
    required Map<String, String> headers,
  }) async {
    try {
      if (Env().isInDebugMode) {
        print('Api Get request url $url, with $query');
      }

      final response = await _dio
          .get(_queryBuilder(url, query),
              options: buildCacheOptions(
                Duration(days: 1),
                forceRefresh: true,
                options: Options(
                  headers: _headerBuilder(headers),
                ),
              ))
          .timeout(_httpTimeout, onTimeout: () {
        throw NetworkException();
      });
      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  @override
  Future download({
    String? url,
    String? path,
    required Map<String, String> headers,
  }) async {
    try {
      if (Env().isInDebugMode) {
        print('Api Download request url $url,');
      }

      final response = await _dio
          .download(
        _queryBuilder(url, {}),
        path,
        options: Options(
          headers: _headerBuilder(headers),
        ),
      )
          .timeout(_httpUploadTimeout, onTimeout: () {
        throw NetworkException();
      });

      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  @override
  Future<dynamic> post({
    String? url,
    Map? body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    FormData? formData,
    bool isUploadImage = false,
  }) async {
    try {
      if (Env().isInDebugMode) {
        print('Api Post request url $url, with $body');
      }

      final response = await _dio
          .post(_queryBuilder(url, query),
              data: formData != null
                  ? formData
                  : body != null
                      ? json.encode(body)
                      : null,
              options: Options(
                headers: _headerBuilder(headers),
              ))
          .timeout((isUploadImage) ? _httpUploadTimeout : _httpTimeout,
              onTimeout: () {
        throw NetworkException();
      });

      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  @override
  Future<dynamic> put({
    String? url,
    Map? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    FormData? formData,
    bool isUploadImage = false,
  }) async {
    try {
      if (Env().isInDebugMode) {
        print('Api Put request url $url, with $body');
      }

      final response = await _dio
          .put(_queryBuilder(url, query),
              data: formData != null
                  ? formData
                  : body != null
                      ? json.encode(body)
                      : null,
              options: Options(
                headers: _headerBuilder(headers),
              ))
          .timeout(_httpTimeout, onTimeout: () {
        throw NetworkException();
      });
      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  // private methods
  Map<String, dynamic> _headerBuilder(Map<String, dynamic>? headers) {
    if (headers == null) {
      headers = {};
    }

    headers[HttpHeaders.acceptHeader] = 'application/json';
    if (headers[HttpHeaders.contentTypeHeader] == null) {
      headers[HttpHeaders.contentTypeHeader] = 'application/json';
    }

    if (headers != null && headers.isNotEmpty) {
      headers.forEach((key, value) {
        headers?[key] = value;
      });
    }

    return headers;
  }

  String _queryBuilder(String? path, Map<String, dynamic>? query) {
    final buffer = StringBuffer();
    buffer.write(Env().apiBaseUrl! + path.toString());

    if (query != null) {
      if (query.isNotEmpty) {
        buffer.write('?');
      }
      query.forEach((key, value) {
        buffer.write('$key=$value&');
      });
    }
    if (Env().isInDebugMode) {}
    return buffer.toString();
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  dynamic _returnResponse(Response response) {
    var data = response;
    final responseJson = data;
    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      if (Env().isInDebugMode) {
        print('Api response success with $responseJson');
      }

      return responseJson;
    } else {
      handleError(response);
    }
  }

  Future<dynamic> handleError(dynamic error) async {
    if (error is DioError) {
      var response = error.response;
      if (Env().isInDebugMode) {
        print('Api response failed with $response');
      }

      var message = '';
      try {
        message = response!.data['message'];
      } catch (e) {
        message = '';
      }

      if (message.isNotEmpty) {
        if (message.toUpperCase() == 'INVALID CREDENTIALS' ||
            message.toUpperCase() == 'MISSING AUTHENTICATION' ||
            message.toUpperCase() == 'FORBIDDEN') {
          if (Env().isInDebugMode) {
            print('Force Logout...');
          }

          throw InvalidCredentialException(
              "Sesi telah habis, harap login kembali");
        }
      } else if (response!.data.runtimeType == String) {
        message = removeAllHtmlTags(response.data);
        if (message.contains('502')) {
          // Bad Gateway
          message = '502 Bad Gateway';
        }
      }

      switch (response!.statusCode) {
        case 400:
          throw BadRequestException(
              message.isNotEmpty ? message : "Bad request");
        case 401:
          throw InvalidCredentialException(
              message.isNotEmpty ? message : "Invalid credential");
        case 403:
          throw UnauthorisedException(
              message.isNotEmpty ? message : "Invalid token");
        case 404:
          throw NotFoundException(message.isNotEmpty ? message : "Not found");
        case 422:
          throw UnauthorisedException(
              message.isNotEmpty ? message : "Invalid credentials");

        default:
          throw FetchDataException(
              message.isNotEmpty ? message : "Unknown Error");
      }
    }
  }
}
