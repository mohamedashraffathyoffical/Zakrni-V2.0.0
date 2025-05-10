import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../widgets/dhikr_counter_button.dart';
import '../../widgets/global_reset_button.dart';

class WakingAzkarPage extends StatefulWidget {
  const WakingAzkarPage({super.key});

  @override
  State<WakingAzkarPage> createState() => _WakingAzkarPageState();
}

class _WakingAzkarPageState extends State<WakingAzkarPage> {
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
    final appLanguage = Provider.of<AppLanguage>(context);
    final isArabic = appLanguage.appLocale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'أذكار الاستيقاظ' : 'Waking Supplications'),
        actions: [
          GlobalResetButton(onResetCompleted: _refreshCounters),
        ],
      ),
      body: AnimatedList(
        key: _listKey,
        padding: const EdgeInsets.all(16.0),
        initialItemCount: _getWakingAzkar(isArabic).length,
        itemBuilder: (context, index, animation) {
          final azkar = _getWakingAzkar(isArabic)[index];
          return FadeTransition(
            opacity: animation,
            child: _buildAzkarCard(context, azkar, index),
          );
        },
      ),
    );
  }

  Widget _buildAzkarCard(
    BuildContext context,
    Map<String, String> azkar,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
            ],
            if (azkar['repetition'] != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.repeat,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          azkar['repetition']!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  DhikrCounterButton(
                    key: Key('waking_azkar_$index'),
                    index: index,
                    totalCount: _parseRepetitionCount(azkar['repetition']!),
                    dhikrTitle: azkar['title']!,
                    onComplete: (_) {},
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _parseRepetitionCount(String repetitionText) {
    try {
      if (repetitionText.contains('مرة') || repetitionText.contains('مرات')) {
        return int.parse(repetitionText.split(' ')[0]);
      } else if (repetitionText.contains('Once')) {
        return 1;
      } else if (repetitionText.contains('times')) {
        return int.parse(repetitionText.split(' ')[0]);
      }
      return 1;
    } catch (e) {
      return 1;
    }
  }

  List<Map<String, String>> _getWakingAzkar(bool isArabic) {
    if (isArabic) {
      return [
        {
          'title': 'دعاء الاستيقاظ من النوم',
          'content': 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا، وَإِلَيْهِ النُّشُورُ',
          'transliteration': 'Alhamdu lillahil-lathee ahyana ba\'da ma amatana, wa ilayhin-nushoor',
          'translation': 'All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'التهليل بعد الاستيقاظ',
          'content': 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا اللَّهُ، وَاللَّهُ أَكْبَرُ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ، رَبِّ اغْفِرْ لِي',
          'transliteration': 'La ilaha illallahu wahdahu la shareeka lah, lahul-mulku walahul-hamd, wahuwa \'ala kulli shay\'in qadeer, subhanallahi, walhamdu lillahi, wala ilaha illallahu, wallahu akbar, wala hawla wala quwwata illa billahil-\'aliyyil-\'azeem, rabbighfir lee',
          'translation': 'None has the right to be worshipped except Allah alone, without partner. To Him belongs all sovereignty and praise, and He is over all things omnipotent. Glory is to Allah. Praise is to Allah. None has the right to be worshipped except Allah. Allah is the greatest. There is no might nor power except with Allah, the Most High, the Most Great. O my Lord, forgive me.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء لبس الثوب',
          'content': 'الْحَمْدُ لِلَّهِ الَّذِي كَسَانِي هَذَا (الثَّوْبَ) وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
          'transliteration': 'Alhamdu lillahil-lathee kasanee hatha (aththawb) warazaqaneehi min ghayri hawlin minnee wala quwwah',
          'translation': 'All praise is for Allah who has clothed me with this (garment) and provided it for me, with no power or might from myself.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء دخول الخلاء',
          'content': 'بِسْمِ اللَّهِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبْثِ وَالْخَبَائِثِ',
          'transliteration': 'Bismillah, Allahumma innee a\'oothu bika minal-khubthi wal-khaba\'ith',
          'translation': 'In the name of Allah. O Allah, I seek refuge with You from the male and female devils.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء الخروج من الخلاء',
          'content': 'غُفْرَانَكَ',
          'transliteration': 'Ghufranaka',
          'translation': 'I ask You (Allah) for forgiveness.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء الوضوء',
          'content': 'بِسْمِ اللَّهِ',
          'transliteration': 'Bismillah',
          'translation': 'In the name of Allah.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء فتح الصيام',
          'content': 'ذَهَبَ الظَّمَأُ، وَابْتَلَّتِ الْعُرُوقُ، وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ',
          'transliteration': 'Dhahabath-thama\'u, wabtallatil-\'urooqu, wa thabatal-ajru in sha Allah',
          'translation': 'The thirst is gone, the veins are moistened, and the reward is confirmed, if Allah wills.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء الخروج من المنزل',
          'content': 'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
          'transliteration': 'Bismillah, tawakkaltu \'alallah, wa la hawla wa la quwwata illa billah',
          'translation': 'In the name of Allah, I place my trust in Allah, and there is no might nor power except with Allah.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء دخول المنزل',
          'content': 'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى رَبِّنَا تَوَكَّلْنَا',
          'transliteration': 'Bismillahi walajna, wa bismillahi kharajna, wa \'ala rabbina tawakkalna',
          'translation': 'In the name of Allah we enter, in the name of Allah we leave, and upon our Lord we depend.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء الذهاب إلى المسجد',
          'content': 'اللَّهُمَّ اجْعَلْ فِي قَلْبِي نُورًا، وَفِي لِسَانِي نُورًا، وَفِي سَمْعِي نُورًا، وَفِي بَصَرِي نُورًا، وَمِنْ فَوْقِي نُورًا، وَمِنْ تَحْتِي نُورًا، وَعَنْ يَمِينِي نُورًا، وَعَنْ شِمَالِي نُورًا، وَمِنْ أَمَامِي نُورًا، وَمِنْ خَلْفِي نُورًا، وَاجْعَلْ فِي نَفْسِي نُورًا، وَأَعْظِمْ لِي نُورًا',
          'transliteration': 'Allahumma-j\'al fee qalbi nooraa, wa fee lisaanee nooraa, wa fee sam\'ee nooraa, wa fee basaree nooraa, wa min fawqi nooraa, wa min tahti nooraa, wa \'an yameeni nooraa, wa \'an shimaali nooraa, wa min amami nooraa, wa min khalfi nooraa, waj\'al fee nafsi nooraa, wa \'a\'zhim li nooraa',
          'translation': 'O Allah, place light in my heart, light in my tongue, light in my hearing, light in my sight, light above me, light below me, light on my right, light on my left, light in front of me, light behind me, place light in my soul, and make the light greater for me.',
          'repetition': 'مرة واحدة',
        },
      ];
    } else {
      return [
        {
          'title': 'Waking Up Supplication',
          'content': 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا، وَإِلَيْهِ النُّشُورُ',
          'transliteration': 'Alhamdu lillahil-lathee ahyana ba\'da ma amatana, wa ilayhin-nushoor',
          'translation': 'All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.',
          'repetition': 'Once',
        },
        {
          'title': 'Declaration of Faith After Waking',
          'content': 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا اللَّهُ، وَاللَّهُ أَكْبَرُ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ، رَبِّ اغْفِرْ لِي',
          'transliteration': 'La ilaha illallahu wahdahu la shareeka lah, lahul-mulku walahul-hamd, wahuwa \'ala kulli shay\'in qadeer, subhanallahi, walhamdu lillahi, wala ilaha illallahu, wallahu akbar, wala hawla wala quwwata illa billahil-\'aliyyil-\'azeem, rabbighfir lee',
          'translation': 'None has the right to be worshipped except Allah alone, without partner. To Him belongs all sovereignty and praise, and He is over all things omnipotent. Glory is to Allah. Praise is to Allah. None has the right to be worshipped except Allah. Allah is the greatest. There is no might nor power except with Allah, the Most High, the Most Great. O my Lord, forgive me.',
          'repetition': 'Once',
        },
        {
          'title': 'Supplication When Dressing',
          'content': 'الْحَمْدُ لِلَّهِ الَّذِي كَسَانِي هَذَا (الثَّوْبَ) وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
          'transliteration': 'Alhamdu lillahil-lathee kasanee hatha (aththawb) warazaqaneehi min ghayri hawlin minnee wala quwwah',
          'translation': 'All praise is for Allah who has clothed me with this (garment) and provided it for me, with no power or might from myself.',
          'repetition': 'Once',
        },
        {
          'title': 'Supplication When Entering the Toilet',
          'content': 'بِسْمِ اللَّهِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبْثِ وَالْخَبَائِثِ',
          'transliteration': 'Bismillah, Allahumma innee a\'oothu bika minal-khubthi wal-khaba\'ith',
          'translation': 'In the name of Allah. O Allah, I seek refuge with You from the male and female devils.',
          'repetition': 'Once',
        },
        {
          'title': 'Supplication When Leaving the Toilet',
          'content': 'غُفْرَانَكَ',
          'transliteration': 'Ghufranaka',
          'translation': 'I ask You (Allah) for forgiveness.',
          'repetition': 'Once',
        },
        {
          'title': 'Remembrance Before Ablution',
          'content': 'بِسْمِ اللَّهِ',
          'transliteration': 'Bismillah',
          'translation': 'In the name of Allah.',
          'repetition': 'Once',
        },
        {
          'title': 'Supplication When Breaking Fast',
          'content': 'ذَهَبَ الظَّمَأُ، وَابْتَلَّتِ الْعُرُوقُ، وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ',
          'transliteration': 'Dhahabath-thama\'u, wabtallatil-\'urooqu, wa thabatal-ajru in sha Allah',
          'translation': 'The thirst is gone, the veins are moistened, and the reward is confirmed, if Allah wills.',
          'repetition': 'Once',
        },
        {
          'title': 'Supplication When Leaving Home',
          'content': 'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
          'transliteration': 'Bismillah, tawakkaltu \'alallah, wa la hawla wa la quwwata illa billah',
          'translation': 'In the name of Allah, I place my trust in Allah, and there is no might nor power except with Allah.',
          'repetition': 'Once',
        },
        {
          'title': 'Supplication When Entering Home',
          'content': 'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى رَبِّنَا تَوَكَّلْنَا',
          'transliteration': 'Bismillahi walajna, wa bismillahi kharajna, wa \'ala rabbina tawakkalna',
          'translation': 'In the name of Allah we enter, in the name of Allah we leave, and upon our Lord we depend.',
          'repetition': 'Once',
        },
        {
          'title': 'Supplication When Going to the Mosque',
          'content': 'اللَّهُمَّ اجْعَلْ فِي قَلْبِي نُورًا، وَفِي لِسَانِي نُورًا، وَفِي سَمْعِي نُورًا، وَفِي بَصَرِي نُورًا، وَمِنْ فَوْقِي نُورًا، وَمِنْ تَحْتِي نُورًا، وَعَنْ يَمِينِي نُورًا، وَعَنْ شِمَالِي نُورًا، وَمِنْ أَمَامِي نُورًا، وَمِنْ خَلْفِي نُورًا، وَاجْعَلْ فِي نَفْسِي نُورًا، وَأَعْظِمْ لِي نُورًا',
          'transliteration': 'Allahumma-j\'al fee qalbi nooraa, wa fee lisaanee nooraa, wa fee sam\'ee nooraa, wa fee basaree nooraa, wa min fawqi nooraa, wa min tahti nooraa, wa \'an yameeni nooraa, wa \'an shimaali nooraa, wa min amami nooraa, wa min khalfi nooraa, waj\'al fee nafsi nooraa, wa \'a\'zhim li nooraa',
          'translation': 'O Allah, place light in my heart, light in my tongue, light in my hearing, light in my sight, light above me, light below me, light on my right, light on my left, light in front of me, light behind me, place light in my soul, and make the light greater for me.',
          'repetition': 'Once',
        },
      ];
    }
  }
}
