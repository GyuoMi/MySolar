import 'package:flutter/material.dart';
import 'package:my_solar_app/cloud_functions/database/database_api.dart';
import 'package:my_solar_app/screens/devices.dart';
import 'package:my_solar_app/screens/login_page.dart';
import 'package:my_solar_app/widgets/authentication/square_tile_images.dart';
import 'package:my_solar_app/widgets/authentication/text_field.dart';
import 'package:my_solar_app/cloud_functions/authentication/interfaces/auth_repository_interface.dart';
import 'package:my_solar_app/cloud_functions/database/interfaces/device_persistence_interface.dart';
import 'package:my_solar_app/models/logged_in_user.dart';
import 'package:my_solar_app/widgets/drawer.dart'; 

IDevicePersistence devicePersistence = DatabaseApi();
int userId = LoggedInUser.userId;
//int userId = 50;
var devicesPageInstance = DevicesPage();

class TrackingPage extends StatelessWidget {
  TrackingPage({super.key});
  List<TextEditingController>? _controllers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: const Text('Tracking'),
          leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu), // Hamburger menu icon
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        ),
        body: Center(
          //   child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          // children: [
            // const Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       Expanded(
            //           flex: 3,
            //           child: Padding(
            //             padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            //             child: Text(
            //               "Devices",
            //               style: TextStyle(fontWeight: FontWeight.bold),
            //               textScaleFactor: 1.25,
            //             ),
            //           )),
            //       Expanded(
            //           flex: 1,
            //           child: Padding(
            //             padding:
            //                 EdgeInsets.only(right: 10, bottom: 10, top: 10),
            //             child: Text(
            //               "Minutes",
            //               style: TextStyle(fontWeight: FontWeight.bold),
            //               textScaleFactor: 1.25,
            //             ),
            //           )),
            //     ]),

            child: FutureBuilder(
                future: devicesPageInstance.createDevicesList(userId),
                builder: (context, snapshot) {
                  if (true) {
                    final List<Device> devices = snapshot.data!;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, bottom: 10, top: 10),
                                    child: Text(
                                      "Devices",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textScaleFactor: 1.25,
                                    ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: 10, bottom: 10, top: 10),
                                    child: Text(
                                      "Minutes",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textScaleFactor: 1.25,
                                    ),
                                  )),
                            ]),

                        //create list of devices
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: devices.length,
                            itemBuilder: (context, index) {
                              final device = devices[index];

                              _controllers!.add(TextEditingController());
                              _controllers![index].text = "00";
                              return Row(children: [
                                Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        device.name,
                                        //textAlign: TextAlign.center,
                                      ),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      controller: _controllers![index],
                                    ),
                                  ),
                                ),
                              ]);
                            },
                            //separatorBuilder: (BuildContext context, int index) =>const Divider(),
                          ),
                        ),
                        //create save button
                        Expanded(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: FilledButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        minimumSize: const Size(300, 50)),
                                    onPressed: () {
                                      //TODO
                                      for (int index = 0; index < 10; index++) {
                                        String value =
                                            _controllers![index].text;
                                        _controllers![index].text = value;
                                      }
                                    },
                                    child: const Text("Save")),
                              )),
                        ),

                        const SizedBox(height: 10),
                      ],
                    );

                    // return ListView.builder(
                    //   scrollDirection: Axis.vertical,
                    //   shrinkWrap: true,
                    //   itemCount: devices.length,
                    //   itemBuilder: (context, index) {
                    //     final device = devices[index];

                    //     _controllers!.add(TextEditingController());
                    //     _controllers![index].text = "00";
                    //     return Row(children: [
                    //       Expanded(
                    //           flex: 3,
                    //           child: Padding(
                    //             padding: const EdgeInsets.only(left: 10),
                    //             child: Text(
                    //               device.name,
                    //               //textAlign: TextAlign.center,
                    //             ),
                    //           )),
                    //       Expanded(
                    //         flex: 1,
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(right: 10),
                    //           child: TextFormField(
                    //             textAlign: TextAlign.center,
                    //             keyboardType: TextInputType.number,
                    //             controller: _controllers![index],
                    //           ),
                    //         ),
                    //       ),
                    //     ]);
                    //   },
                    //   //separatorBuilder: (BuildContext context, int index) =>const Divider(),
                    // );
                  } else {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/empty_page.png',
                            scale: 3,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "So much blank space.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textScaleFactor: 1.25,
                          ),
                          const SizedBox(height: 20),
                          const Text("Let's fill it with excitement!"),
                          const SizedBox(height: 40),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FilledButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        minimumSize: const Size(300, 50)),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DevicesPage()));
                                    },
                                    child: const Text("Add Devices")),
                              ]),
                        ]);
                  }
                }),
            // Expanded(
            //   child: Align(
            //       alignment: Alignment.bottomCenter,
            //       child: Padding(
            //         padding: const EdgeInsets.only(bottom: 10),
            //         child: FilledButton(
            //             style: ElevatedButton.styleFrom(
            //                 shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(10)),
            //                 minimumSize: const Size(300, 50)),
            //             onPressed: () {
            //               //TODO
            //               for (int index = 0; index < 10; index++) {
            //                 String value = _controllers![index].text;
            //                 _controllers![index].text = value;
            //               }
            //             },
            //             child: const Text("Save")),
            //       )),
            // ),
            // if (false) ...[
            //   Image.asset(
            //     'assets/images/empty_page.png',
            //     scale: 3,
            //   ),
            //   const SizedBox(height: 20),
            //   const Text(
            //     "So much blank space.",
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //     textScaleFactor: 1.25,
            //   ),
            //   const SizedBox(height: 20),
            //   const Text("Let's fill it with excitement!"),
            //   const SizedBox(height: 40),
            //   Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //     FilledButton(
            //         style: ElevatedButton.styleFrom(
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(10)),
            //             minimumSize: const Size(300, 70)),
            //         onPressed: () {
            //           Navigator.of(context).push(MaterialPageRoute(
            //               builder: (context) => DevicesPage()));
            //         },
            //         child: const Text("Add Devices")),
            //   ]),
            // ] //if
            // else ...[
            //   const Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         Expanded(
            //             flex: 3,
            //             child: Padding(
            //               padding:
            //                   EdgeInsets.only(left: 10, bottom: 10, top: 10),
            //               child: Text(
            //                 "Devices",
            //                 style: TextStyle(fontWeight: FontWeight.bold),
            //                 textScaleFactor: 1.25,
            //               ),
            //             )),
            //         Expanded(
            //             flex: 1,
            //             child: Padding(
            //               padding:
            //                   EdgeInsets.only(right: 10, bottom: 10, top: 10),
            //               child: Text(
            //                 "Minutes",
            //                 style: TextStyle(fontWeight: FontWeight.bold),
            //                 textScaleFactor: 1.25,
            //               ),
            //             )),
            //       ]),

            //   //create list of devices
            //   Expanded(
            //     child: ListView.builder(
            //       scrollDirection: Axis.vertical,
            //       shrinkWrap: true,
            //       itemCount: devices.length,
            //       itemBuilder: (context, index) {
            //         final device = devices[index];

            //         _controllers!.add(TextEditingController());
            //         _controllers![index].text = "00";
            //         return Row(children: [
            //           const Expanded(
            //               flex: 3,
            //               child: Padding(
            //                 padding: EdgeInsets.only(left: 10),
            //                 child: Text(
            //                   //TODO
            //                   "Device name",
            //                   //textAlign: TextAlign.center,
            //                 ),
            //               )),
            //           Expanded(
            //             flex: 1,
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 10),
            //               child: TextFormField(
            //                 textAlign: TextAlign.center,
            //                 controller: _controllers![index],
            //               ),
            //             ),
            //           ),
            //         ]);
            //       },
            //       //separatorBuilder: (BuildContext context, int index) =>const Divider(),
            //     ),
            //   ),

            // //create save button
            // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //   FilledButton(
            //       style: ElevatedButton.styleFrom(
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10)),
            //           minimumSize: const Size(300, 70)),
            //       onPressed: () {
            //         //TODO
            //         for (int index = 0; index < 10; index++) {
            //           String value = _controllers![index].text;
            //           _controllers![index].text = value;
            //         }
            //       },
            //       child: const Text("Save")),
            // ]),

            //   const SizedBox(height: 10),
            // ], //else
          // ]),
        ));
  }
}
