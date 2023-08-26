import 'package:flutter/material.dart';
import 'package:my_solar_app/widgets/authentication/square_tile_images.dart';
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
            Image.asset('assets/images/my_solar_logo.png',scale: 3,),
            Text("Welcome back!"),
            //shows user name and password text boxes
            const SizedBox(height: 40),
            LoginPageTextField(controller: usernameController, hintText: "Username", obscureText: false),
            const SizedBox(height: 20),
            LoginPageTextField(controller: passwordController, hintText: 'Password', obscureText: true),

            //aligns password to the right
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(padding: const EdgeInsets.fromLTRB(0, 5, 50, 0),
                  child: Text("Forgot Password?"))
                ],),
            const SizedBox(height: 20),

            //creates Sign In button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  FilledButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size(300,70)
                      ),
                      //TODO: change this lambda function
                      onPressed: ()=> "this", child: Text("Sign In")),
        ]
            ),
            const SizedBox(height: 25),

            //creates divider with text continue with
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Or continue with"),
            ],)
            ,
          const SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SquareImageTile(imagePath: 'assets/images/google.png'),
              SizedBox(width: 40),
              SquareImageTile(imagePath: 'assets/images/apple.png')
            ],
          ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member? '
                ),
                Text(
                  'Register now',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            )
          ]
          ,

        )
      )
    );
  }
}