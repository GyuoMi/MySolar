// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../API\'s/LoadSheddingAPI.dart';
// import '../../API\'s/loadsheddingFunctions.dart';
// class LoadShedding extends StatefulWidget {
//   const LoadShedding({super.key});
//
//   @override
//   State<LoadShedding> createState() => _LoadSheddingState();
// }
//
// class _LoadSheddingState extends State<LoadShedding> {
//   String jsonData = '';
//   Map<String, dynamic>? data;
//   List<dynamic> days = [];
//   impLoadshedding service = impLoadshedding();
//   int loadsheddingstatus= 1000;
//   LoadSheddingService service1 = LoadSheddingService();
//   Future<int> fetchLoadSheddingStatus() async {
//     // Fetch the load shedding status using your API service
//     // Replace 'loadSheddingService' with your actual instance of the LoadSheddingService class
//
//     return service1.getStatus();
//   }
//
//   Future<void> getLoadshedding() async {
//     final loadshedding =
//     await fetchLoadSheddingStatus(); // Get the weather info
//
//     // When you have the weatherInfo, update the URL and trigger a UI update
//     setState(() {
//       loadsheddingstatus = loadshedding - 1;
//     });
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     //searchAreasByText("fourways ");
//     service.fetchData();
//    service.getLoadshedding();
//    getLoadshedding();
//
//   }
//
//
//
// @override
// Widget build(BuildContext context) {
//   //final double screenWidth = MediaQuery.of(context).size.width;
//   //final double screenHeight = MediaQuery.of(context).size.height;
//   //final double marginValue = screenWidth * 0.1;
//   //final double topmargin = screenHeight * 0.01;
//   if (data == null) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Load Shedding Page"),
//         backgroundColor: Colors.deepOrange,
//       ),
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
//
//   if(jsonData.isNotEmpty){
//     data = json.decode(jsonData);
//
//
//   }
//
//   //print (data);
//   int stageno = 0;
//
//
//   List<dynamic> firstDay = service.dayTimes(loadsheddingstatus, 1);
//   String dayZero = days[0];
//
//
//
//   return  SingleChildScrollView(
//
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.only(top: 10, bottom: 10),
//             //margin: EdgeInsets.only(top: topmargin),
//             child: const Text(
//               'Load Shedding Schedule',
//               style:
//               TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Container(
//               padding: EdgeInsets.only(top: 10, bottom: 15),
//               child: Text("Current Stage: $loadsheddingstatus",
//                   style: const TextStyle(
//                       fontSize: 16.0, fontStyle: FontStyle.italic))),
//           Container(
//               width: 200,
//               padding: EdgeInsets.only(bottom: 5),
//               decoration: BoxDecoration(
//                   border:
//                   Border.all(width: 1.0, color: Colors.deepOrange)),
//               child: Column(children: [
//                 Container(
//                   //height: screenHeight,
//                   width: 200,
//                   padding: EdgeInsets.only(top: 5, bottom: 5),
//                   decoration:
//                   BoxDecoration(color: Colors.deepOrange), //shade200
//                   child: Text(
//                     dayZero,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.white),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 for (var i in firstDay)
//                   Container(
//                       padding: EdgeInsets.only(bottom: 5, top: 5),
//                       child: Text(i.toString()))
//               ])),
//           // Container(
//           //     width: 200,
//           //     margin: EdgeInsets.only(top: 10),
//           //     padding: EdgeInsets.only(bottom: 5),
//           //     decoration: BoxDecoration(
//           //       border: Border.all(width: 1.0, color: Colors.black),
//           //     ),
//           //     child: Column(children: [
//           //       Container(
//           //         width: 200,
//           //         padding: EdgeInsets.only(top: 5, bottom: 5),
//           //         decoration: BoxDecoration(color: Colors.black),
//           //         child: Text(
//           //           dayOne,
//           //           style: const TextStyle(
//           //               fontWeight: FontWeight.bold, color: Colors.white),
//           //           textAlign: TextAlign.center,
//           //         ),
//           //       ),
//           //       for (var i in secondDay)
//           //         Container(
//           //             padding: EdgeInsets.only(bottom: 5, top: 5),
//           //             child: Text(i.toString()))
//           // //     ])),
//           // Container(
//           //     width: 200,
//           //     margin: EdgeInsets.only(top: 10),
//           //     padding: EdgeInsets.only(bottom: 5),
//           //     decoration: BoxDecoration(
//           //         border: Border.all(width: 1.0, color: Colors.black)),
//           //     child: Column(children: [
//           //       Container(
//           //         width: 200,
//           //         //height: screenHeight,
//           //         padding: EdgeInsets.only(top: 5, bottom: 5),
//           //         decoration: BoxDecoration(color: Colors.black),
//           //         child: Text(
//           //           dayTwo,
//           //           style: const TextStyle(
//           //               fontWeight: FontWeight.bold, color: Colors.white),
//           //           textAlign: TextAlign.center,
//           //         ),
//           //       ),
//           //       for (var i in thirdDay)
//           //         Container(
//           //             padding: EdgeInsets.only(bottom: 5, top: 5),
//           //             child: Text(i.toString()))
//           //     ])),
//           // Container(
//           //     width: 200,
//           //     margin: EdgeInsets.only(top: 10),
//           //     padding: EdgeInsets.only(bottom: 5),
//           //     decoration: BoxDecoration(
//           //         border: Border.all(width: 1.0, color: Colors.black)),
//           //     child: Column(children: [
//           //       Container(
//           //         width: 200,
//           //         //height: screenHeight,
//           //         //padding: const EdgeInsets.symmetric(horizontal: 14),
//           //         padding: EdgeInsets.only(top: 5, bottom: 5),
//           //         decoration: BoxDecoration(color: Colors.black),
//           //         child: Text(
//           //           dayThree,
//           //           style: const TextStyle(
//           //               fontWeight: FontWeight.bold, color: Colors.white),
//           //           textAlign: TextAlign.center,
//           //         ),
//           //       ),
//           //       for (var i in fourthDay)
//           //         Container(
//           //             padding: EdgeInsets.only(bottom: 5, top: 5),
//           //             child: Text(i.toString()))
//           //     ])),
//           // Container(
//           //     width: 200,
//           //     margin: EdgeInsets.only(top: 10),
//           //     padding: EdgeInsets.only(bottom: 5),
//           //     decoration: BoxDecoration(
//           //         border: Border.all(width: 1.0, color: Colors.black)),
//           //     child: Column(children: [
//           //       Container(
//           //         width: 200,
//           //         //height: screenHeight,
//           //         //padding: const EdgeInsets.symmetric(horizontal: 14),
//           //         padding: EdgeInsets.only(top: 5, bottom: 5),
//           //         decoration: BoxDecoration(color: Colors.black),
//           //         child: Text(
//           //           dayFour,
//           //           style: const TextStyle(
//           //               fontWeight: FontWeight.bold, color: Colors.white),
//           //           textAlign: TextAlign.center,
//           //         ),
//           //       ),
//           //       for (var i in fifthDay)
//           //         Container(
//           //             padding: EdgeInsets.only(bottom: 5, top: 5),
//           //             child: Text(i.toString()))
//           //     ])),
//           // Container(
//           //     width: 200,
//           //     margin: EdgeInsets.only(top: 10),
//           //     padding: EdgeInsets.only(bottom: 5),
//           //     decoration: BoxDecoration(
//           //         border: Border.all(width: 1.0, color: Colors.black)),
//           //     child: Column(children: [
//           //       Container(
//           //         width: 200,
//           //         //height: screenHeight,
//           //         //padding: const EdgeInsets.symmetric(horizontal: 14),
//           //         padding: EdgeInsets.only(top: 5, bottom: 5),
//           //         decoration: BoxDecoration(color: Colors.black),
//           //         child: Text(
//           //           dayFive,
//           //           style: const TextStyle(
//           //               fontWeight: FontWeight.bold, color: Colors.white),
//           //           textAlign: TextAlign.center,
//           //         ),
//           //       ),
//           //       for (var i in sixthDay)
//           //         Container(
//           //             padding: EdgeInsets.only(bottom: 5, top: 5),
//           //             child: Text(i.toString()))
//           //     ])),
//           // Container(
//           //     width: 200,
//           //     margin: EdgeInsets.only(top: 10, bottom: 15),
//           //     padding: EdgeInsets.only(bottom: 5),
//           //     decoration: BoxDecoration(
//           //         border: Border.all(width: 1.0, color: Colors.black)),
//           //     child: Column(children: [
//           //       Container(
//           //         //height: screenHeight,
//           //         //padding: const EdgeInsets.symmetric(horizontal: 14),
//           //         width: 200,
//           //         padding: EdgeInsets.only(top: 5, bottom: 5),
//           //         decoration: BoxDecoration(color: Colors.black),
//           //         child: Text(
//           //           daySix,
//           //           style: const TextStyle(
//           //               fontWeight: FontWeight.bold, color: Colors.white),
//           //           textAlign: TextAlign.center,
//           //         ),
//           //       ),
//           //       for (var i in seventhDay)
//           //         Container(
//           //             padding: EdgeInsets.only(bottom: 5, top: 5),
//           //             child: Text(i.toString()))
//           //     ]))
//         ],
//       )
//
//   );
// }
// }