import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class BaseRepository {
  @protected
  late final Uri uri;
  late final String _accessKey;

  BaseRepository({
    required String address,
    required String accessKey,
  }) {
    uri = Uri.parse(address);
    _accessKey = accessKey;
  }

  @protected
  Future<Response> get(Uri url, {Map<String, String>? headers}) {
    var _headers = headers ??= {};
    _headers['Authorization'] = 'Bearer $_accessKey';
    var dio = Dio(
        BaseOptions(baseUrl: url.toString(), responseType: ResponseType.bytes));
    return dio.get("", options: Options(headers: _headers));
  }

  @protected
  Future<Response> put(Uri url,
      {Map<String, String>? headers, Map<String, dynamic>? body}) {
    var _headers = headers ??= {};
    _headers['Authorization'] = 'Bearer $_accessKey';

    String? encodedBody;
    if (body != null) {
      _headers['Content-Type'] = 'application/json';
      encodedBody = jsonEncode(body);
    }

    var dio = Dio(
        BaseOptions(baseUrl: url.toString(), responseType: ResponseType.bytes));
    return dio.put("", data: encodedBody, options: Options(headers: _headers));
  }

  @protected
  Future<Response> post(Uri url,
      {Map<String, String>? headers, Map<String, dynamic>? body}) {
    var _headers = headers ??= {};
    _headers['Authorization'] = 'Bearer $_accessKey';

    String? encodedBody;
    if (body != null) {
      _headers['Content-Type'] = 'application/json';
      encodedBody = jsonEncode(body);
    }

    var dio = Dio(
        BaseOptions(baseUrl: url.toString(), responseType: ResponseType.bytes));
    return dio.post("", data: encodedBody, options: Options(headers: _headers));
  }
}
