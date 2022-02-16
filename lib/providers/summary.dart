import 'dart:convert';

import 'package:digimobile/models/constant.dart';
import 'package:digimobile/providers/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SummaryItem {
  final String statusTitle;
  final double totalTax;
  final double totalAmount;

  SummaryItem.fromJson(Map<String, dynamic> json)
      : totalTax = json['TaxTotals'],
        statusTitle = json['ProcessStatusTitle'],
        totalAmount = json['TotalAmount'];
}

class Summary with ChangeNotifier {
  int _entityId;

  void update(
      {int entry,
      List<SummaryItem> invoices,
      List<SummaryItem> credit,
      List<SummaryItem> debit}) {
    _entityId = entry;
    _invoice = invoices;
    _credit = credit;
    _debit = debit;
  }

  List<SummaryItem> _invoice ;
  List<SummaryItem> _credit;
  List<SummaryItem> _debit ;

  List<SummaryItem> get invoices => _invoice == null ? null : [..._invoice];
  List<SummaryItem> get credits => _credit == null ? null : [..._credit];
  List<SummaryItem> get debits => _debit == null ? null : [..._debit];

  Future<void> fetchDataAndSet([bool refresh = false]) async {
    if (!refresh && _invoice != null && _invoice.isNotEmpty) return;

    print('not return');
    try {
      _invoice = await fetchSubmitted(
          1,
          DateFormat('MM/dd/yyyy')
              .format(DateTime.now().subtract(Duration(days: 7))),
          DateFormat('MM/dd/yyyy').format(DateTime.now()));
      _credit = await fetchSubmitted(
          2,
          DateFormat('MM/dd/yyyy')
              .format(DateTime.now().subtract(Duration(days: 7))),
          DateFormat('MM/dd/yyyy').format(DateTime.now()));
      _debit = await fetchSubmitted(
          3,
          DateFormat('MM/dd/yyyy')
              .format(DateTime.now().subtract(Duration(days: 7))),
          DateFormat('MM/dd/yyyy').format(DateTime.now()));

      // _invoice = await fetchSubmitted(1, '1/31/2022', '2/7/2022');
      // _credit = await fetchSubmitted(2, '1/31/2022', '2/7/2022');
      // _debit = await fetchSubmitted(3, '1/31/2022', '2/7/2022');
      notifyListeners();
    } catch (error) {
      _invoice = null;
      _credit = null;
      _debit = null;
      print(error);
      throw error;
    }
  }

  Future<List<SummaryItem>> fetchSubmitted(
      int documentId, String startDate, String endDate) async {
    final url = Uri.parse(
        '${Constant().api2}/Reports/GetDocumentsTotals?DocumentTypeID=$documentId&StartRange=$startDate&EndRange=$endDate&EntityID=$_entityId');
    String token = await User().getToken();
    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      final fetchData = json.decode(response.body) as List<dynamic>;

      List<SummaryItem> newSummary = [];
      fetchData.forEach((element) {
        newSummary.add(SummaryItem.fromJson(element));
      });
      return newSummary;
    } catch (error) {
      throw error;
    } finally {
      token = null;
    }
  }
}
