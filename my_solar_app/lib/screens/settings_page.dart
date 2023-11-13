import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_solar_app/cloud_functions/authentication/auth_repository.dart';
import 'package:my_solar_app/cloud_functions/database/database_api.dart';
import 'package:my_solar_app/cloud_functions/database/interfaces/manual_system_persistence_interface.dart';
import 'package:my_solar_app/cloud_functions/database/interfaces/system_persistence_interface.dart';
import 'package:my_solar_app/cloud_functions/database/interfaces/user_persistence_interface.dart';
import 'package:my_solar_app/models/logged_in_user.dart';
import 'package:my_solar_app/widgets/authentication/text_field.dart';
import 'package:my_solar_app/cloud_functions/authentication/interfaces/auth_repository_interface.dart';
import 'package:my_solar_app/widgets/drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final IAuthRepository authentication = AuthRepository();
  TextEditingController emailController =
      TextEditingController(text: LoggedInUser.getEmail());
  final passwordController =
      TextEditingController(text: LoggedInUser.getPassword());
  final systemNameController =
      TextEditingController(text: LoggedInUser.getSystemName());
  final solarPanelCountController = TextEditingController(
      text: LoggedInUser.getSolarPanelAmount().toString());
  final solarPanelProductionController = TextEditingController(
      text: LoggedInUser.getProductionOfSolarPanel().toString());
  final batteryCapacityController = TextEditingController(
      text: LoggedInUser.getBatteryCapacityInWatts().toString());

  final IManualSystemPersistence systemPersistence = DatabaseApi();

  ColorLabel systemType = ColorLabel.manual;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController colorController = TextEditingController();
    final List<DropdownMenuEntry<ColorLabel>> colorEntries =
        <DropdownMenuEntry<ColorLabel>>[];
    for (final ColorLabel color in ColorLabel.values) {
      colorEntries.add(
        DropdownMenuEntry<ColorLabel>(
            value: color, label: color.label, enabled: color.label != 'Grey'),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: CustomDrawer(),
      appBar: AppBar(title: Text("Settings")),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   'assets/images/my_solar_logo.png',
          //   scale: 3,
          // ),
          //shows user name and password text boxes
          // const SizedBox(height: 20),
          // LoginPageTextField(
          //   controller: emailController,
          //   hintText: "Email",
          //   obscureText: false,
          //   textType: TextInputType.emailAddress,
          // ),
          const SizedBox(height: 20),
          LoginPageTextField(
            controller: passwordController,
            hintText: "Password",
            obscureText: false,
            textType: TextInputType.text,
          ),

          const SizedBox(height: 20),
          LoginPageTextField(
            controller: systemNameController,
            hintText: "System Name",
            obscureText: false,
            textType: TextInputType.text,
          ),
          const SizedBox(height: 20),
          LoginPageTextField(
            controller: solarPanelCountController,
            hintText: "Number of Solar Panels",
            obscureText: false,
            textType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
          ),
          const SizedBox(height: 20),

          LoginPageTextField(
            controller: solarPanelProductionController,
            hintText: "Solar Panel Production in Watts",
            obscureText: false,
            textType:
                TextInputType.numberWithOptions(signed: false, decimal: true),
          ),
          const SizedBox(height: 20),

          LoginPageTextField(
            controller: batteryCapacityController,
            hintText: "Battery Capacity in Watts",
            obscureText: false,
            textType:
                TextInputType.numberWithOptions(signed: false, decimal: true),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownMenu<ColorLabel>(
                      width: 300,
                      initialSelection: ColorLabel.manual,
                      controller: colorController,
                      label: const Text('System Type'),
                      dropdownMenuEntries: colorEntries,
                      onSelected: (ColorLabel? color) {
                        setState(() {
                          systemType = color!;
                        });
                      }),
                ]),
          ),

          //creates Sign In button
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FilledButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(300, 70)),
                onPressed: () async {
                  final name = emailController.text.trim();
                  final userPassword = passwordController.text.trim();
                  final userId = LoggedInUser.getUserId();
                  final systemName = systemNameController.text.trim();
                  final numberOfSolarPanels =
                      int.parse(solarPanelCountController.text.trim());
                  final solarPanelProduction =
                      double.parse(solarPanelProductionController.text.trim());
                  final batteryCapacity =
                      int.parse(batteryCapacityController.text.trim());
                  try {
                    //check to see if user is in database
                    //await authentication.signInEmailAndPassword(name, password);

                    //get user details
                    IUserPersistence userPersistence = DatabaseApi();

                    //update user in auth tbl
                    if (userPassword != LoggedInUser.getPassword()) {
                      var results = await supabase.auth.updateUser(
                          UserAttributes(email: name, password: userPassword));
                    } //set up logged in user

                    //update user in user_tbl
                    await userPersistence.updateUserName(userId, name);
                    await userPersistence.updateUserPassword(
                        userId, userPassword);

                    //update system_tbl
                    await systemPersistence.updateManualName(
                        userId, systemName);
                    await systemPersistence.updateManualCount(
                        userId, numberOfSolarPanels);
                    await systemPersistence.updateManualMaxProduction(
                        userId, solarPanelProduction);
                    await systemPersistence.updateManualCapacity(
                        userId, batteryCapacity);
                    //TODO update address here

                    LoggedInUser.setUser(userId, systemType.type, name,
                        userPassword, "something");

                    LoggedInUser.setSystem(systemName, numberOfSolarPanels,
                        solarPanelProduction, batteryCapacity);

                    //navigate to new homepage
                    Navigator.of(context).pushReplacementNamed('/');
                  } on AuthException catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(error.message),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ));
                  } catch (error) {
                    print(error.toString());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Error occured please try again"),
                        backgroundColor: Theme.of(context).colorScheme.error));
                  }
                },
                child: const Text("Save")),
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
          // // ),
          // const SizedBox(
          //   height: 30,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text('Not a member? '),
              // RichText(
              //   text: TextSpan(
              //       text: 'Register now',
              //       style: TextStyle(
              //           color: Colors.blue, fontWeight: FontWeight.bold),
              //       recognizer: TapGestureRecognizer()
              //         ..onTap = () => Navigator.of(context)
              //             .pushReplacementNamed('/register_user')),
              // )
            ],
          )
        ],
      )),
    );
  }
}

enum ColorLabel {
  manual('Manual', 0),
  solarman('SolarMan', 1);

  const ColorLabel(this.label, this.type);
  final String label;
  final int type;
}
