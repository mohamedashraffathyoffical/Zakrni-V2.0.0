class PrayerTime {
  final String name;
  final DateTime time;

  PrayerTime({required this.name, required this.time});

  factory PrayerTime.fromJson(Map<String, dynamic> json, String name) {
    // Parse time from API response
    final timeStr = json[name];
    if (timeStr == null) {
      // Handle null case by using current time as fallback
      final now = DateTime.now();
      return PrayerTime(
        name: name,
        time: now,
      );
    }
    
    // API returns time in format like "04:30" or "04:30 (EET)"
    // Extract just the time part
    final timePart = timeStr.split(' ')[0];
    final List<String> parts = timePart.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    final now = DateTime.now();
    final time = DateTime(now.year, now.month, now.day, hour, minute);
    
    return PrayerTime(
      name: name,
      time: time,
    );
  }

  @override
  String toString() {
    return '$name: ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class DailyPrayers {
  final PrayerTime fajr;
  final PrayerTime sunrise;
  final PrayerTime dhuhr;
  final PrayerTime asr;
  final PrayerTime maghrib;
  final PrayerTime isha;
  final DateTime date;

  DailyPrayers({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
  });

  factory DailyPrayers.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'];
    
    // Parse date from API response
    final dateStr = json['date']['gregorian']['date'];
    final List<String> dateComponents = dateStr.split('-');
    
    // API returns date in format "06-05-2025" (year-month-day)
    final year = int.parse(dateComponents[0]);
    final month = int.parse(dateComponents[1]);
    final day = int.parse(dateComponents[2]);
    
    return DailyPrayers(
      fajr: PrayerTime.fromJson(timings, 'Fajr'),
      sunrise: PrayerTime.fromJson(timings, 'Sunrise'),
      dhuhr: PrayerTime.fromJson(timings, 'Dhuhr'),
      asr: PrayerTime.fromJson(timings, 'Asr'),
      maghrib: PrayerTime.fromJson(timings, 'Maghrib'),
      isha: PrayerTime.fromJson(timings, 'Isha'),
      date: DateTime(year, month, day),
    );
  }

  List<PrayerTime> toList() {
    return [fajr, sunrise, dhuhr, asr, maghrib, isha];
  }

  PrayerTime getNextPrayer() {
    final now = DateTime.now();
    final prayers = toList();
    
    for (var prayer in prayers) {
      if (prayer.time.isAfter(now)) {
        return prayer;
      }
    }
    
    // If all prayers for today have passed, return tomorrow's Fajr
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return PrayerTime(
      name: 'Fajr',
      time: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, fajr.time.hour, fajr.time.minute),
    );
  }

  Duration getTimeUntilNextPrayer() {
    final nextPrayer = getNextPrayer();
    final now = DateTime.now();
    return nextPrayer.time.difference(now);
  }
}
