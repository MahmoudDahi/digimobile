import 'package:digimobile/screens/payment_screen.dart';
import 'package:digimobile/widgets/digi_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompletePaymentScreen extends StatelessWidget {
  static const routeName = '/complete-payment-screen';

  const CompletePaymentScreen({Key key}) : super(key: key);

 
  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil(
            (route) => route.settings.name == PaymentScreen.routeName);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.primary,
          ),
          leading: Container(),
          title: Text(lang.success),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/confirm-payment.png'),
            Text(
              lang.success,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: DigiButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) =>
                      route.settings.name == PaymentScreen.routeName);
                },
                child: Text(lang.done),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
