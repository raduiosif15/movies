import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/models/index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;

  void _onResult(AppAction action) {
    setState(() {
      _isLoading = false;
    });
    if (action is ErrorAction) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${action.error}')));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email.';
                      }

                      if (!value.contains('@')) {
                        return 'Please enter a valid email.';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _password,
                    decoration:  InputDecoration(
                      labelText: 'password',
                      suffix: IconButton(
                        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() => _obscureText = !_obscureText);
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password.';
                      }

                      if (value.length < 6) {
                        return 'Please enter a longer password.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 32.0),
                  Builder(
                    builder: (BuildContext context) {
                      if (_isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return TextButton(
                        child: const Text('Login'),
                        onPressed: () {
                          if (!Form.of(context)!.validate()) {
                            return;
                          }

                          setState(() => _isLoading = true);
                          StoreProvider.of<AppState>(context)
                              .dispatch(Register(_email.text, _password.text, _onResult));
                        },
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
}
