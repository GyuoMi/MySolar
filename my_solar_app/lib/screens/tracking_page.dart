import 'package:flutter/material.dart';
import 'package:my_solar_app/cloud_functions/database/database_api.dart';
import 'package:my_solar_app/cloud_functions/database/interfaces/database_functions_interface.dart';
import 'package:my_solar_app/cloud_functions/database/interfaces/record_persistence_interface.dart';
import 'package:my_solar_app/screens/devices.dart';
import 'package:my_solar_app/cloud_functions/database/interfaces/device_persistence_interface.dart';
import 'package:my_solar_app/models/logged_in_user.dart';
import 'package:my_solar_app/widgets/drawer.dart';

IDevicePersistence devicePersistence = DatabaseApi();
IRecordPersistence recordPersistence = DatabaseApi();
IDatabaseFunctions databaseFunctions = DatabaseApi();
int userId = LoggedInUser.userId;
// int userId = 61;
var devicesPageInstance = DevicesPage();

class Time {
  Time({required this.recent_time, required this.next_time});
  String recent_time;
  String next_time;
}

Future<String> getRecentTime() async {
  final jsonTime = await databaseFunctions.getTime();

  var time = Time(
      next_time: jsonTime['next_time'] as String,
      recent_time: jsonTime['recent_time'] as String);

  return time.recent_time;
}

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
          child: FutureBuilder(
              future: devicesPageInstance.createDevicesList(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.data != null && snapshot.data!.isNotEmpty) {
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    keyboardType: TextInputType.number,
                                    controller: _controllers![index],
                                  ),
                                ),
                              ),
                            ]);
                          },
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
                                  onPressed: () async {
                                    String recentTime = await getRecentTime();
                                    for (int index = 0;
                                        index < devices.length;
                                        index++) {
                                      String value = _controllers![index].text;
                                      recordPersistence.createRecord(
                                          devices[index].id,
                                          recentTime,
                                          double.tryParse(value) ?? 00.00);
                                    }
                                  },
                                  child: const Text("Save")),
                            )),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
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
        ));
  }
}
