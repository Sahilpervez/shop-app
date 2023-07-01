import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  var _authDetails = {
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
    _authDetails['email'] = "${emailController.text}";
    _authDetails['password'] = "${passwordController.text}";
  }

  void _submit() {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.login) {
      // Log user in
    } else {
      // Sign up user
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
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formkey,
              child: ListView(
                children: [
                  Column(
                    children: [
                      const Image(
                        image: AssetImage("assets/LogoImage.png"),
                      ),
                      Text(
                        (_authMode == AuthMode.login)?"Hello Again!" : "Welcome!",
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      if(_authMode == AuthMode.login)
                        Text(
                          "Welcome Back, you've been missed!",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 20,
                          ),
                        ),
                      if(_authMode == AuthMode.login)
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
                            print(emailController.text);
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
                          obscureText:  true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            }
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
                            print(passwordController.text);
                          },
                          onSaved: (value) {
                            _authDetails['password'] = value!;
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
                            obscureText:  true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Confirm Password";
                              }else if(value! != passwordController.text){
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
                            },
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 106, 31, 175),
                            // const Color.fromARGB(255, 106, 31, 175),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: (_isLoading)? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 4,
                                ):Text(
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
                        height: 15,
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
