import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvoiceItem extends StatelessWidget {
  final String name;
  final DateTime dateTime;
  final double tax;
  final double total;
  final numberFormat = NumberFormat.decimalPattern('en_us');

  InvoiceItem({
    @required this.name,
    @required this.dateTime,
    @required this.tax,
    @required this.total,
  });

  Widget _valueWithTitle(BuildContext context, String title, double value) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 60),
      child: Row(
        children: [
          Text(
            '${title} :',
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                numberFormat.format(value),
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline2,
              ),
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
            Text(DateFormat.yMMMd().format(dateTime),style: Theme.of(context).textTheme.headline1,),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _valueWithTitle(
                      context, AppLocalizations.of(context).total_tax, tax),
                ),
                Flexible(
                  child: _valueWithTitle(context,
                      AppLocalizations.of(context).total_amount, total),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
