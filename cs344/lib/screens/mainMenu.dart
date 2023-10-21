// import 'package:cs344/screens/timeLine.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(MainMenu());
// }

// class MainMenu extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MainMenuList(),
//     );
//   }
// }

// class MainMenuList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey,
//       appBar: AppBar(
//         title: Text(
//           "Customers"
//         ),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(8),
//         children: [
//           SizedBox(
//             height: 50,
//           ),
//           Container(
//             height: 50,
//             color: Colors.blue,
//             child: Center(
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => TimeLine()));
//                 },
//                 child: Text("Customer A",
//                 style: TextStyle(color: Colors.white),),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 50,
//           ),
//           Container(
//             height: 50,
//             color: Colors.blue,
//             child: Center(
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => TimeLine()));
//                 },
//                 child: Text("Customer B",
//                   style: TextStyle(color: Colors.white),),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 50,
//           ),
//           Container(
//             height: 50,
//             color: Colors.blue,
//             child: Center(
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => TimeLine()));
//                 },
//                 child: Text("Customer C",
//                   style: TextStyle(color: Colors.white),),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }