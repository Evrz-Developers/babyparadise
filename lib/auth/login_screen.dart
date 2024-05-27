import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marginpoint/auth/auth_service.dart';
import 'package:marginpoint/utils/firebase_utils.dart';

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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
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
    if (userData == null || !userData.containsKey('role')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User role not found. Please sign up.'),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
            context, '/register', (route) => false);
      }
      return;
    }
    String? userRole = userData['role'];
    print("userRole $userData");

    if (userRole == 'admin') {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/admin', (route) => false);
      }
    } else if (userRole == 'staff') {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/staff', (route) => false);
      }
    } else {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/shop', (route) => false);
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
                  padding: const EdgeInsets.all(16),
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
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextButton(
                          child: const Text("New User?",
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
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            User? user = await _authService.signInWithGoogle();
                            if (user != null) {
                              await _handleUserRole();
                            }
                          },
                          child: Text("Google Sign in",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary)),
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
