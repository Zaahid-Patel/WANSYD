import 'package:cs344/screens/signIn.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String username = "";
    String businessName = "";
    String email = "";
    String phoneNumber = "";
    String password = "";
    String checkPassword = "";
    
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
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              width: 20,
            ),
            Text(
              "Register",
              style: Theme.of(context).textTheme.headline1,
            ),
          ]),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            // SizedBox(
            //   width: 10,
            // ),
            SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (inputN){
                  username = inputN;
                },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Username",
                      hintStyle: Theme.of(context).textTheme.bodyText1),
                )),
            // SizedBox(
            //   width: 10,
            // ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            // SizedBox(
            //   width: 10,
            // ),
            SizedBox(
                width: 300,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  onChanged: (inputE){
                  email = inputE;
                },
                  decoration: InputDecoration(
                      hintText: "Email Address",
                      hintStyle: Theme.of(context).textTheme.bodyText1),
                )),
            // SizedBox(
            //   width: 10,
            // ),
          ]),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            // SizedBox(
            //   width: 10,
            // ),
            SizedBox(
                width: 300,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  onChanged: (inputPN) {
                  phoneNumber = inputPN;
                },
                  decoration: InputDecoration(
                      hintText: "Phone number",
                      hintStyle: Theme.of(context).textTheme.bodyText1),
                )),
            // SizedBox(
            //   width: 10,
            // ),
          ]),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            // SizedBox(
            //   width: 10,
            // ),
            SizedBox(
                width: 300,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  onChanged: (inputBN) {
                  businessName = inputBN;
                },
                  decoration: InputDecoration(
                      hintText: "Company Name",
                      hintStyle: Theme.of(context).textTheme.bodyText1),
                )),
            // SizedBox(
            //   width: 10,
            // ),
          ]),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            // SizedBox(
            //   width: 10,
            // ),
            SizedBox(
                width: 300,
                child: TextField(
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  onChanged: (inputP) {
                  password = inputP;
                },
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: Theme.of(context).textTheme.bodyText1),
                )),
            // SizedBox(
            //   width: 10,
            // ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            // SizedBox(
            //   width: 10,
            // ),
            SizedBox(
                width: 300,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  onChanged: (inputP) {
                  checkPassword = inputP;
                },
                  decoration: InputDecoration(
                      hintText: "Retype Password",
                      hintStyle: Theme.of(context).textTheme.bodyText1),
                )),
            // SizedBox(
            //   width: 10,
            // ),
          ]),
          
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
              onPressed: () async {
                OverlayLoadingProgress.start(context);
                if(password == checkPassword){
                final res = await http.post(Uri.parse('http://berdichevsky.nn.r.appspot.com/server/register/rep/'),
                  headers: <String, String>{
                    "method": "POST",
                    'Content-Type':'application/json; charset=UTF-8'
                  },
                  body: jsonEncode(<String,String>{
                    "username":username,
                    "password":password,
                    "business_name":businessName,
                    "rep_email":email,
                    "rep_phone_number":phoneNumber}),
                );

                print(res);
                OverlayLoadingProgress.stop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignIn())
                );
                }else{
                  OverlayLoadingProgress.stop(context);
                  return showDialog<void>(
                    context: context, 
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: const Text("Error"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: const <Widget>[
                              Text("The passwords entered do not match"),
                              Text("Please retype passwords and try again")
                            ]
                            )
                        ),
                        actions: <Widget>[
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                          }, 
                          child: const Text('Approve'))
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
      ),
    ));
  }
}
