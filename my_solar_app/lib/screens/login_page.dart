import 'package:flutter/material.dart';
import 'package:my_solar_app/widgets/authentication/text_field.dart';

class LoginPage extends StatelessWidget{
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome back!"),
            const SizedBox(height: 20),
            AuthenticationTextField(controller: usernameController, hintText: "Username", obscureText: false),
            const SizedBox(height: 20),
            AuthenticationTextField(controller: passwordController, hintText: 'Password', obscureText: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(padding: const EdgeInsets.fromLTRB(0, 5, 50, 0),
                  child: Text("Forgot Password?"))
                ],),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  FilledButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size(300,70)
                      ),
                      onPressed: ()=> "this", child: Text("Sign In")),
        ]
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Expanded(child: Divider(
                thickness: 0.5
              )),
                Text("Or continue with"),
                Expanded(child: Divider(
                    thickness: 0.5
                )),
            ],)
            ]
          ,

        )
      )
    );
  }
}