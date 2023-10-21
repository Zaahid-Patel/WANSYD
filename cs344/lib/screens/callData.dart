import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:call_log/call_log.dart';
import 'package:cs344/screens/homePage.dart';
import 'package:cs344/screens/timeLine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/ui/with_foreground_task.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:phone_state/phone_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:overlay_loading_progress/overlay_loading_progress.dart';

class CallData extends StatefulWidget {
  @override
  State<CallData> createState() => _CallDataState();
}

List<Card> cards = [];

Map<String, dynamic> uneditedCallData = {};

List<CallEntry> offlineCallData = [];

class CallEntry {
  final String phoneNumber;
  final String customerName;
  final String callLength;
  final String callNote;
  final String callDateTime;

  const CallEntry(
      {required this.phoneNumber,
      required this.customerName,
      required this.callLength,
      required this.callNote,
      required this.callDateTime});
}

class _CallDataState extends State<CallData> {
  bool Show = false;

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Customers"),
              actions: [

                IconButton(
                    onPressed: () async {
                      OverlayLoadingProgress.start(context);
                      await refreshCallData();
                      OverlayLoadingProgress.stop(context);
                    },
                    icon: Icon(Icons.refresh)),
                IconButton(
                    onPressed: () async {
                      OverlayLoadingProgress.start(context);
                      final prefs = await SharedPreferences.getInstance();
                      prefs.remove('AUTHTOKEN');
                      AwesomeNotifications().cancelAll();
                      AwesomeNotifications().dispose;
                      OverlayLoadingProgress.stop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    icon: Icon(Icons.logout))
              ],
            ),
            body: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: cards)))));
  }

  @override
  void initState() {
    super.initState();
    refreshCallData();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    try {
      AwesomeNotifications().actionStream.listen((event) async {
        print(event);
        if (event.buttonKeyPressed == "DONT_SAVE_KEY") {
          await AwesomeNotifications()
              .dismissNotificationsByChannelKey('note_channel');
        }
        if (event.buttonKeyPressed == "NOTE_BUTTON_KEY") {
          await AwesomeNotifications()
              .dismissNotificationsByChannelKey('note_channel');
          final prefs = await SharedPreferences.getInstance();
          String? startTime = event.payload?.values.first;
          Iterable<CallLogEntry> callDataList = await CallLog.query(
            dateFrom: int.parse(startTime ?? ""),
          );
          CallLogEntry callData = callDataList.last;
          String? token = prefs.getString('AUTHTOKEN');
          try {
            final response = await http.post(
              Uri.parse(
                  'http://berdichevsky.nn.r.appspot.com/server/create/call/data/'),
              headers: <String, String>{
                "method": 'POST',
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Token ${token}'
              },
              body: jsonEncode(<String, String?>{
                'customer_phone_number': callData.number,
                'customer_name': callData.name,
                'call_length': callData.duration.toString(),
                'call_date_time': event.actionDate,
                'note': event.buttonKeyInput
              }),
            );
          } catch (e) {
            offlineCallData.add(CallEntry(
                callLength: callData.duration.toString(),
                customerName: callData.name ?? "",
                callNote: event.buttonKeyInput,
                callDateTime: event.actionDate ?? "",
                phoneNumber: callData.number ?? ""));
          }
        }
        print("Refreshing");
        refreshCallData();
        print("Refresh complete");
      });
    } catch (e) {
      print("Stream already begun");
      print("Refreshing");
      refreshCallData();
      print("Refresh complete");
    }

    final isolate = FlutterIsolate.spawn(callDataCollector, '');
  }

  Future<void> refreshCallData() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('AUTHTOKEN');

    if (offlineCallData.isNotEmpty) {
      for (CallEntry entry in offlineCallData) {
        final response = await http.post(
          Uri.parse(
              'http://berdichevsky.nn.r.appspot.com/server/create/call/data/'),
          headers: <String, String>{
            "method": 'POST',
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ${token}'
          },
          body: jsonEncode(<String, String?>{
            'customer_phone_number': entry.phoneNumber,
            'customer_name': entry.customerName,
            'call_length': entry.callLength,
            'call_date_time': entry.callDateTime,
            'note': entry.callNote
          }),
        );
        offlineCallData.remove(entry);
      }
    }

    try {
      final response = await http.get(
        Uri.parse('http://berdichevsky.nn.r.appspot.com/server/get/call/data/'),
        headers: <String, String>{
          "method": "GET",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${token}',
        },
      );
      print(response.statusCode);
      String busName = "";

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body)['data'];
        print(jsonDecode(response.body)['data']);
        uneditedCallData = data;
        cards = [];

        data.forEach((key, value) {
          int i = 0;
          Map<String, dynamic> customerData = new Map();
          customerData = value['customer_info'];
          List<Widget> key_value_pairs = [];

          customerData.forEach((key, value) {
            print("--> ${key} : ${value}");
            if(value == null)value = "Enter business name here";
            if (i > 0)
              key_value_pairs.add(Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(i!=3)Container(
                        alignment: Alignment.centerLeft,
                        height: 20,
                        // decoration: BoxDecoration(border: Border.all()),
                        child: Text(
                          "${value}",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ]),
              ));
            i++;
          });

          int cardId = 0;
          Map<String, dynamic> allCalls = value['customer_call_data'];
          List<Card> callDataCards = [];

          Card card = Card(
              child: Stack(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.blueGrey,
                  elevation: 10,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      width: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          key_value_pairs[0],
                          key_value_pairs[1],
                          key_value_pairs[2],
                        ],
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
 
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lightBlue),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TimeLine(allCalls: allCalls)));
                          },
                          child: Text(
                            "Call Data",
                            style: Theme.of(context).textTheme.bodyText1,
                          )),
                    ]),
                  ])),
            ],
          ));

          setState(() {
            cards.add(card);
          });
        });
      }
    } catch (e) {}
  }
}

void callDataCollector(String args) async {
  int startTime = 0;
  PhoneState.phoneStateStream.listen((event) async {
    if (event == PhoneStateStatus.CALL_STARTED) {
      startTime =
          DateTime.now().subtract(Duration(seconds: 5)).millisecondsSinceEpoch;
    }
    if (event == PhoneStateStatus.CALL_ENDED) {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'note_channel',
              title: 'Add note to call',
              category: NotificationCategory.Service,
              notificationLayout: NotificationLayout.BigText,
              locked: true,
              // fullScreenIntent: true,
              autoDismissible: true,
              payload: {'startTime': startTime.toString()}),
          actionButtons: [
            NotificationActionButton(
                buttonType: ActionButtonType.InputField,
                enabled: true,
                label: "Make Note",
                key: "NOTE_BUTTON_KEY",
                autoDismissible: true,
                showInCompactView: false),
            NotificationActionButton(
                buttonType: ActionButtonType.KeepOnTop,
                enabled: true,
                label: "Dont Save",
                key: "DONT_SAVE_KEY",
                autoDismissible: true,
                showInCompactView: false)
          ]);
    }
  });
}
