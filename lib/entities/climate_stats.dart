class ClimateStats {
  int light;
  double pressure;
  double temperature;
  double humidity;
  int co2;

  ClimateStats(
      {required this.temperature,
      required this.humidity,
      required this.pressure,
      required this.co2,
      required this.light});

  factory ClimateStats.fromJson(Map<String, dynamic> json) {
    return ClimateStats(
        temperature: json['temperature'],
        humidity: json['humidity'],
        pressure: json['pressure'],
        co2: json['co2'],
        light: json['light']);
  }
}
