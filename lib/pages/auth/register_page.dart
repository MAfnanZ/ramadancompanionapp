import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadancompanionapp/services/auth/presentation/provider/auth_provider.dart';
import 'package:ramadancompanionapp/widgets/custom_button.dart';
import 'package:ramadancompanionapp/widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({
    super.key,
    required this.togglePages,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controllers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //register button pressed
  void register() {
    //prepare info
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String pw = passwordController.text.trim();
    final String confirmPw =
        confirmPasswordController.text.trim();

    // auth provider
    final authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    //ensure fields are filled
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        pw.isNotEmpty &&
        confirmPw.isNotEmpty) {
      //ensure passwords match
      if (pw == confirmPw) {
        //register user
        authProvider.register(
          name,
          email,
          pw,
        );
      } else {
        //show error - passwords do not match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: Passwords do not match"),
            backgroundColor: Colors.red,
          ),
        );
      }
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
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('REGISTER'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: Column(
              spacing: 15,
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
                CustomTextfield(
                  controller: nameController,
                  hintText: 'Name',
                  isPassword: false,
                ),
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
                //confirm password input
                CustomTextfield(
                  controller: confirmPasswordController,
                  hintText: 'ConfirmPassword',
                  isPassword: true,
                ),
                //register button
                CustomButton(
                  onPressed: register,
                  text: 'R E G I S T E R',
                ),
                //login button
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have an account? ",
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
                        'Login now',
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
