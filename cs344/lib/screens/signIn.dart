import 'package:flutter/material.dart';
import 'package:cs344/screens/callData.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cs344/main.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String username = "";
    String password = "";
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/scaffold.png"), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                    width: 300,
                    child: TextField(
                      onChanged: (inputU) {
                        username = inputU;
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Username",
                          hintStyle: Theme.of(context).textTheme.bodyText1),
                    )),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                    width: 300,
                    child: TextField(
                      obscureText: true,
                      onChanged: (inputP) {
                        password = inputP;
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: Theme.of(context).textTheme.bodyText1),
                    )),
              ]),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                  onPressed: () async {
                    OverlayLoadingProgress.start(context);
                    final response = await http.post(
                        Uri.parse(
                            'http://berdichevsky.nn.r.appspot.com/server/login/rep/'),
                        headers: <String, String>{
                          "method": "POST",
                          'Content-Type': 'application/json; charset=UTF-8'
                        },
                        body: jsonEncode(<String, String>{
                          "username": username,
                          "password": password,
                        }));
                    print(response.statusCode);
                    if (response.statusCode == 200) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(
                          "AUTHTOKEN", jsonDecode(response.body)["token"]);

                      var status = await Permission.phone;
                      if (await status.isDenied) {
                        Permission.phone.request();
                      }

                      OverlayLoadingProgress.stop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (buildcontext) => CallData()));
                    } else {
                      OverlayLoadingProgress.stop(context);
                      return showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: SingleChildScrollView(
                                  child: ListBody(children: const <Widget>[
                                Text("Incorrect login details"),
                                Text(
                                    "Please enter login details again and try again")
                              ])),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Ok'))
                              ],
                            );
                          });
                    }
                  },
                  child: Text(
                    "Submit",
                    style: Theme.of(context).textTheme.bodyText1,
                  ))
            ],
          )),
    );
  }
}




