import 'package:flutter/material.dart';
import 'package:flutter_sliding_toast/flutter_sliding_toast.dart';

class CustomAlert {
  Colors color = Colors.green as Colors;

  static void error(
    BuildContext context, {
    Widget? leading,
    required String title,
    String? subtitle,
  }) {
    InteractiveToast.slide(
      toastStyle: ToastStyle(backgroundColor: Colors.red),
      context: context,
      leading: leading,
      title: Text(title),
    );
  }

  static void success(
    BuildContext context, {
    Widget? leading,
    required String title,
    String? subtitle,
  }) {
    InteractiveToast.slide(
      toastStyle: ToastStyle(backgroundColor: Colors.green),
      context: context,
      leading: leading,
      title: Text(title),
    );
  }
}