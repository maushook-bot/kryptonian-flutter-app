import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:flutter_complete_guide/pallete/purplay.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/screens/perspective_zoom_screen.dart';
import 'package:provider/provider.dart';

enum AuthMode { Login, SignUp }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          PerspectiveZoomScreen(),
          Card(
            elevation: 20.4,
            shadowColor: Purplay.kToDark.shade50,
            color: Colors.black.withOpacity(0.5),
            margin: EdgeInsets.only(
              right: deviceSize.width * 0.05,
              top: deviceSize.height * 0.15,
              left: deviceSize.width * 0.05,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 0,
                    child: Image.asset(
                      'assets/images/cart-purple-removebg-preview.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Kryptonian Boutique',
                    style: TextStyle(
                      color: Purplay.kToDark.shade400,
                      fontFamily: 'Lato',
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              heightFactor: 2.5,
            ),
          ),
          AuthCard(),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _form = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    print('Inside ShowAlertDialog');
    showDialog<Null>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('An Error has Occurred', textAlign: TextAlign.center),
          content: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text('$message', textAlign: TextAlign.center),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Close'),
            )
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // TODO: Log User In
        await Provider.of<Auth>(context, listen: false).login(
            _authData['email'], _authData['password'], 'signInWithPassword');
      } else {
        // TODO: Sign Up User
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password'], 'signUp');
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed!';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This Email is already in use!';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Cannot find this Email. Signup or Try later!';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Password Invalid. Try Again!';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Password is too weak!';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid Email!';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Authentication Failed. Try again Later!';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 30,
      color: Purplay.kToDark.shade50.withOpacity(0.6),
      margin: EdgeInsets.only(
        right: deviceSize.width * 0.05,
        top: deviceSize.height * 0.30,
        left: deviceSize.width * 0.05,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter Email',
                      icon: Icon(Icons.email_outlined),
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Email is Empty Schmuck!';
                      } else if (!value.contains('@') ||
                          !value.contains('.') ||
                          !value.contains('com')) {
                        return 'Invalid Email!';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) => _authData['email'] = value,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      icon: Icon(Icons.password_rounded),
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password is Empty Schmuck!';
                      } else if (value.length < 2) {
                        return 'Password Strength: Weak';
                      } else if (value.length < 4) {
                        return 'Password Strength: Medium';
                      } else if (value.length < 8) {
                        return 'Password Strength: okay';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) => _authData['password'] = value,
                  ),
                  _authMode == AuthMode.Login
                      ? Text('')
                      : TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            icon: Icon(Icons.password_rounded),
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          validator: _authMode == AuthMode.SignUp
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not Match Schmuck!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                  SizedBox(height: 14),
                  _isLoading == true
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal[700],
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _submit,
                          child: Text(_authMode == AuthMode.Login
                              ? 'Sign in with Email'
                              : 'Create an account'),
                        ),
                  TextButton(
                    onPressed: _toggleAuthMode,
                    child: Text(
                      _authMode == AuthMode.Login
                          ? 'Need an account? Register'
                          : 'Have an account? Sign in',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
