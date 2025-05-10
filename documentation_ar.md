# توثيق تطبيق ذكرني (Zakrni) - الإصدار 2.0.0

## نظرة عامة على التطبيق

تطبيق ذكرني هو تطبيق إسلامي متكامل يوفر مواقيت الصلاة والأذكار للمستخدمين. يتميز التطبيق بواجهة مستخدم سهلة الاستخدام وميزات متعددة تساعد المسلمين على أداء عباداتهم في الأوقات المحددة.

## الحزم والمكتبات المستخدمة

تم استخدام العديد من المكتبات والحزم لتطوير هذا التطبيق، ومن أهمها:

1. **flutter_localizations**: لدعم التعريب واللغات المتعددة (العربية والإنجليزية)
2. **http (1.1.0)**: للاتصال بواجهة برمجة التطبيقات (API) للحصول على مواقيت الصلاة
3. **provider (6.0.5)**: لإدارة حالة التطبيق وتوفير نمط إدارة الحالة
4. **shared_preferences (2.2.0)**: لتخزين تفضيلات المستخدم محلياً مثل المحافظة المختارة وإعدادات الإشعارات
5. **url_launcher (^6.2.5)**: لفتح روابط خارجية من داخل التطبيق
6. **package_info_plus (^5.0.1)**: للحصول على معلومات حول إصدار التطبيق
7. **flutter_local_notifications (^14.0.0+1)**: لإدارة وعرض الإشعارات المحلية للصلوات
8. **timezone (^0.9.2)**: للتعامل مع المناطق الزمنية المختلفة
9. **audioplayers (^5.2.1)**: لتشغيل صوت الأذان عند وقت الصلاة

## الميزات الرئيسية للتطبيق

### 1. عرض مواقيت الصلاة

- عرض مواقيت الصلاة اليومية (الفجر، الشروق، الظهر، العصر، المغرب، العشاء)
- عرض العد التنازلي للصلاة القادمة
- دعم لمختلف محافظات مصر مع حفظ المحافظة المختارة بين جلسات التطبيق

### 2. نظام الإشعارات

- إشعارات قبل وقت الصلاة بـ 5 دقائق
- تشغيل الأذان عند وقت الصلاة (اختياري)
- إمكانية اختيار نوع الأذان (السديس، مكة، المدينة)
- إشعار مستمر عند تشغيل الأذان مع زر لإيقافه

### 3. الأذكار

- أذكار الصباح
- أذكار المساء
- أذكار النوم
- أذكار الاستيقاظ
- أذكار بعد الصلاة

### 4. إعدادات متنوعة

- إمكانية تغيير اللغة (العربية والإنجليزية)
- خيارات إعادة ضبط التطبيق (إعادة ضبط شاملة وإعادة ضبط فردية)
- اختبار الإشعارات للتأكد من عملها بشكل صحيح

## شرح للوظائف والملفات الرئيسية

### 1. نموذج وقت الصلاة (prayer_time.dart)

يحتوي هذا الملف على تعريف فئات `PrayerTime` و `DailyPrayers` التي تمثل بيانات أوقات الصلاة:

```dart
class PrayerTime {
  final String name;
  final DateTime time;

  PrayerTime({required this.name, required this.time});
  
  // تحويل البيانات من JSON إلى كائن PrayerTime
  factory PrayerTime.fromJson(Map<String, dynamic> json, String name) {
    // ...
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
  
  // ...
  
  // الحصول على الصلاة التالية
  PrayerTime getNextPrayer() {
    final now = DateTime.now();
    final prayers = toList();
    
    for (var prayer in prayers) {
      if (prayer.time.isAfter(now)) {
        return prayer;
      }
    }
    
    // إذا انتهت جميع صلوات اليوم، أعد صلاة الفجر للغد
    // ...
  }
}
```

### 2. خدمة واجهة برمجة التطبيقات للصلاة (prayer_api_service.dart)

تستخدم هذه الخدمة واجهة برمجة التطبيقات Al-Adhan للحصول على مواقيت الصلاة:

```dart
class PrayerApiService {
  // استخدام واجهة برمجة تطبيقات Al-Adhan لمواقيت الصلاة
  static const String baseUrl = 'https://api.aladhan.com/v1/timingsByCity';
  
  // خريطة محافظات مصر مع إحداثياتها
  static final Map<String, Map<String, dynamic>> egyptGovernorates = {
    'القاهرة': {'city': 'Cairo', 'country': 'Egypt'},
    'الإسكندرية': {'city': 'Alexandria', 'country': 'Egypt'},
    // ...
  };
  
  // الحصول على مواقيت الصلاة لمحافظة محددة
  Future<DailyPrayers> getPrayerTimes(String governorate) async {
    // ...
  }
}
```

### 3. خدمة الأذان (adhan_service.dart)

تدير هذه الخدمة تشغيل الأذان وإعداداته:

```dart
class AdhanService {
  // الأذانات المتاحة
  static const List<String> availableAdhans = [
    'none',
    'sudais',
    'makkah',
    'madinah',
  ];
  
  // تشغيل الأذان
  Future<void> playAdhan() async {
    if (_selectedAdhan == 'none' || !_adhanEnabled) {
      return;
    }
    
    // عرض إشعار للأذان
    await _showAdhanNotification();
    
    // تشغيل ملف الصوت
    await _audioPlayer.play(AssetSource(adhanFile));
  }
  
  // عرض إشعار مع زر إيقاف عند تشغيل الأذان
  Future<void> _showAdhanNotification() async {
    // ...
  }
}
```

