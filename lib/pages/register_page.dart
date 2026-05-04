// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_social_app/components/my_button.dart';
import 'package:minimal_social_app/components/my_textfield.dart';
import 'package:minimal_social_app/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  // register method
  void register() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // make sure password match
    if (passwordController.text != confirmPwController.text) {
      // pop loading circle
      Navigator.pop(context);

      // show error message to user
      displayMessageToUser("Passwords don't match", context);
    }
    // if passwords do match
    else {
      // try creating the user
      try {
        // create the user
        // ignore: unused_local_variable
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );

        // create a user document and add to firestore
        createUserDocument(userCredential);

        //  pop loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop loading circle
        Navigator.pop(context);

        // display error message to user
        displayMessageToUser(e.code, context);
      }
    }
  }

  // create a user document and collect them in Firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
            'email': userCredential.user!.email,
            'username': usernameController.text,
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.people_alt_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.secondary,
              ),

              const SizedBox(height: 25),

              // app name
              Text(
                "A U R A",
                style: GoogleFonts.urbanist(textStyle: TextStyle(fontSize: 20)),
              ),

              const SizedBox(height: 50),

              //  username textfeild
              MyTextfield(
                hintText: "Username",
                obscureText: false,
                controller: usernameController,
              ),

              const SizedBox(height: 10),

              //  email textfeild
              MyTextfield(
                hintText: "Email",
                obscureText: false,
                controller: emailController,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextfield(
                hintText: "Password",
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10),

              // confirm pasword textfield
              MyTextfield(
                hintText: "Confirm Password",
                obscureText: true,
                controller: confirmPwController,
              ),
              const SizedBox(height: 10),

              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // register button
              MyButton(text: "Register", onTap: register),
              const SizedBox(height: 25),

              // already have an account? register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Login Here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
