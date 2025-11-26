import 'package:ramadancompanionapp/tools/typedefs.dart';

class PrayerTimes {
  final JsonMap timings;

  PrayerTimes({required this.timings});

  factory PrayerTimes.fromJson(JsonMap data) {
    final timingsJson = data['timings'] as JsonMap;
    final timings = timingsJson.map(
        (key, value) => MapEntry(key, value.toString()));
    return PrayerTimes(timings: timings);
  }
}
