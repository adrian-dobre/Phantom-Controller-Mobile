import 'package:flutter/material.dart';

class RemoteButton extends TextButton {
  RemoteButton(
      {Key? key,
      required void Function()? onPressed,
      void Function()? onLongPress,
      void Function(bool)? onHover,
      void Function(bool)? onFocusChange,
      ButtonStyle? style,
      FocusNode? focusNode,
      bool autofocus = false,
      Clip clipBehavior = Clip.none,
      required Widget child,
      bool active = false})
      : super(
            key: key,
            onPressed: onPressed,
            onLongPress: onLongPress,
            onHover: onHover,
            onFocusChange: onFocusChange,
            style: style ??
                ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.only(top: 5)),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      active ? Colors.white : const Color(0xFF434657)),
                ),
            focusNode: focusNode,
            autofocus: autofocus,
            child: child);
}
