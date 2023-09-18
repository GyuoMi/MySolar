import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:supabase/supabase.dart';

final supabaseProvider = Provider<SupabaseClient>((ref) {
  return SupabaseClient(
     'https://fsirbhoucrjtnkvchwuf.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzaXJiaG91Y3JqdG5rdmNod3VmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIzNzYxNTAsImV4cCI6MjAwNzk1MjE1MH0.Bb3OZyxku8_7c_aIQe5GlMsup0SODK-5pPa92tzkNFM'
  );
});


final userDevicesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseProvider);
  final response = await supabase.from('setup_tbl')
      .select('device_name, device_wattage')
      .execute();
  if (response.error != null) {
    throw Exception('Failed to fetch user devices: ${response.error}');
  }
  return response.data as List<Map<String, dynamic>>;
});


class UserDeviceList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userDevices = watch(userDevicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Devices'),
      ),
      body: userDevices.when(
        data: (devices) {
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              final deviceName = device['device_name'] as String;
              final deviceWattage = device['device_wattage'] as String;

              return ListTile(
                title: Text(deviceName),
                subtitle: Text('Wattage: $deviceWattage'),
                onTap: () {
                  // popup for device settings is here
                },
              );
            },
          );
        },
        loading: () => CircularProgressIndicator(),
        error: (error, stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        },
      ),
    );
  }
}
