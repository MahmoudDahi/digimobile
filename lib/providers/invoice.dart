import 'dart:convert';

import 'package:digimobile/providers/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/constant.dart';

class Invoice {
  final int id;
  final DateTime date;
  final String customer;
  final double tax;
  final double total;

  Invoice.fromJson(Map<String, dynamic> json)
      : id = json['DocumentID'],
        customer = json['VendorName'],
        date = DateTime.tryParse(json['dateTimeIssued']),
        tax = json['taxTotals'],
        total = json['totalAmount'];
}

class InvoiceDetails {
  final String name;
  final double tax;
  final double price;
  final double total;

  InvoiceDetails.fromJson(Map<String, dynamic> json)
      : price = json['salesTotal'],
        name = json['ItemName'],
        tax = json['ItemTaxTotal'],
        total = json['total'];
}

class Invoices with ChangeNotifier {
  final api = '${Constant().api2}/Documents';
  List<Invoice> _items = [];

  List<Invoice> get items => [..._items];

  Future<void> fetchAndSetDate(int entity) async {
    if (_items.isNotEmpty) return;
    final url = Uri.parse('$api/GetInvoiceListLastWeek?EntityID=$entity');
    var token = await User().getToken();
    try {
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
      });
      final fetchData = json.decode(response.body) as List<dynamic>;
      fetchData.forEach((json) {
        _items.add(Invoice.fromJson(json));
      });
      
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<List<InvoiceDetails>> fetchInvoiceDetails(int id) async {
    final url = Uri.parse('$api/SingleDocDetailsView?DocumentID=$id');
    var token = await User().getToken();
    List<InvoiceDetails> list = [];
    try {
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
      });
      final fetchData = json.decode(response.body) as List<dynamic>;
      fetchData.forEach((json) {
        list.add(InvoiceDetails.fromJson(json));
      });
      return list;
    } catch (error) {
      throw error;
    }
  }
}
