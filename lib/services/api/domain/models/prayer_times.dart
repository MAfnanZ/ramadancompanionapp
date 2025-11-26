import 'package:ramadancompanionapp/typedefs.dart';

class PrayerTimes {
  final JsonMap timings;

  PrayerTimes({required this.timings});

  factory PrayerTimes.fromJson(JsonMap data) {
    final timingsJson = data['data']['timings'] as JsonMap;
    final timings = timingsJson.map(
        (key, value) => MapEntry(key, value.toString()));
    return PrayerTimes(timings: timings);
  }
}
