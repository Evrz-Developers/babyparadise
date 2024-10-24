import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:babyparadise/widgets/custom_text_form_field.dart';
import 'package:get/get.dart';
import 'package:babyparadise/services/user_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showSpinner = false;

  String _name = "";
  String _email = "";
  String _password = "";

  final UserController userController = Get.put(UserController());

  void _handlesignup() async {
    try {
      setState(() {
        showSpinner = true;
      });
      
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Registered with ${userCredential.user!.email}')),
        );
      }

      // Creating user document in Firestore for the user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _name,
        'email': _email,
        'role': 'user', // Set default role
        // Additional user data fields can be added here
      });
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/shop',
          (route) => false,
        );
      }
      // Once user is registered, save the user details to the controller
      userController.setUserDetails(
          isLoggedIn: true,
          id: userCredential.user!.uid,
          role: 'user',
          name: _name,
          email: _email);
    } on FirebaseAuthException catch (e) {
      var errorMessage = "An error occurred";
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Email/password accounts are not enabled.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many requests. Try again later.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Oops.. Please check the Credentials'),
          ),
        );
      }
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() {
        showSpinner = true; // Show loader
      });
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Sign out any previously signed-in account
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          showSpinner = false; // Hide loader
        });
        return; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);


      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Welcome aboard, ${googleUser.displayName}'),
          ),
        );
      }
      userController.setUserDetails(
          isLoggedIn: true,
          id: userCredential.user!.uid,
          role: 'user',
          name: googleUser.displayName ?? '',
          email: googleUser.email);

      // Create user document in Firestore if it doesn't exist
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid);
      final userSnapshot = await userDoc.get();
      if (!userSnapshot.exists) {
        await userDoc.set({
          'name': googleUser.displayName,
          'email': googleUser.email,
          'role': 'user', // Set default role
        });
      }

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/shop',
          (route) => false,
        );
      }
      setState(() {
        showSpinner = false; // Hide loader
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Uh oh.. Google sign-in failed. Please try again.'),
          ),
        );
      }
      setState(() {
        showSpinner = false; // Hide loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      appBar: AppBar(
          // title: const Text('Sign Up'),
          ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text("Welcome",
                  style: TextStyle(
                      fontSize: 34.0,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.inverseSurface)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: SignInButton(
                            Buttons.google,
                            text: showSpinner
                                ? "Please hold on..."
                                : "Sign up with Google",
                            onPressed: _handleGoogleSignIn,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "or",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        CustomTextFormField(
                          controller: _nameController,
                          labelText: 'Name',
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            setState(() {
                              _name = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: _emailController,
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [
                            AutofillHints.email
                          ], // Pass autofill hints for email

                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: _passwordController,
                          labelText: 'Password',
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: 
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                _handlesignup();
                              }
                            },
                              child: showSpinner
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary),
                                        strokeWidth: 1,
                                      ),
                                    )
                                  : Text('Sign Up',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                              .inversePrimary))),
                        ),
                        const SizedBox(height: 20.0),
                        TextButton(
                          child: const Text("Existing user? Login!",
                              style: TextStyle(color: Colors.blue)),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          },
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
