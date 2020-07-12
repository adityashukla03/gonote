import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gonote/service/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final AuthService _authService = AuthService();
  final _loginForm = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loggingIn = false;
  String _errorMessage;
  bool _useEmailSignIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Colors.white30],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            )
        ),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 560,
              ),
              padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 48),
              child: Form(
                key: _loginForm,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 32),
                    const Text(
                      'Go Note',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_useEmailSignIn) ..._buildEmailSignInFields(),
                    if (!_useEmailSignIn) ..._buildGoogleSignInFields(),
                    if (_errorMessage != null) _buildLoginMessage(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGoogleSignInFields() => [
        RaisedButton(
          color: Colors.white70,
          padding: const EdgeInsets.all(0),
          onPressed: _signInWithGoogle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset('assets/images/google.png', width: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40 / 1.618),
                child: const Text('Continue with Google'),
              ),
            ],
          ),
        ),
        FlatButton(
          child: Text('Sign in with email'),
          onPressed: () => setState(() {
            _useEmailSignIn = true;
          }),
        ),
        if (_loggingIn)
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 12),
            child: const CircularProgressIndicator(backgroundColor: Colors.black,),
          ),
      ];

  List<Widget> _buildEmailSignInFields() => [
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'Email',
          ),
          validator: (value) =>
              value.isEmpty ? 'Please input your email' : null,
        ),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
            hintText: 'Password',
          ),
          validator: (value) =>
              value.isEmpty ? 'Please input your password' : null,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        _buildEmailSignInButton(),
        if (_loggingIn) const LinearProgressIndicator(),
        FlatButton(
          child: Text('Use Google Sign In'),
          onPressed: () => setState(() {
            _useEmailSignIn = false;
          }),
        ),
      ];

  Widget _buildEmailSignInButton() => RaisedButton(
        onPressed: _signInWithEmail,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          child: const Text('Sign in / Sign up'),
        ),
      );

  Widget _buildLoginMessage() => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 18),
        child: Text(
          _errorMessage,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.red,
          ),
        ),
      );

  void _signInWithGoogle() async {
    _setLoggingIn();
    String errMsg;
    try {
      final result = await _authService.signInWithGoogle();
      print(result);
    } catch (e) {
      debugPrint('google signIn failed: $e');
      errMsg = 'Login failed, please try again later.';
      _setLoggingIn(false, errMsg);
    }
  }

  void _signInWithEmail() async {
    if (_loginForm.currentState?.validate() != true) return;

    FocusScope.of(context).unfocus();
    String errMsg;
    try {
      _setLoggingIn();
      final result =
          await _authService.loginWithEmailPwd(_emailController.text, _passwordController.text);
      if (result is PlatformException && result.code == 'ERROR_USER_NOT_FOUND') {
        try{
          final result = await _authService.registerwithEmailPwd(_emailController.text, _passwordController.text);
          if (result == null) {
            errMsg = 'Login failed, please try again later.';
            _setLoggingIn(false, errMsg);
          } else {
            errMsg = '';
            _setLoggingIn(false, errMsg);
          }
        } catch (e) {
          debugPrint('login failed: $e');
          errMsg = e.message;
          _setLoggingIn(false, errMsg);
        }
      } else {
        errMsg = 'Login failed, please try again later.';
        _setLoggingIn(false, errMsg);
      }
    } catch (e) {
      debugPrint('login failed: $e');
      errMsg = 'Login failed, please try again later.';
      _setLoggingIn(false, errMsg);
    }
  }

  void _setLoggingIn([bool loggingIn = true, String errMsg]) {
    if (mounted) {
      setState(() {
        _loggingIn = loggingIn;
        _errorMessage = errMsg;
      });
    }
  }
}
