import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phantom_controller/application/helpers/colors.dart';
import 'package:phantom_controller/application/helpers/phantom_icons.dart';
import 'package:phantom_controller/application/helpers/utils.dart';
import 'package:phantom_controller/application/widgets/context_button.dart';
import 'package:phantom_controller/application/widgets/controller_status.dart';
import 'package:phantom_controller/application/widgets/mode_button.dart';
import 'package:phantom_controller/application/widgets/remote_button.dart';
import 'package:phantom_controller/application/widgets/themed_container.dart';
import 'package:phantom_controller/application/widgets/themed_scaffold.dart';
import 'package:phantom_controller/entities/fan_speed.dart';
import 'package:phantom_controller/entities/humidity.dart';
import 'package:phantom_controller/entities/ventilation_mode.dart';
import 'package:phantom_controller/repositories/repos.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'configuration.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  VentilationMode? ventilationMode;
  FanSpeed? fanSpeed;
  Humidity? humidity;
  int? co2;
  double? temperature;
  double? relativeHumidity;
  double? pressure;
  int? lux;
  bool sendingCommand = false;
  bool refreshingData = false;
  Timer? refreshTimer;
  String? controllerAddress;
  String? controllerAccessKey;
  bool preferencesLoaded = false;

  @override
  void dispose() {
    super.dispose();
    cancelRefreshTimerIfNeeded();
    WidgetsBinding.instance!.removeObserver(this);
  }

  void cancelRefreshTimerIfNeeded() {
    if (refreshTimer != null && refreshTimer!.isActive) {
      refreshTimer!.cancel();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        refreshData();
        break;
      default:
        break;
    }
  }

  void refreshData() {
    cancelRefreshTimerIfNeeded();
    getPhantomStats().whenComplete(() {
      refreshTimer = Timer(const Duration(minutes: 1), () {
        refreshData();
      });
    });
  }

  void changeMode(VentilationMode mode) {
    checkConfiguration().then((value) {
      var previousMode = ventilationMode;
      setState(() {
        ventilationMode = mode;
      });
      sendCommand(() => Repos.phantomRepository!.changeVentilationMode(mode))
          .catchError((error) {
        setState(() {
          ventilationMode = previousMode;
        });
      });
    });
  }

  void changeFanSpeed(FanSpeed speed) {
    checkConfiguration().then((value) {
      var previousSpeed = fanSpeed;
      setState(() {
        fanSpeed = speed;
      });
      sendCommand(() => Repos.phantomRepository!.changeFanSpeed(speed))
          .catchError((error) {
        setState(() {
          fanSpeed = previousSpeed;
        });
      });
    });
  }

  void changeHumidityLevel(Humidity level) {
    checkConfiguration().then((value) {
      var previousHumidity = humidity;
      setState(() {
        humidity = level;
      });
      sendCommand(() => Repos.phantomRepository!.changeHumidityLevel(level))
          .catchError((error) {
        setState(() {
          humidity = previousHumidity;
        });
      });
    });
  }

  void resetFilter() {
    checkConfiguration().then(
        (value) => sendCommand(() => Repos.phantomRepository!.filterReset()));
  }

  Future<void> checkConfiguration() {
    if (Repos.phantomRepository == null) {
      navigateToConfiguration(context);
      return Future.error("Invalid configuration");
    }
    return Future.value(null);
  }

  Future<dynamic> sendCommand(Future<dynamic> Function() runCommand) {
    setState(() {
      sendingCommand = true;
    });
    return runCommand().then((value) {}).catchError((error) {
      showError(context, "Error while sending command: ${error.message}");
      throw error;
    }).whenComplete(() {
      setState(() {
        sendingCommand = false;
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    initController();
  }

  void initController() {
    loadPreferences()
        .then((value) => {
              if (controllerAddress == null || controllerAccessKey == null)
                {navigateToConfiguration(context)}
              else
                {Repos.init(controllerAddress!, controllerAccessKey!)}
            })
        .then((value) => refreshData());
  }

  Future<dynamic> getPhantomStats() {
    if (Repos.phantomRepository == null) {
      return Future.value(null);
    }
    setState(() {
      refreshingData = true;
    });
    return Repos.phantomRepository!.getStats().then((value) {
      setState(() {
        fanSpeed = FanSpeed.values[value.ventilation.fanSpeed - 1];
        humidity = Humidity.values[value.ventilation.humidityLevel - 1];
        ventilationMode = VentilationMode.values[value.ventilation.mode - 1];
        co2 = value.climate.co2;
        lux = value.climate.light;
        temperature = value.climate.temperature;
        relativeHumidity = value.climate.humidity;
        pressure = value.climate.pressure;
      });
    }).catchError((error) {
      showError(context, "Error while getting data: ${error.message}");
    }).whenComplete(() {
      setState(() {
        refreshingData = false;
      });
    });
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      controllerAddress = prefs.getString('controllerAddress');
      controllerAccessKey = prefs.getString('controllerAccessKey');
      preferencesLoaded = true;
    });
  }

  void clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('controllerAddress');
    prefs.remove('controllerAccessKey');
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('controllerAddress', controllerAddress!);
    prefs.setString('controllerAccessKey', controllerAccessKey!);
  }

  confirmReset(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget reset = TextButton(
      child: const Text("Reset"),
      onPressed: () {
        clearPreferences();
        cancelRefreshTimerIfNeeded();
        Repos.reset();
        setState(() {
          controllerAddress = null;
          controllerAccessKey = null;
          ventilationMode = null;
          fanSpeed = null;
          humidity = null;
          co2 = null;
          lux = null;
          pressure = null;
          humidity = null;
          temperature = null;
        });
        Navigator.pop(context);
        navigateToConfiguration(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: themeColorGradientEnd,
      title: const Text("Reset Configuration"),
      content: const Text("Are you sure you want to reset the configuration?"),
      actions: [
        cancelButton,
        reset,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
        title: "Phantom Controller",
        drawer: Drawer(
          child: ThemedContainer(
              child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                  height: 110,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: themeColorGradientEnd,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text('Menu',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24))
                        ]),
                  )),
              ListTile(
                title: const Text('Configuration'),
                onTap: () {
                  Navigator.pop(context);
                  navigateToConfiguration(context);
                },
              ),
              ListTile(
                title: const Text('Reset Configuration'),
                onTap: () {
                  Navigator.pop(context);
                  confirmReset(context);
                },
              ),
            ],
          )),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ControllerStatus(
                    refreshingData: refreshingData,
                    ventilationMode: ventilationMode,
                    sendingCommand: sendingCommand,
                    co2: co2,
                    temperature: temperature,
                    relativeHumidity: relativeHumidity,
                    pressure: pressure,
                    lux: lux),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      getContextualControls(),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: getFirstRowControls(),
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: getSecondRowControls(),
                          )),
                    ])),
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

  List<Widget> getFirstRowControls() {
    return [
      ModeButton(
          active: ventilationMode == VentilationMode.auto,
          onPressed: () {
            changeMode(VentilationMode.auto);
          },
          iconData: PhantomIcons.auto),
      ModeButton(
        active: ventilationMode == VentilationMode.manual,
        onPressed: () {
          changeMode(VentilationMode.manual);
        },
        iconData: PhantomIcons.manual,
      ),
      ModeButton(
        active: ventilationMode == VentilationMode.monitor,
        onPressed: () {
          changeMode(VentilationMode.monitor);
        },
        iconData: PhantomIcons.monitor,
      ),
      ModeButton(
        active: ventilationMode == VentilationMode.night,
        onPressed: () {
          changeMode(VentilationMode.night);
        },
        iconData: PhantomIcons.night,
      ),
      SizedBox(
          height: 65,
          child: RemoteButton(
              onPressed: () {
                resetFilter();
              },
              child: const Text("FILTER\nRESET")))
    ];
  }

  List<Widget> getSecondRowControls() {
    return [
      ModeButton(
        active: ventilationMode == VentilationMode.masterSlave,
        onPressed: () {
          changeMode(VentilationMode.masterSlave);
        },
        iconData: PhantomIcons.master_slave,
      ),
      ModeButton(
        active: ventilationMode == VentilationMode.slaveMaster,
        onPressed: () {
          changeMode(VentilationMode.slaveMaster);
        },
        iconData: PhantomIcons.slave_master,
      ),
      ModeButton(
        active: ventilationMode == VentilationMode.insert,
        onPressed: () {
          changeMode(VentilationMode.insert);
        },
        iconData: PhantomIcons.insert,
      ),
      ModeButton(
        active: ventilationMode == VentilationMode.evacuation,
        onPressed: () {
          changeMode(VentilationMode.evacuation);
        },
        iconData: PhantomIcons.evac,
      ),
      ModeButton(
        active: ventilationMode == VentilationMode.temporaryEvacuation,
        onPressed: () {
          changeMode(VentilationMode.temporaryEvacuation);
        },
        iconData: PhantomIcons.temp_evac,
      )
    ];
  }

  void onSaveConfiguration(
      {required String controllerAccessKey,
      required String controllerAddress}) {
    setState(() {
      this.controllerAddress = controllerAddress;
      this.controllerAccessKey = controllerAccessKey;
      savePreferences();
      initController();
    });
  }

  void navigateToConfiguration(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Configuration(
                controllerAddress: controllerAddress,
                controllerAccessKey: controllerAccessKey,
                onSave: onSaveConfiguration)));
  }

  Padding getContextualControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: shouldShowHumidity()
            ? getHumidityControls()
            : shouldShowFan()
                ? getFanControls()
                : getPlaceholderControls(),
      ),
    );
  }

  bool shouldShowFan() {
    return [
      null,
      VentilationMode.manual,
      VentilationMode.masterSlave,
      VentilationMode.slaveMaster,
      VentilationMode.insert,
      VentilationMode.evacuation
    ].contains(ventilationMode);
  }

  bool shouldShowHumidity() {
    return [VentilationMode.auto, VentilationMode.monitor]
        .contains(ventilationMode);
  }

  List<Widget> getPlaceholderControls() {
    return [const SizedBox(height: 70)];
  }

  List<Widget> getFanControls() {
    return [
      ContextButton(
        active: fanSpeed == FanSpeed.low,
        onPressed: () {
          changeFanSpeed(FanSpeed.low);
        },
        child: const Icon(PhantomIcons.fan, size: 24),
      ),
      ContextButton(
        active: fanSpeed == FanSpeed.medium,
        onPressed: () {
          changeFanSpeed(FanSpeed.medium);
        },
        child: const Icon(PhantomIcons.fan, size: 40),
      ),
      ContextButton(
        active: fanSpeed == FanSpeed.high,
        onPressed: () {
          changeFanSpeed(FanSpeed.high);
        },
        child: const Icon(PhantomIcons.fan, size: 60),
      ),
    ];
  }

  List<Widget> getHumidityControls() {
    return [
      ContextButton(
        active: humidity == Humidity.low,
        onPressed: () {
          changeHumidityLevel(Humidity.low);
        },
        child: const Icon(PhantomIcons.humidity, size: 24),
      ),
      ContextButton(
        active: humidity == Humidity.medium,
        onPressed: () {
          changeHumidityLevel(Humidity.medium);
        },
        child: const Icon(PhantomIcons.humidity, size: 40),
      ),
      ContextButton(
        active: humidity == Humidity.high,
        onPressed: () {
          changeHumidityLevel(Humidity.high);
        },
        child: const Icon(PhantomIcons.humidity, size: 60),
      ),
    ];
  }
}
