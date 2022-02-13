import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phantom_controller/application/pages/main.dart';

import 'application/helpers/colors.dart';

void main() {
  Paint.enableDithering = true;
  runApp(const PhantomController());
}

class PhantomController extends StatelessWidget {
  const PhantomController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData.dark();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Phantom Controller',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(primary: Colors.blue),
        appBarTheme: AppBarTheme.of(context)
            .copyWith(color: themeColorGradientEnd, elevation: 0),
        scaffoldBackgroundColor: themeColorGradientStart,
        canvasColor: themeColorGradientStart,
      ),
      home: const MainPage(),
    );
  }
}
