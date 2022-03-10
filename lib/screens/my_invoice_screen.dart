import 'package:digimobile/providers/invoice.dart';
import 'package:digimobile/providers/user.dart';
import 'package:digimobile/screens/invoice_details_screen.dart';
import 'package:digimobile/widgets/invoice_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyInvoicesScreen extends StatelessWidget {
  static const routeName = '/my-invoices-screen';
  const MyInvoicesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final entity = Provider.of<User>(context, listen: false).entityId;
    final title = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder(
          future: Provider.of<Invoices>(context).fetchAndSetDate(entity),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            return Consumer<Invoices>(builder: (context, value, _) {
              final list = value.items.reversed.toList();
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemBuilder: (ctx, index) => InkWell(
                  onTap: () => Navigator.of(context).pushNamed(
                    InvoiceDetailsScreen.routeName,
                    arguments: value.items[index].id,
                  ),
                  child: InvoiceItem(
                    name: list[index].customer,
                    dateTime: list[index].date,
                    tax: list[index].tax,
                    total: list[index].total,
                  ),
                ),
                itemCount: value.items.length,
              );
            });
          }),
    );
  }
}
