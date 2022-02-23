import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

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
import 'providers/app_setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:digimobile/providers/entity.dart';
import 'package:digimobile/providers/summary.dart';
import 'package:digimobile/screens/login_screen.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  AppSetting appSetting = AppSetting();
  await appSetting.fetchLocal();
  runApp(MyApp(
    appLanguage: appSetting,
  ));
}

class MyApp extends StatelessWidget {
  final AppSetting appLanguage;

  MyApp({this.appLanguage});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final darkColor = Colors.deepPurple;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppSetting>(
          create: (_) => appLanguage,
        ),
        ChangeNotifierProvider<User>(
          create: (_) => User(),
        ),
        ChangeNotifierProxyProvider<User, Document>(
          create: (ctx) => Document(),
          update: (ctx, user, dataPre) => Document(user.entityId),
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
      child: Consumer<AppSetting>(
        builder: (ctx, sett, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DigiMobile',
          locale: sett.appLocal,
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
          themeMode: sett.themeMode,
          darkTheme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.

            brightness: Brightness.dark,
            

            appBarTheme: AppBarTheme(backgroundColor: darkColor),
            switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.all(darkColor),
              trackColor: MaterialStateProperty.all(darkColor),
            ),
            primaryColor: darkColor,

            drawerTheme: DrawerThemeData(
              backgroundColor: Colors.grey.shade800,
            ),
            floatingActionButtonTheme:
                FloatingActionButtonThemeData(backgroundColor: darkColor),
            cardColor: Colors.grey.shade900,
            hoverColor: Colors.black26,
            textTheme: TextTheme(
              headline6: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white70),
              headline1: TextStyle(
                fontSize: 16,
                color: Colors.white60,
              ),
              headline2: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
              headline3: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            primarySwatch: darkColor,

            fontFamily: sett.currentFont,
          ),
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
            brightness: Brightness.light,
            hoverColor: Colors.grey[200],
            textTheme: TextTheme(
              headline6: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey[800]),
              headline1: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              headline2: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
              headline3: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            primarySwatch: Colors.deepPurple,

            fontFamily: sett.currentFont,
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
