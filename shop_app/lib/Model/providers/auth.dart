import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Model/http_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAQDuz7Cv6x0kP7mXhez74HtR5o5_Jpihw";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );
      final res = json.decode((response.body));
      if (res['error'] != null) {
        if (kDebugMode) {
          print(res['error']['message']);
        }
        throw HttpException("${res['error']['message']}");
      }
      _token = res['idToken'];
      _userId = res['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(res['expiresIn']),
        ),
      );
      autoLogout();

      final pref = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token' : _token,
          'userId' : userId,
          'expiryDate' : _expiryDate?.toIso8601String(),
        }
      );
      print(userData);
      final result = await pref.setString('userData', userData);
      print(result);
      print("userData added to local storage");

      notifyListeners();
      
    } catch (error) {
      if (kDebugMode) {
        print("Inside Catch Block $error");
      }
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> autoLogin()async {
    final prefs = await SharedPreferences.getInstance() ;
    if(! prefs.containsKey('userData')){
      print("no UserData found");
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String , dynamic>;
    
    print(extractedUserData);

    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);


    if(expiryDate.isBefore(DateTime.now())){
      print("Token expired");
      return false;
    }

    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if(_authTimer != null)
    {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final pref = await SharedPreferences.getInstance();
    final data = json.decode(pref.getString('userData')!) as Map<String,dynamic> ;
    if (kDebugMode) {
      print(data);
    }
    final result = await pref.clear();
    print(result);
    notifyListeners();
  }

  void autoLogout(){
    if(_authTimer !=null){
      _authTimer!.cancel();
    }
    if (kDebugMode) {
      print("Auth Timer set");
    }
    
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
