import 'package:digimobile/screens/amount_payment_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentScreen extends StatelessWidget {
  static const routeName = '/payment-screen';

  const PaymentScreen({Key key}) : super(key: key);

  Widget _listPaymentItem(BuildContext context, String title, String imgPath,
      void Function() onpress) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Image.asset(imgPath),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(AmountPaymentScreen.routeName, arguments: title);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.payment)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            _listPaymentItem(context, lang.vat, 'assets/images/vat.png', () {}),
            _listPaymentItem(context, lang.service_tax,
                'assets/images/servic-tax.png', () {}),
            _listPaymentItem(context, lang.withholding_tax,
                'assets/images/withholding.png', () {}),
            _listPaymentItem(
                context, lang.table_tax, 'assets/images/table-tax.png', () {}),
          ],
        ),
      ),
    );
  }
}
