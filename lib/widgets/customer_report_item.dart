import 'package:digimobile/models/constant.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerReportItem extends StatelessWidget {
  final String name;
  final int count;
  final double tax;
  final double total;
  final regex = Constant().regex;

  CustomerReportItem({
    @required this.name,
    @required this.count,
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
                value.toString().replaceAll(regex, ''),
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              softWrap: true,
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(
              height: 4,
            ),
            _valueWithTitle(context,
                AppLocalizations.of(context).doucment_number, count.toDouble()),
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
