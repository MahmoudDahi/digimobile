import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvoiceDetailsItem extends StatelessWidget {
  final String name;
  final double price;
  final double tax;
  final double total;
  final numberFormat = NumberFormat.decimalPattern('en_us');

  InvoiceDetailsItem({
    @required this.name,
    @required this.price,
    @required this.tax,
    @required this.total,
  });

  Widget _valueWithTitle(BuildContext context, String title, double value) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 60),
      child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${title} :',
            style: Theme.of(context).textTheme.headline1,
          ),
         
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              numberFormat.format(value),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
         
          children: [
            Text(
              name,
              softWrap: true,
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(height: 4),
            _valueWithTitle(
                context, AppLocalizations.of(context).sales_total, price),
            SizedBox(height: 4),
            _valueWithTitle(
                context, AppLocalizations.of(context).item_tax, tax),
            SizedBox(height: 4),
            _valueWithTitle(context, AppLocalizations.of(context).total, total)
          ],
        ),
      ),
    );
  }
}
