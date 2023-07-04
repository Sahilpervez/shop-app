// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screeens/products_overview_screen.dart';

import '../Model/providers/auth.dart';

enum AuthMode { signUp, login }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const route = "/auth";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthMode _authMode = AuthMode.login;
  final GlobalKey<FormState> _formkey = GlobalKey();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var _isLoading = false;
  Map<String, String> _authDetails = {
    "email": "",
    "password": "",
  };

  @override
  void dispose() {
    // TODO: implement dispose
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void saveData() {
    _authDetails['email'] = emailController.text;
    _authDetails['password'] = passwordController.text;
  }

  void _showErrorDialogue(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("An Error Occured!!"),
            content: Text(message),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        });
  }

  Future<void> _submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authDetails["email"]!, _authDetails["password"]!);
      } else {
        // Sign up user
        await Provider.of<Auth>(context, listen: false)
            .signup(_authDetails['email']!, _authDetails['password']!);
      }
    } on HttpException catch (error) {
      if (kDebugMode) {
        print(error);
      }
      var errorMessage = "Authentication failed";
    } catch (error) {
      var errorMessage = "Couldn't authenticate you, Try again later";
      if (kDebugMode) {
        print("Inside catch block in login_screen $error");
      }
      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "Email address already in use";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "This is not a valid email address";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "Password is too weak";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Could not find a user with this email";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Invalid Password";
      }
      _showErrorDialogue(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            child: Form(
              key: _formkey,
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage("assets/LogoImage.png"),
                        height: 270,
                      ),
                      Text(
                        (_authMode == AuthMode.login)
                            ? "Hello Again!"
                            : "Welcome!",
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      if (_authMode == AuthMode.login)
                        Text(
                          "Welcome Back, you've been missed!",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 20,
                          ),
                        ),
                      if (_authMode == AuthMode.login)
                        Container(
                            height: MediaQuery.of(context).size.height * 0.05),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.symmetric(vertical: 7),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == "" || !value!.contains("@")) {
                              return "Invalid Email!";
                            }
                            return null;
                          },
                          controller: emailController,
                          focusNode: emailFocusNode,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "E-mail",
                            labelStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 18,
                            ),
                          ),
                          cursorColor: Colors.black,
                          style: const TextStyle(fontSize: 19),
                          onTapOutside: (value) {
                            emailFocusNode.unfocus();
                            if (kDebugMode) {
                              print(emailController.text);
                            }
                          },
                          onSaved: (value) {
                            _authDetails['email'] = value!;
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.symmetric(vertical: 7),
                        child: TextFormField(
                          obscureText: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            }
                            return null;
                          },
                          controller: passwordController,
                          focusNode: passwordFocusNode,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Password",
                            labelStyle: TextStyle(
                                color: Colors.grey.shade600, fontSize: 18),
                          ),
                          cursorColor: Colors.black,
                          style: const TextStyle(fontSize: 19),
                          onTapOutside: (value) {
                            passwordFocusNode.unfocus();
                            if (kDebugMode) {
                              print(passwordController.text);
                            }
                          },
                          onSaved: (value) {
                            _authDetails['password'] = value!;
                          },
                          onFieldSubmitted: (value){
                            _authDetails['password'] = value;
                            _submit();
                          },
                        ),
                      ),
                      if (_authMode == AuthMode.signUp)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          margin: const EdgeInsets.symmetric(vertical: 7),
                          child: TextFormField(
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Confirm Password";
                              } else if (value != passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                            controller: confirmPasswordController,
                            focusNode: confirmPasswordFocusNode,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Confirm Password",
                              labelStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 18,
                              ),
                            ),
                            cursorColor: Colors.black,
                            style: const TextStyle(fontSize: 19),
                            onTapOutside: (value) {
                              confirmPasswordFocusNode.unfocus();
                              if (kDebugMode) {
                                print(confirmPasswordController.text);
                              }
                            },
                            onSaved: (value) {
                              // _authDetails['password'] = value!;
                              print("onSaved");
                              // _submit();
                            },
                            onFieldSubmitted: (value){
                              // _submit();
                              print("onFieldSubmitted");
                            },
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 106, 31, 175),
                            // const Color.fromARGB(255, 106, 31, 175),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            _submit();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: (_isLoading)
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 4,
                                      )
                                    : Text(
                                        (_authMode == AuthMode.login)
                                            ? "Login"
                                            : "Sign Up",
                                        style: const TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (_authMode == AuthMode.login)
                                ? "Not a member?\t\t"
                                : "Already have an Account?\t\t",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _switchAuthMode();
                            },
                            child: Text(
                              (_authMode == AuthMode.login)
                                  ? "Register now"
                                  : "Sign In",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
