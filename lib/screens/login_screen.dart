import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../utils/email_validator.dart';
import '../utils/password_validator.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
    required this.onLogin,
    required this.onRegister,
  }) : super(key: key);

  final Function() onLogin;
  final Function() onRegister;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextFormField(
                  controller: emailController,
                  validator: emailValidator,
                  keyboardType: TextInputType.emailAddress,
                  hitText: 'Email',
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: passwordController,
                  validator: passwordValidator,
                  hitText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                context.watch<AuthProvider>().isLoggedIn
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomButton(
                        button: 'Elevated',
                        text: 'LOGIN',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final authRead = context.read<AuthProvider>();

                            await authRead.login(
                              emailController.text,
                              passwordController.text,
                            );

                            if (authRead.loginResponse?.error == false) {
                              widget.onLogin();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid Email or Password'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                const SizedBox(height: 8),
                CustomButton(
                  button: 'Outlined',
                  text: 'REGISTER',
                  onPressed: () => widget.onRegister(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
