import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:velbis_labwork/home.dart';
import 'package:velbis_labwork/registerscreen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = TextEditingController();
  var password = TextEditingController();
  bool showPassword = true;
  final _Formkey = GlobalKey<FormState>();

  void toggleShowPass() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void login() async {
    if (_Formkey.currentState!.validate()) {
      EasyLoading.show(status: "Processing...");
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) {
        EasyLoading.dismiss();
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (_) => const HomeScreen()),
        );
      }).catchError((error) {
        print('ERROR $error');
        EasyLoading.showError('Incorrect Email and Password');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: _Formkey,
        child: Column(
          children: [
            TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  label: Text('Email'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required Email';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Please Enter Valid Email';
                  }
                  return null;
                }),
            TextFormField(
              obscureText: showPassword,
              controller: password,
              decoration: InputDecoration(
                label: Text('Password'),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: toggleShowPass,
                  icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required Password';
                }

                if (value.length <= 5) {
                  return 'Password is Incorrect';
                }
                return null;
              },
            ),
            ElevatedButton(onPressed: login, child: Text('LOGIN')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No account?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterSc(),
                          ));
                    },
                    child: Text('Register'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
