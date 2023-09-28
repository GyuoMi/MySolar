import 'package:flutter/material.dart';
import 'package:my_solar_app/cloud_functions/database/database_api.dart';
import 'package:my_solar_app/cloud_functions/database/interfaces/database_functions_interface.dart';
import 'package:my_solar_app/cloud_functions/database/supabase_functions.dart';
import 'package:riverpod/riverpod.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../cloud_functions/database/interfaces/device_persistence_interface.dart';

IDatabaseFunctions database = SupabaseFunctions();

class DevicesPage extends StatelessWidget {
IDevicePersistence devicePersistence = DatabaseApi();
  
  final List<Device> devices = [
    Device(name: 'Device 1', wattage: 100),
    Device(name: 'Device 2', wattage: 200),
    // Add more devices here as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Devices'),
      ),
      body: DeviceList(devices: devices), // Pass the devices list here
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle adding a new device here
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


class Device {
  final String name;
  final double wattage;
  
  Device({required this.name, required this.wattage});
}

class DeviceList extends StatelessWidget {
  final List<Device> devices;

  DeviceList({required this.devices});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];

        return FutureBuilder(
          future: devicePersistence.getDevice(61), // Replace 61 with the actual user ID
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Display loading indicator while fetching data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final deviceData = snapshot.data;

              return ListTile(
                onTap: () {
                  // Handle the click on the device here
                },
                title: Text(device.name),
                subtitle: Text('${device.wattage} watts'),
                trailing: Icon(Icons.arrow_forward),
              );
            }
          },
        );
      },
    );
  }
}



