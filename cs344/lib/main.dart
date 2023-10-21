import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cs344/screens/callData.dart';
import 'package:cs344/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  //========================================================
  WidgetsFlutterBinding.ensureInitialized();
  //========================================================
  
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'note_channel_group',
            importance: NotificationImportance.Max,
            channelKey: 'note_channel',
            channelName: 'note notifications',
            channelDescription: 'Notification channel for notes',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white),
            
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'note_channel_group',
            channelGroupName: 'note group')
      ],
      debug: true);

  //========================================================

  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "flutter_background example app",
    notificationText:
        "Background notification for keeping the example app running in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(
        name: 'background_icon',
        defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );

  //========================================================

  bool success =
      await FlutterBackground.initialize(androidConfig: androidConfig);
  
  //========================================================
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('AUTHTOKEN');
  print(token);
  if (token != null) {
    runApp(MyAppNoLoggin());
  } else {
    runApp(MyAppLogin());
  }
}

class MyAppLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RepApp',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF1F628e),
        fontFamily: 'Helvetica',
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.white),
          headline2: TextStyle(fontSize: 25.0, color: Colors.white),
          bodyText1: TextStyle(fontSize: 15.0, color: Colors.white),
          bodyText2: TextStyle(fontSize: 18.0,color: Colors.white),
        ),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF2b4257)),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class MyAppNoLoggin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RepApp',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF1F628e),
        accentColor: Color(0xFF2b4257),
        fontFamily: 'Helvetica',
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.white),
          headline2: TextStyle(fontSize: 25.0, color: Colors.white),
          bodyText1: TextStyle(fontSize: 15.0, color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: CallData(),
    );
  }
}
