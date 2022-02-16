import 'package:flutter/material.dart';

class Constant {
  final api2 = 'http://192.168.1.152/taxtechpre/v2/WEB';
  final api1 = 'http://192.168.1.152/taxtechpre/v1/WEB';
  final regex = RegExp(r'([.]*0)(?!.*\d)');

  Widget errorWidget(
    BuildContext context,
    String error,
  ) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).errorColor,
      padding: const EdgeInsets.all(8),
      child: Text(
        error,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
