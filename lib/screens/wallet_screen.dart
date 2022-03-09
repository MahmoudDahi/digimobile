import 'package:digimobile/widgets/main_card_account.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WalletScreen extends StatelessWidget {
  static const routeName = '/wallet-screen';
  const WalletScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.wallet),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MainCardAccount(),
        ],
      ),
    );
  }
}
