import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:digimobile/models/constant.dart';

class EntityItem {
  final int id;
  final String title;

  EntityItem.fromJson(Map<String, dynamic> json)
      : id = json['EntityId'],
        title = json['EntityTitle'];
}

class Entity with ChangeNotifier {
  List<EntityItem> _item = [];

  List<EntityItem> get items => [..._item];

  Future<void> fetchAndSetData() async {
    if (_item.isNotEmpty) return;
    String _error;

    final url = Uri.parse('${Constant().api1}/Accounts/GetEntitiesList');
    try {
      final response = await http.post(
        url,
      );
      final fetchData = json.decode(response.body) as List<dynamic>;
      fetchData.forEach((json) {
        _item.add(EntityItem.fromJson(json));
      });
    } catch (error) {
      print('entity erorr $error');
      _error = error;
    }
    await Future.delayed(Duration(seconds: 5));
    if (_error != null) throw _error;
    notifyListeners();
  }
}
