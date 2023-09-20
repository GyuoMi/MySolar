import 'package:flutter/material.dart';
import 'package:my_solar_app/screens/login_page.dart';
import 'package:my_solar_app/widgets/authentication/square_tile_images.dart';
import 'package:my_solar_app/widgets/authentication/text_field.dart';
import 'package:my_solar_app/cloud_functions/authentication/interfaces/auth_repository_interface.dart';

class TrackingPage extends StatelessWidget {
  TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (true) ...[
          Image.asset(
            'assets/images/empty_page.png',
            scale: 3,
          ),
          const SizedBox(height: 20),
          const Text(
            "So much blank space.",
            style: TextStyle(fontWeight: FontWeight.bold),
            textScaleFactor: 1.25,
          ),
          const SizedBox(height: 20),
          const Text("Let's fill it with excitement!"),
          const SizedBox(height: 40),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FilledButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(300, 70)),
                onPressed: () {
                  //TODO: change LoginPage to devices page
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: const Text("Add Devices")),
          ]),
        ] //if
        else ...[
          const Text("Welcome back!"),

          //create save button
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FilledButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(300, 70)),
                //TODO: change this lambda function
                onPressed: () => "this",
                child: const Text("Save")),
          ]),
        ], //else
      ],
    )));
  }
}
