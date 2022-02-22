import 'package:digimobile/main.dart';
import 'package:digimobile/screens/customers_report_screen.dart';
import 'package:digimobile/screens/new_document_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../widgets/summary_invoice_item.dart';
import '../providers/summary.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SummaryInvoiceMainScreen extends StatefulWidget {
  @override
  State<SummaryInvoiceMainScreen> createState() =>
      _SummaryInvoiceMainScreenState();
}

class _SummaryInvoiceMainScreenState extends State<SummaryInvoiceMainScreen> {
  void initState() {
    super.initState();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Navigator.pushNamed(
          context,
          CustomersReportScreen.routeName,
        );
      }
    });

    FirebaseMessaging.instance
        .getToken()
        .then((value) => print('token : $value'));

    FirebaseMessaging.onMessage
        .listen((RemoteMessage message) => _showNotification(message));

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.pushNamed(
        context,
        CustomersReportScreen.routeName,
      );
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (_) {
      Navigator.pushNamed(
        context,
        CustomersReportScreen.routeName,
      );
    });

    final notification = message.notification;

    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            fullScreenIntent: true,
            color: Colors.deepPurple,
            playSound: true,
            icon: '@drawable/digi_notifi',
          ),
        ),
        payload: message.data['code'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final popup = PopupMenuButton(
      icon: Icon(Icons.add),
      onSelected: (value) {
        Navigator.of(context)
            .pushNamed(NewDoucmentScreen.routeName, arguments: value);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text(
            AppLocalizations.of(context).new_invoice,
            style: Theme.of(context).textTheme.headline2,
          ),
          value: {
            'title': AppLocalizations.of(context).new_invoice,
            'id': 1,
          },
        ),
        PopupMenuItem(
          child: Text(
            AppLocalizations.of(context).new_credit,
            style: Theme.of(context).textTheme.headline2,
          ),
          value: {
            'title': AppLocalizations.of(context).new_credit,
            'id': 2,
          },
        ),
        PopupMenuItem(
          child: Text(
            AppLocalizations.of(context).new_debit,
            style: Theme.of(context).textTheme.headline2,
          ),
          value: {
            'title': AppLocalizations.of(context).new_debit,
            'id': 3,
          },
        ),
      ],
    );
    final mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
       
        onPressed: () {},
        child: popup,
      ),
      appBar: AppBar(
        title: Text('DigiMobile'),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          popup,
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<Summary>(context, listen: false).fetchDataAndSet(true),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: MemoryImage(
                            Provider.of<User>(context, listen: false)
                                .profileImage),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Provider.of<User>(context, listen: false).companyName,
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(fontSize: 14),
                        ),
                        Text(
                          Provider.of<User>(context, listen: false).displayName,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              FutureBuilder(
                future: Provider.of<Summary>(context, listen: false)
                    .fetchDataAndSet(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  return Consumer<Summary>(
                    builder: (ctx, summary, _) {
                      {
                        if (snapshot.error != null && summary.invoices == null)
                          return Container(
                            height: 600,
                            child: Image.asset(
                              'assets/images/no_network_connection.png',
                              fit: BoxFit.cover,
                            ),
                          );
                        if (summary.invoices.isEmpty)
                          return Container(
                            height: 600,
                            child: Image.asset(
                              'assets/images/no_data_found.png',
                              fit: BoxFit.contain,
                            ),
                          );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, left: 16, right: 16),
                              child: SummaryInvoiceItem(
                                AppLocalizations.of(context).submitted_invoice,
                                summary.invoices,
                                mediaWidth,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: SummaryInvoiceItem(
                                AppLocalizations.of(context).submitted_credit,
                                summary.credits,
                                mediaWidth,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16, left: 16, right: 16),
                              child: SummaryInvoiceItem(
                                AppLocalizations.of(context).submitted_debit,
                                summary.debits,
                                mediaWidth,
                              ),
                            )
                          ],
                        );
                      }
                    },
                  );
                },
              ),
              SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
