import 'package:digimobile/providers/user.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/constant.dart';
import '../models/reports.dart';
import '../widgets/range_date.dart';

class MOFRejectedScreen extends StatefulWidget {
  static const routeName = '/mof-rejected';

  @override
  _MOFRejectedScreenState createState() => _MOFRejectedScreenState();
}

class _MOFRejectedScreenState extends State<MOFRejectedScreen> {
  bool _isloading = false;
  List<ReportItem> doucments;
  String _error;

  void _confirmRange(DateTime start, DateTime end, [int doucment]) async {
    setState(() {
      _isloading = true;
    });
    List<ReportItem> list;
    try {
      list = await Reports().getMOFRejected(
          start, end, Provider.of<User>(context, listen: false).entityId);
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
    String reason,
    int count,
  ) {
    return DataRow(cells: [
      DataCell(
        Text(
          reason,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).mof_rejected),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) Constant().errorWidget(context, _error),
            RangeDate(_confirmRange, _isloading, false),
            SizedBox(height: 16),
            if (doucments != null && doucments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: DataTable(
                  dataRowHeight: 60,
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  columns: [
                    _columnData(AppLocalizations.of(context).reject_reason),
                    _columnData(AppLocalizations.of(context).doucments_count),
                  ],
                  rows: doucments
                      .map((e) => _rowData(e.name, e.doucmentNo))
                      .toList(),
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