### 4. خدمة إشعارات الصلاة (prayer_notification_service.dart)

تدير هذه الخدمة جدولة وعرض إشعارات الصلاة:

```dart
class PrayerNotificationService {
  // جدولة إشعارات لجميع الصلوات
  Future<void> scheduleAllPrayerNotifications(DailyPrayers prayers, BuildContext context) async {
    // ...
  }
  
  // جدولة إشعار لصلاة محددة
  Future<void> schedulePrayerNotification(PrayerTime prayer, BuildContext context) async {
    // ...
  }
  
  // عرض إشعار اختباري
  Future<bool> showTestNotification(BuildContext context) async {
    // ...
  }
}
```

### 5. الصفحة الرئيسية (home_page.dart)

تعرض هذه الصفحة مواقيت الصلاة والعد التنازلي للصلاة القادمة:

```dart
class _HomePageState extends State<HomePage> {
  // ...
  
  // جلب مواقيت الصلاة
  Future<void> _fetchPrayerTimes() async {
    // ...
  }
  
  // بدء مؤقت العد التنازلي
  void _startCountdownTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // ...
      
      // تنسيق الوقت المتبقي
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      final seconds = difference.inSeconds.remainder(60);
      
      // تنسيق الوقت بشكل مختلف بناءً على اللغة
      if (isArabic) {
        // تنسيق عربي مع أرقام عربية وثواني
        final arabicHours = _convertToArabicNumerals(hours.toString());
        final arabicMinutes = _convertToArabicNumerals(minutes.toString().padLeft(2, '0'));
        final arabicSeconds = _convertToArabicNumerals(seconds.toString().padLeft(2, '0'));
        _timeRemaining = '$arabicHours:$arabicMinutes:$arabicSeconds';
      } else {
        // تنسيق إنجليزي مع ثواني
        _timeRemaining = '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }
    });
  }
  
  // تحويل الأرقام إلى أرقام عربية
  String _convertToArabicNumerals(String input) {
    // ...
  }
}
```

### 6. صفحة الإعدادات (settings_page.dart)

تتيح هذه الصفحة للمستخدم تخصيص إعدادات التطبيق:

```dart
class _SettingsPageState extends State<SettingsPage> {
  // ...
  
  // تحميل الإعدادات
  Future<void> _loadSettings() async {
    // ...
  }
  
  // حفظ إعدادات الإشعارات
  Future<void> _saveNotificationSettings(bool value) async {
    // ...
  }
  
  // حفظ إعدادات الأذان
  Future<void> _saveAdhanSettings(String adhan) async {
    // ...
  }
  
  // إعادة ضبط التطبيق
  Future<void> _resetApp() async {
    // ...
  }
}
```

## كيفية تنفيذ العد التنازلي للصلاة

تم تنفيذ العد التنازلي للصلاة باستخدام الخطوات التالية:

1. **تحديد الصلاة القادمة**: يتم استخدام الدالة `getNextPrayer()` في فئة `DailyPrayers` لتحديد الصلاة القادمة بناءً على الوقت الحالي.

2. **حساب الوقت المتبقي**: يتم حساب الفرق بين وقت الصلاة القادمة والوقت الحالي باستخدام `nextPrayer.time.difference(now)`.

3. **تحديث العد التنازلي**: يتم استخدام `Timer.periodic` لتحديث العد التنازلي كل ثانية.

4. **تنسيق العرض**: يتم تنسيق الوقت المتبقي بتنسيق مناسب (ساعات:دقائق:ثواني) ويتم تحويل الأرقام إلى أرقام عربية إذا كانت اللغة المختارة هي العربية.

## كيفية تنفيذ نظام الإشعارات

تم تنفيذ نظام الإشعارات باستخدام الخطوات التالية:

1. **تهيئة نظام الإشعارات**: يتم تهيئة `FlutterLocalNotificationsPlugin` في بداية التطبيق.

2. **جدولة الإشعارات**: يتم جدولة إشعارات لكل صلاة قبل وقتها بـ 5 دقائق.

3. **إشعارات الأذان**: عند تشغيل الأذان، يتم عرض إشعار مستمر مع زر لإيقاف الأذان.

4. **اختبار الإشعارات**: تم إضافة زر لاختبار الإشعارات للتأكد من عملها بشكل صحيح.

## الخاتمة

تطبيق ذكرني هو تطبيق شامل يوفر مجموعة متكاملة من الميزات للمسلمين لمساعدتهم على أداء عباداتهم في الأوقات المحددة. يتميز التطبيق بواجهة مستخدم سهلة الاستخدام ودعم للغتين العربية والإنجليزية، مما يجعله مناسبًا لمجموعة واسعة من المستخدمين.

تم تطوير التطبيق باستخدام إطار عمل Flutter، مما يسمح بتشغيله على أنظمة Android و iOS. كما تم استخدام مجموعة من المكتبات والحزم لتوفير تجربة مستخدم سلسة وفعالة.
