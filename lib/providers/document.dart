import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/constant.dart';
import '../providers/user.dart';

class Document with ChangeNotifier {
  int entityId;
  Document([this.entityId]);

  final _apiConfig = '${Constant().api2}/Config';

  Future<bool> createNewDocument(int customerId, DateTime date, int internalId,
      int documentType, int serviceId, double cost) async {
    try {
      final branchId = await _fetchBranchId();
      final activityCode = await _fetchActivityCode();

      final invoicesInternald = await _newDoucment(
          customerId,
          branchId,
          DateFormat('yyyy-MM-dd hh:mm').format(date),
          activityCode,
          internalId,
          documentType);
      final result = await _newInvoice(invoicesInternald, serviceId, cost);
      return result == 1;
    } catch (error) {
      throw error;
    }
  }

  Future<int> _newInvoice(
    int invoiceInternal,
    int serviceId,
    double cost,
  ) async {
    final url = Uri.parse(
        '${Constant().api2}/Documents/CreateInvoicLineManual?InvoiceInternalID=$invoiceInternal&ItemID=$serviceId&description=&quantity=1&currencySold=1&amountSold=$cost&currencyExchangeRate=1&ItemsDiscount=0&ActionBy=1');

    String token = await User().getToken();
    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $token'});

      return int.tryParse(
          json.decode(response.body)['CustomeRespons']['Response ID']);
    } catch (error) {
      throw error;
    } finally {
      token = null;
    }
  }

  Future<int> _newDoucment(int customerId, int branchId, String date,
      int activityCode, int internalId, int documentType) async {
    final url = Uri.parse(
        '${Constant().api2}/Documents/CreateInvoiceHead?VendorID=$customerId&OwnerID=$branchId&dateTimeIssued=${date}&taxpayerActivityCode=$activityCode&internalID=$internalId&EntityID=$entityId&ActionBy=1&DocumentType=$documentType');

    String token = await User().getToken();
    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $token'});
      final fetchData = json.decode(response.body)['CustomeRespons'];
      return int.tryParse(fetchData['Document DBID']);
    } catch (error) {
      print('new douc');
      throw error;
    } finally {
      token = null;
    }
  }

  Future<int> _fetchBranchId() async {
    final url =
        Uri.parse('$_apiConfig/GetBranchesActiveList?EntityID=$entityId');
    String token = await User().getToken();
    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $token'});
      final fetchData = json.decode(response.body) as List<dynamic>;
      return fetchData.first['BranchID'];
    } catch (error) {
      print('branch error $error');
      throw error;
    } finally {
      token = null;
    }
  }

  Future<int> _fetchActivityCode() async {
    final url =
        Uri.parse('$_apiConfig/ReadStringKey?EntityID=$entityId&ConfigKey=3');
    String token = await User().getToken();
    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $token'});
      final fetchData = json.decode(response.body)['CustomeRespons'];
      return int.tryParse(fetchData['Response MSG']);
    } catch (error) {
      print('activity error $error');
      throw error;
    } finally {
      token = null;
    }
  }
}
