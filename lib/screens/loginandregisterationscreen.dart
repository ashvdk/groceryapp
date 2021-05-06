import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginandRegisterationScreen extends StatefulWidget {
  final Function jwtOrEmpty;
  const LoginandRegisterationScreen({Key key, this.jwtOrEmpty})
      : super(key: key);

  @override
  _LoginandRegisterationScreenState createState() =>
      _LoginandRegisterationScreenState();
}

class _LoginandRegisterationScreenState
    extends State<LoginandRegisterationScreen> {
  final storage = new FlutterSecureStorage();
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  bool passwordShoworHide = true;
  String _validateUsername;
  String _validatePassword;
  bool showLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            Text(
              'Login or Registration',
              style: TextStyle(fontSize: 30.0),
            ),
            SizedBox(
              height: 50.0,
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                errorText: _validateUsername == "NO_USERNAME"
                    ? "Please enter your username"
                    : _validateUsername == "USERNAME_SHORT"
                        ? "Username should more the 5 letters"
                        : null,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: _passwordController,
              obscureText: passwordShoworHide,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      passwordShoworHide = !passwordShoworHide;
                    });
                  },
                  icon: passwordShoworHide
                      ? Icon(CupertinoIcons.eye_slash)
                      : Icon(CupertinoIcons.eye),
                ),
                errorText: _validatePassword == "NO_PASSWORD"
                    ? "Please enter your password"
                    : _validatePassword == "PASSWORD_SHORT"
                        ? "Password should more the 5 letters"
                        : _validatePassword == "PASSWORD_WRONG"
                            ? "Password is incorret"
                            : null,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () async {
                if (_usernameController.text.isEmpty) {
                  setState(() {
                    _validateUsername = "NO_USERNAME";
                  });
                  return;
                } else {
                  if (_usernameController.text.length < 5) {
                    setState(() {
                      _validateUsername = "USERNAME_SHORT";
                    });
                    return;
                  } else {
                    setState(() {
                      _validateUsername = "USERNAME_OK";
                    });
                  }
                }
                if (_passwordController.text.isEmpty) {
                  setState(() {
                    _validatePassword = "NO_PASSWORD";
                  });
                  return;
                } else {
                  if (_passwordController.text.length < 5) {
                    setState(() {
                      _validatePassword = "PASSWORD_SHORT";
                    });
                    return;
                  } else {
                    setState(() {
                      _validatePassword = "PASSWORD_OK";
                    });
                  }
                }
                setState(() {
                  showLoading = true;
                });
                String url = "http://192.168.1.6:3000/api/signup";
                http.Response response = await http.post(url, body: {
                  "username": _usernameController.text,
                  "password": _passwordController.text
                });
                if (response.statusCode == 200) {
                  var jwt = jsonDecode(response.body)['token'];
                  storage.write(key: "jwt", value: jwt);
                  widget.jwtOrEmpty();
                  setState(() {
                    showLoading = false;
                  });
                } else {
                  setState(() {
                    _validatePassword = "PASSWORD_WRONG";
                    showLoading = false;
                  });
                }
              },
              child: showLoading
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : Text('Login or Registeration'),
              style: TextButton.styleFrom(
                primary: Colors.white,
                minimumSize: Size(500, 60),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                backgroundColor: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
