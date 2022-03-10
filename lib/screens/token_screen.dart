import 'package:digimobile/widgets/digi_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

import 'activated_token_screen.dart';
import 'waiting_screen.dart';

class TokenScreen extends StatefulWidget {
  static const routeName = '/token-screen';

  const TokenScreen({Key key}) : super(key: key);

  @override
  State<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  final _tokenController = TextEditingController();
  final _pinfocus = FocusNode();
  var _pinCode = '';

  @override
  void dispose() {
    _tokenController.dispose();
    _pinfocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle:
          TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
    );
    final lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.token_activation),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      TextField(
                        controller: _tokenController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          label: Text(lang.token_serial),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_pinfocus),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 24, left: 16, right: 16),
                        child: Text(
                          lang.current_pin,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      Container(
                        width: 243,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Pinput(
                          focusNode: _pinfocus,
                          onCompleted: (pin) {
                            setState(() {
                              _pinCode = pin;
                            });
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 243,
                child: DigiButton(
                  onPressed:
                      _pinCode.isNotEmpty && _tokenController.text.isNotEmpty
                          ? () {
                              Navigator.of(context).pushNamed(
                                  WaitingScreen.routeName,
                                  arguments: ActivatedTokenScreen.routeName);
                            }
                          : null,
                  child: Text(lang.activation),
                ),
              ),
            ],
          )),
    );
  }
}
