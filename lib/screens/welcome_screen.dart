import 'package:flutter/material.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static String id = '/welcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Hero(
                tag: 'logo',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    '⚡',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Text(
                'Flash Chat',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 40, 50.0, 20),
            child: ElevatedButton(
              onPressed: () => {Navigator.pushNamed(context, LoginScreen.id)},
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue[300],
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Log in',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              onPressed: () =>
                  {Navigator.pushNamed(context, RegistrationScreen.id)},
              child: const Text(
                'Register',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
