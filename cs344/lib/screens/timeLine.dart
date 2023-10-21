import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';
import 'package:http/http.dart' as http;
import 'callData.dart';

Map<String, dynamic> allCallData = {};

class TimeLine extends StatefulWidget {
  TimeLine({key, required this.allCalls});
  Map<String, dynamic> allCalls;

  @override
  State<TimeLine> createState() {
    allCallData = allCalls;
    return _TimeLineState();
  }
}

List<Card> allCallDataCards = [];

class _TimeLineState extends State<TimeLine> {

 Future<bool> _onWillPop() async {
    Navigator.push(context,
                          MaterialPageRoute(builder: (buildcontext) => CallData()));
    return true;
  }

  @override
  void initState() {
    List<Card> callDataCards = [];
    int cardId = 0;
    int cardIndex = 0;
    String cardPos = "";
    allCallData.forEach((key, value) {
      cardPos = key;
      List<Widget> call_key_value_pairs = [];
      Map<String, dynamic> callData = value;
      callData.forEach((key, value) {
        if (key == 'id') cardId = value;
        if (key == 'dateTime')
          call_key_value_pairs.add(Padding(
              padding: EdgeInsets.all(5), child: Text("Call Date: ${value}")));
        if (key == 'call_length')
          call_key_value_pairs.add(Padding(
              padding: EdgeInsets.all(5),
              child: Text("The call lasted: ${value} minutes")));
        if (key == 'note')
          call_key_value_pairs.add(Padding(
              padding: EdgeInsets.all(5),
              child: Text("Note about call: ${value}")));
      });
      print("index is  ${cardIndex}");
      callDataCards.add(Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.blueGrey,
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(20),
            child:Container(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: call_key_value_pairs +
                    [
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: Colors.lightBlue),
                        onPressed: () async {
                          print(cardIndex);
                          setState(() {
                            print("State set");
                            allCallDataCards = [];
                            callDataCards.removeAt(cardIndex - 1);
                            allCallData.remove(cardPos);
                            refreshCards(allCallData);
                          });
                          final prefs = await SharedPreferences.getInstance();
                          String? token = prefs.getString('AUTHTOKEN');
                          final response = await http.put(
                              Uri.parse(
                                  'http://berdichevsky.nn.r.appspot.com/server/delete/entry/'),
                              headers: <String, String>{
                                "method": "PUT",
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                'Authorization': 'Token ${token}',
                              },
                              body: jsonEncode(<String, int>{
                                'id': cardId,
                              }));

                        },
                        child: Icon(Icons.delete),
                      )
                    ]),
          ))));
      cardIndex++;
    });

    setState(() {
      allCallDataCards = [];
      allCallDataCards.addAll(callDataCards);
    });
  }

  void refreshCards(Map<String, dynamic> changedCallData){
    List<Card> callDataCards = [];
    int cardId = 0;
    int cardIndex = 0;
    String cardPos = "";
    changedCallData.forEach((key, value) {
      cardPos = key;
      List<Widget> call_key_value_pairs = [];
      Map<String, dynamic> callData = value;
      callData.forEach((key, value) {
        if (key == 'id') cardId = value;
        if (key == 'dateTime')
          call_key_value_pairs.add(Padding(
              padding: EdgeInsets.all(5), child: Text("Call Date: ${value}")));
        if (key == 'call_length')
          call_key_value_pairs.add(Padding(
              padding: EdgeInsets.all(5),
              child: Text("The call lasted: ${value} minutes")));
        if (key == 'note')
          call_key_value_pairs.add(Padding(
              padding: EdgeInsets.all(5),
              child: Text("Note about call: ${value}")));
      });
      print("index is  ${cardIndex}");
      callDataCards.add(Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.blueGrey,
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(20),
            child:Container(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: call_key_value_pairs +
                    [
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: Colors.lightBlue),
                        onPressed: () async {
                          print(cardIndex);
                          setState(() {
                            print("State set");
                            allCallDataCards = [];
                            callDataCards.removeAt(cardIndex - 1);
                            allCallData.remove(cardPos);
                            refreshCards(changedCallData);
                          });
                          final prefs = await SharedPreferences.getInstance();
                          String? token = prefs.getString('AUTHTOKEN');
                          final response = await http.put(
                              Uri.parse(
                                  'http://berdichevsky.nn.r.appspot.com/server/delete/entry/'),
                              headers: <String, String>{
                                "method": "PUT",
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                'Authorization': 'Token ${token}',
                              },
                              body: jsonEncode(<String, int>{
                                'id': cardId,
                              }));

                        },
                        child: Icon(Icons.delete),
                      )
                    ]),
          ))));
      cardIndex++;
    });

    setState(() {
      allCallDataCards = [];
      allCallDataCards.addAll(callDataCards);
    });
  }

  @override
  Widget build(BuildContext context) {

    if (allCallDataCards.isEmpty) {
      return new WillPopScope(
        onWillPop: _onWillPop,
        child:Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Call History"),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (buildcontext) => CallData()));
    
                    },
                    icon: Icon(Icons.home)),
               
              ],
            ),
          body:Container(
          padding: const EdgeInsets.all(20),
          child: Text("No call history"))));
    } else {
      return new WillPopScope(
        onWillPop: _onWillPop,
        child:Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Call History"),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (buildcontext) => CallData()));
    
                    },
                    icon: Icon(Icons.home)),
               
              ],
            ),
          body:Container(
          padding: const EdgeInsets.all(20),
          child: Timeline.tileBuilder(
            theme: TimelineTheme.of(context).copyWith(
              nodePosition: 0,
            ),
            builder: TimelineTileBuilder.fromStyle(
              itemCount: allCallDataCards.length,
              contentsAlign: ContentsAlign.basic,
              contentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: allCallDataCards[index],
              ),
            ),
          ))));
    }
  }
}
