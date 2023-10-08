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
        id: deviceData[0][devicePersistence.deviceId] as dynamic,
        name: deviceData[0][devicePersistence.deviceName] as String,
        usage: deviceData[0][devicePersistence.deviceUsage] as bool,
        wattage: deviceData[0][devicePersistence.deviceWattage] + 0.0 as dynamic,
        voltage: deviceData[0][devicePersistence.deviceVoltage] + 0.0 as dynamic,
        loadshedding: deviceData[0][devicePersistence.deviceLoadSheddingSetting] as bool,
        normal: deviceData[0][devicePersistence.deviceNormalSetting] as bool,
      );

      devices.add(device);
    }

    // Step 6: Return the list of devices
    return devices;
  }

  Future<void> _showEditDeviceDialog(BuildContext context, Device device) async {
    await showDialog(
      context: context, // Pass the context here
      builder: (BuildContext context) {
        return EditDeviceDialog(device: device);
      },
    );
  }
}

class Device {
  dynamic id;
  String name;
  bool usage;
  dynamic wattage;
  dynamic voltage;
  bool loadshedding;
  bool normal;

  Device({
    required this.id,
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
            showEditDeviceDialog(context, device);
          },
          title: Text(device.name),
          subtitle: Text('${device.wattage} watts'),
          trailing: Icon(Icons.arrow_forward),
        );
      },
    );
  }
}

class EditDeviceDialog extends StatefulWidget {
  final Device device;

  EditDeviceDialog({required this.device});

  @override
  _EditDeviceDialogState createState() => _EditDeviceDialogState();
}

class _EditDeviceDialogState extends State<EditDeviceDialog> {
  late bool isProducer;
  late bool isLoadshedding;
  late bool isNormal;

  @override
  void initState() {
    super.initState();
    isProducer = widget.device.usage;
    isLoadshedding = widget.device.loadshedding;
    isNormal = widget.device.normal;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Device'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text Form Field for Device Name
          TextFormField(
            initialValue: widget.device.name,
            decoration: InputDecoration(labelText: 'Device name'),
            onChanged: (value) {
              // Update the device name
              widget.device.name = value;
            },
          ),

          // Switch for Device Usage (Producer/Consumer)
          SwitchListTile(
            title: Text('Device Usage'),
            value: isProducer,
            onChanged: (value) {
              setState(() {
                isProducer = value;
                widget.device.usage = value; // Update device.usage accordingly
              });
            },
            secondary: isProducer ? Text('Producer') : Text('Consumer'),
          ),
           // Text Form Field for Device Voltage
            TextFormField(
              initialValue: widget.device.voltage.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Device voltage'),
              onChanged: (value) {
                // Update the device voltage
                widget.device.voltage = double.tryParse(value) ?? 0.0;
              },
            ),

            // Text Form Field for Device Wattage
            TextFormField(
              initialValue: widget.device.wattage.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Device wattage'),
              onChanged: (value) {
                // Update the device wattage
                widget.device.wattage = double.tryParse(value) ?? 0.0;
              },
            ),

            // Switch for Loadshedding
            SwitchListTile(
            title: Text('Loadshedding'),
            value: isLoadshedding,
            onChanged: (value) {
              setState(() {
                isLoadshedding = value;
                widget.device.loadshedding = value;
              });
            },
          ),

          // Switch for Normal
            SwitchListTile(
              title: Text('Normal'),
            value: isNormal,
            onChanged: (value) {
              setState(() {
                isNormal = value;
                widget.device.normal =
                    value; // Update device.normal accordingly
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        // Done button...
        TextButton(
          onPressed: () {
            // double vD = widget.device.voltage as double;
            // double wD = widget.device.wattage as double;
            // vD += 0.0;
            // wD += 0.0;
            devicePersistence.updateDeviceName(widget.device.id, widget.device.name);
            devicePersistence.updateDeviceUsage(widget.device.id, widget.device.usage);
            devicePersistence.updateDeviceNormalSetting(widget.device.id, widget.device.normal);
            devicePersistence.updateDeviceVoltage(widget.device.id, widget.device.voltage);
            devicePersistence.updateDeviceWattage(widget.device.id, widget.device.wattage);
            devicePersistence.updateDeviceLoadSheddingSetting(widget.device.id, widget.device.loadshedding);

            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Done'),
        ),
      ],
    );
  }
}
