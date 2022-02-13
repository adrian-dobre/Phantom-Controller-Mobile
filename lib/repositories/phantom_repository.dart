import 'dart:convert';

import 'package:phantom_controller/entities/fan_speed.dart';
import 'package:phantom_controller/entities/humidity.dart';
import 'package:phantom_controller/entities/phantom_stats.dart';
import 'package:phantom_controller/entities/ventilation_mode.dart';

import 'base/base_repository.dart';

class PhantomRepository extends BaseRepository {
  PhantomRepository({required String address, required String accessKey})
      : super(address: address, accessKey: accessKey);

  Future<dynamic> changeVentilationMode(VentilationMode mode) {
    var url = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        pathSegments: [uri.path, 'phantom-controller', 'ventilation', 'mode']);

    return put(url, body: {"mode": mode.index + 1});
  }

  Future<dynamic> changeFanSpeed(FanSpeed fanSpeed) {
    var url = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        pathSegments: [
          uri.path,
          'phantom-controller',
          'ventilation',
          'fan-speed'
        ]);

    return put(url, body: {"fanSpeed": fanSpeed.index + 1});
  }

  Future<dynamic> changeHumidityLevel(Humidity humidity) {
    var url = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        pathSegments: [
          uri.path,
          'phantom-controller',
          'ventilation',
          'humidity-level'
        ]);

    return put(url, body: {"humidityLevel": humidity.index + 1});
  }

  Future<dynamic> filterReset() {
    var url = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        pathSegments: [
          uri.path,
          'phantom-controller',
          'ventilation',
          'filter-reset'
        ]);

    return post(url);
  }

  Future<PhantomStats> getStats() {
    var url = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        pathSegments: [uri.path, 'phantom-controller', 'stats']);

    return get(url).then((value) =>
        PhantomStats.fromJson(json.decode(String.fromCharCodes(value.data))));
  }
}
