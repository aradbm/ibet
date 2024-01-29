// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ibet/models/user.dart';
import 'package:ibet/services/firestore.dart';
import 'local_widgets/my_button.dart';
import 'local_widgets/my_textfield.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  // sign user in method
  void _submit() async {
    var email = emailController.text;
    var password = passwordController.text;
    try {
      if (_isLogin) {
        // ignore: unused_local_variable
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        // register user
        // ignore: unused_local_variable
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: email, password: password);

        // save user to firestore
        await FireStoreService().createUser(AppUser(
          userid: userCredentials.user!.uid,
          username: usernameController.text,
          points: 100,
        ));
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // show dialog with error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email already in use.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (error.code == 'user-not-found') {
        // show dialog with error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please check your email and password.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // use assets/icon.png
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    'assets/icon/icon.png',
                    height: 120,
                    // make round corners
                    color: Colors.white,
                    colorBlendMode: BlendMode.color,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                if (!_isLogin) ...[
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                ],
                const SizedBox(height: 35),
                MyButton(
                  onTap: _submit,
                  text: _isLogin ? 'Login' : 'Register',
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin ? 'Register now' : 'Login now',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
