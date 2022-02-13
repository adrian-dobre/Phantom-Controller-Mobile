import 'package:flutter/material.dart';
import 'package:phantom_controller/application/helpers/phantom_icons.dart';
import 'package:phantom_controller/entities/ventilation_mode.dart';

List<Widget> getLabeledStatusIndicator(String label, double? value, String unit,
    {Color? rangeIndicatorColor, bool stripDecimals = false}) {
  return [
    Row(children: [
      Text(label,
          style: const TextStyle(
              color: Color(0xFF434657),
              fontSize: 10,
              fontWeight: FontWeight.bold)),
    ]),
    Row(children: [
      Row(children: [
        Text(
            (value != null
                    ? stripDecimals
                        ? value.toInt()
                        : value
                    : '-- ')
                .toString(),
            style: const TextStyle(color: Colors.white, fontSize: 18))
      ]),
      simulateScript(unit, 18)
    ]),
    Row(
        children: rangeIndicatorColor != null
            ? [
                Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      width: 50,
                      height: 2,
                      color: rangeIndicatorColor,
                    ))
              ]
            : [])
  ];
}

SizedBox simulateScript(String unit, double fontSize,
    {bool superscript = true}) {
  return SizedBox(
    height: fontSize,
    child: Column(
      mainAxisAlignment:
          superscript ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Text(unit,
            style: TextStyle(color: Colors.white, fontSize: fontSize / 2)),
      ],
    ),
  );
}

final Map<VentilationMode?, IconData> ventilationModeIconsMap = {
  VentilationMode.auto: PhantomIcons.auto,
  VentilationMode.manual: PhantomIcons.manual,
  VentilationMode.monitor: PhantomIcons.monitor,
  VentilationMode.night: PhantomIcons.night,
  VentilationMode.masterSlave: PhantomIcons.master_slave,
  VentilationMode.slaveMaster: PhantomIcons.slave_master,
  VentilationMode.insert: PhantomIcons.insert,
  VentilationMode.evacuation: PhantomIcons.evac,
  VentilationMode.temporaryEvacuation: PhantomIcons.temp_evac,
  null: PhantomIcons.home
};

void showError(BuildContext context, String errorMessage) {
  WidgetsBinding.instance?.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        )));
  });
}
