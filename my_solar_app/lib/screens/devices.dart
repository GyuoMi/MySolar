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
            return DeviceList(devices: devices, showEditDeviceDialog: _showEditDeviceDialog);
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
    var deviceIds = (deviceIdsResponse as List<dynamic>)
        .map((item) =>
            item[devicePersistence.deviceId] as int) // Extract device_id
        .toList();

    // Step 3: Initialize an empty list to store devices
    List<Device> devices = [];

    // Step 4: Loop through the device IDs and fetch device details for each ID
    for (var deviceId in deviceIds) {
      var deviceData = await devicePersistence.getDevice(deviceId);

      // Create a Device object from deviceData and add it to the list
      var device = Device(
        name: deviceData[0][devicePersistence.deviceName] as String,
        usage: deviceData[0][devicePersistence.deviceUsage] as bool,
        wattage: deviceData[0][devicePersistence.deviceWattage] as dynamic,
        voltage: deviceData[0][devicePersistence.deviceVoltage] as dynamic,
        loadshedding:
            deviceData[0][devicePersistence.deviceLoadSheddingSetting] as bool,
        normal: deviceData[0][devicePersistence.deviceNormalSetting] as bool,
      );

      devices.add(device);
    }

    // Step 6: Return the list of devices
    return devices;
  }

  Future<void> _showEditDeviceDialog(BuildContext context, Device device) async {
  bool isProducer = device.usage;

  await showDialog(
    context: context, // Pass the context here
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Device'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text Form Field for Device Name
            TextFormField(
              initialValue: device.name,
              decoration: InputDecoration(labelText: 'Device name'),
              onChanged: (value) {
                // Update the device name
                device.name = value;
              },
            ),

            // Switch for Device Usage (Producer/Consumer)
            SwitchListTile(
              title: Text('Device Usage'),
              value: isProducer,
              onChanged: (value) {
                isProducer = value;
                device.usage = value ? true : false; // Update device.usage accordingly
                // Trigger a rebuild of the widget
              },
              secondary: isProducer ? Text('Producer') : Text('Consumer'),
            ),

            // Text Form Field for Device Voltage
            TextFormField(
              initialValue: device.voltage.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Device voltage'),
              onChanged: (value) {
                // Update the device voltage
                device.voltage = double.tryParse(value) ?? 0.0;
              },
            ),

            // Text Form Field for Device Wattage
            TextFormField(
              initialValue: device.wattage.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Device wattage'),
              onChanged: (value) {
                // Update the device wattage
                device.wattage = double.tryParse(value) ?? 0.0;
              },
            ),

            // Switch for Loadshedding
            SwitchListTile(
              title: Text('Loadshedding'),
              value: device.loadshedding,
              onChanged: (value) {
                // Update the device loadshedding setting
                device.loadshedding = value;
              },
            ),

            // Switch for Normal
            SwitchListTile(
              title: Text('Normal'),
              value: device.normal,
              onChanged: (value) {
                // Update the device normal setting
                device.normal = value;
              },
            ),
          ],
        ),
        actions: <Widget>[
          // Done button...
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Done'),
          ),
        ],
      );
    },
  );
}


}

class Device {
  String name;
  bool usage;
  dynamic wattage;
  dynamic voltage;
  bool loadshedding;
  bool normal;

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
  final Function(BuildContext, Device) showEditDeviceDialog;

  DeviceList({required this.devices, required this.showEditDeviceDialog});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];

        return ListTile(
          onTap: () {
            showEditDeviceDialog(context,device);
          },
          title: Text(device.name),
          subtitle: Text('${device.wattage} watts'),
          trailing: Icon(Icons.arrow_forward),
        );
      },
    );
  }
}
