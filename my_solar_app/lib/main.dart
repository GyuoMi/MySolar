import 'package:flutter/material.dart';
import 'package:my_solar_app/screens/login_page.dart';
import 'package:my_solar_app/screens/register_system_page.dart';
import 'package:my_solar_app/screens/register_user_page.dart';
import 'package:my_solar_app/screens/Homepage.dart';
import 'package:my_solar_app/screens/settings_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_solar_app/screens/devices.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fsirbhoucrjtnkvchwuf.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzaXJiaG91Y3JqdG5rdmNod3VmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIzNzYxNTAsImV4cCI6MjAwNzk1MjE1MH0.Bb3OZyxku8_7c_aIQe5GlMsup0SODK-5pPa92tzkNFM',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
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
        });
  }
}

