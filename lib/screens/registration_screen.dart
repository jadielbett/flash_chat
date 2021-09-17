import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static String id = '/RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String password = '';
  String email = '';
  String errorMessage = '';
  bool isLoading = false;
  bool errorMessageVisibility = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      '⚡',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 200.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: errorMessageVisibility,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                  child: Text(
                    '* $errorMessage',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 10),
                child: TextField(
                  onChanged: (String value) {
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                  textAlign: TextAlign.justify,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      color: Colors.black38,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(color: Colors.black87)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                child: TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: hidePassword,
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      onPressed: () {
                        hidePassword = !hidePassword;
                        setState(() {});
                      },
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    hintText: 'Create your password',
                    hintStyle: const TextStyle(
                      color: Colors.black38,
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(color: Colors.black87)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 18, 18, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    isLoading = true;
                    try {
                      // final UserCredential newUser =
                      await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);

                      isLoading = false;
                      Navigator.pushNamed(context, ChatScreen.id);
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        isLoading = false;
                        errorMessageVisibility = true;
                        errorMessage =
                            'Please fill in the relevant fields correctly';
                      });
                      if (e.code == 'weak-password') {
                        setState(() {
                          isLoading = false;
                          errorMessageVisibility = true;
                          errorMessage = 'The password provided is too weak';
                        });
                      } else if (e.code == 'email-already-in-use') {
                        setState(() {
                          isLoading = false;
                          errorMessageVisibility = true;
                          errorMessage = 'The account already exists';
                        });
                      }
                    }
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 22),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 60),
                    primary: Colors.blue,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    const Text(
                      'Already have an account,',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
