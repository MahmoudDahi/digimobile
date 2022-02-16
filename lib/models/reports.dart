import 'dart:convert';
import 'dart:io';

import 'package:digimobile/models/constant.dart';
import 'package:digimobile/providers/user.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ReportItem {
  final int id;
  final String name;
  final int doucmentNo;
  final double taxSum;
  final double totalAmount;

  ReportItem.fromJsonCustomer(Map<String, dynamic> json)
      : id = json['VendorID'],
        name = json['VendorName'],
        doucmentNo = json['DocCount'],
        taxSum = json['TaxSum'],
        totalAmount = json['TotalAmount'];

  ReportItem.fromJsonDoucment(Map<String, dynamic> json)
      : id = json['ProcessStatusID'],
        name = json['ProcessStatusTitle'],
        doucmentNo = json['DocCount'],
        taxSum = json['TaxTotals'],
        totalAmount = json['TotalAmount'];

  ReportItem.fromJsonMOF(Map<String, dynamic> json)
      : id = json[''],
        name = json['MOFRejectStatus'],
        doucmentNo = json['DocCount'],
        taxSum = json[''],
        totalAmount = json[''];
}

class Reports {
  final _api = '${Constant().api2}/Reports';
  final dateFormat = 'MM/dd/yyyy';

  String convertDate(DateTime dateTime) {
    return DateFormat(dateFormat).format(dateTime);
  }

  Future<List<ReportItem>> getCustomerReport(
      DateTime startDate, DateTime endDate, int doucmentId) async {
    final url = Uri.parse(
        '$_api/GetVendorTotals?DocumentTypeID=$doucmentId&StartRange=${convertDate(startDate)}&EndRange=${convertDate(endDate)}');
    var token = await User().getToken();
    List<ReportItem> loadingItem = [];
    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $token'});
      final fetchData = json.decode(response.body) as List<dynamic>;
      print(fetchData);
      fetchData.forEach((json) {
        loadingItem.add(ReportItem.fromJsonCustomer(json));
      });
      return loadingItem;
    } on SocketException catch (_) {
      throw '1';
    } catch (error) {
      throw error;
    } finally {
      token = null;
      loadingItem = null;
    }
  }

  Future<List<ReportItem>> getDocumentCount(
      DateTime startDate, DateTime endDate, int doucmentId) async {
    final url = Uri.parse(
        '${Constant().api2}/Reports/GetDocumentsCount?DocumentTypeID=$doucmentId&StartRange=${convertDate(startDate)}&EndRange=${convertDate(endDate)}');

    var token = await User().getToken();
    List<ReportItem> loadingItem = [];
    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $token'});
      final fetchData = json.decode(response.body) as List<dynamic>;
      fetchData.forEach((json) {
        loadingItem.add(ReportItem.fromJsonDoucment(json));
      });
      return loadingItem;
    }on SocketException catch (_) {
      throw '1';
    }  catch (error) {
      throw error;
    } finally {
      token = null;
      loadingItem = null;
    }
  }

  Future<List<ReportItem>> getDocumentValues(
      DateTime startDate, DateTime endDate, int doucmentId, int entity) async {
    final url = Uri.parse(
        '${Constant().api2}/Reports/GetDocumentsTotals?DocumentTypeID=$doucmentId&StartRange=${convertDate(startDate)}&EndRange=${convertDate(endDate)}&EntityID=$entity');

    var token = await User().getToken();
    List<ReportItem> loadingItem = [];
    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $token'});
      final fetchData = json.decode(response.body) as List<dynamic>;
      fetchData.forEach((json) {
        loadingItem.add(ReportItem.fromJsonDoucment(json));
      });
      return loadingItem;
    } on SocketException catch (_) {
      throw '1';
    } catch (error) {
      throw error;
    } finally {
      token = null;
      loadingItem = null;
    }
  }

  Future<List<ReportItem>> getMOFRejected(
      DateTime startDate, DateTime endDate, int entity) async {
    final url = Uri.parse(
        '${Constant().api2}/Reports/GetRejectReason?StartRange=${convertDate(startDate)}&EndRange=${convertDate(endDate)}&EntityID=$entity');

    var token = await User().getToken();
    List<ReportItem> loadingItem = [];
    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $token'});
      final fetchData = json.decode(response.body) as List<dynamic>;

      fetchData.forEach((json) {
        loadingItem.add(ReportItem.fromJsonMOF(json));
      });
      return loadingItem;
    }on SocketException catch (_) {
      throw '1';
    }  catch (error) {
      throw error;
    } finally {
      token = null;
      loadingItem = null;
    }
  }
}
