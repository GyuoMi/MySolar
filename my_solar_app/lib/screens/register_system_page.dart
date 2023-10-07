import 'package:flutter/material.dart';
import 'package:my_solar_app/cloud_functions/authentication/auth_repository.dart';
import 'package:my_solar_app/widgets/authentication/text_field.dart';
import 'package:my_solar_app/cloud_functions/authentication/interfaces/auth_repository_interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterSystemPage extends StatefulWidget {
  RegisterSystemPage({super.key});
  @override
  State<RegisterSystemPage> createState() => _RegisterSystemPage();
}

class _RegisterSystemPage extends State<RegisterSystemPage> {
  final IAuthRepository authentication = AuthRepository();
  final Iauthentication = AuthRepository();
  final systemNameController = TextEditingController();
  final solarPanelCountController = TextEditingController();
  final solarPanelProductionController = TextEditingController();
  final batteryCapacityController = TextEditingController();
  ColorLabel? systemType;

  final supabase = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
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
        /* const Text("Solar System"), */
        //shows user name and password text boxes
        const SizedBox(height: 40),

        LoginPageTextField(
          controller: systemNameController,
          hintText: "System Name",
          obscureText: false,
          textType: TextInputType.text,
        ),
        const SizedBox(height: 20),
        LoginPageTextField(
          controller: solarPanelCountController,
          hintText: "Solar Panel Count",
          obscureText: false,
          textType:
              TextInputType.numberWithOptions(signed: false, decimal: false),
        ),
        const SizedBox(height: 20),

        LoginPageTextField(
          controller: solarPanelProductionController,
          hintText: 'Solar Panel Production',
          obscureText: false,
          textType:
              TextInputType.numberWithOptions(signed: false, decimal: true),
        ),
        const SizedBox(height: 20),

        LoginPageTextField(
          controller: batteryCapacityController,
          hintText: 'Battery Capacity',
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
        const SizedBox(height: 20),

        //creates Sign In button
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FilledButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(300, 70)),
              onPressed: () async {
                final systemName = systemNameController.text.trim();
                final panelCount = solarPanelCountController.text.trim();
                final productinCount =
                    solarPanelProductionController.text.trim();
                final batteryCapacity = batteryCapacityController.text.trim();

                //TODO upload to database
                try {
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
              child: const Text("Next")),
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('already have an account? '),
            Text(
              'Login now',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )
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
