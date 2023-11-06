import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_solar_app/cloud_functions/authentication/auth_repository.dart';
import 'package:my_solar_app/cloud_functions/database/database_api.dart';
import 'package:my_solar_app/cloud_functions/database/interfaces/manual_system_persistence_interface.dart';
import 'package:my_solar_app/cloud_functions/database/interfaces/user_persistence_interface.dart';
import 'package:my_solar_app/main.dart';
import 'package:my_solar_app/models/logged_in_user.dart';
import 'package:my_solar_app/widgets/authentication/square_tile_images.dart';
import 'package:my_solar_app/widgets/authentication/text_field.dart';
import 'package:my_solar_app/cloud_functions/authentication/interfaces/auth_repository_interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final IAuthRepository authentication = AuthRepository();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    // _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
    //   final session = event.session;
    //   if (session != null) {
    //     //goes to the main page
    //     Navigator.of(context).pushReplacementNamed('/');
    //   }
    // });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _authSubscription.cancel();
    super.dispose();
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
        const Text("Welcome back!"),
        //shows user name and password text boxes
        const SizedBox(height: 40),
        LoginPageTextField(
          controller: emailController,
          hintText: "Email",
          obscureText: false,
          textType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        LoginPageTextField(
          controller: passwordController,
          hintText: 'Password',
          obscureText: true,
          textType: TextInputType.text,
        ),

        //aligns password to the right
        // const Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Padding(
        //         padding: EdgeInsets.fromLTRB(0, 5, 50, 0),
        //         child: Text("Forgot Password?"))
        //   ],
        // ),
        const SizedBox(height: 20),

        //creates Sign In button
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FilledButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(300, 70)),
              onPressed: () async {
                final name = emailController.text.trim();
                final password = passwordController.text.trim();
                try {
                  //check to see if user is in database
                  await authentication.signInEmailAndPassword(name, password);

                  //get user details
                  IUserPersistence userPersistence = DatabaseApi();
                  var userData = await userPersistence.getUserDetails(name);
                  int id = userData[0][userPersistence.userId] as int;
                  int sysId = userData[0][userPersistence.systemId] as int;
                  String address =
                      userData[0][userPersistence.userAddress] as String;

                  //set up logged in user
                  LoggedInUser.setUser(id, sysId, name, password, address);

                  IManualSystemPersistence systemPersistence = DatabaseApi();
                  //set up logged in users system details
                  var systemData =
                      await systemPersistence.getManualSystemDetails(id);
                  String systemName =
                      systemData[0][systemPersistence.manualName] as String;
                  int systemPanels =
                      systemData[0][systemPersistence.manualCount] as int;
                  double panelProduction = systemData[0]
                      [systemPersistence.manualMaxProduction] as double;
                  double batteryCapacity =
                      systemData[0][systemPersistence.manualCapacity] as double;

                  LoggedInUser.setSystem(systemName, systemPanels,
                      panelProduction, batteryCapacity);

                  //navigate to new homepage
                  Navigator.of(context).pushReplacementNamed('/');
                } on AuthException catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error.message),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ));
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Error occured please try again"),
                      backgroundColor: Theme.of(context).colorScheme.error));
                }
              },
              child: const Text("Sign In")),
        ]),
        const SizedBox(height: 25),

        //creates divider with text continue with
        // const Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text("Or continue with"),
        //   ],
        // ),
        // const SizedBox(
        //   height: 25,
        // ),
        // const Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     SquareImageTile(imagePath: 'assets/images/google.png'),
        //     SizedBox(width: 40),
        //     SquareImageTile(imagePath: 'assets/images/apple.png')
        //   ],
        // ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Not a member? '),
            RichText(
              text: TextSpan(
                  text: 'Register now',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.of(context)
                        .pushReplacementNamed('/register_user')),
            )
          ],
        )
      ],
    )));
  }
}
