import 'package:digimobile/providers/user.dart';
import 'package:digimobile/widgets/range_date.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/constant.dart';
import '../models/reports.dart';

class DoucmentsValuesScreen extends StatefulWidget {
  static const routeName = '/doucments-values';
  @override
  _DoucmentsValuesScreenState createState() => _DoucmentsValuesScreenState();
}

class _DoucmentsValuesScreenState extends State<DoucmentsValuesScreen> {
  bool _isloading = false;
  List<ReportItem> doucments;
  final numberFormat = NumberFormat.decimalPattern('en_us');

  String _error;
  double widthScreen;

  void _confirmRange(
    DateTime start,
    DateTime end,
    int doucmentId,
  ) async {
    setState(() {
      _isloading = true;
    });
    List<ReportItem> list;
    try {
      list = await Reports().getDocumentValues(start, end, doucmentId,
          Provider.of<User>(context, listen: false).entityId);
      setState(() {
        _error = null;
        doucments = list;
      });
    } catch (error) {
      if (error.toString() == '1') {
        _error = AppLocalizations.of(context).no_internet_connection;
        return;
      }
      _error = error.toString();
    } finally {
      list = null;
      setState(() {
        _isloading = false;
      });
    }
  }

  DataColumn _columnData(String title) {
    return DataColumn(
      label: Expanded(
        child: Text(
          title,
          softWrap: true,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }

  DataRow _rowData(String title, double tax, double total) {
    return DataRow(cells: [
      DataCell(
        Container(
          width: (widthScreen / 10) * 4,
          child: Text(
            title,
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline2,
          ),
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
              numberFormat.format(total),
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
        ),
      ),
    ]);
  }

  DataRow _rowDataTotal(double total) {
    return DataRow(cells: [
      DataCell(
        Text(
          AppLocalizations.of(context).total,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      DataCell(Container()),
      DataCell(
        Container(
          alignment: AlignmentDirectional.centerStart,
          width: (widthScreen / 10) * 2.5,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              numberFormat.format(total),
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    List<DataRow> rows = [];
    double total = 0;

    if (doucments != null && doucments.isNotEmpty) {
      doucments.forEach((doucment) {
        rows.add(_rowData(
          doucment.name,
          doucment.taxSum,
          doucment.totalAmount,
        ));
        total += doucment.totalAmount;
      });

      rows.add(
        _rowDataTotal(total),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).doucments_values),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) Constant().errorWidget(context, _error),
            RangeDate(_confirmRange, _isloading),
            SizedBox(height: 16),
            if (doucments != null && doucments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DataTable(
                  horizontalMargin: 12,
                  columnSpacing: (widthScreen / 10) * .2,
                  dataRowHeight: 60,
                  headingRowColor:
                      MaterialStateProperty.all(Theme.of(context).hoverColor),
                  columns: [
                    _columnData(AppLocalizations.of(context).status),
                    _columnData(AppLocalizations.of(context).total_tax),
                    _columnData(AppLocalizations.of(context).total_amount),
                  ],
                  rows: rows,
                ),
              ),
            if (doucments != null && doucments.isEmpty)
              Container(
                width: 400,
                height: 500,
                child: Image.asset(
                  'assets/images/no_data_found.png',
                  fit: BoxFit.contain,
                ),
              ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
