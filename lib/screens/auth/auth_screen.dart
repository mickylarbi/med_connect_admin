import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/screens/home/tab_view.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_text_span.dart';
import 'package:med_connect_admin/screens/shared/custom_textformfield.dart';
import 'package:med_connect_admin/screens/shared/header_text.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class AuthScreen extends StatefulWidget {
  final AuthType authType;
  const AuthScreen({Key? key, required this.authType}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // SystemChannels.textInput.invokeMethod('TextInput.hide');
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                children: [
                  Hero(
                    tag: kLogoTag,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: (kScreenWidth(context) - 96) * 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const HeaderText(text: 'Admin'),
                  const SizedBox(height: 100),
                  CustomTextFormField(
                    controller: _emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  PasswordTextFormField(controller: _passwordController),
                  if (widget.authType == AuthType.signUp)
                    const SizedBox(height: 20),
                  if (widget.authType == AuthType.signUp)
                    PasswordTextFormField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password'),
                  const SizedBox(height: 50),
                  CustomFlatButton(
                    onPressed: () {
                      if (_emailController.text.trim().isEmpty ||
                          _passwordController.text.isEmpty ||
                          (widget.authType == AuthType.signUp &&
                              _confirmPasswordController.text.isEmpty)) {
                        showAlertDialog(context,
                            message: 'One or more fields are empty');
                      } else if (!_emailController.text.trim().contains(RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                        showAlertDialog(context,
                            message: 'Email address is invalid');
                      } else if (widget.authType == AuthType.signUp &&
                          (_passwordController.text !=
                              _confirmPasswordController.text)) {
                        showAlertDialog(context,
                            message: 'Passwords do not match');
                      } else if (_passwordController.text.length < 6) {
                        showAlertDialog(context,
                            message:
                                'Password should not be less than 6 characters');
                      } else {
                        if (widget.authType == AuthType.login) {
                          _auth.signIn(
                            context,
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                          );
                        } else {
                          _auth.signUp(context,
                              email: _emailController.text.trim(),
                              password: _passwordController.text);
                        }
                      }
                    },
                    child: Text(widget.authType == AuthType.login
                        ? 'Login'
                        : 'Sign Up'),
                  ),
                  const SizedBox(height: 30),
                  CustomTextSpan(
                    firstText: widget.authType == AuthType.login
                        ? "Don't have an account?"
                        : 'Already have an account?',
                    secondText:
                        widget.authType == AuthType.login ? 'Sign up' : 'Login',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthScreen(
                            authType: widget.authType == AuthType.login
                                ? AuthType.signUp
                                : AuthType.login,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

enum AuthType { login, signUp }

class AuthWidget extends StatelessWidget {
  AuthWidget({Key? key}) : super(key: key);
  final AuthService _authenticationService = AuthService();

  @override
  Widget build(BuildContext context) {
    if (_authenticationService.currentUser == null) {
      return const AuthScreen(authType: AuthType.login);
    }

    return const TabView();
  }
}
