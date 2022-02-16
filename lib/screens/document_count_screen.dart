import 'package:digimobile/widgets/range_date.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/constant.dart';
import '../models/reports.dart';

class DoucmentCountScreen extends StatefulWidget {
  static const routeName = '/doucment-count';

  @override
  _DoucmentCountScreenState createState() => _DoucmentCountScreenState();
}

class _DoucmentCountScreenState extends State<DoucmentCountScreen> {
  bool _isloading = false;
  List<ReportItem> doucments;
  String _error;

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
      list = await Reports().getDocumentCount(start, end, doucmentId);
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
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
      ),
    );
  }

  DataRow _rowData(
    String title,
    int count,
  ) {
    return DataRow(cells: [
      DataCell(
        Text(
          title,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.black),
        ),
      ),
      DataCell(
        Text(
          count.toString(),
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(fontWeight: FontWeight.w300),
        ),
      ),
    ]);
  }

  DataRow _rowDataTotal(int total) {
    return DataRow(cells: [
      DataCell(
        Text(
          AppLocalizations.of(context).total,
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      DataCell(
        Text(
          total.toString(),
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> rows = [];
    int total = 0;

    if (doucments != null && doucments.isNotEmpty) {
      doucments.forEach((doucment) {
        rows.add(_rowData(
          doucment.name,
          doucment.doucmentNo,
        ));
        total += doucment.doucmentNo;
      });

      rows.add(
        _rowDataTotal(total),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).doucments_count),
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: DataTable(
                  dataRowHeight: 60,
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  columns: [
                    _columnData(AppLocalizations.of(context).status),
                    _columnData(AppLocalizations.of(context).doucments_count),
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
