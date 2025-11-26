import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadancompanionapp/pages/auth/auth_page.dart';
import 'package:ramadancompanionapp/pages/home/homepage.dart';
import 'package:ramadancompanionapp/services/auth/presentation/provider/auth_provider.dart';
import 'package:ramadancompanionapp/services/auth/presentation/provider/auth_states.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final state = authProvider.state;
        if (state is AuthInitial || state is AuthLoading) {
          return Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
            color: Colors.white,
          )));
        }

        //authenticated -> home page
        if (state is Authenticated) {
          return Homepage();
        }

        //unauthenticated -> auth page (login/register)
        if (state is Unauthenticated) {
          return AuthPage();
        }

        if (state is AuthError) {
          // show error snackbar once
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          });

          // fallback: show previous page (login/register or loading)
          return AuthPage();
        }

        return SizedBox();
      },
    );
  }
}
