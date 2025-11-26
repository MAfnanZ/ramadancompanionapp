import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadancompanionapp/services/api/presentation/provider/prayer_provider.dart';
import 'package:ramadancompanionapp/services/auth/presentation/provider/auth_provider.dart';
import 'package:ramadancompanionapp/widgets/custom_button.dart';
import 'package:ramadancompanionapp/widgets/custom_textfield.dart';
import 'package:ramadancompanionapp/widgets/custom_tile.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() =>
      _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  //text editing controllers
  final cityController = TextEditingController();
  final countryController = TextEditingController();

  // get times button pressed
  void getTimes() {
    final String city = cityController.text.trim();
    final String country = countryController.text.trim();
    final prayerProvider =
        Provider.of<PrayerProvider>(context, listen: false);

    //ensure fields are filled
    if (city.isNotEmpty && country.isNotEmpty) {
      prayerProvider.getPrayerTimesAndNext(city, country);
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
    cityController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final name = authProvider.currentUser?.name ?? 'Guest';
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 17,
          children: [
            Center(
              child: Text(
                'Prayer Times',
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ',
                  style: textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$name!',
                  style: textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              spacing: 5,
              children: [
                Expanded(
                  child: Column(
                    spacing: 5,
                    children: [
                      CustomTextfield(
                          controller: cityController,
                          hintText: 'City',
                          isPassword: false),
                      CustomTextfield(
                          controller: countryController,
                          hintText: 'Country',
                          isPassword: false),
                    ],
                  ),
                ),
                CustomButton(
                  text: 'Get \nTimes',
                  onPressed: getTimes,
                ),
              ],
            ),
            Consumer<PrayerProvider>(
              builder: (context, provider, _) {
                final state = provider.state;
                if (provider.state == PrayerState.loading) {
                  return Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12.0),
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ),
                  );
                }

                if (state == PrayerState.loaded &&
                    provider.prayerTimes != null) {
                  final time =
                      provider.prayerTimes!.timings;
                  final nextTime =
                      provider.nextPrayerTimes!.timings;
                  return Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12.0),
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 15,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.all(
                                        8.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: Icon(
                                  Icons.alarm,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Prayer Times for ${cityController.text}',
                                  style: textTheme
                                      .titleMedium
                                      ?.copyWith(
                                    color: Colors.black,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        CustomTile(
                            title: "Fajr",
                            trailing: time["Fajr"]),
                        Divider(),
                        CustomTile(
                            title: "Dhuhr",
                            trailing: time["Dhuhr"]),
                        Divider(),
                        CustomTile(
                            title: "Asr",
                            trailing: time["Asr"]),
                        Divider(),
                        CustomTile(
                            title: "Maghrib",
                            trailing: time["Maghrib"]),
                        Divider(),
                        CustomTile(
                            title: "Isha",
                            trailing: time["Isha"]),
                        Divider(),
                        CustomTile(
                          backgroundColor: Colors.green,
                          title: "Next Prayer Time",
                          titleColor: Colors.white,
                          subtitle: nextTime.keys.first,
                          subtitleColor: Colors.white,
                          trailing: nextTime.values.first,
                          trailingColor: Colors.white,
                        ),
                      ],
                    ),
                  );
                }

                if (state == PrayerState.error) {
                  // show error snackbar once
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content:
                            Text(provider.errorMessage!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                }

                return Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(12.0),
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer,
                  ),
                  child: Text(
                    'Enter city and country to get prayer times',
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
