import 'package:flutter/material.dart';
import 'package:phantom_controller/application/helpers/colors.dart';
import 'package:phantom_controller/application/helpers/utils.dart';
import 'package:phantom_controller/entities/ventilation_mode.dart';

class ControllerStatus extends StatelessWidget {
  const ControllerStatus({
    Key? key,
    required this.refreshingData,
    required this.ventilationMode,
    required this.sendingCommand,
    required this.co2,
    required this.temperature,
    required this.relativeHumidity,
    required this.pressure,
    required this.lux,
  }) : super(key: key);

  final bool refreshingData;
  final VentilationMode? ventilationMode;
  final bool sendingCommand;
  final int? co2;
  final double? temperature;
  final double? relativeHumidity;
  final double? pressure;
  final int? lux;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 260,
        child: Stack(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: refreshingData
                ? [
                    const Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 3, color: Colors.white)))
                  ]
                : [],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              alignment: Alignment.center,
              child: Icon(ventilationModeIconsMap[ventilationMode],
                  size: 180, color: Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: sendingCommand
                ? [
                    const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.wifi_rounded))
                  ]
                : [],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: getLabeledStatusIndicator(
                          "CO\u2082", co2?.toDouble(), "PPM",
                          stripDecimals: true,
                          rangeIndicatorColor: getCO2IndicatorColor(co2)),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getLabeledStatusIndicator(
                            "TEMPERATURE", temperature, "O",
                            rangeIndicatorColor:
                                getTemperatureIndicatorColor(temperature))),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: getLabeledStatusIndicator(
                            "HUMIDITY", relativeHumidity, "%",
                            rangeIndicatorColor:
                                getHumidityIndicatorColor(relativeHumidity)))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: getLabeledStatusIndicator(
                          "PRESSURE", pressure?.toDouble(), "MBAR",
                          stripDecimals: true),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: getLabeledStatusIndicator(
                          "LIGHT", lux?.toDouble(), "LUX",
                          stripDecimals: true),
                    )
                  ],
                ),
              ],
            ),
          )
        ]));
  }
}
