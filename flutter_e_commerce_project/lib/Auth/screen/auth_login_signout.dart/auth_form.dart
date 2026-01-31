import 'package:e_commerce/Auth/service/auth_service.dart';
import 'package:e_commerce/Auth/screen/user_form/admin_screen.dart';
import 'package:e_commerce/Product/Home_Screen/home_screen.dart';
import 'package:e_commerce/Auth/model/user.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String? _authError;
  var _email = '';
  var _username = '';
  var _password = '';
  bool _isLogin = true;
  bool _isLoading = false; // for loading indicator

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      height: media.height,
      width: media.width,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildEmailForm(),
                  if (!_isLogin) const SizedBox(height: 20),
                  if (!_isLogin) _buildUsernameForm(),
                  const SizedBox(height: 20),
                  _buildPasswordForm(),

                  // error message
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _authError == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: media.width * 0.9,
                                  child: Text(
                                    _authError!,
                                    key: ValueKey(_authError),
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                  ),
                  _buildTextFieldButton(),
                  _buildSubmit(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildTextFieldButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
            });
          },
          child: Text(
            _isLogin
                ? 'Create new account or sign up'
                : 'I already have account',
          ),
        ),
      ],
    );
  }

  ElevatedButton _buildSubmit() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(0, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: _isLoading ? null : _submitForm,
      label: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              _isLogin ? 'Login' : 'Sign Up',
              style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 14),
            ),
      icon: Icon(
        _isLogin ? Icons.login : Icons.create,
        color: Colors.white,
      ),
    );
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
      _authError = null;
    });

    final authService = AuthService();

    try {
      User? user;

      if (_isLogin) {
        // Login
        user = await authService.login(_email, _password);

        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome ${user.username}!')),
          );

          // Navigate according to role
          if (user.role == 'ADMIN') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminScreen(adminEmail: _email),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          }
        }
      } else {
        // Sign up
        user = await authService.register(_username, _email, _password);

        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Account created! Welcome ${user.username}')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        }
      }
    } catch (e) {
      setState(() {
        _authError = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  TextFormField _buildEmailForm() {
    return TextFormField(
      validator: (text) {
        if (text!.isEmpty) return 'Email is Required';
        if (!EmailValidator.validate(text)) return 'Email format is correct';
        return null;
      },
      onSaved: (text) => _email = text!,
      key: const ValueKey('email'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        labelText: 'Email',
        hintText: 'Enter your email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  TextFormField _buildUsernameForm() {
    return TextFormField(
      validator: (text) {
        if (text!.isEmpty) return 'Username is Required';
        if (!RegExp(r'^[a-z]+$').hasMatch(text)) {
          return 'Username only contains lowercase';
        }
        return null;
      },
      onSaved: (text) => _username = text!,
      key: const ValueKey('username'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        labelText: 'Username',
        hintText: 'Enter your username',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  TextFormField _buildPasswordForm() {
    return TextFormField(
      obscureText: true,
      validator: (text) {
        if (text!.isEmpty) return 'Password is Required';
        if (text.length < 8) return 'Password should have at least 8 chars';
        return null;
      },
      onSaved: (text) => _password = text!,
      key: const ValueKey('password'),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        labelText: 'Password',
        hintText: 'Enter your password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
