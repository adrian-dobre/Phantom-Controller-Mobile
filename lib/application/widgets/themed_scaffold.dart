import 'package:flutter/material.dart';
import 'package:phantom_controller/application/widgets/themed_container.dart';

class ThemedScaffold extends Scaffold {
  ThemedScaffold(
      {Key? key, required String title, required Widget body, Widget? drawer})
      : super(
            key: key,
            appBar: AppBar(
              title: Text(title),
            ),
            drawer: drawer,
            body: ThemedContainer(child: body));
}
