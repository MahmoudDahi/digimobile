import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:digimobile/models/exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:digimobile/models/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  String _userName;
  String _companyName;
  int _entityId;
  int _userID;
  String _displayName;
  String _profileImage;

  bool get isAuth => _profileImage != null;

  int get entityId => _entityId;

  String get displayName => _displayName;

  String get companyName => _companyName;

  Uint8List get profileImage => Base64Codec().decode(_profileImage);

  Future<void> loginUser(String username, String password, int entityID,
      [String companyName]) async {
    final url = Uri.parse(
        '${Constant().api2}/Auth/AccountLogin?EntityID=$entityID&UserName=$username&Password=$password');

    try {
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final resposne = await http.post(url, headers: {
        'entity': entityID.toString(),
        HttpHeaders.authorizationHeader: basicAuth,
      });

      print(resposne.statusCode);
      if (resposne.statusCode != 200)
        throw ExceptionError('Username or Password not correct');
      final fetchData = json.decode(resposne.body)['CustomeRespons'];

      int responseId = int.parse(fetchData['Response ID']);
      if (responseId != 1 && responseId != 2)
        throw ExceptionError(fetchData['Response MSG']);
      _saveToken(fetchData['Token']);
      _userName = username;
      _entityId = entityID;
      _companyName = companyName;
      await _fetchAndSetDataUser();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> _fetchAndSetDataUser() async {
    final url = Uri.parse(
        '${Constant().api2}/Accounts/GetProfile?UserName=$_userName&EntityID=$_entityId');
    String Token = await getToken();
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $Token',
        },
      );
      final fetchData = json.decode(response.body) as List<dynamic>;

      _userID = fetchData.first['UserID'];
      _displayName = fetchData.first['DisplayName'];
      _profileImage = fetchData.first['ProfileImage'];
      await _saveUser();
      notifyListeners();
    } catch (error) {
      throw 'Network Error';
    } finally {
      Token = null;
    }
  }

  Future<String> changePassword(
      String currentPassword, String newPassword) async {
    final url = Uri.parse(
        '${Constant().api2}/Password/ChangeMyPassword?UserID=$_userID&Password=$newPassword');
    try {
      await loginUser(_userName, currentPassword, _entityId);
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$_userName:$currentPassword'));
      final resposne = await http.post(url, headers: {
        'entity': _entityId.toString(),
        HttpHeaders.authorizationHeader: basicAuth,
      });
      final fetchDate =
          json.decode(resposne.body)['CustomeRespons'] as Map<String, dynamic>;
      print('data response : $fetchDate');
      int responseId = int.tryParse(fetchDate['Response ID']);
      if (responseId != 1) return fetchDate['Response MSG'];
      return null;
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> _saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'user',
      json.encode(
        {
          'userId': _userID,
          'entityId': _entityId,
          'companyname': _companyName,
          'username': _userName,
          'displayname': _displayName,
          'profileimage': _profileImage,
        },
      ),
    );
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return false;
    final userData = json.decode(prefs.getString('user'));
    _entityId = userData['entityId'];
    _userID = userData['userId'];
    _userName = userData['username'];
    _companyName = userData['companyname'];
    _displayName = userData['displayname'];
    _profileImage = userData['profileimage'];

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _entityId = null;
    _displayName = null;
    _profileImage = null;
    _userID = null;
    _userName = null;
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return null;
    return prefs.getString('token');
  }
}
