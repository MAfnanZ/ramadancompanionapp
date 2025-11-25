import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadancompanionapp/services/auth/presentation/provider/auth_provider.dart';
import 'package:ramadancompanionapp/widgets/custom_button.dart';
import 'package:ramadancompanionapp/widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({
    super.key,
    required this.togglePages,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //login button pressed
  void login() {
    final String email = emailController.text.trim();
    final String pw = passwordController.text.trim();

    // auth provider
    final authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    //ensure fields are filled
    if (email.isNotEmpty && pw.isNotEmpty) {
      //login user
      authProvider.login(email, pw);
    } else {
      //show error - fill all fields
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('LOGIN'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: Column(
              spacing: 25,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //app name
                Text(
                  'RAMADAN COMPANION',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 25),
                //email input
                CustomTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  isPassword: false,
                ),
                //password input
                CustomTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  isPassword: true,
                ),
                //login button
                CustomButton(
                  onPressed: login,
                  text: 'L O G I N',
                ),
                //register button
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    TextButton(
                      onPressed: widget.togglePages,
                      child: Text(
                        'Register now',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              color: Colors.limeAccent,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
