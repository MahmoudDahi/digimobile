import 'package:flutter/material.dart';

class DigiButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;

  DigiButton({
   @required this.onPressed,
   @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        textStyle: Theme.of(context).textTheme.headline1,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
