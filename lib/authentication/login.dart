import 'package:commit_me/themes.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//Other files
import 'package:commit_me/firebase/AppState.dart';

class LoginPage extends StatefulWidget {
  final AppState state;
  const LoginPage({super.key, required this.state});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  String? email;
  String? password;
  String errorMessage = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          ElevatedButton(
            onPressed: () => context.go('/login/signup'),
            child: const Text('Sign Up'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Login',
            style: headtitle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 50),
            child: Text(
              'Log In to continue',
              style: smalltext,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Email';
                        } else if (!EmailValidator.validate(value)) {
                          return 'Email Invalid';
                        }
                        email = value;
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        hintText: 'Email',
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Password';
                      } else if (value.length < 8) {
                        return 'Password Invalid';
                      }
                      password = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      hintText: 'Password',
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      errorMessage =
                          await widget.state.logIn(email!, password!);
                      if (errorMessage == '') {
                        _formKey.currentState!.reset();
                        setState(() {
                          context.go('/menu');
                        });
                      } else if (errorMessage ==
                          'The email or password is incorrect.') {
                        setState(() {});
                      } else {
                        setState(() {});
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
                Text(
                  errorMessage,
                  style: normaltext,
                ),
                Text(
                  'local user and firebase user in sync: ${widget.state.getCurrentUser().toString() == widget.state.getCurrentFirebaseUser().toString()}',
                ),
                Text(
                  widget.state.getCurrentUser().toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
