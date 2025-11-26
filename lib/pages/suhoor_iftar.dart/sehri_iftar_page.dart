import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadancompanionapp/services/api/presentation/provider/prayer_provider.dart';
import 'package:ramadancompanionapp/services/auth/presentation/provider/auth_provider.dart';
import 'package:ramadancompanionapp/tools/time.dart';
import 'package:ramadancompanionapp/widgets/custom_button.dart';
import 'package:ramadancompanionapp/widgets/custom_textfield.dart';

class SehriIftarPage extends StatefulWidget {
  const SehriIftarPage({super.key});

  @override
  State<SehriIftarPage> createState() =>
      _SehriIftarPageState();
}

class _SehriIftarPageState extends State<SehriIftarPage> {
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
      prayerProvider.getSehriIftarTimes(city, country);
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
                'Sehri/Iftar Times',
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
                    provider.sehriIftarTimes != null) {
                  final sehriIftarTimes =
                      provider.sehriIftarTimes!;
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
                      child: DataTable(
                        columnSpacing: 20,
                        dataRowMaxHeight: 60,
                        headingRowColor:
                            WidgetStateProperty.all(
                                Colors.green),
                        headingTextStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        columns: const [
                          DataColumn(
                            label: Text('Hijri'),
                          ),
                          DataColumn(
                            label: Text('Gregorian'),
                          ),
                          DataColumn(
                            label: Text('Day'),
                          ),
                          DataColumn(
                            label: Text('Imsak'),
                          ),
                          DataColumn(
                            label: Text('Iftar'),
                          ),
                        ],
                        rows: sehriIftarTimes.map((day) {
                          return DataRow(cells: [
                            DataCell(Text(day.hijriDate)),
                            DataCell(
                                Text(day.gregorianDate)),
                            DataCell(
                                Text(day.gregorianWeekday)),
                            DataCell(
                                Text(cleanTime(day.imsak))),
                            DataCell(Text(
                                cleanTime(day.maghrib))),
                          ]);
                        }).toList(),
                      ));
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
                    'Enter city and country to get sehri/iftar times',
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
