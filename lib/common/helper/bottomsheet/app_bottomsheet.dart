import 'package:flutter/material.dart';

class AppBottomsheet {
  static Future<T?> display<T>(BuildContext context, Widget child) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => child,
    );
  }
}
