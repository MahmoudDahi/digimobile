import 'package:digimobile/providers/customers.dart';
import 'package:digimobile/providers/document.dart';
import 'package:digimobile/providers/services.dart';
import 'package:digimobile/providers/user.dart';
import 'package:digimobile/screens/change_password_screen.dart';
import 'package:digimobile/screens/customers_report_screen.dart';
import 'package:digimobile/screens/document_count_screen.dart';
import 'package:digimobile/screens/documents_values_screen.dart';
import 'package:digimobile/screens/mof_rejected_screen.dart';
import 'package:digimobile/screens/new_document_screen.dart';
import 'package:digimobile/screens/splash_screen.dart';
import 'package:digimobile/screens/summary_invoice_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/app_language.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:digimobile/providers/entity.dart';
import 'package:digimobile/providers/summary.dart';
import 'package:digimobile/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocal();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppLanguage>(
          create: (_) => appLanguage,
        ),
        ChangeNotifierProvider<User>(
          create: (_) => User(),
        ),
        ChangeNotifierProxyProvider<User, Document>(
          create: (ctx) => Document(),
          update: (ctx, user, dataPre) =>
              Document(user.entityId),
        ),
        ChangeNotifierProxyProvider<User, Summary>(
          create: (_) => Summary(),
          update: (ctx, user, summaryPre) => Summary()
            ..update(
              entry: user.entityId,
              invoices: summaryPre.invoices,
              credit: summaryPre.credits,
              debit: summaryPre.debits,
            ),
        ),
        ChangeNotifierProvider<Entity>(
          create: (_) => Entity(),
        ),
        ChangeNotifierProvider<Customers>(
          create: (_) => Customers(),
        ),
         ChangeNotifierProvider<Services>(
          create: (_) => Services(),
        ),
      ],
      child: Consumer<AppLanguage>(
        builder: (ctx, lang, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DigiMobile',
          locale: lang.appLocal,
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''), // English, no country code
            Locale('ar', ''), // Arabic, no country code
          ],
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            textTheme: TextTheme(
              headline6: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey[800]),
              headline1: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            primarySwatch: Colors.deepPurple,
            fontFamily: lang.currentFont,
          ),
          home: Consumer<Entity>(
            builder: (ctx, entity, _) => FutureBuilder(
              future: entity.fetchAndSetData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return SplashScreen();

                return Consumer<User>(
                  builder: (ctx, user, _) {
                    if (user.isAuth) return SummaryInvoiceMainScreen();
                    return FutureBuilder<bool>(
                      future: user.tryAutoLogin(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return SplashScreen();

                        if (entity.items.isNotEmpty) return LoginScreen();
                        return SplashScreen();
                      },
                    );
                  },
                );
              },
            ),
          ),
          routes: {
            ChangePasswordScreen.routeName: (ctx) => ChangePasswordScreen(),
            CustomersReportScreen.routeName: (ctx) => CustomersReportScreen(),
            DoucmentCountScreen.routeName: (ctx) => DoucmentCountScreen(),
            DoucmentsValuesScreen.routeName: (ctx) => DoucmentsValuesScreen(),
            MOFRejectedScreen.routeName: (ctx) => MOFRejectedScreen(),
            NewDoucmentScreen.routeName: (ctx) => NewDoucmentScreen(),
          },
        ),
      ),
    );
  }
}
