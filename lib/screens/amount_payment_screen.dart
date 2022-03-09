import 'package:digimobile/screens/waiting_screen.dart';
import 'package:digimobile/widgets/digi_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AmountPaymentScreen extends StatefulWidget {
  static const routeName = '/amount-payment-screen';
  const AmountPaymentScreen({Key key}) : super(key: key);

  @override
  State<AmountPaymentScreen> createState() => _AmountPaymentScreenState();
}

class _AmountPaymentScreenState extends State<AmountPaymentScreen> {
  final _amountController = TextEditingController();
  final double balance = 10000;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern('en');
    final lang = AppLocalizations.of(context);
    final route = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(route),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<User>(context, listen: false).displayName,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Provider.of<User>(context, listen: false).companyName,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${lang.balance} :',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            numberFormat.format(balance),
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  label: Text(lang.enter_amount),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText:
                      _amountController.text.isEmpty || amountBelowBalance()
                          ? null
                          : lang.error_balance,
                ),
                onChanged: (_) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              DigiButton(
                onPressed: amountBelowBalance()
                    ? () {
                        Navigator.of(context)
                            .pushNamed(WaitingScreen.routeName);
                      }
                    : null,
                child: Text(lang.next),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool amountBelowBalance() =>
      _amountController.text.isNotEmpty &&
      double.tryParse(_amountController.text) <= balance;
}
