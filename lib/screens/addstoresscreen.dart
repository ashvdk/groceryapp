import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddStoreScreen extends StatefulWidget {
  final List coordinates;
  final Function jwtOrEmpty;
  const AddStoreScreen({Key key, this.coordinates, this.jwtOrEmpty})
      : super(key: key);

  @override
  _AddStoreScreenState createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  TextEditingController _storenameController;
  TextEditingController _storedescriptionController;
  String _validateStoreName;
  String _validateStoreDescription;
  final storage = new FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _storenameController = TextEditingController();
    _storedescriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Store Details',
              style: TextStyle(fontSize: 25.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: _storenameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Give Your Store Name',
                  errorText: _validateStoreName == "NO_STORE_NAME"
                      ? "Please provide your store name"
                      : null),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: _storedescriptionController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                      'Store description like what are you selling etc..',
                  errorText: _validateStoreDescription == "NO_STORE_DESCRIPTION"
                      ? "Please provide your store description"
                      : null),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    //minimumSize: Size(500, 60),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () async {
                      if (_storenameController.text.isEmpty) {
                        setState(() {
                          _validateStoreName = "NO_STORE_NAME";
                        });
                        return;
                      }

                      if (_storedescriptionController.text.isEmpty) {
                        setState(() {
                          _validateStoreDescription = "NO_STORE_DESCRIPTION";
                        });
                        return;
                      }
                      setState(() {
                        _validateStoreName = "";
                        _validateStoreDescription = "";
                      });
                      String url = "http://192.168.1.6:3000/api/addstore";
                      var jwtToken = await storage.read(key: "jwt");
                      http.Response response = await http.post(url, body: {
                        "storename": _storenameController.text,
                        "description": _storedescriptionController.text,
                        "coordinates": widget.coordinates.join(", "),
                      }, headers: {
                        HttpHeaders.authorizationHeader: jwtToken
                      });
                      if (response.statusCode == 200) {
                        print(jsonDecode(response.body)['payload']);
                        storage.write(key: "store", value: "yes");
                        widget.jwtOrEmpty();
                      }
                    },
                    child: Text('Save your store'),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      //minimumSize: Size(500, 60),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
