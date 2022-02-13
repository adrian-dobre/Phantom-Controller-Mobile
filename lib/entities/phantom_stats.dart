import 'package:phantom_controller/entities/ventilation_stats.dart';

import 'climate_stats.dart';

class PhantomStats {
  ClimateStats climate;
  VentilationStats ventilation;

  PhantomStats({required this.climate, required this.ventilation});

  factory PhantomStats.fromJson(Map<String, dynamic> json) {
    return PhantomStats(
        climate: ClimateStats.fromJson(json['climate']),
        ventilation: VentilationStats.fromJson(json['ventilation']));
  }
}
