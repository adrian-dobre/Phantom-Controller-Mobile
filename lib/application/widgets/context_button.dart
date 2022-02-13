import 'package:flutter/material.dart';
import 'package:phantom_controller/application/widgets/remote_button.dart';

class ContextButton extends SizedBox {
  ContextButton(
      {Key? key,
      required void Function()? onPressed,
      required Widget child,
      bool active = false})
      : super(
            key: key,
            width: 110,
            height: 70,
            child: RemoteButton(
                active: active, onPressed: onPressed, child: child));
}
