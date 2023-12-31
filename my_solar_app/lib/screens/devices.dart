import 'package:flutter/material.dart';
import 'package:my_solar_app/cloud_functions/database/database_api.dart';
import 'package:my_solar_app/cloud_functions/database/interfaces/device_persistence_interface.dart';
import 'package:my_solar_app/models/logged_in_user.dart';
import 'package:my_solar_app/widgets/drawer.dart'; 
import 'dart:async';

// Define your database and device persistence instances
IDevicePersistence devicePersistence = DatabaseApi();
int userId = LoggedInUser.getUserId();
class DevicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Devices'),
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
      body: FutureBuilder<List<Device>>(
        future: createDevicesList(LoggedInUser.getUserId()), // Replace 61 with the actual user ID
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
            return DeviceList(deviceList: devices, showEditDeviceDialog: _showEditDeviceDialog);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDeviceDialog(context);
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
  // Method to refresh the device page
  void _refreshDevicePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DevicesPage()),
    );
  }
  Future<void> _showEditDeviceDialog(BuildContext context, Device device) async {
    await showDialog(
      context: context, // Pass the context here
      builder: (BuildContext context) {
        return EditDeviceDialog(
          device: device,
          isAdding: false,
          refreshDeviceList: () {
            createDevicesList(LoggedInUser.getUserId());
          },
        );
      },
    );
    _refreshDevicePage(context);
  }

  Future<void> _showAddDeviceDialog(BuildContext context) async {
  // Create a new Device object for adding a device
  var newDevice = Device(
    id: 0, // Assign a temporary ID (or any default value)
    name: "", // Provide default values or empty strings
    usage: false, // Provide default values
    wattage: 0.0, // Provide default values
    voltage: 0.0, // Provide default values
    loadshedding: false, // Provide default values
    normal: false, // Provide default values
  );

  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditDeviceDialog(
          device: newDevice,
          isAdding: true,
          refreshDeviceList: () {
            createDevicesList(LoggedInUser.getUserId());
          },
        ); // Pass an additional flag to indicate it's for adding
      },
    );
  _refreshDevicePage(context);
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
  final List<Device> deviceList;

  final Function(BuildContext, Device) showEditDeviceDialog;

  DeviceList({required this.deviceList, required this.showEditDeviceDialog});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: deviceList.length,
      itemBuilder: (context, index) {
        final device = deviceList[index];

        return Dismissible(
          key: Key(device.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          confirmDismiss: (direction) async {
            // Show delete confirmation dialog
            return await _showDeleteConfirmationDialog(context, device);
          },
          child: ListTile(
            onTap: () {
              showEditDeviceDialog(context, device);
            },
            title: Text(device.name),
            subtitle: Text('${device.wattage} watts'),
            trailing: Icon(Icons.arrow_forward),
          ),
        );
      },
    );
  }
}

Future<bool> _showDeleteConfirmationDialog(BuildContext context, Device device) async {
  Completer<bool> completer = Completer<bool>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${device.name}?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Close the dialog and return false
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await devicePersistence.deleteDevice(device.id);
              Navigator.of(context).pop(true); // Close the dialog and return true
              // You can also refresh the device list here if needed
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  ).then((value) => completer.complete(value ?? false));

  return completer.future;
}


class EditDeviceDialog extends StatefulWidget {
  final Device device;
  final bool isAdding;
  final Function refreshDeviceList;
  EditDeviceDialog({required this.device, required this.isAdding, required this.refreshDeviceList});

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
      title: Text(widget.isAdding ? 'Add Device' : 'Edit Device'),
      content: SingleChildScrollView(
        child: Column(
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
      ),
      actions: <Widget>[
        // Done button...
       TextButton(
  onPressed: () async {
    if (widget.isAdding) {
      await devicePersistence.createDevice(
        userId,
        widget.device.name,
        widget.device.usage,
        widget.device.wattage,
        widget.device.voltage,
        widget.device.normal,
        widget.device.loadshedding,
      );
    } else {
      devicePersistence.updateDeviceName(widget.device.id, widget.device.name);
      devicePersistence.updateDeviceUsage(widget.device.id, widget.device.usage);
      devicePersistence.updateDeviceNormalSetting(widget.device.id, widget.device.normal);
      devicePersistence.updateDeviceVoltage(widget.device.id, widget.device.voltage);
      devicePersistence.updateDeviceWattage(widget.device.id, widget.device.wattage);
      devicePersistence.updateDeviceLoadSheddingSetting(widget.device.id, widget.device.loadshedding);
    }

    // Close the dialog
    Navigator.of(context).pop();

    // Refresh the device list after adding or editing
    widget.refreshDeviceList();
  },
  child: Text('Done'),
),
 
      ],
    );
  }
}
