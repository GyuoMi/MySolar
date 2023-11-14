import 'package:flutter/material.dart';
//import 'package:geocoding/geocoding.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
//import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

//import 'package:location/location.dart';

class AddressMapPage extends StatefulWidget {
  @override
  _AddressMapPageState createState() => _AddressMapPageState();
}

class _AddressMapPageState extends State<AddressMapPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Map App'),
        ),
        body: WebView(
          initialUrl: 'https://www.google.com/maps',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
  // final TextEditingController _addressController = TextEditingController();
  // GoogleMapController? _mapController;
  // Marker? _userMarker;
  // static final CameraPosition _currentPosition = CameraPosition(
  //   target: LatLng(26.1929, 28.0305),
  //   zoom: 14.4746,
  // );
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Address Map App'),
  //     ),
  //     body: Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: TextField(
  //             controller: _addressController,
  //             decoration: InputDecoration(
  //               hintText: 'Enter your address',
  //               suffixIcon: IconButton(
  //                 icon: Icon(Icons.search),
  //                 onPressed: () {
  //                   _searchAndNavigate();
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: GoogleMap(
  //             onMapCreated: (controller) {
  //               _mapController = controller;
  //             },
  //             markers: Set.of((_userMarker != null) ? [_userMarker!] : []), initialCameraPosition: _currentPosition ,
  //             // initialCameraPosition: null, // You can remove or set it to null
  //           ),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             // Implement logic to go back to the home address
  //             _goToHomeAddress();
  //           },
  //           child: Text('Go to Home Address'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

//   Future<void> _searchAndNavigate() async {
//     try {
//       List<Location> locations = await locationFromAddress(_addressController.text);
//       if (locations.isNotEmpty) {
//         Location location = locations.first;
//         _updateMarker(location);
//         _moveCamera(location);
//       } else {
//         // Handle invalid address
//         _showInvalidAddressDialog();
//       }
//     } catch (e) {
//       // Handle errors
//       print(e.toString());
//     }
//   }
//
//   void _moveCamera(Location location) {
//     _mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: LatLng(location.latitude!, location.longitude!),
//           zoom: 15.0,
//         ),
//       ),
//     );
//   }
//
//   void _updateMarker(Location location) {
//     setState(() {
//       _userMarker = Marker(
//         markerId: MarkerId('User'),
//         position: LatLng(location.latitude!, location.longitude!),
//         infoWindow: InfoWindow(title: 'Your Address'),
//       );
//     });
//   }
//
//
//   void _goToHomeAddress() {
//     // Implement logic to go back to the home address (use stored home address coordinates)
//     // For simplicity, let's assume home address coordinates are (0.0, 0.0)
//     _mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: LatLng(0.0, 0.0),
//           zoom: 15.0,
//         ),
//       ),
//     );
//   }
//
//   void _showInvalidAddressDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Invalid Address'),
//           content: Text('Please enter a valid address.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
