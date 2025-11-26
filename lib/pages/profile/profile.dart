import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadancompanionapp/services/auth/presentation/provider/auth_provider.dart';
import 'package:ramadancompanionapp/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 17,
        children: [
          Center(
            child: Text(
              'Profile',
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  spacing: 25,
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          'Name: ',
                          style: textTheme.headlineLarge
                              ?.copyWith(
                                  color: Colors.black),
                        ),
                        Text(
                          authProvider.currentUser!.name,
                          style: textTheme.headlineLarge
                              ?.copyWith(
                                  fontWeight:
                                      FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          'Email: ',
                          style: textTheme.headlineLarge
                              ?.copyWith(
                                  color: Colors.black),
                        ),
                        Text(
                          authProvider.currentUser!.email,
                          style: textTheme.headlineLarge
                              ?.copyWith(
                                  fontWeight:
                                      FontWeight.bold),
                        ),
                      ],
                    ),
                    CustomButton(
                        text: 'L O G O U T',
                        onPressed: () =>
                            authProvider.logout()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
