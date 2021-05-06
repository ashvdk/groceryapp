import 'package:flutter/material.dart';
import 'package:groceries_pick_up_app/screens/loginandregisterationscreen.dart';
import 'package:groceries_pick_up_app/screens/showstoresscreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        //home: LoginandRegisterationScreen(),
        home: SplashSreen());
  }
}

class SplashSreen extends StatefulWidget {
  const SplashSreen({Key key}) : super(key: key);

  @override
  _SplashSreenState createState() => _SplashSreenState();
}

class _SplashSreenState extends State<SplashSreen> {
  bool isLoggedIn = false;
  bool storeCreated = false;
  void jwtOrEmpty() async {
    var jwtToken = await storage.read(key: "jwt");
    var store = await storage.read(key: "store");
    if (jwtToken == null) {
      setState(() {
        isLoggedIn = false;
      });
      return;
    }
    var jwt = jwtToken.split(".");
    if (jwt.length != 3) {
      setState(() {
        isLoggedIn = false;
      });
      return;
    }
    if (store == "yes") {
      setState(() {
        storeCreated = true;
      });
    }
    setState(() {
      isLoggedIn = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jwtOrEmpty();
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? storeCreated
            ? Text('Store has been created')
            : ShowStores(
                jwtOrEmpty: jwtOrEmpty,
              )
        : LoginandRegisterationScreen(jwtOrEmpty: jwtOrEmpty);
  }
}
