import 'package:firebase_auth/firebase_auth.dart';
import 'package:marginpoint/utils/firebase_utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool showSpinner = false;

  String _email = "";
  String _password = "";
  void _handleSignIn() async {
    try {
      // Show loader when login starts
      setState(() {
        showSpinner = true;
      });
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      // Fetch user data from Firestore
      if (_auth.currentUser != null) {
        Map<String, dynamic>? userData = await getUserDetails();
        String? userRole = userData!['role'];
        print("userRole $userRole");
        // Navigate to appropriate page based on user role
        if (userRole == 'admin') {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/admin', (route) => false);
          }
        } else if (userRole == 'staff') {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/staff', (route) => false);
          }
        } else {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/shop', (route) => false);
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully logged in!'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
          ),
        );
      }
      // Handle login failure if needed
    } finally {
      // Hide loader after login completes (whether successful or not)
      setState(() {
        showSpinner = false;
      });
      // }
      // .then((value) {
      // Handle successful login
      // print('Successfully Logged in');
      // setState(() {
      //   showSpinner = false;
      // });
      // Navigator.pushNamed(context, '/shop');
    }

    // on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     print('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     print('Wrong password provided for that user.');
    //   }
    // catch (e) {
    //   print(e);
    // }
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
              child: Text("Login",
                  style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.inverseSurface)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          cursorColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
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
                        SizedBox(height: 20),
                        TextFormField(
                          cursorColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
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
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextButton(
                          child: Text("New User?",
                              style: TextStyle(color: Colors.blue)),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/register', (route) => false);
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                          ),
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            if (_formKey.currentState!.validate()) {
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
                                          .inversePrimary)),
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
