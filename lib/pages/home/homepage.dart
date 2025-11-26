import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadancompanionapp/pages/prayer_times/prayer_times_page.dart';
import 'package:ramadancompanionapp/pages/profile/profile.dart';
import 'package:ramadancompanionapp/pages/qibla/qibla_page.dart';
import 'package:ramadancompanionapp/pages/sehri_iftar/sehri_iftar_page.dart';
import 'package:ramadancompanionapp/providers/tab_switcher.dart';
import 'package:ramadancompanionapp/services/api/presentation/provider/prayer_provider.dart';
import 'package:ramadancompanionapp/services/auth/presentation/provider/auth_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final prayerProvider =
        Provider.of<PrayerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('RAMADAN COMPANION'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          //logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              prayerProvider.clear();
            },
          ),
        ],
      ),
      body: Consumer<TabSwitcher>(
          builder: (context, tab, child) {
        return [
          PrayerTimesPage(),
          SehriIftarPage(),
          QiblaPage(),
          ProfilePage(),
        ][tab.page];
      }),
      bottomNavigationBar: Consumer<TabSwitcher>(
        builder: (context, tab, child) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: tab.page,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.access_time_rounded),
                  label: 'Prayer Times'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Sehri/Iftar'),
              BottomNavigationBarItem(
                  icon: Icon(
                      Icons.compass_calibration_outlined),
                  label: 'Qibla'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile'),
            ],
            onTap: (index) {
              context.read<TabSwitcher>().page = index;
            },
          );
        },
      ),
    );
  }
}
