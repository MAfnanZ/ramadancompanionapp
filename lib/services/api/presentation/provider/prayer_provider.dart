/*

Prayer State Management

*/

import 'package:flutter/material.dart';
import 'package:ramadancompanionapp/services/api/domain/models/prayer_times.dart';
import 'package:ramadancompanionapp/services/api/domain/models/sehri_iftar.dart';
import 'package:ramadancompanionapp/services/api/domain/repos/prayer_repo.dart';

enum PrayerState { initial, loading, loaded, error }

class PrayerProvider extends ChangeNotifier {
  final PrayerRepo prayerRepo;

  PrayerProvider({required this.prayerRepo}) {
    clear();
  }

  PrayerTimes? _prayerTimes;
  PrayerTimes? _nextPrayerTimes;
  List<SehriIftarTimes>? _sehriIftarTimes;

  PrayerState _state = PrayerState.initial;
  String? _errorMessage;

  PrayerTimes? get prayerTimes => _prayerTimes;
  PrayerTimes? get nextPrayerTimes => _nextPrayerTimes;
  List<SehriIftarTimes>? get sehriIftarTimes =>
      _sehriIftarTimes;

  PrayerState get state => _state;
  String? get errorMessage => _errorMessage;

  //Get prayer times
  Future<void> getPrayerTimesAndNext(
      String city, String country) async {
    try {
      _state = PrayerState.loading;
      _errorMessage = null;
      notifyListeners();

      _prayerTimes =
          await prayerRepo.getPrayerTimes(city, country);
      _nextPrayerTimes = await prayerRepo
          .getNextPrayerTimes(city, country);
      _state = PrayerState.loaded;
      notifyListeners();
    } catch (e) {
      _state = PrayerState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }

    notifyListeners();
  }

  //Get Sehri Iftar times for ramadan
  Future<void> getSehriIftarTimes(
      String city, String country) async {
    try {
      _state = PrayerState.loading;
      _errorMessage = null;
      notifyListeners();

      final IslamicYear =
          await prayerRepo.getCurrentIslamicYear();

      _sehriIftarTimes = await prayerRepo
          .getSehriIftarTimes(city, country, IslamicYear);

      _state = PrayerState.loaded;
      notifyListeners();
    } catch (e) {
      _state = PrayerState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
    notifyListeners();
  }

  void clear() {
    _prayerTimes = null;
    _nextPrayerTimes = null;
    _sehriIftarTimes = null;
    _state = PrayerState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
