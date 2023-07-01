import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAQDuz7Cv6x0kP7mXhez74HtR5o5_Jpihw";
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        "email" : email,
        "password" : password,
        "returnSecureToken" : true,
      }),
    );
  }
}
