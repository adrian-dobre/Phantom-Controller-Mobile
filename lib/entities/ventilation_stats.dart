class VentilationStats {
  int mode;
  int fanSpeed;
  int humidityLevel;

  VentilationStats(
      {required this.mode,
      required this.fanSpeed,
      required this.humidityLevel});

  factory VentilationStats.fromJson(Map<String, dynamic> json) {
    return VentilationStats(
        mode: json['mode'],
        fanSpeed: json['fanSpeed'],
        humidityLevel: json['humidityLevel']);
  }
}
