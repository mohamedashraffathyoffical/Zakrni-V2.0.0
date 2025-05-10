import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../widgets/dhikr_counter_button.dart';
import '../../widgets/global_reset_button.dart';

class MorningAzkarPage extends StatefulWidget {
  const MorningAzkarPage({super.key});

  @override
  State<MorningAzkarPage> createState() => _MorningAzkarPageState();
}

class _MorningAzkarPageState extends State<MorningAzkarPage> {
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
        title: Text(appLocalizations.morningAzkar),
        actions: [GlobalResetButton(onResetCompleted: _refreshCounters)],
      ),
      body: AnimatedList(
        key: _listKey,
        padding: const EdgeInsets.all(16.0),
        initialItemCount: _getMorningAzkar(isArabic).length,
        itemBuilder: (context, index, animation) {
          final azkar = _getMorningAzkar(isArabic)[index];
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
    // Parse the repetition count from the text
    int totalCount = 1; // Default to 1 if parsing fails
    if (azkar['repetition'] != null) {
      final repetitionText = azkar['repetition']!;
      if (repetitionText.contains('100')) {
        totalCount = 100;
      } else if (repetitionText.contains('3')) {
        totalCount = 3;
      } else if (repetitionText.contains('7')) {
        totalCount = 7;
      } else if (repetitionText.contains('10')) {
        totalCount = 10;
      }
      // Add more patterns as needed
    }

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
                    totalCount: totalCount,
                    index: index,
                    dhikrTitle: azkar['title'] ?? 'Morning Dhikr',
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

  List<Map<String, String>> _getMorningAzkar(bool isArabic) {
    if (isArabic) {
      return [
        {
          'title': ' استغفار',
          'content':
              'أَسْتَغْفِرُ اللهَ العَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ، الحَيُّ القَيُّومُ، وَأَتُوبُ إِلَيهِ.',
          'repetition': '3 مرات',
        },
        {
          'title': ' أذكار الصباح',
          'content':
              'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَـهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': ' دعاء الصباح',
          'content':
              'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': ' دعاء الاستيقاظ',
          'content':
              'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': ' دعاء بدء اليوم',
          'content':
              'اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ فَمِنْكَ وَحْدَكَ لاَ شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': ' توكل على الله',
          'content':
              'حَسْبِيَ اللَّهُ لا إِلَـهَ إِلاَّ هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ.',
          'repetition': '7 مرات',
        },
        {
          'title': ' طلب الحفظ من الله',
          'content':
              'اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ، وَمِنْ خَلْفِي، وَعَنْ يَمِينِي، وَعَنْ شِمَالِي، وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِي.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': ' طلب الحفظ في الدين والدنيا',
          'content':
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'طلب الستر من الله',
          'content':
              'اللَّهُمَّ اسْتُرْ عَوْرَاتِي، وَآمِنْ رَوْعَاتِي، اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ وَمِنْ خَلْفِي، وَعَنْ يَمِينِي وَعَنْ شِمَالِي، وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِي.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': ' الإخلاص في العقيدة',
          'content':
              'اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ، وَأَنْ أَقْتَرِفَ عَلَى نَفْسِي سُوءًا، أَوْ أَجُرَّهُ إِلَى مُسْلِمٍ.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': ' أذكار الاستيقاظ من النوم',
          'content': 'الْحَمْدُ لله الذي أحيانا بعدما أماتنا وإليه النشور.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': ' التسبيح والتحميد',
          'content':
              'سُبْحَانَ اللهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ.',
          'repetition': '3 مرات',
        },
        {
          'title': ' طلب العلم النافع',
          'content':
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': ' طلب الرضا من الله',
          'content':
              'رَضِيتُ بِاللهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صلى الله عليه وسلم نَبِيًّا وَرَسُولًا.',
          'repetition': '3 مرات',
        },
        {
          'title': ' كلمة التوحيد',
          'content':
              'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.',
          'repetition': '100 مرة',
        },
        {
          'title': ' طلب الجنة والنجاة من النار',
          'content':
              'اللَّهُمَّ أَجِرْنِي مِنَ النَّارِ. اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ.',
          'repetition': '7 مرات',
        },
        {
          'title': ' سؤال الحسنات',
          'content':
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنَ الْخَيْرِ كُلِّهِ عَاجِلِهِ وَآجِلِهِ ، مَا عَلِمْتُ مِنْهُ وَمَا لَمْ أَعْلَمْ ، وَأَعُوذُ بِكَ مِنَ الشَّرِّ كُلِّهِ عَاجِلِهِ وَآجِلِهِ ، مَا عَلِمْتُ مِنْهُ وَمَا لَمْ أَعْلَمْ.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': ' سؤال الجنة',
          'content':
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ وَمَا قَرَّبَ إِلَيْهَا مِنْ قَوْلٍ أَوْ عَمَلٍ ، وَأَعُوذُ بِكَ مِنَ النَّارِ وَمَا قَرَّبَ إِلَيْهَا مِنْ قَوْلٍ أَوْ عَمَلٍ.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': ' الصلاة على النبي',
          'content':
              'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ.',
          'repetition': '10 مرات',
        },
        {
          'title': ' سورة الإخلاص',
          'content':
              'بِسْمِ اللهِ الرَّحْمنِ الرَّحِيمِ \n قُلۡ هُوَ ٱللَّهُ أَحَدٌ (1) ٱللَّهُ ٱلصَّمَدُ (2) لَمۡ يَلِدۡ وَلَمۡ يُولَدۡ (3) وَلَمۡ يَكُن لَّهُۥ كُفُوًا أَحَدُۢ (4)',
          'repetition': '3 مرات',
        },
        {
          'title': ' سورة الفلق',
          'content':
              'بِسْمِ اللهِ الرَّحْمنِ الرَّحِيمِ \n قُلۡ أَعُوذُ بِرَبِّ ٱلۡفَلَقِ (1) مِن شَرِّ مَا خَلَقَ (2) وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ (3) وَمِن شَرِّ ٱلنَّفَّٰثَٰتِ فِي ٱلۡعُقَدِ (4) وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ (5) ',
          'repetition': '3 مرات',
        },
        {
          'title': ' سورة الناس',
          'content':
              'بِسْمِ اللهِ الرَّحْمنِ الرَّحِيمِ \n قُلۡ أَعُوذُ بِرَبِّ ٱلنَّاسِ (1) مَلِكِ ٱلنَّاسِ (2) إِلَٰهِ ٱلنَّاسِ (3) مِن شَرِّ ٱلۡوَسۡوَاسِ ٱلۡخَنَّاسِ (4) ٱلَّذِي يُوَسۡوِسُ فِي صُدُورِ ٱلنَّاسِ (5) مِنَ ٱلۡجِنَّةِ وَٱلنَّاسِ (6)',
          'repetition': '3 مرات',
        },
        {
          'title': ' آية الكرسي',
          'content': ' ﴿ اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ ﴾\n البقرة: 255]  ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': ' التسبيح',
          'content': 'سُبْحَانَ اللهِ',
          'repetition': '33 مرة',
        },
        {'title': ' الحمد', 'content': 'الحَمدُ لله', 'repetition': '33 مرة'},
        {'title': ' التكبير', 'content': 'اللهُ أكبر', 'repetition': '33 مرة'},
        {
          'title': ' التهليل',
          'content':
              'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.',
          'repetition': 'مرة واحدة بعد التسبيح',
        },
        {
          'title': ' ربنا آتنا',
          'content':
              'رَبَّنَا آِتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآْخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ.',
          'repetition': '3 مرات',
        },
        {
          'title': ' سيد الاستغفار',
          'content':
              'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ.',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'الاستغفار',
          'content': 'أَسْتَغْفِرُ اللهَ وَأَتُوبُ إِلَيْهِ.',
          'repetition': '100 مرة',
        },
        {
          'title': 'التسبيح',
          'content': 'سُبْحَانَ اللهِ وَبِحَمْدِهِ.',
          'repetition': '100 مرة',
        },
        {
          'title': 'آية الكرسي',
          'content': ' ﴿ اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ ﴾\n البقرة: 255]  ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'المعوذات',
          'content':
              'قُلْ هُوَ اللَّهُ أَحَدٌ، اللَّهُ الصَّمَدُ، لَمْ يَلِدْ وَلَمْ يُولَدْ، وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ.\n\nقُلْ أَعُوذُ بِرَبِّ الْفَلَقِ، مِن شَرِّ مَا خَلَقَ، وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ، وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ، وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ.\n\nقُلْ أَعُوذُ بِرَبِّ النَّاسِ، مَلِكِ النَّاسِ، إِلَهِ النَّاسِ، مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ، الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ، مِنَ الْجِنَّةِ وَ النَّاسِ.',
          'repetition': '3 مرات',
        },
      ];
    } else {
      return [
        {
          'title': 'Seeking Forgiveness',
          'content': 'أَسْتَغْفِرُ اللهَ العَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ، الحَيُّ القَيُّومُ، وَأَتُوبُ إِلَيهِ.',
          'transliteration': 'Astaghfirullaha al-\'Azeem alladhee la ilaha illa huwa, al-Hayyul-Qayyoom, wa atoobu ilayh.',
          'translation': 'I seek forgiveness from Allah, the Magnificent, besides whom there is none worthy of worship, the Ever-Living, the Sustainer of all, and I repent to Him.',
          'repetition': '3 times',
        },
        {
          'title': 'Morning Remembrance',
          'content': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَـهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
          'transliteration': 'Asbahna wa asbahal mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la shareeka lah, lahul mulku wa lahul hamd, wa huwa ala kulli shay\'in qadeer.',
          'translation': 'We have reached the morning and the kingdom belongs to Allah. Praise is to Allah. None has the right to be worshipped except Allah, alone, without partner. To Him belongs the dominion, to Him belongs all praise, and He is over all things Omnipotent.',
          'repetition': 'Once',
        },
        {
          'title': 'Morning and Evening Supplication',
          'content': 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ.',
          'transliteration': 'Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namoot, wa ilayka an-nushoor.',
          'translation': 'O Allah, by You we enter the morning, by You we enter the evening, by You we live, by You we die, and to You is the resurrection.',
          'repetition': 'Once',
        },
        {
          'title': 'Protection Prayer',
          'content': 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ.',
          'transliteration': 'Alhamdu lillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushoor.',
          'translation': 'All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.',
          'repetition': 'Once',
        },
        {
          'title': 'Beginning of Day Prayer',
          'content': 'اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ فَمِنْكَ وَحْدَكَ لاَ شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ.',
          'transliteration': 'Allahumma ma asbaha bi min ni\'matin aw bi-ahadin min khalqika faminka wahdaka la shareeka lak, falakal-hamdu wa lakash-shukr.',
          'translation': 'O Allah, whatever blessing has been received by me or anyone of Your creation is from You alone, without partner, so for You is all praise and unto You all thanks.',
          'repetition': 'Once',
        },
        {
          'title': 'Trust in Allah',
          'content': 'حَسْبِيَ اللَّهُ لا إِلَـهَ إِلاَّ هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ.',
          'transliteration': 'Hasbiyallahu la ilaha illa huwa \'alayhi tawakkaltu wa huwa rabbul-\'arshil-\'azeem.',
          'translation': 'Allah is sufficient for me. There is none worthy of worship but Him. I have placed my trust in Him, He is Lord of the Majestic Throne.',
          'repetition': '7 times',
        },
        {
          'title': 'Seeking Protection',
          'content': 'اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ، وَمِنْ خَلْفِي، وَعَنْ يَمِينِي، وَعَنْ شِمَالِي، وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِي.',
          'transliteration': 'Allahummahfazni min bayni yadayya, wa min khalfi, wa \'an yameeni, wa \'an shimali, wa min fawqi, wa a\'udhu bi\'azamatika an ughtala min tahti.',
          'translation': 'O Allah, protect me from what is in front of me and behind me, from my right and my left, from above me and I seek refuge in Your Greatness from being taken unaware from beneath me.',
          'repetition': 'Once',
        },
        {
          'title': 'Seeking Well-being',
          'content': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي.',
          'transliteration': 'Allahumma inni as\'alukal-\'afiyata fid-dunya wal-akhirah. Allahumma inni as\'alukal-\'afwa wal-\'afiyata fi dini wa dunyaya wa ahli wa mali.',
          'translation': 'O Allah, I ask You for well-being in this world and in the Hereafter. O Allah, I ask You for pardon and well-being in my religion, my worldly affairs, my family and my wealth.',
          'repetition': 'Once',
        },
        {
          'title': 'Seeking Allah\'s Cover',
          'content': 'اللَّهُمَّ اسْتُرْ عَوْرَاتِي، وَآمِنْ رَوْعَاتِي، اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ وَمِنْ خَلْفِي، وَعَنْ يَمِينِي وَعَنْ شِمَالِي، وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِي.',
          'transliteration': 'Allahummas-tur \'awrati, wa amin raw\'ati, Allahummahfazni min bayni yadayya wa min khalfi, wa \'an yameeni wa \'an shimali, wa min fawqi, wa a\'udhu bi\'azamatika an ughtala min tahti.',
          'translation': 'O Allah, conceal my faults, calm my fears, and protect me from what is in front of me and behind me, from my right and my left, from above me, and I seek refuge in Your Greatness from being taken unaware from beneath me.',
          'repetition': 'Once',
        },
        {
          'title': 'Sincerity in Faith',
          'content': 'اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ، وَأَنْ أَقْتَرِفَ عَلَى نَفْسِي سُوءًا، أَوْ أَجُرَّهُ إِلَى مُسْلِمٍ.',
          'transliteration': 'Allahumma \'Alimal-ghaybi wash-shahadah, fatiras-samawati wal-ard, rabba kulli shay\'in wa malikah, ashhadu an la ilaha illa ant, a\'udhu bika min sharri nafsi wa min sharrish-shaytani wa shirkih, wa an aqtarifa \'ala nafsi su\'an aw ajurrahu ila muslim.',
          'translation': 'O Allah, Knower of the unseen and the evident, Creator of the heavens and the earth, Lord and Sovereign of all things, I bear witness that none has the right to be worshipped except You. I seek refuge in You from the evil of my soul and from the evil of Satan and his idolatrous suggestions, and from committing wrong against my soul or bringing such upon another Muslim.',
          'repetition': 'Once',
        },
        {
          'title': 'Glorification and Praise',
          'content': 'سُبْحَانَ اللهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ.',
          'transliteration': 'Subhanallahi wa bihamdihi \'adada khalqihi, wa rida nafsihi, wa zinata \'arshihi, wa midada kalimatihi.',
          'translation': 'Glory and praise be to Allah, as many times as the number of His creation, as pleases Him, as weighs His throne, and as vast as His words.',
          'repetition': '3 times',
        },
        {
          'title': 'Seeking Beneficial Knowledge',
          'content': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا.',
          'transliteration': 'Allahumma inni as\'aluka \'ilman nafi\'an, wa rizqan tayyiban, wa \'amalan mutaqabbalan.',
          'translation': 'O Allah, I ask You for knowledge that is beneficial, provision that is good, and deeds that are acceptable.',
          'repetition': 'Once',
        },
        {
          'title': 'Satisfaction with Allah',
          'content': 'رَضِيتُ بِاللهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صلى الله عليه وسلم نَبِيًّا وَرَسُولًا.',
          'transliteration': 'Raditu billahi rabban, wa bil-islami dinan, wa bi-Muhammadin sallallahu \'alayhi wa sallama nabiyyan wa rasula.',
          'translation': 'I am pleased with Allah as my Lord, with Islam as my religion and with Muhammad (peace and blessings of Allah be upon him) as my Prophet and Messenger.',
          'repetition': '3 times',
        },
        {
          'title': 'Declaration of Faith',
          'content': 'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.',
          'transliteration': 'La ilaha illallah wahdahu la sharika lah, lahul-mulku wa lahul-hamd, wa huwa \'ala kulli shay\'in qadir.',
          'translation': 'There is none worthy of worship but Allah alone, Who has no partner. His is the dominion and His is the praise, and He is able to do all things.',
          'repetition': '100 times',
        },
        {
          'title': 'Seeking Paradise',
          'content': 'اللَّهُمَّ أَجِرْنِي مِنَ النَّارِ. اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ.',
          'transliteration': 'Allahumma ajirni minan-nar. Allahumma inni as\'alukal-jannah.',
          'translation': 'O Allah, save me from the Fire. O Allah, I ask You for Paradise.',
          'repetition': '7 times',
        },
        {
          'title': 'Asking for Good',
          'content': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنَ الْخَيْرِ كُلِّهِ عَاجِلِهِ وَآجِلِهِ ، مَا عَلِمْتُ مِنْهُ وَمَا لَمْ أَعْلَمْ ، وَأَعُوذُ بِكَ مِنَ الشَّرِّ كُلِّهِ عَاجِلِهِ وَآجِلِهِ ، مَا عَلِمْتُ مِنْهُ وَمَا لَمْ أَعْلَمْ.',
          'transliteration': 'Allahumma inni as\'aluka minal-khayri kullihi \'ajilihi wa ajilih, ma \'alimtu minhu wa ma lam a\'lam, wa a\'udhu bika minash-sharri kullihi \'ajilihi wa ajilih, ma \'alimtu minhu wa ma lam a\'lam.',
          'translation': 'O Allah, I ask You for all that is good, in this world and in the Hereafter, what I know and what I do not know. I seek refuge with You from all evil, in this world and in the Hereafter, what I know and what I do not know.',
          'repetition': 'Once',
        },
        {
          'title': 'Seeking Paradise',
          'content': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ وَمَا قَرَّبَ إِلَيْهَا مِنْ قَوْلٍ أَوْ عَمَلٍ ، وَأَعُوذُ بِكَ مِنَ النَّارِ وَمَا قَرَّبَ إِلَيْهَا مِنْ قَوْلٍ أَوْ عَمَلٍ.',
          'transliteration': 'Allahumma inni as\'alukal-jannata wa ma qarraba ilayha min qawlin aw \'amal, wa a\'udhu bika minan-nari wa ma qarraba ilayha min qawlin aw \'amal.',
          'translation': 'O Allah, I ask You for Paradise and whatever brings me closer to it of words and deeds, and I seek refuge in You from the Fire and whatever brings me closer to it of words and deeds.',
          'repetition': 'Once',
        },
        {
          'title': 'Blessings on the Prophet',
          'content': 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ.',
          'transliteration': 'Allahumma salli \'ala Muhammadin wa \'ala ali Muhammad, kama sallayta \'ala Ibrahima wa \'ala ali Ibrahim, innaka Hamidun Majid.',
          'translation': 'O Allah, send prayers upon Muhammad and upon the family of Muhammad, just as You sent prayers upon Ibrahim and upon the family of Ibrahim. Indeed, You are full of praise and majesty.',
          'repetition': '10 times',
        },
        {
          'title': 'Surah Al-Ikhlas',
          'content': '''بِسْمِ اللهِ الرَّحْمنِ الرَّحِيمِ 
قُلْ هُوَ اللَّهُ أَحَدٌ 
اللَّهُ الصَّمَدُ 
لَمْ يَلِدْ وَلَمْ يُولَدْ 
وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ''',
          'transliteration': 'Bismillahir-Rahmanir-Rahim. Qul huwa Allahu ahad. Allahus-samad. Lam yalid wa lam yulad. Wa lam yakun lahu kufuwan ahad.',
          'translation': 'In the name of Allah, the Most Gracious, the Most Merciful. Say, "He is Allah, [who is] One, Allah, the Eternal Refuge. He neither begets nor is born, Nor is there to Him any equivalent."',
          'repetition': '3 times',
        },
        {
          'title': 'Surah Al-Falaq',
          'content': '''بِسْمِ اللهِ الرَّحْمنِ الرَّحِيمِ 
قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ 
مِنْ شَرِّ مَا خَلَقَ 
وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ 
وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ 
وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ''',
          'transliteration': 'Bismillahir-Rahmanir-Rahim. Qul a\'udhu bi rabbil-falaq. Min sharri ma khalaq. Wa min sharri ghasiqin idha waqab. Wa min sharrin-naffathati fil \'uqad. Wa min sharri hasidin idha hasad.',
          'translation': 'In the name of Allah, the Most Gracious, the Most Merciful. Say, "I seek refuge in the Lord of daybreak. From the evil of that which He created. And from the evil of darkness when it settles. And from the evil of the blowers in knots. And from the evil of an envier when he envies."',
          'repetition': '3 times',
        },
        {
          'title': 'Surah An-Nas',
          'content': '''بِسْمِ اللهِ الرَّحْمنِ الرَّحِيمِ 
قُلْ أَعُوذُ بِرَبِّ النَّاسِ 
مَلِكِ النَّاسِ 
إِلَهِ النَّاسِ 
مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ 
الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ 
مِنَ الْجِنَّةِ وَالنَّاسِ''',
          'transliteration': 'Bismillahir-Rahmanir-Rahim. Qul a\'udhu bi rabbin-nas. Malikin-nas. Ilahin-nas. Min sharril-waswasil-khannas. Alladhee yuwaswisu fee sudoorin-nas. Minal-jinnati wan-nas.',
          'translation': 'In the name of Allah, the Most Gracious, the Most Merciful. Say, "I seek refuge in the Lord of mankind, The Sovereign of mankind, The God of mankind, From the evil of the retreating whisperer - Who whispers [evil] into the breasts of mankind - From among the jinn and mankind."',
          'repetition': '3 times',
        },
        {
          'title': 'Ayatul Kursi',
          'content': 'اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلاَ يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلاَّ بِمَا شَاء وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ.',
          'transliteration': 'Allahu la ilaha illa huwal-hayyul-qayyum. La ta\'khudhuhu sinatun wa la nawm. Lahu ma fis-samawati wa ma fil-ard. Man dhal-ladhi yashfa\'u \'indahu illa bi-idhnih. Ya\'lamu ma bayna aydeehim wa ma khalfahum. Wa la yuhituna bi-shay\'im-min \'ilmihi illa bima sha\'. Wasi\'a kursiyyuhus-samawati wal-ard. Wa la ya\'uduhu hifzuhuma wa huwal-\'aliyyul-\'azim.',
          'translation': 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.',
          'repetition': 'Once',
        },
        {
          'title': 'Seeking Protection',
          'content': 'أَعُوذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.',
          'transliteration': 'A\'udhu bi-kalimatil-lahit-tammati min sharri ma khalaq.',
          'translation': 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
          'repetition': '3 times',
        },
        {
          'title': 'Morning Dhikr',
          'content': 'سُبْحَانَ اللهِ وَبِحَمْدِهِ.',
          'transliteration': 'Subhanallahi wa bihamdihi.',
          'translation': 'Glory and praise be to Allah.',
          'repetition': '100 times',
        },
        {
          'title': 'Glorification of Allah',
          'content': 'سُبْحَانَ اللهِ العَظِيمِ وَبِحَمْدِهِ.',
          'transliteration': 'Subhanallahil-\'azimi wa bihamdihi.',
          'translation': 'Glory and praise be to Allah, the Magnificent.',
          'repetition': '100 times',
        },
        {
          'title': 'Seeking Forgiveness',
          'content': 'أَسْتَغْفِرُ اللهَ وَأَتُوبُ إِلَيْهِ.',
          'transliteration': 'Astaghfirullaha wa atubu ilayh.',
          'translation': 'I seek forgiveness from Allah and I repent to Him.',
          'repetition': '100 times',
        },
        {
          'title': 'Protection from Harm',
          'content': 'بِسْمِ اللهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ.',
          'transliteration': 'Bismillahil-ladhi la yadurru ma\'a ismihi shay\'un fil-ardi wa la fis-sama\'i wa huwas-sami\'ul-\'alim.',
          'translation': 'In the name of Allah, with whose name nothing can cause harm on earth or in the heavens, and He is the All-Hearing, the All-Knowing.',
          'repetition': '3 times',
        },
        {
          'title': 'Gratitude to Allah',
          'content': 'اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ.',
          'transliteration': 'Allahumma ma asbaha bi min ni\'matin faminka wahdaka la sharika lak, falakal-hamdu wa lakash-shukr.',
          'translation': 'O Allah, whatever blessing I have received today is from You alone, without partner, so for You is all praise and unto You all thanks.',
          'repetition': 'Once',
        },
        {
          'title': 'Seeking Guidance',
          'content': 'اللَّهُمَّ اهْدِنِي مِنْ عِنْدِكَ، وَأَفِضْ عَلَيَّ مِنْ فَضْلِكَ، وَانْشُرْ عَلَيَّ مِنْ رَحْمَتِكَ، وَأَنْزِلْ عَلَيَّ مِنْ بَرَكَاتِكَ.',
          'transliteration': 'Allahumma ihdini min \'indik, wa afid \'alayya min fadlik, wanshur \'alayya min rahmatik, wa anzil \'alayya min barakatik.',
          'translation': 'O Allah, guide me from Yourself, pour upon me from Your favor, spread upon me from Your mercy, and send down upon me from Your blessings.',
          'repetition': 'Once',
        },
        {
          'title': 'Seeking Refuge from Evil',
          'content': 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَأَعُوذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ، وَأَعُوذُ بِكَ مِنَ الْجُبْنِ وَالْبُخْلِ، وَأَعُوذُ بِكَ مِنْ غَلَبَةِ الدَّيْنِ، وَقَهْرِ الرِّجَالِ.',
          'transliteration': 'Allahumma inni a\'udhu bika minal-hammi wal-hazan, wa a\'udhu bika minal-\'ajzi wal-kasal, wa a\'udhu bika minal-jubni wal-bukhl, wa a\'udhu bika min ghalabatid-dayni, wa qahri rrijal.',
          'translation': 'O Allah, I seek refuge in You from anxiety and sorrow, I seek refuge in You from weakness and laziness, I seek refuge in You from cowardice and miserliness, and I seek refuge in You from being overcome by debt and overpowered by men.',
          'repetition': 'Once',
        },
      ];
    }
  }
}
