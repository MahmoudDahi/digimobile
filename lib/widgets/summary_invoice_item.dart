import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../providers/summary.dart';

class SummaryInvoiceItem extends StatelessWidget {
  final String title;
  final List<SummaryItem> summaryItem;
  final widthScreen;
  final numberFormat = NumberFormat.decimalPattern('en_us');

  SummaryInvoiceItem(this.title, this.summaryItem, this.widthScreen);

  DataRow _totalRow(BuildContext context) {
    double total = 0;
    summaryItem.forEach((element) {
      total += element.totalAmount;
    });
    return DataRow(
      cells: [
        DataCell(Text(
          AppLocalizations.of(context).total,
          style: Theme.of(context).textTheme.headline3,
        )),
        DataCell(Container()),
        DataCell(
          Container(
            width: (widthScreen / 10) * 2.5,
            alignment: AlignmentDirectional.centerStart,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                numberFormat.format(total),
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  DataRow _rowDataItem(
      BuildContext context, String statusTitle, double tax, double amount) {
    return DataRow(
      cells: [
        DataCell(
          Container(
            alignment: AlignmentDirectional.centerStart,
            width: (widthScreen / 10) * 3.5,
            child: Text(statusTitle,
                softWrap: true,
                maxLines: 3,
                style: Theme.of(context).textTheme.headline1,
                overflow: TextOverflow.ellipsis),
          ),
        ),
        DataCell(
          Container(
            alignment: AlignmentDirectional.centerStart,
            width: (widthScreen / 10) * 1.5,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                numberFormat.format(tax),
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: AlignmentDirectional.centerStart,
            width: (widthScreen / 10) * 2.5,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                numberFormat.format(amount),
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> rowsItem = [];
    summaryItem.forEach((item) {
      rowsItem.add(_rowDataItem(
          context, item.statusTitle, item.totalTax, item.totalAmount));
    });
    rowsItem.add(_totalRow(context));
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: Text(title, style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context).from,
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(width: 4),
                Text(
                  DateFormat('dd/MM/yyyy').format(
                    DateTime.now().subtract(
                      Duration(days: 7),
                    ),
                  ),
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context).to,
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(width: 4),
                Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.now()),
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          DataTable(
            dataRowHeight: 80,
            horizontalMargin: 8,
            headingRowHeight: 60,
            columnSpacing: (widthScreen / 10) * 0.2,
            headingRowColor:
                MaterialStateProperty.all(Theme.of(context).hoverColor),
            columns: [
              DataColumn(
                label: Container(
                  width: (widthScreen / 10) * 3.5,
                  child: Text(
                    AppLocalizations.of(context).status,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  width: (widthScreen / 10) * 1.5,
                  child: Text(
                    AppLocalizations.of(context).total_tax,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  width: (widthScreen / 10) * 2.5,
                  child: Text(
                    AppLocalizations.of(context).total_amount,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            rows: rowsItem,
          ),
        ],
      ),
    );
  }
}
