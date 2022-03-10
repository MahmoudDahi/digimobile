import 'package:digimobile/providers/invoice.dart';
import 'package:digimobile/widgets/invoice_details_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  static const routeName = '/invoice-details';
  const InvoiceDetailsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    final id = ModalRoute.of(context).settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.invoice_details),
      ),
      body: FutureBuilder<List<InvoiceDetails>>(
        future: Provider.of<Invoices>(context, listen: false)
            .fetchInvoiceDetails(id),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snap.data != null && snap.data.isNotEmpty) {
            final list = snap.data;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) => InvoiceDetailsItem(
                name: list[index].name,
                price: list[index].price,
                tax: list[index].tax,
                total: list[index].total,
              ),
            );
          } else {
            return Center(
              child: Image.asset(
                'assets/images/no_data_found.png',
                fit: BoxFit.cover,
              ),
            );
          }
        },
      ),
    );
  }
}
