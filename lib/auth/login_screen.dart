import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:babyparadise/auth/auth_service.dart';
import 'package:babyparadise/utils/firebase_utils.dart';
import 'package:babyparadise/widgets/forgot_password_dialog.dart';
import 'package:get/get.dart';
import 'package:babyparadise/services/user_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserController userController = Get.find();
  bool showSpinner = false;

  String _email = "";
  String _password = "";

  void _handleSignIn() async {
    try {
      setState(() {
        showSpinner = true;
      });
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      if (_auth.currentUser != null) {
        await _handleUserRole();
      }
    } on FirebaseAuthException catch (e) {
      var errorMessage = "";
      if (e.code == 'invalid-email' || e.code == 'invalid-credential') {
        errorMessage = 'Invalid email or password';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password, please try again';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This user has been disabled';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many requests, please try again later';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Signing in with email and password is not enabled';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nope! $errorMessage '),
          ),
        );
      }
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  Future<void> _handleUserRole() async {
    Map<String, dynamic>? userData = await getUserDetails();
    if (userData != null && !userData.containsKey('role')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Not registered yet? Let\'s sign up.'),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
            context, '/register', (route) => false);
      }
      return;
    }
    userController.setUserDetails(
        isLoggedIn: true,
        id: userData?['userId'],
        role: userData?['role'],
        name: userData?['name'],
        email: userData?['email']);
  
    String? userRole = userData?['role'];
    // ignore: avoid_print
    print("userRole $userData");

    if (userRole == 'admin') {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/admin', (route) => false);
      }
    } else if (userRole == 'staff') {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/staff', (route) => false);
      }
    } else if (userRole == 'user') {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/shop', (route) => false);
      }
    } else {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/register', (route) => false);
      }
    }
    // Not showing welcome message
    // if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Welcome aboard..'),
    //     ),
    //   );
    // }
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ForgotPasswordDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      appBar: AppBar(
          // title: const Text('Log in'),
          ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text("Baby Paradise",
                  style: TextStyle(
                      fontSize: 32.0,
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
                                : "Continue with Google", 
                            onPressed: () async {
                              setState(() {
                                showSpinner = true; // Show loader
                              });
                              User? user =
                                  await _authService.signInWithGoogle();
                              if (user != null) {
                                await _handleUserRole();
                              }
                              setState(() {
                                showSpinner = false; // Hide loader
                              });
                            },
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

                        TextFormField(
                          cursorColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [
                            AutofillHints.email
                          ], // Enable autofill for email

                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          cursorColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                        ),
                        // const SizedBox(
                        //   height: 10.0,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _handleForgotPassword,
                              child: const Text("Forgot Password?",
                                  style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10.0,
                        ),
                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  showSpinner = true;
                                });
                                _handleSignIn();
                              }
                            },
                            child: showSpinner
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context)
                                              .colorScheme
                                              .inversePrimary),
                                      strokeWidth: 1,
                                    ),
                                  )
                                : Text('Login',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface)),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextButton(
                          child: const Text("Don't have an account? Sign up",
                              style: TextStyle(color: Colors.blue)),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/register', (route) => false);
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
