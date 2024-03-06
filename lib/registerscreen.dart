import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:velbis_labwork/loginscreen.dart';

class RegisterSc extends StatefulWidget {
  const RegisterSc({super.key});

  @override
  State<RegisterSc> createState() => _RegisterScState();
}

class _RegisterScState extends State<RegisterSc> {
  bool hidePassword = true;
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  void toggleHidePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait...');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((user) {
        EasyLoading.dismiss();
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => const Login(),
          ),
        );
      }).catchError((error) {
        print('Registration Error: $error');
        String errorMessage =
            'An error occurred during registration. Please try again.';
        if (error is FirebaseAuthException) {
          errorMessage = error.message ?? errorMessage;
        }
        EasyLoading.showError(errorMessage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Email address'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required. Please enter your email';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                  controller: password,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: const Text('Password'),
                    suffixIcon: IconButton(
                      onPressed: toggleHidePassword,
                      icon: Icon(hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required. Please enter your password';
                    }
                    return null;
                  }),
              ElevatedButton(
                onPressed: login,
                child: const Text('Register'),
              ),
              const Text('Already have an account?'),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (_) => const Login()));
                  },
                  child: const Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}
