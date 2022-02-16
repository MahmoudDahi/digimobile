import 'package:digimobile/screens/new_document_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../widgets/summary_invoice_item.dart';
import '../providers/summary.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SummaryInvoiceMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('DigiMobile'),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.add),
            onSelected: (value) {
              Navigator.of(context)
                  .pushNamed(NewDoucmentScreen.routeName, arguments: value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(AppLocalizations.of(context).new_invoice),
                value: {
                  'title': AppLocalizations.of(context).new_invoice,
                  'id': 1,
                },
              ),
              PopupMenuItem(
                child: Text(AppLocalizations.of(context).new_credit),
                value: {
                  'title': AppLocalizations.of(context).new_credit,
                  'id': 2,
                },
              ),
              PopupMenuItem(
                child: Text(AppLocalizations.of(context).new_debit),
                value: {
                  'title': AppLocalizations.of(context).new_debit,
                  'id': 3,
                },
              ),
            ],
          )
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

                    return Consumer<Summary>(builder: (ctx, summary, _) {
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
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
