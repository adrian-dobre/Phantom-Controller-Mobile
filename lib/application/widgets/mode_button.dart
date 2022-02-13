import 'package:flutter/material.dart';
import 'package:phantom_controller/application/widgets/remote_button.dart';

class ModeButton extends SizedBox {
  ModeButton(
      {Key? key,
      required void Function()? onPressed,
      bool active = false,
      required IconData iconData})
      : super(
            key: key,
            child: RemoteButton(
                active: active,
                onPressed: onPressed,
                child: Icon(
                  iconData,
                  size: 60,
                )));
}
