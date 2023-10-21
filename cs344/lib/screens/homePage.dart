import 'package:cs344/screens/signIn.dart';
import 'package:cs344/screens/signUp.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext buildcontext) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/scaffold.png"), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/logo.png")),
        ),
                width: 200,
                height: 200),
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                ),
                onPressed: () {
                  Navigator.push(buildcontext,
                      MaterialPageRoute(builder: (buildcontext) => SignIn()));
                },
                child: Text(
                  "Sign In",
                  style: Theme.of(buildcontext).textTheme.bodyText1,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                onPressed: () async {
                  var status = await Permission.phone;
                  if (await status.isDenied) {
                    Permission.storage.request();
                  }

                  Navigator.push(buildcontext,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
                child: Text(
                  "Sign Up",
                  style: Theme.of(buildcontext).textTheme.bodyText1,
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ])
          ],
        ),
      ),
    );
  }
}
