/*

Prayer API Backend

*/

import 'package:ramadancompanionapp/services/api/data/http_client.dart';
import 'package:ramadancompanionapp/typedefs.dart';

class PrayerApi {
  final HttpClientService httpClient;

  PrayerApi({required this.httpClient});

  Future<JsonMap> getPrayersTime(
          String city, String country) =>
      httpClient.getMap(
          'timingsByCity?city=$city&country=$country&method=3');

  Future<JsonMap> getNextPrayerTime(
          String city, String country) =>
      httpClient.getMap(
          'nextPrayerByAddress?address=$city,$country&method=3');
}
