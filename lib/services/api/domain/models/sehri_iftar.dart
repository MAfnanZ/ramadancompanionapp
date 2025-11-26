import 'package:ramadancompanionapp/tools/typedefs.dart';

class SehriIftarTimes {
  final String imsak;
  final String maghrib;
  final String gregorianDate;
  final String gregorianWeekday;
  final String hijriDate;

  SehriIftarTimes({
    required this.imsak,
    required this.maghrib,
    required this.gregorianDate,
    required this.gregorianWeekday,
    required this.hijriDate,
  });

  factory SehriIftarTimes.fromJson(JsonMap json) {
    return SehriIftarTimes(
      imsak: json["timings"]["Imsak"],
      maghrib: json["timings"]["Maghrib"],
      gregorianDate: json["date"]["gregorian"]["date"],
      gregorianWeekday: json["date"]["gregorian"]["weekday"]
          ["en"],
      hijriDate: json["date"]["hijri"]["date"],
    );
  }
}

class SehriIftarParser {
  static List<SehriIftarTimes> fromJsonList(
      List<JsonMap> list) {
    return list
        .map((item) => SehriIftarTimes.fromJson(item))
        .toList();
  }
}
