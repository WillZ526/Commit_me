import 'package:commit_me/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:commit_me/firebase/AppState.dart';
import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  final state;
  const SignUpPage({super.key, required this.state});

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Sign Up',
            style: headtitle
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email';
                      }
                      email = value;
                      return null;
                    }),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 8) {
                      return 'Password must have at least 8 characters';
                    }
                    password = value;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    child: Text('Sign Up'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        errorMessage = await widget.state.signUp(email, password);
                        if (errorMessage == '') {
                          _formKey.currentState!.reset();
                          setState(() {
                            context.go('/login');
                          });
                        } else {
                          setState(() {});
                        }
                      }
                    }),
                Text(
                  errorMessage,
                  style: normaltext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
