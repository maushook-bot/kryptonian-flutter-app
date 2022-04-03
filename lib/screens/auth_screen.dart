import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/screens/perspective_zoom_screen.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

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
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    right: deviceSize.width * 0.05,
                    top: deviceSize.height * 0.045,
                    left: deviceSize.width * 0.05,
                    bottom: deviceSize.height * 0.0,
                  ),
                  child: Image.asset(
                    'assets/images/shopping_1.png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                AuthCard(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  double _passStrength = 0.0;
  String _password;
  String _passStrengthId;
  String _displayText = '* Password Strength: ';
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  /// Animation Controller & Animations:-
  AnimationController _animationController;
  Animation<Size> _heightAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final deviceSize = MediaQuery.of(context).size;

    /// Animation Controller and Animations:-
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _heightAnimation = Tween<Size>(
      begin: Size(double.infinity, deviceSize.height * 0.67),
      end: Size(double.infinity, deviceSize.height * 0.72),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticInOut,
    ));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.decelerate),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _passStrength = 0;
        _passStrengthId = 'Empty';
        _displayText = '* Password Strength: $_passStrengthId';
      });
    } else if (_password.length < 6) {
      setState(() {
        _passStrength = 1 / 4;
        _passStrengthId = 'Weak';
        _displayText = '* Password Strength: $_passStrengthId';
      });
    } else if (_password.length < 8) {
      setState(() {
        _passStrength = 2 / 4;
        _passStrengthId = 'Medium';
        _displayText = '* Password Strength: $_passStrengthId';
      });
    } else {
      if (!letterReg.hasMatch(_password) || !numReg.hasMatch(_password)) {
        setState(() {
          // Password length >= 8
          // But doesn't contain both letter and digit characters
          _passStrength = 3 / 4;
          _passStrengthId = 'Strong';
          _displayText = '* Password Strength: $_passStrengthId';
        });
      } else {
        // Password length >= 8
        // Password contains both letter and digit characters
        setState(() {
          _passStrength = 1;
          _passStrengthId = 'Great';
          _displayText = '* Password Strength: $_passStrengthId';
        });
      }
    }
  }

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
        await Provider.of<Auth>(context, listen: false)
            .login(
                _authData['email'], _authData['password'], 'signInWithPassword')
            .then((_) => Navigator.of(context).pushNamed(
                ProductsOverviewScreen.routeName,
                arguments: ['', false]));
      } else {
        // TODO: Sign Up User
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password'], 'signUp')
            .then((_) => Navigator.of(context).pushNamed(
                ProductsOverviewScreen.routeName,
                arguments: ['', false]));
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
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Card(
        elevation: 400,
        shadowColor: Colors.deepPurpleAccent,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Color(0x192841).withOpacity(0.4),
        margin: EdgeInsets.only(
          right: deviceSize.width * 0.05,
          top: deviceSize.height * 0.04,
          left: deviceSize.width * 0.05,
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.decelerate,
          height: _authMode == AuthMode.SignUp
              ? deviceSize.height * 0.70
              : deviceSize.height * 0.67,
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.SignUp
                  ? deviceSize.height * 0.70
                  : deviceSize.height * 0.60),
          width: deviceSize.width * 0.95,
          padding: EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: deviceSize.width,
                    margin: EdgeInsets.only(
                      right: deviceSize.width * 0,
                      top: deviceSize.height * 0.00,
                      left: deviceSize.width * 0.005,
                      bottom: deviceSize.height * 0,
                    ),
                    child: Text(
                      _authMode == AuthMode.Login ? 'Login' : 'New User',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: deviceSize.width,
                    margin: EdgeInsets.only(
                      right: deviceSize.width * 0,
                      top: deviceSize.height * 0.0,
                      left: deviceSize.width * 0.005,
                      bottom: deviceSize.height * 0.03,
                    ),
                    child: Text(
                      _authMode == AuthMode.Login
                          ? 'Please SignIn to continue'
                          : 'Please create an account',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Enter Email',
                      focusColor: Colors.white,
                      fillColor: Colors.white,
                      icon: Icon(Icons.email_outlined, color: Colors.cyan),
                      labelStyle: TextStyle(color: Colors.white30),
                      hintStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                      errorStyle: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Email is empty schmuck!';
                      } else if (EmailValidator.validate(value) == false) {
                        return 'Email is invalid schmuck!';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) => _authData['email'] = value,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      icon: Icon(Icons.lock_outlined, color: Colors.cyan),
                      labelStyle: TextStyle(color: Colors.white30),
                      helperStyle: TextStyle(color: Colors.white30),
                      hintStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    onChanged: (value) => _checkPassword(value),
                    onSaved: (value) => _authData['password'] = value,
                  ),
                  AnimatedContainer(
                    constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                      maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                    ),
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          icon: Icon(Icons.lock_outlined, color: Colors.cyan),
                          labelStyle: TextStyle(color: Colors.white30),
                          hintStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
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
                                  return 'Passwords do not match schmuck!';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.5),
                  _authMode == AuthMode.SignUp
                      ? Container(
                          width: deviceSize.width,
                          padding: EdgeInsets.only(
                            top: deviceSize.height * 0,
                            right: deviceSize.width * 0.19,
                            left: deviceSize.width * 0.1,
                            bottom: deviceSize.height * 0.01,
                          ),
                          child: Text(_displayText,
                              style: TextStyle(
                                  color: Colors.white30, fontSize: 12)),
                        )
                      : Text(''),
                  _authMode == AuthMode.SignUp
                      ? Container(
                          width: deviceSize.width * 0.56,
                          child: LinearProgressIndicator(
                            minHeight: 1,
                            value: _passStrength,
                            color: _passStrength <= 1 / 4
                                ? Colors.red
                                : _passStrength == 2 / 4
                                    ? Colors.yellow
                                    : _passStrength == 3 / 4
                                        ? Colors.blue
                                        : Colors.green,
                            backgroundColor: Colors.blueGrey,
                          ),
                        )
                      : Text(''),
                  _authMode == AuthMode.SignUp
                      ? _buildPasswordHelper(context, deviceSize)
                      : Text(''),
                  SizedBox(height: 14),
                  _isLoading == true
                      ? CircularProgressIndicator()
                      : Container(
                          height: 50,
                          padding: EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 20,
                              onSurface: Colors.blueGrey,
                              fixedSize: const Size(199, 50),
                              primary: Colors.cyan,
                              onPrimary: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _passStrength >= 3 / 4 ? _submit : null,
                            child: Text(
                                _authMode == AuthMode.Login
                                    ? 'Login with Email'
                                    : 'Create an account',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                  TextButton(
                    onPressed: _toggleAuthMode,
                    child: Text(
                      _authMode == AuthMode.Login
                          ? 'Need an account? Register'
                          : 'Have an account? Sign in',
                      style: TextStyle(
                        color: Colors.cyan,
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

  Widget _buildPasswordHelper(BuildContext context, Size deviceSize) {
    return Container(
      padding: EdgeInsets.all(10),
      //margin: EdgeInsets.only(top: 10, left: 48, right: 45),
      margin: EdgeInsets.only(
        top: deviceSize.height * 0.015,
        left: deviceSize.height * 0.00,
        right: deviceSize.height * 0.0,
      ),
      constraints: BoxConstraints(
        minHeight: deviceSize.height * 0.05,
        minWidth: deviceSize.height * 0.75,
      ),
      color: Colors.blueGrey.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _passStrength >= 3 / 4
                    ? Icons.check_circle
                    : Icons.check_circle,
                size: 20,
                color: _passStrength >= 3 / 4
                    ? Colors.lightGreenAccent
                    : Colors.blueGrey,
              ),
              SizedBox(width: 5),
              Text(
                'Required: Must contain at least 8 characters',
                style: TextStyle(
                  fontSize: 12,
                  color: _passStrength >= 3 / 4
                      ? Colors.lightGreenAccent
                      : Colors.blueGrey,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                _passStrength >= 1 ? Icons.check_circle : Icons.check_circle,
                size: 20,
                color: _passStrength >= 1
                    ? Colors.lightGreenAccent
                    : Colors.blueGrey,
              ),
              SizedBox(width: 5),
              Text(
                'Optional: contains both letter and digits',
                style: TextStyle(
                  fontSize: 12,
                  color: _passStrength >= 1
                      ? Colors.lightGreenAccent
                      : Colors.blueGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
