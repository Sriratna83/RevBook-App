import 'package:revbook_app/models/user.dart';
import 'package:revbook_app/viewModel/auth_view_model.dart';
import 'package:revbook_app/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatefulWidget {
  static const String routeName = "AuthScreen";
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(238, 174, 202, 1).withOpacity(0.3),
                  const Color.fromRGBO(179, 213, 190, 1).withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  AuthForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  bool _isSignIn = true;
  bool _isLoading = false;

  late final FocusNode _fieldPassword;
  late final FocusNode _fieldRepeatPassword;

  late final User _auth;

  @override
  void initState() {
    _auth = User();
    _fieldPassword = FocusNode();
    _fieldRepeatPassword = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _fieldPassword.dispose();
    _fieldRepeatPassword.dispose();
    // _passwordController.dispose();

    super.dispose();
  }

  void _toggleAuth() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  void _submit() async {
    try {
      if (!_form.currentState!.validate()) return;

      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthViewModel>(context, listen: false);

      if (_isSignIn) {
        await authProvider.signIn(_auth.email!, _auth.password!);
      } else {
        await authProvider.signUp(_auth.email!, _auth.password!);
      }
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  initialValue: _auth.email,
                  onChanged: (v) {
                    _auth.email = v;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_fieldPassword);
                  },
                  validator: (v) {
                    if (v!.isEmpty) return "Field is empty";
                    if (v.length < 6 && v.length > 20) {
                      return "must be at least 6 characters and don't be at 20";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      // borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  obscureText: true,
                  // controller: _
                  // passwordController,
                  initialValue: _auth.password,
                  focusNode: _fieldPassword,
                  onFieldSubmitted: (_) {
                    if (_isSignIn) {
                      _submit();
                    } else {
                      FocusScope.of(context).requestFocus(_fieldRepeatPassword);
                    }
                  },
                  onChanged: (v) {
                    _auth.password = v;
                  },
                  textInputAction:
                      _isSignIn ? TextInputAction.done : TextInputAction.next,
                  validator: (v) {
                    if (v!.isEmpty) return "Field is empty";
                    if (v.length < 6 || v.length > 20) {
                      return "must be at least 6 characters and don't be at 20";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.grey,
                      ),
                      // borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      // borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),

                // if (!_isSignIn)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, -1.2),
                        end: const Offset(0, 0),
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: _isSignIn
                      ? Container()
                      : TextFormField(
                          obscureText: true,
                          focusNode: _fieldRepeatPassword,
                          initialValue: _auth.repeatPassword,
                          onChanged: (v) {
                            _auth.repeatPassword = v;
                          },
                          textInputAction: TextInputAction.done,
                          validator: (v) {
                            if (v!.isEmpty) return "Field is empty";
                            if (v.length < 6 || v.length > 20) {
                              return "must be at least 6 characters and don't be at 20";
                            }

                            if (_auth.password != _auth.repeatPassword) {
                              return "password in this field doesn't equal";
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Repeat password',
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 16 * 2,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )
                            : Text(
                                _isSignIn ? "Sign In" : "Sign Up",
                                style: const TextStyle(fontSize: 20),
                              ),
                      ),
                    ),
                    onPressed: _submit,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextButton(
                  child: Text(
                    !_isSignIn ? "Sign In" : "Sign Up",
                  ),
                  onPressed: _isLoading ? null : _toggleAuth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
