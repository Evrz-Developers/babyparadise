import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marginpoint/widgets/custom_text_form_field.dart';

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

  String _name = "";
  String _email = "";
  String _password = "";
  void _handlesignup() async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'User registered with mail: ${userCredential.user!.email}')),
        );
      }

      // Create user document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _name,
        'email': _email,
        'role': 'user', // Set default role
        // Additional user data fields can be added here
      });
      // UserCredential userCredential = await _auth
      //     .createUserWithEmailAndPassword(email: _email, password: _password);
      // print('user registered ${userCredential.user!.email}');
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/shop',
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      var errorMessage = "";
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
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
            content: Text('Please check the Credentials'),
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
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
                  'User signed in with Google: ${userCredential.user!.email}')),
        );
      }

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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google sign-in failed. Please try again.'),
          ),
        );
      }
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
              child: Text("Register",
                  style: TextStyle(
                      fontSize: 40.0,
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
                        const SizedBox(height: 10.0),
                        TextButton(
                          child: const Text("Existing user?",
                              style: TextStyle(color: Colors.blue)),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          },
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _handlesignup();
                              }
                            },
                            child: Text('Sign Up',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary))),
                        const SizedBox(height: 20.0),
                        SignInButton(
                          Buttons.google,
                          text: "Sign up with Google",
                          onPressed: _handleGoogleSignIn,
                        )
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
