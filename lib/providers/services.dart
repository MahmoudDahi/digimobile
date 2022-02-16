
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;

import '../models/constant.dart';
import 'package:digimobile/providers/user.dart';

class Service {
  final String name;
  final int id;

  Service.fromJson(Map<String, dynamic> json)
      : id = json['ItemSerial'],
        name = json['ItemName'];
}

class Services with ChangeNotifier{
  List<Service> _servicesList = [];

  
  List<Service> get services => _servicesList != null ? [..._servicesList] : [];


  Future<void> fetchAndSetServicesList() async {
    if (_servicesList != null && _servicesList.isNotEmpty) return;
    _servicesList = [];
    final url = Uri.parse('${Constant().api2}/Config/GetItemsActiveList');
    String token = await User().getToken();
    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $token'});
      final fetchData = json.decode(response.body) as List<dynamic>;
      fetchData.forEach(
        (json) => _servicesList.add(
          Service.fromJson(json),
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