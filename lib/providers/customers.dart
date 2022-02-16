import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/constant.dart';
import 'package:digimobile/providers/user.dart';

class Customer {
  final String name;
  final int id;

  Customer.fromJson(Map<String, dynamic> json)
      : id = json['VendorID'],
        name = json['VendorName'];
}

class Customers with ChangeNotifier {
  List<Customer> _customerList = [];

  List<Customer> get customerList =>
      _customerList != null ? [..._customerList] : [];

  Future<void> fetchAndSetCustomerList() async {
    if (_customerList != null && _customerList.isNotEmpty) return;
    _customerList = [];
    final url = Uri.parse('${Constant().api2}/Config/GetVendorActiveList');
    String token = await User().getToken();
    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $token'});
      final fetchData = json.decode(response.body) as List<dynamic>;
      fetchData.forEach(
        (json) => _customerList.add(
          Customer.fromJson(json),
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    } finally {
      token = null;
    }
  }
}
