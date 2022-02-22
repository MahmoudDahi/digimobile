import 'package:digimobile/providers/app_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../widgets/input_login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppSetting>(
      builder:(ctx,sett,_)=> AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: sett.isDark?Colors.grey.shade800:Colors.white,
          statusBarBrightness:sett.isDark?Brightness.light: Brightness.dark,
          statusBarIconBrightness:sett.isDark?Brightness.light: Brightness.dark,
        ),
        child: SafeArea(
          child: Scaffold(
           
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/digi.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        AppLocalizations.of(context).welcome_login,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        AppLocalizations.of(context).login_title,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      InputLogin(),
                      SizedBox(
                        height: 32,
                      ),
                      Text(
                        'Powered By DigiFin',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
