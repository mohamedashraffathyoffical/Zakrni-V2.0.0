import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../widgets/dhikr_counter_button.dart';
import '../../widgets/global_reset_button.dart';

class AfterPrayerAzkarPage extends StatefulWidget {
  const AfterPrayerAzkarPage({super.key});

  @override
  State<AfterPrayerAzkarPage> createState() => _AfterPrayerAzkarPageState();
}

class _AfterPrayerAzkarPageState extends State<AfterPrayerAzkarPage> {
  // Key to force widget rebuild when the counters are reset
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  
  // Refresh the state after counters have been reset
  void _refreshCounters() {
    setState(() {
      // Force rebuild of the list
    });
  }
  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final appLanguage = Provider.of<AppLanguage>(context);
    final isArabic = appLanguage.appLocale.languageCode == 'ar';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.afterPrayerAzkar),
        actions: [
          GlobalResetButton(onResetCompleted: _refreshCounters),
        ],
      ),
      body: AnimatedList(
        key: _listKey,
        padding: const EdgeInsets.all(16.0),
        initialItemCount: _getAfterPrayerAzkar(isArabic).length,
        itemBuilder: (context, index, animation) {
          final azkar = _getAfterPrayerAzkar(isArabic)[index];
          return FadeTransition(
            opacity: animation,
            child: _buildAzkarCard(context, azkar, index),
          );
        },
      ),
    );
  }
  
  Widget _buildAzkarCard(BuildContext context, Map<String, String> azkar, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    azkar['title']!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              azkar['content']!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.start,
            ),
            if (azkar['transliteration'] != null) ...[
              const SizedBox(height: 8),
              Text(
                azkar['transliteration']!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
            ],
            if (azkar['translation'] != null) ...[
              const SizedBox(height: 8),
              Text(
                azkar['translation']!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ],
            if (azkar['repetition'] != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      azkar['repetition']!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(width: 16),
                  DhikrCounterButton(
                    totalCount: _parseRepetitionCount(azkar['repetition']!),
                    index: index,
                    dhikrTitle: azkar['title'] ?? 'After Prayer Dhikr',
                    onComplete: (count) {
                      // Optional: Show a snackbar when dhikr is completed
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Completed ${azkar['title']}'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  // Helper method to parse repetition count from text
  int _parseRepetitionCount(String repetitionText) {
    if (repetitionText.contains('33')) {
      return 33;
    } else if (repetitionText.contains('3')) {
      return 3;
    } else if (repetitionText.contains('100')) {
      return 100;
    } else if (repetitionText.contains('7')) {
      return 7;
    } else if (repetitionText.contains('10')) {
      return 10;
    }
    return 1; // Default to one if no match found
  }
  
  List<Map<String, String>> _getAfterPrayerAzkar(bool isArabic) {
    if (isArabic) {
      return [
        {
          'title': 'الاستغفار',
          'content': 'أَسْتَغْفِرُ اللهَ (ثلاثًا) اللَّهُمَّ أَنْتَ السَّلاَمُ، وَمِنْكَ السَّلاَمُ، تَبَارَكْتَ يَا ذَا الْجَلاَلِ وَالإِكْرَامِ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'التسبيح والتحميد',
          'content': 'لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، اللَّهُمَّ لَا مَانِعَ لِمَا أَعْطَيْتَ، وَلَا مُعْطِيَ لِمَا مَنَعْتَ، وَلَا يَنْفَعُ ذَا الْجَدِّ مِنْكَ الْجَدُّ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'التسبيح',
          'content': 'سُبْحَانَ اللهِ',
          'repetition': '33 مرة',
        },
        {
          'title': 'التحميد',
          'content': 'الْحَمْدُ لِلَّهِ',
          'repetition': '33 مرة',
        },
        {
          'title': 'التكبير',
          'content': 'اللهُ أَكْبَرُ',
          'repetition': '33 مرة',
        },
        {
          'title': 'التهليل',
          'content': 'لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          'repetition': 'مرة واحدة بعد التسبيح والتحميد والتكبير',
        },
        {
          'title': 'آية الكرسي',
          'content': ' ﴿ اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ ﴾\n البقرة: 255]  ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'المعوذات',
          'content': 'قُلْ هُوَ اللَّهُ أَحَدٌ* اللَّهُ الصَّمَدُ* لَمْ يَلِدْ وَلَمْ يُولَدْ* وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ\n\nقُلْ أَعُوذُ بِرَبِّ الْفَلَقِ* مِن شَرِّ مَا خَلَقَ* وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ* وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ* وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\n\nقُلْ أَعُوذُ بِرَبِّ النَّاسِ* مَلِكِ النَّاسِ* إِلَهِ النَّاسِ* مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ* الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ* مِنَ الْجِنَّةِ وَ النَّاسِ',
          'repetition': 'مرة واحدة بعد كل صلاة',
        },
        {
          'title': 'تسبيح فاطمة الزهراء',
          'content': 'سُبْحَانَ اللهِ (33 مرة)\nالْحَمْدُ لِلَّهِ (33 مرة)\nاللهُ أَكْبَرُ (34 مرة)',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء بعد التشهد الأخير',
          'content': 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ جَهَنَّمَ، وَمِنْ عَذَابِ الْقَبْرِ، وَمِنْ فِتْنَةِ الْمَحْيَا وَالْمَمَاتِ، وَمِنْ شَرِّ فِتْنَةِ الْمَسِيحِ الدَّجَّالِ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء النجاة من النار',
          'content': 'اللَّهُمَّ أَجِرْنِي مِنَ النَّارِ',
          'repetition': '7 مرات بعد صلاة المغرب والصبح',
        },
        {
          'title': 'دعاء النصر والهداية',
          'content': 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'سؤال الجنة',
          'content': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ',
          'repetition': '3 مرات',
        },
        {
          'title': 'الاستعاذة من الجبن والبخل',
          'content': 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْبُخْلِ، وَأَعُوذُ بِكَ مِنَ الْجُبْنِ، وَأَعُوذُ بِكَ مِنْ أَنْ أُرَدَّ إِلَى أَرْذَلِ الْعُمُرِ، وَأَعُوذُ بِكَ مِنْ فِتْنَةِ الدُّنْيَا وَعَذَابِ الْقَبْرِ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء صلاة الفجر',
          'content': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا',
          'repetition': 'مرة واحدة بعد السلام من صلاة الفجر',
        },
        {
          'title': 'آية الكرسي',
          'content': ' ﴿ اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ ﴾\n البقرة: 255]  ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء للعلم النافع',
          'content': 'اللَّهُمَّ انْفَعْنِي بِمَا عَلَّمْتَنِي، وَعَلِّمْنِي مَا يَنْفَعُنِي، وَزِدْنِي عِلْمًا',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء للشهادة',
          'content': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الشَّهَادَةَ فِي سَبِيلِكَ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء للهداية',
          'content': 'اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'الاستعاذة من الشيطان',
          'content': 'أَعُوذُ بِاللهِ السَّمِيعِ الْعَلِيمِ مِنَ الشَّيْطَانِ الرَّجِيمِ مِنْ هَمْزِهِ وَنَفْخِهِ وَنَفْثِهِ',
          'repetition': 'مرة واحدة بعد السلام من الصلاة',
        },
        {
          'title': 'دعاء لحسن الخاتمة',
          'content': 'اللَّهُمَّ أَحْسِنْ عَاقِبَتَنَا فِي الْأُمُورِ كُلِّهَا، وَأَجِرْنَا مِنْ خِزْيِ الدُّنْيَا وَعَذَابِ الْآخِرَةِ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء للحماية من الهموم',
          'content': 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء الثبات على الدين',
          'content': 'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ، وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء قضاء الدين',
          'content': 'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء للشكر',
          'content': 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء سجود الشكر',
          'content': 'سُبْحَانَ رَبِّيَ الأَعْلَى',
          'repetition': '3 مرات',
        },
        {
          'title': 'دعاء حماية الأبناء',
          'content': 'أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ، وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'الإستغفار للمؤمنين',
          'content': 'رَبَّنَا اغْفِرْ لَنَا وَلِإِخْوَانِنَا الَّذِينَ سَبَقُونَا بِالْإِيمَانِ وَلَا تَجْعَلْ فِي قُلُوبِنَا غِلًّا لِلَّذِينَ آمَنُوا رَبَّنَا إِنَّكَ رَءُوفٌ رَحِيمٌ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء الدخول للمسجد',
          'content': 'أَعُوذُ بِاللهِ الْعَظِيمِ، وَبِوَجْهِهِ الْكَرِيمِ، وَسُلْطَانِهِ الْقَدِيمِ، مِنَ الشَّيْطَانِ الرَّجِيمِ، بِسْمِ اللهِ، وَالصَّلَاةُ وَالسَّلَامُ عَلَى رَسُولِ اللهِ، اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
          'repetition': 'مرة واحدة عند دخول المسجد',
        },
        {
          'title': 'دعاء الخروج من المسجد',
          'content': 'بِسْمِ اللهِ وَالصَّلاَةُ وَالسَّلاَمُ عَلَى رَسُولِ اللهِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ، اللَّهُمَّ اعْصِمْنِي مِنَ الشَّيْطَانِ الرَّجِيمِ',
          'repetition': 'مرة واحدة عند الخروج من المسجد',
        },
        {
          'title': 'دعاء العافية',
          'content': 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إِلَّا أَنْتَ',
          'repetition': 'مرة واحدة',
        },
      ];
    } else {
      return [
        {
          'title': 'Asking for Forgiveness',
          'content': 'أَسْتَغْفِرُ اللهَ (ثلاثًا)\nاللَّهُمَّ أَنْتَ السَّلاَمُ، وَمِنْكَ السَّلاَمُ، تَبَارَكْتَ يَا ذَا الْجَلاَلِ وَالإِكْرَامِ',
          'transliteration': 'Astaghfirullah (three times)\nAllahumma antas-salam, wa minkas-salam, tabarakta ya dhal-jalali wal-ikram',
          'translation': 'I seek Allah\'s forgiveness (three times).\nO Allah, You are Peace and from You comes peace. Blessed are You, O Owner of majesty and honor.',
          'repetition': 'Once',
        },
        {
          'title': 'Glorification and Praise',
          'content': 'لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، اللَّهُمَّ لَا مَانِعَ لِمَا أَعْطَيْتَ، وَلَا مُعْطِيَ لِمَا مَنَعْتَ، وَلَا يَنْفَعُ ذَا الْجَدِّ مِنْكَ الْجَدُّ',
          'transliteration': 'La ilaha illallah wahdahu la sharika lah, lahul-mulku wa lahul-hamd, wa huwa \'ala kulli shay\'in qadir. Allahumma la mani\'a lima a\'tayt, wa la mu\'tiya lima mana\'t, wa la yanfa\'u dhal-jaddi minkal-jadd',
          'translation': 'None has the right to be worshipped but Allah alone, He has no partner, His is the dominion and His is the praise, and He is Able to do all things. O Allah, there is none who can withhold what You grant, and none who can grant what You withhold, and the might of the mighty benefits them not against You.',
          'repetition': 'Once',
        },
        {
          'title': 'Glorification',
          'content': 'سُبْحَانَ اللهِ',
          'transliteration': 'Subhanallah',
          'translation': 'Glory be to Allah',
          'repetition': '33 times',
        },
        {
          'title': 'Praise',
          'content': 'الْحَمْدُ لِلَّهِ',
          'transliteration': 'Alhamdulillah',
          'translation': 'All praise is due to Allah',
          'repetition': '33 times',
        },
        {
          'title': 'Magnification',
          'content': 'اللهُ أَكْبَرُ',
          'transliteration': 'Allahu Akbar',
          'translation': 'Allah is the Greatest',
          'repetition': '33 times',
        },
        {
          'title': 'Declaration of Faith',
          'content': 'لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          'transliteration': 'La ilaha illallah wahdahu la sharika lah, lahul-mulku wa lahul-hamd, wa huwa \'ala kulli shay\'in qadir',
          'translation': 'None has the right to be worshipped but Allah alone, He has no partner, His is the dominion and His is the praise, and He is Able to do all things.',
          'repetition': 'Once after completing the glorification, praise, and magnification',
        },
        {
          'title': 'Ayatul Kursi',
          'content': 'اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلاَ يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلاَّ بِمَا شَاء وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ',
          'translation': 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.',
          'repetition': 'Once',
        },
        {
          'title': 'The Three Quls (Al-Mu\'awwidhat)',
          'content': 'قُلْ هُوَ اللَّهُ أَحَدٌ* اللَّهُ الصَّمَدُ* لَمْ يَلِدْ وَلَمْ يُولَدْ* وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ\n\nقُلْ أَعُوذُ بِرَبِّ الْفَلَقِ* مِن شَرِّ مَا خَلَقَ* وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ* وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ* وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\n\nقُلْ أَعُوذُ بِرَبِّ النَّاسِ* مَلِكِ النَّاسِ* إِلَهِ النَّاسِ* مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ* الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ* مِنَ الْجِنَّةِ وَ النَّاسِ',
          'transliteration': 'Qul huwa Allahu ahad, Allahu samad, lam yalid wa lam yulad, wa lam yakun lahu kufuwan ahad.\n\nQul a\'udhu bi rabbil-falaq, min sharri ma khalaq, wa min sharri ghasiqin idha waqab, wa min sharrin-naffathati fil \'uqad, wa min sharri hasidin idha hasad.\n\nQul a\'udhu bi rabbin-nas, malikin-nas, ilahin-nas, min sharril-waswasil-khannas, alladhi yuwaswisu fi sudurin-nas, minal-jinnati wan-nas.',
          'translation': 'Say, "He is Allah, [who is] One, Allah, the Eternal Refuge. He neither begets nor is born, Nor is there to Him any equivalent."\n\nSay, "I seek refuge in the Lord of daybreak, From the evil of that which He created, And from the evil of darkness when it settles, And from the evil of the blowers in knots, And from the evil of an envier when he envies."\n\nSay, "I seek refuge in the Lord of mankind, The Sovereign of mankind, The God of mankind, From the evil of the retreating whisperer - Who whispers [evil] into the breasts of mankind - From among the jinn and mankind."',
          'repetition': 'Once after each prayer',
        },
        {
          'title': 'Tasbih Fatimah',
          'content': 'سُبْحَانَ اللهِ (33 مرة)\nالْحَمْدُ لِلَّهِ (33 مرة)\nاللهُ أَكْبَرُ (34 مرة)',
          'transliteration': 'Subhanallah (33 times)\nAlhamdulillah (33 times)\nAllahu Akbar (34 times)',
          'translation': 'Glory be to Allah (33 times)\nAll praise is due to Allah (33 times)\nAllah is the Greatest (34 times)',
          'repetition': 'After each prayer',
        },
        {
          'title': 'Prayer for Seeking Guidance',
          'content': 'اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَهَ إِلاَّ أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لاَ يَغْفِرُ الذُّنُوبَ إِلاَّ أَنْتَ',
          'transliteration': 'Allahumma anta rabbi la ilaha illa anta, khalaqtani wa ana abduka, wa ana \'ala \'ahdika wa wa\'dika mastata\'tu, a\'udhu bika min sharri ma sana\'tu, abu\'u laka bini\'matika \'alayya, wa abu\'u bidhanbi faghfir li fa\'innahu la yaghfirudh-dhunuba illa anta',
          'translation': 'O Allah! You are my Lord, there is no God but You. You created me and I am Your servant, and I abide by Your covenant and promise as best as I can. I seek refuge in You from the evil of what I have done. I acknowledge Your blessing upon me, and I acknowledge my sin, so forgive me, for verily none can forgive sins except You.',
          'repetition': 'Once',
        },
        {
          'title': 'Dua for Worldly and Hereafter Success',
          'content': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          'transliteration': 'Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan waqina \'adhaban-nar',
          'translation': 'Our Lord! Grant us good in this world and good in the Hereafter, and save us from the punishment of the Fire.',
          'repetition': 'Once after each prayer',
        },
        {
          'title': 'Dua for Protection',
          'content': 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْجُبْنِ وَالْبُخْلِ، وَأَعُوذُ بِكَ مِنْ أَنْ أُرَدَّ إِلَى أَرْذَلِ الْعُمُرِ، وَأَعُوذُ بِكَ مِنْ فِتْنَةِ الدُّنْيَا، وَأَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ',
          'transliteration': 'Allahumma inni a\'udhu bika minal-jubni wal-bukhli, wa a\'udhu bika min an uradda ila ardhalil-\'umuri, wa a\'udhu bika min fitnatid-dunya, wa a\'udhu bika min \'adhabil-qabri',
          'translation': 'O Allah, I seek refuge in You from cowardice and miserliness, and I seek refuge in You from being returned to a feeble old age, and I seek refuge in You from the trials of this world, and I seek refuge in You from the punishment of the grave.',
          'repetition': 'Once',
        },
        {
          'title': 'Prayer for Forgiveness and Wellbeing',
          'content': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي',
          'transliteration': 'Allahumma inni as\'alukal-\'afwa wal-\'afiyata fid-dunya wal-akhirah, Allahumma inni as\'alukal-\'afwa wal-\'afiyata fi dini wa dunyaya wa ahli wa mali',
          'translation': 'O Allah, I ask You for pardon and well-being in this world and in the Hereafter. O Allah, I ask You for pardon and well-being in my religious and my worldly affairs, my family and my wealth.',
          'repetition': 'Once',
        },
        {
          'title': 'Dua for Steadfastness',
          'content': 'يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَى دِينِكَ',
          'transliteration': 'Ya muqallibal-qulubi thabbit qalbi \'ala dinik',
          'translation': 'O Turner of hearts, keep my heart steadfast on Your religion.',
          'repetition': 'Once after each prayer',
        },
        {
          'title': 'Dua for Seeking God\'s Guidance',
          'content': 'اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ، وَعَافِنِي فِيمَنْ عَافَيْتَ، وَتَوَلَّنِي فِيمَنْ تَوَلَّيْتَ، وَبَارِكْ لِي فِيمَا أَعْطَيْتَ، وَقِنِي شَرَّ مَا قَضَيْتَ، فَإِنَّكَ تَقْضِي وَلَا يُقْضَى عَلَيْكَ، وَإِنَّهُ لَا يَذِلُّ مَنْ وَالَيْتَ، وَلَا يَعِزُّ مَنْ عَادَيْتَ، تَبَارَكْتَ رَبَّنَا وَتَعَالَيْتَ',
          'transliteration': 'Allahumma-hdini fiman hadayt, wa \'afini fiman \'afayt, wa tawallani fiman tawallayt, wa barik li fima a\'tayt, wa qini sharra ma qadayt, fa\'innaka taqdi wa la yuqda \'alayk, wa innahu la yadhillu man walayt, wa la ya\'izzu man \'adayt, tabarakta Rabbana wa ta\'alayt',
          'translation': 'O Allah, guide me among those whom You have guided, grant me wellness among those whom You have granted wellness, take me into Your protection among those whom You have protected, bless me in what You have given me, and shield me from the evil of what You have decreed, for You decree and none can decree against You, and none whom You support shall be humiliated, and none whom You oppose shall be honored. Blessed are You, our Lord, and Exalted.',
          'repetition': 'Once after each prayer',
        },
        {
          "title": "Prayer for Beneficial Knowledge",
          "content": "اللَّهُمَّ انْفَعْنِي بِمَا عَلَّمْتَنِي، وَعَلِّمْنِي مَا يَنْفَعُنِي، وَزِدْنِي عِلْمًا",
          "transliteration": "Allahumma infa'ni bima 'allamtani, wa 'allimni ma yanfa'uni, wa zidni 'ilma",
          "translation": "O Allah, benefit me with what You have taught me, and teach me that which will benefit me, and increase me in knowledge.",
          "repetition": "Once"
        },
        {
          "title": "Prayer for Martyrdom",
          "content": "اللَّهُمَّ إِنِّي أَسْأَلُكَ الشَّهَادَةَ فِي سَبِيلِكَ",
          "transliteration": "Allahumma inni as'aluka ash-shahaadata fi sabilik",
          "translation": "O Allah, I ask You for martyrdom in Your path.",
          "repetition": "Once"
        },
        {
          "title": "Prayer for Guidance",
          "content": "اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي",
          "transliteration": "Allahumma-hdini wa saddidni",
          "translation": "O Allah, guide me and keep me on the right path.",
          "repetition": "Once"
        },
        {
          "title": "Seeking Refuge from Satan",
          "content": "أَعُوذُ بِاللهِ السَّمِيعِ الْعَلِيمِ مِنَ الشَّيْطَانِ الرَّجِيمِ مِنْ هَمْزِهِ وَنَفْخِهِ وَنَفْثِهِ",
          "transliteration": "A'udhu billahi-ssamee'il-'aleem mina-shshaytani-rrajeem, min hamzihi wa nafkhihi wa nafthihi",
          "translation": "I seek refuge with Allah, the All-Hearing, the All-Knowing, from the accursed Satan, from his madness, his arrogance, and his poetry.",
          "repetition": "Once after completing the prayer"
        },
        {
          "title": "Prayer for a Good End",
          "content": "اللَّهُمَّ أَحْسِنْ عَاقِبَتَنَا فِي الْأُمُورِ كُلِّهَا، وَأَجِرْنَا مِنْ خِزْيِ الدُّنْيَا وَعَذَابِ الْآخِرَةِ",
          "transliteration": "Allahumma ahsin 'aaqibatana fil-umuri kulliha, wa ajirna min khizyid-dunya wa 'adhaabil-akhirah",
          "translation": "O Allah, make good our end in all matters, and save us from disgrace in this world and from punishment in the Hereafter.",
          "repetition": "Once"
        },
        {
          "title": "Seeking Protection from Worries",
          "content": "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ",
          "transliteration": "Allahumma inni a'udhu bika minal-hammi wal-hazan, wal-'ajzi wal-kasal, wal-bukhli wal-jubn, wa dala'id-dayn wa ghalabatir-rijal",
          "translation": "O Allah, I seek refuge in You from anxiety and sorrow, from weakness and laziness, from miserliness and cowardice, from being overcome by debt and from being overpowered by men.",
          "repetition": "Once"
        },
        {
          "title": "Prayer for Constancy in Faith",
          "content": "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ، وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ",
          "transliteration": "Ya Hayyu ya Qayyumu bi-rahmatika astaghith, aslih li sha'ni kullahu, wa la takilni ila nafsi tarfata 'ayn",
          "translation": "O Ever Living, O Self-Subsisting and Supporter of all, by Your mercy I seek assistance, rectify for me all my affairs. Do not leave me to myself, even for the blink of an eye.",
          "repetition": "Once"
        },
        {
          "title": "Prayer for Debt Relief",
          "content": "اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ",
          "transliteration": "Allahumma-kfini bi-halalika 'an haramika, wa aghnini bi-fadlika 'amman siwak",
          "translation": "O Allah, suffice me with what You have allowed instead of what You have forbidden, and make me independent of all those besides You.",
          "repetition": "Once"
        },
        {
          "title": "Prayer for Gratitude",
          "content": "اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ",
          "transliteration": "Allahumma a'inni 'ala dhikrika wa shukrika wa husni 'ibadatik",
          "translation": "O Allah, help me to remember You, to give You thanks, and to perform Your worship in the best manner.",
          "repetition": "Once"
        },
        {
          "title": "Prostration of Gratitude",
          "content": "سُبْحَانَ رَبِّيَ الأَعْلَى",
          "transliteration": "Subhana Rabbiyal-A'la",
          "translation": "Glory be to my Lord, the Most High.",
          "repetition": "3 times"
        },
        {
          "title": "Prayer for Protection of Children",
          "content": "أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ، وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ",
          "transliteration": "U'idhu-kuma bi-kalimatil-lahit-tammati min kulli shaytanin wa hammah, wa min kulli 'aynin lammah",
          "translation": "I seek protection for you both in the Perfect Words of Allah from every devil and every poisonous reptile, and from every evil eye.",
          "repetition": "Once"
        },
        {
          "title": "Seeking Forgiveness for Believers",
          "content": "رَبَّنَا اغْفِرْ لَنَا وَلِإِخْوَانِنَا الَّذِينَ سَبَقُونَا بِالْإِيمَانِ وَلَا تَجْعَلْ فِي قُلُوبِنَا غِلًّا لِلَّذِينَ آمَنُوا رَبَّنَا إِنَّكَ رَءُوفٌ رَحِيمٌ",
          "transliteration": "Rabbana-ghfir lana wa li-ikhwanina-lladhina sabaquna bil-iman wa la taj'al fi qulubina ghillan lil-ladhina amanu rabbana innaka ra'ufun rahim",
          "translation": "Our Lord, forgive us and our brothers who preceded us in faith and put not in our hearts any resentment toward those who have believed. Our Lord, indeed You are Kind and Merciful.",
          "repetition": "Once"
        },
        {
          "title": "Prayer for Entering the Mosque",
          "content": "أَعُوذُ بِاللهِ الْعَظِيمِ، وَبِوَجْهِهِ الْكَرِيمِ، وَسُلْطَانِهِ الْقَدِيمِ، مِنَ الشَّيْطَانِ الرَّجِيمِ، بِسْمِ اللهِ، وَالصَّلَاةُ وَالسَّلَامُ عَلَى رَسُولِ اللهِ، اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ",
          "transliteration": "A'udhu billahil-'azim, wa bi-wajhihil-karim, wa sultanihil-qadim, minash-shaytanir-rajim, bismillah, was-salatu was-salamu 'ala rasulillah, allahum-maftah li abwaba rahmatik",
          "translation": "I seek refuge in Allah the Magnificent, and in His noble face, and in His eternal authority, from the accursed Satan. In the name of Allah, and peace and blessings be upon the Messenger of Allah. O Allah, open for me the gates of Your mercy.",
          "repetition": "Once when entering the mosque"
        },
        {
          "title": "Prayer for Leaving the Mosque",
          "content": "بِسْمِ اللهِ وَالصَّلاَةُ وَالسَّلاَمُ عَلَى رَسُولِ اللهِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ، اللَّهُمَّ اعْصِمْنِي مِنَ الشَّيْطَانِ الرَّجِيمِ",
          "transliteration": "Bismillah, was-salatu was-salamu 'ala rasulillah, allahumma inni as'aluka min fadlik, allahumma'simni minash-shaytanir-rajim",
          "translation": "In the name of Allah, and peace and blessings be upon the Messenger of Allah. O Allah, I ask You of Your bounty. O Allah, protect me from the accursed Satan.",
          "repetition": "Once when leaving the mosque"
        },
        {
          "title": "Prayer for Well-being",
          "content": "اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إِلَّا أَنْتَ",
          "transliteration": "Allahumma 'afini fi badani, allahumma 'afini fi sam'i, allahumma 'afini fi basari, la ilaha illa ant",
          "translation": "O Allah, grant me well-being in my body. O Allah, grant me well-being in my hearing. O Allah, grant me well-being in my sight. There is no deity but You.",
          "repetition": "Once"
        },
      ];
    }
  }
}
