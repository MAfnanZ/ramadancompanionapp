/*

PRAYER REPOSITORY - Outlines the possible prayer operations for this app

*/

import 'package:ramadancompanionapp/services/api/data/prayer_api.dart';
import 'package:ramadancompanionapp/services/api/domain/models/prayer_times.dart';

class PrayerRepo {
  final PrayerApi prayerApi;

  PrayerRepo({required this.prayerApi});

  Future<PrayerTimes> getPrayerTimes(
      String city, String country) async {
    final json =
        await prayerApi.getPrayersTime(city, country);

    return PrayerTimes.fromJson(json);
  }

  Future<PrayerTimes> getNextPrayerTimes(
      String city, String country) async {
    final json =
        await prayerApi.getNextPrayerTime(city, country);

    return PrayerTimes.fromJson(json);
  }
}
