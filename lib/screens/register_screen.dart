import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../utils/email_validator.dart';
import '../utils/password_validator.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key? key,
    required this.onRegister,
    required this.onLogin,
  }) : super(key: key);

  final Function() onRegister;
  final Function() onLogin;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name.';
                    }
                    return null;
                  },
                  hitText: 'Name',
                ),
                const SizedBox(height: 8),
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
                context.watch<AuthProvider>().isRegistered
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomButton(
                        button: 'Elevated',
                        text: 'REGISTER',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final authRead = context.read<AuthProvider>();

                            await authRead.register(
                              nameController.text,
                              emailController.text,
                              passwordController.text,
                            );

                            if (authRead.registerResponse?.error == false) {
                              widget.onRegister();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Email is already taken'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                const SizedBox(height: 8),
                CustomButton(
                  button: 'Outlined',
                  text: 'LOGIN',
                  onPressed: () => widget.onLogin(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
