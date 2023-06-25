import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class DataProvider extends ChangeNotifier {
  bool _signedUp = false;
  bool _signedIn = false;
  late dynamic _user_data;
  late dynamic _friends;

  get user_data => _user_data;
  get signedUp => _signedUp;
  get signedIn => _signedIn;
  get friends => _friends;

  final String? urlPrefix = dotenv.env['BACKEND_URL'];

  Future<String> signup(data) async {
    final url = Uri.parse('$urlPrefix/signup');

    Response res = await post(url, body: data);
    var decodedRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;

    if (decodedRes['success'] == true) {
      _user_data = decodedRes['data'];
      _friends = decodedRes['data']['frndData'];
      _signedUp = true;
    } else {
      _user_data = decodedRes;
      _signedUp = false;
    }

    notifyListeners();

    return decodedRes['msg'];
  }

  Future<String> signin(data) async {
    print('signin data $data');
    final url = Uri.parse('$urlPrefix/signin');
    var json_data = json.encode(data);
    Response res = await post(url, body: data);
    var decodedRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    if (decodedRes['success'] == true) {
      _user_data = decodedRes['data'];
      _friends = decodedRes['data']['frndData'];
      _signedIn = true;
    } else {
      _user_data = decodedRes;
      _signedIn = false;
    }
    notifyListeners();
    return decodedRes['msg'];
  }

  Future<void> log(data) async {
    final url = Uri.parse('$urlPrefix/log');
    var json_data = jsonEncode(data);
    Response res = await post(url, body: data);
    var decodedRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    _friends = decodedRes['data']['Item']['frndData'];

    notifyListeners();
  }

  Future<void> addFriend(data) async {
    final url = Uri.parse('$urlPrefix/add-friend');

    Response res = await post(url, body: data);
    var decodedRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;

    _friends['fPhNo'].add(data['fPhNo']);
    _friends['fName'].add(data['fName']);
    _friends['fRollNo'].add(data['fRollNo']);

    notifyListeners();
  }

  Future<void> editFriend(data) async {
    final url = Uri.parse('$urlPrefix/edit-friend');

    Response res = await post(url, body: data);

    var decodedRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;

    notifyListeners();
  }

  logout() {
    _user_data = null;
    _friends = null;
    _signedIn = false;
    _signedUp = false;
    notifyListeners();
  }
}
