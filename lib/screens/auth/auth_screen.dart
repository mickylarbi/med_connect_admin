import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_connect_admin/screens/home/tab_view.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_text_span.dart';
import 'package:med_connect_admin/screens/shared/custom_textformfield.dart';
import 'package:med_connect_admin/screens/shared/header_text.dart';
import 'package:med_connect_admin/utils/constants.dart';

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
                  const CustomTextFormField(
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
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const TabView()),
                      //     (route) => false);
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
                  const SizedBox(height: 30),
                  Row(
                    children: const [
                      Expanded(child: Divider(height: 40, thickness: 2)),
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider(height: 40, thickness: 2)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const GoogleButton(),
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
