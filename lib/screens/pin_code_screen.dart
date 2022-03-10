import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

import 'complete_payment_screen.dart';
import 'waiting_screen.dart';

class PinCodeScreen extends StatelessWidget {
  static const routeName = '/pin-code';
  const PinCodeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle:
          TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.current_pin),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
           
           
            children: [
              Image.asset(
                'assets/images/pin-code.png',
                width: 350,
                height: 350,
                fit: BoxFit.cover,
              ),
              Container(
                width: 243,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Pinput(
                  onCompleted: (pin) {
                    Navigator.of(context).pushNamed(WaitingScreen.routeName,
                        arguments: CompletePaymentScreen.routeName);
                  },
                  length: 4,
                  separator: Container(
                    height: 64,
                    width: 1,
                    color: Colors.white,
                  ),
                  defaultPinTheme: defaultPinTheme,
                  showCursor: true,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(.2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
