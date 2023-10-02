import 'package:flutter/material.dart';
import 'package:my_solar_app/cloud_functions/database/database_api.dart';
import 'package:my_solar_app/cloud_functions/database/interfaces/device_persistence_interface.dart';

// Define your database and device persistence instances
IDevicePersistence devicePersistence = DatabaseApi();

class DevicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Devices'),
      ),
      body: FutureBuilder<List<Device>>(
        future: createDevicesList(61), // Replace 61 with the actual user ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No devices found.'),
            );
          } else {
            final List<Device> devices = snapshot.data!;
            return DeviceList(devices: devices);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle adding a new device here
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Device>> createDevicesList(int userId) async {
    // Step 1: Get a list of device IDs for the given userId
    final deviceIdsResponse = await devicePersistence.getUserDeviceIds(userId);

    // Step 2: Extract device IDs from the response
    final deviceIds = (deviceIdsResponse as List<dynamic>)
        .map((item) => item['device_id'] as int) // Extract device_id
        .toList();

    // Step 3: Initialize an empty list to store devices
    final List<Device> devices = [];

    // Step 4: Loop through the device IDs and fetch device details for each ID
    for (final deviceId in deviceIds) {
      final deviceData = await devicePersistence.getDevice(deviceId);
      print(deviceData);

      // Create a Device object from deviceData and add it to the list
      final device = Device(
        name: deviceData[0]['device_name'] as String,
        usage: deviceData[0]['device_usage'] as bool,
        wattage: deviceData[0]['device_wattage'] as double,
        voltage: deviceData[0]['device_voltage'] as double,
        loadshedding: deviceData[0]['device_loadshedding'] as bool,
        normal: deviceData[0]['device_normal'] as bool,
      );

      devices.add(device);
    }

    // Step 6: Return the list of devices
    return devices;
  }
}

class Device {
  final String name;
  final bool usage;
  final double wattage;
  final double voltage;
  final bool loadshedding;
  final bool normal;

  Device({
    required this.name,
    required this.usage,
    required this.wattage,
    required this.voltage,
    required this.loadshedding,
    required this.normal,
  });
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

        return ListTile(
          onTap: () {
            // Handle tapping on a device
          },
          title: Text(device.name),
          subtitle: Text('${device.wattage} watts'),
          trailing: Icon(Icons.arrow_forward),
        );
      },
    );
  }
}
