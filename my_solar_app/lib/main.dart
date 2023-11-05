import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:my_solar_app/screens/login_page.dart'; // Import login_page.dart

void main() {
=======
import 'package:my_solar_app/screens/login_page.dart';
import 'package:my_solar_app/screens/register_system_page.dart';
import 'package:my_solar_app/screens/register_user_page.dart';
import 'package:my_solar_app/screens/Homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_solar_app/screens/devices.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fsirbhoucrjtnkvchwuf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzaXJiaG91Y3JqdG5rdmNod3VmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIzNzYxNTAsImV4cCI6MjAwNzk1MjE1MH0.Bb3OZyxku8_7c_aIQe5GlMsup0SODK-5pPa92tzkNFM',
  );
>>>>>>> 6a3713525265d4180e2750ce00577ce7d86919f9
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'My Solar App',
      theme: ThemeData(
        colorScheme: ColorScheme.light(),
        useMaterial3: true,
      ),
      home: SplashScreen(), // Start with SplashScreen
    );
=======
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
          '/': (context) => const MyHomePage(title: 'Home Page'),
          '/login': (context) => const LoginPage(),
          '/register_user': (context) => RegisterPage(),
          '/register_system': (context) => RegisterSystemPage(),
          '/devices': (context) => DevicesPage(),
        });
>>>>>>> 6a3713525265d4180e2750ce00577ce7d86919f9
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 10 seconds before navigating to the login screen
    Future.delayed(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/my_solar_logo.png',
              scale: 3,
            ),
            const Text("Welcome to My Solar!"),
          ],
        ),
      ),
    );
  }
}
