import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_solar_app/cloud_functions/authentication/auth_repository.dart';
import 'package:my_solar_app/cloud_functions/database/database_api.dart';
import 'package:my_solar_app/cloud_functions/database/interfaces/user_persistence_interface.dart';
import 'package:my_solar_app/widgets/authentication/text_field.dart';
import 'package:my_solar_app/cloud_functions/authentication/interfaces/auth_repository_interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_solar_app/models/logged_in_user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final IAuthRepository authentication = AuthRepository();
  final IUserPersistence userPersistence = DatabaseApi();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  ColorLabel systemType = ColorLabel.manual;

  final supabase = Supabase.instance.client;
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
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/my_solar_logo.png',
          scale: 3,
        ),
        /* const Text("Register"), */
        //shows user name and password text boxes
        const SizedBox(height: 40),
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
        //TODO add address widget
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownMenu<ColorLabel>(
                    width: 300,
                    initialSelection: ColorLabel.manual,
                    controller: colorController,
                    label: const Text('Location'),
                    dropdownMenuEntries: colorEntries,
                    onSelected: (ColorLabel? color) {
                      setState(() {
                        systemType = color!;
                      });
                    }),
              ]),
        ),

        const SizedBox(height: 20),

        //creates Sign In button
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FilledButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(300, 70)),
              onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                try {
                  await authentication.signUpEmailAndPassword(email, password);
                  //uploads user to database
                  //final convertSystem = convertSystemEnumToValue(systemType);
                  //TODO change 'something' address to an actual address
                  final dataReturn = await userPersistence.createUser(
                      email, systemType.type, password, 'something');

                  //TODO change this address also
                  //sets user class with details
                  final userId = dataReturn[0][userPersistence.userId] as int;
                  LoggedInUser.setUser(
                      userId, systemType.type, email, password, 'something');

                  //navigates to new page
                  Navigator.of(context)
                      .pushReplacementNamed('/register_system');
                } on AuthException catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error.message),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ));
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Error occured please try again"),
                      backgroundColor: Theme.of(context).colorScheme.error));
                }
              },
              child: const Text("Next")),
        ]),
        const SizedBox(height: 25),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('already have an account? '),
            RichText(
              text: TextSpan(
                  text: 'Login now',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        Navigator.of(context).pushReplacementNamed('/login')),
            ),
          ],
        )
      ],
    )));
  }
}

enum ColorLabel {
  manual('Manual', 0),
  solarman('SolarMan', 1);

  const ColorLabel(this.label, this.type);
  final String label;
  final int type;
}
