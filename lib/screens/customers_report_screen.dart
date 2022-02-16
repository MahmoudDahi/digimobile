import 'package:digimobile/widgets/customer_report_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/constant.dart';
import '../models/reports.dart';
import '../widgets/range_date.dart';

class CustomersReportScreen extends StatefulWidget {
  static const routeName = '/cutomers-report';

  @override
  State<CustomersReportScreen> createState() => _CustomersReportScreenState();
}

class _CustomersReportScreenState extends State<CustomersReportScreen> {
  bool _isloading = false;
  final RegExp regex = Constant().regex;
  List<ReportItem> custReport;

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
      list = await Reports().getCustomerReport(start, end, doucmentId);
      setState(() {
        custReport = list;
      });
    } catch (error) {
      print(error);
    } finally {
      list = null;
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).customers_report),
      ),
      body: Column(
        children: [
          RangeDate(_confirmRange, _isloading),
          SizedBox(
            height: 10,
          ),
          if (custReport != null && custReport.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(left: 16,right: 16,bottom: 16),
                itemBuilder: (context, index) => CustomerReportItem(
                  name: custReport[index].name,
                  count: custReport[index].doucmentNo,
                  tax: custReport[index].taxSum,
                  total: custReport[index].totalAmount,
                ),
                itemCount: custReport.length,
              ),
            ),
          if (custReport != null && custReport.isEmpty)
            Container(
              width: 400,
              height: 500,
              child: Image.asset(
                'assets/images/no_data_found.png',
                fit: BoxFit.contain,
              ),
            ),
         
        ],
      ),
    );
  }
}
