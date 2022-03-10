import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/digi_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivatedTokenScreen extends StatelessWidget {
  static const routeName = '/activated-token';
  const ActivatedTokenScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.settings.name == '/');
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/token_activated.png'),
              Text(
                lang.token_activated,
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
                    Navigator.of(context)
                        .popUntil((route) => route.settings.name == '/');
                  },
                  child: Text(lang.done),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
