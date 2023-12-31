import 'package:flutter/material.dart';

import 'package:my_solar_app/screens/Recommendations.dart';
import 'package:my_solar_app/screens/login_page.dart';
import 'package:my_solar_app/screens/maps.dart';
import 'package:my_solar_app/screens/register_system_page.dart';

import 'package:my_solar_app/screens/Homepage.dart';
import 'package:my_solar_app/screens/register_user_page.dart';
import 'package:my_solar_app/screens/settings_page.dart';
import 'package:my_solar_app/screens/tracking_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_solar_app/screens/devices.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:my_solar_app/utilities/notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dotenv.load(fileName: "keys.env");
  requestPermissions();
  await Supabase.initialize(
    url: 'https://fsirbhoucrjtnkvchwuf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzaXJiaG91Y3JqdG5rdmNod3VmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIzNzYxNTAsImV4cCI6MjAwNzk1MjE1MH0.Bb3OZyxku8_7c_aIQe5GlMsup0SODK-5pPa92tzkNFM',
  );
  runApp(MyApp());
}
Future<void> requestPermissions() async {
    // Request internet and notification permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.location,
    ].request();

    // Check the status of each permission
    print("Notification permission: ${statuses[Permission.notification]}");
    print("Location permission: ${statuses[Permission.location]}");

    // Check internet connection status
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print("No internet connection");
    } else {
      print("Internet connection available");
    }
  }
  
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onNotificationTapped(String payload) {
    if (payload == 'tracking_page') {
          print('Tapped on notification with payload: $payload');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TrackingPage()),
      );
    }
  }
    final notificationService = NotificationService(
      context: context,
      onNotificationTapped: onNotificationTapped,
    );
    notificationService.initNotification(); // Initialize notifications
    notificationService.showNotification(
    title: 'MySolar',
    body: 'Enter new device readings',
    payLoad: 'tracking_page',
  );
  notificationService.handleNotification('tracking_page');
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app, try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: const ColorScheme.light(),
          useMaterial3: true,
        ),
        // initialRoute: Supabase.instance.client.auth.currentSession != null
        //     ? '/login'
        //     : '/',
        initialRoute: '/login',
        routes: {
          '/': (context) => const HOME(),
          '/login': (context) => const LoginPage(),
          '/register_user': (context) => RegisterPage(),
          '/register_system': (context) => RegisterSystemPage(),
          '/devices': (context) => DevicesPage(),
          '/settings': (context) => SettingsPage(),
          '/recommendation': (context) => Recommendation(),
          '/map': (context) => AddressMapPage(),
          '/tracking': (context) => TrackingPage(),
        });
    //1
  }
}
