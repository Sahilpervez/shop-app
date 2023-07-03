import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Model/http_exceptions.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth{
    return token != null;
  }

  String? get token{
    if(_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return null;
  }

  String? get userId{
    return _userId;
  }

  Future<void> _authenticate (String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAQDuz7Cv6x0kP7mXhez74HtR5o5_Jpihw";
    try{
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );
      final res=json.decode((response.body));
      if(res['error'] != null){
        print(res['error']['message']);
        throw HttpException("${res['error']['message']}");
      }
      _token = res['idToken'];
      _userId = res['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(res['expiresIn']),),);
      notifyListeners();
    }catch(error){
      print("Inside Catch Block $error");
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
