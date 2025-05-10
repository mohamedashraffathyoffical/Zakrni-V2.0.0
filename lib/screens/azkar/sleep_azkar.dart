import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../widgets/dhikr_counter_button.dart';
import '../../widgets/global_reset_button.dart';

class SleepAzkarPage extends StatefulWidget {
  const SleepAzkarPage({super.key});

  @override
  State<SleepAzkarPage> createState() => _SleepAzkarPageState();
}

class _SleepAzkarPageState extends State<SleepAzkarPage> {
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
        title: Text(appLocalizations.sleepAzkar),
        actions: [
          GlobalResetButton(onResetCompleted: _refreshCounters),
        ],
      ),
      body: AnimatedList(
        key: _listKey,
        padding: const EdgeInsets.all(16.0),
        initialItemCount: _getSleepAzkar(isArabic).length,
        itemBuilder: (context, index, animation) {
          final azkar = _getSleepAzkar(isArabic)[index];
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
                    dhikrTitle: azkar['title'] ?? 'Sleep Dhikr',
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
  
  List<Map<String, String>> _getSleepAzkar(bool isArabic) {
    if (isArabic) {
      return [
        {
          'title': 'دعاء النوم',
          'content': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'التسبيح قبل النوم',
          'content': 'سُبْحَانَ اللهِ',
          'repetition': '33 مرة',
        },
        {
          'title': 'التحميد قبل النوم',
          'content': 'الْحَمْدُ لِلَّهِ',
          'repetition': '33 مرة',
        },
        {
          'title': 'التكبير قبل النوم',
          'content': 'اللهُ أَكْبَرُ',
          'repetition': '34 مرة',
        },
        {
          'title': 'تسليم لله',
          'content': 'اللَّهُمَّ أَسْلَمْتُ وَجْهِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لاَ مَلْجَأَ وَلاَ مَنْجَا مِنْكَ إِلاَّ إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ، وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء عند وضع الجنب للنوم',
          'content': 'باسمك ربي وضعت جنبي، وبك أرفعه، فإن أمسكت نفسي فارحمها، وإن أرسلتها فاحفظها بما تحفظ به عبادك الصالحين',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'الاستغفار قبل النوم',
          'content': 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
          'repetition': '3 مرات',
        },
        {
          'title': 'الصلاة على النبي',
          'content': 'اللهم صل على محمد وعلى آل محمد، كما صليت على إبراهيم وعلى آل إبراهيم، إنك حميد مجيد',
          'repetition': '10 مرات',
        },
        {
          'title': 'قراءة سورة الملك',
          'content': 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ \nتَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ(1) الَّذِي خَلَقَ الْمَوْتَ وَالْحَيَاةَ لِيَبْلُوَكُمْ أَيُّكُمْ أَحْسَنُ عَمَلًا ۚ وَهُوَ الْعَزِيزُ الْغَفُورُ(2) الَّذِي خَلَقَ سَبْعَ سَمَاوَاتٍ طِبَاقًا ۖ مَّا تَرَىٰ فِي خَلْقِ الرَّحْمَٰنِ مِن تَفَاوُتٍ ۖ فَارْجِعِ الْبَصَرَ هَلْ تَرَىٰ مِن فُطُورٍ(3) ثُمَّ ارْجِعِ الْبَصَرَ كَرَّتَيْنِ يَنقَلِبْ إِلَيْكَ الْبَصَرُ خَاسِئًا وَهُوَ حَسِيرٌ(4) وَلَقَدْ زَيَّنَّا السَّمَاءَ الدُّنْيَا بِمَصَابِيحَ وَجَعَلْنَاهَا رُجُومًا لِّلشَّيَاطِينِ ۖ وَأَعْتَدْنَا لَهُمْ عَذَابَ السَّعِيرِ(5) وَلِلَّذِينَ كَفَرُوا بِرَبِّهِمْ عَذَابُ جَهَنَّمَ ۖ وَبِئْسَ الْمَصِيرُ(6) إِذَا أُلْقُوا فِيهَا سَمِعُوا لَهَا شَهِيقًا وَهِيَ تَفُورُ(7) تَكَادُ تَمَيَّزُ مِنَ الْغَيْظِ ۖ كُلَّمَا أُلْقِيَ فِيهَا فَوْجٌ سَأَلَهُمْ خَزَنَتُهَا أَلَمْ يَأْتِكُمْ نَذِيرٌ(8) قَالُوا بَلَىٰ قَدْ جَاءَنَا نَذِيرٌ فَكَذَّبْنَا وَقُلْنَا مَا نَزَّلَ اللَّهُ مِن شَيْءٍ إِنْ أَنتُمْ إِلَّا فِي ضَلَالٍ كَبِيرٍ(9) وَقَالُوا لَوْ كُنَّا نَسْمَعُ أَوْ نَعْقِلُ مَا كُنَّا فِي أَصْحَابِ السَّعِيرِ(10) فَاعْتَرَفُوا بِذَنبِهِمْ فَسُحْقًا لِّأَصْحَابِ السَّعِيرِ(11) إِنَّ الَّذِينَ يَخْشَوْنَ رَبَّهُم بِالْغَيْبِ لَهُم مَّغْفِرَةٌ وَأَجْرٌ كَبِيرٌ(12) وَأَسِرُّوا قَوْلَكُمْ أَوِ اجْهَرُوا بِهِ ۖ إِنَّهُ عَلِيمٌ بِذَاتِ الصُّدُورِ(13) أَلَا يَعْلَمُ مَنْ خَلَقَ وَهُوَ اللَّطِيفُ الْخَبِيرُ(14) هُوَ الَّذِي جَعَلَ لَكُمُ الْأَرْضَ ذَلُولًا فَامْشُوا فِي مَنَاكِبِهَا وَكُلُوا مِن رِّزْقِهِ ۖ وَإِلَيْهِ النُّشُورُ(15) أَأَمِنتُم مَّن فِي السَّمَاءِ أَن يَخْسِفَ بِكُمُ الْأَرْضَ فَإِذَا هِيَ تَمُورُ(16) أَمْ أَمِنتُم مَّن فِي السَّمَاءِ أَن يُرْسِلَ عَلَيْكُمْ حَاصِبًا ۖ فَسَتَعْلَمُونَ كَيْفَ نَذِيرِ(17) وَلَقَدْ كَذَّبَ الَّذِينَ مِن قَبْلِهِمْ فَكَيْفَ كَانَ نَكِيرِ(18) أَوَلَمْ يَرَوْا إِلَى الطَّيْرِ فَوْقَهُمْ صَافَّاتٍ وَيَقْبِضْنَ ۚ مَا يُمْسِكُهُنَّ إِلَّا الرَّحْمَٰنُ ۚ إِنَّهُ بِكُلِّ شَيْءٍ بَصِيرٌ(19) أَمَّنْ هَٰذَا الَّذِي هُوَ جُندٌ لَّكُمْ يَنصُرُكُم مِّن دُونِ الرَّحْمَٰنِ ۚ إِنِ الْكَافِرُونَ إِلَّا فِي غُرُورٍ(20) أَمَّنْ هَٰذَا الَّذِي يَرْزُقُكُمْ إِنْ أَمْسَكَ رِزْقَهُ ۚ بَل لَّجُّوا فِي عُتُوٍّ وَنُفُورٍ(21) أَفَمَن يَمْشِي مُكِبًّا عَلَىٰ وَجْهِهِ أَهْدَىٰ أَمَّن يَمْشِي سَوِيًّا عَلَىٰ صِرَاطٍ مُّسْتَقِيمٍ(22) قُلْ هُوَ الَّذِي أَنشَأَكُمْ وَجَعَلَ لَكُمُ السَّمْعَ وَالْأَبْصَارَ وَالْأَفْئِدَةَ ۖ قَلِيلًا مَّا تَشْكُرُونَ(23) قُلْ هُوَ الَّذِي ذَرَأَكُمْ فِي الْأَرْضِ وَإِلَيْهِ تُحْشَرُونَ(24) وَيَقُولُونَ مَتَىٰ هَٰذَا الْوَعْدُ إِن كُنتُمْ صَادِقِينَ(25) قُلْ إِنَّمَا الْعِلْمُ عِندَ اللَّهِ وَإِنَّمَا أَنَا نَذِيرٌ مُّبِينٌ(26) فَلَمَّا رَأَوْهُ زُلْفَةً سِيئَتْ وُجُوهُ الَّذِينَ كَفَرُوا وَقِيلَ هَٰذَا الَّذِي كُنتُم بِهِ تَدَّعُونَ(27) قُلْ أَرَأَيْتُمْ إِنْ أَهْلَكَنِيَ اللَّهُ وَمَن مَّعِيَ أَوْ رَحِمَنَا فَمَن يُجِيرُ الْكَافِرِينَ مِنْ عَذَابٍ أَلِيمٍ(28) قُلْ هُوَ الرَّحْمَٰنُ آمَنَّا بِهِ وَعَلَيْهِ تَوَكَّلْنَا ۖ فَسَتَعْلَمُونَ مَنْ هُوَ فِي ضَلَالٍ مُّبِينٍ(29) قُلْ أَرَأَيْتُمْ إِنْ أَصْبَحَ مَاؤُكُمْ غَوْرًا فَمَن يَأْتِيكُم بِمَاءٍ مَّعِينٍ(30)',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'بسم الله قبل النوم',
          'content': 'بِسْمِ اللهِ وَضَعْتُ جَنْبِي وَاللهُمَّ اغْفِرْ لِي ذَنْبِي وَأَخْسِئْ شَيْطَانِي وَفُكَّ رِهَانِي وَاجْعَلْنِي فِي النَّدِيِّ الأَعْلَى',
          'repetition': 'مرة واحدة',
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
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء النوم الآخر',
          'content':
              'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لَا مَلْجَأَ وَلَا مَنْجَا مِنْكَ إِلَّا إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ، وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'الاستعاذة من شر النفس',
          'content': 'اللَّهُمَّ عَالِمَ الغَيْبِ وَالشَّهَادَةِ، فَاطِرَ السَّمَاوَاتِ وَالأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ، وَأَنْ أَقْتَرِفَ عَلَى نَفْسِي سُوءًا، أَوْ أَجُرَّهُ إِلَى مُسْلِمٍ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'دعاء الفزع في النوم',
          'content': 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ غَضَبِهِ وَعِقَابِهِ، وَمِنْ شَرِّ عِبَادِهِ، وَمِنْ هَمَزَاتِ الشَّيَاطِينِ وَأَنْ يَحْضُرُونِ',
          'repetition': '3 مرات',
        },
        {
          'title': 'طلب الحماية من الكوابيس',
          'content': 'أَعُوذُ بِكَلِمَاتِ اللهِ التامة من كل شيطان وهامة، ومن كل عين لامة',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'الاستعاذة من الهم والحزن',
          'content': 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحُزْنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'سيد الاستغفار',
          'content': 'اللَّهُمَّ أَنْتَ رَبِّي لا إِلَهَ إِلا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي، فَإِنَّهُ لا يَغْفِرُ الذُّنُوبَ إِلا أَنْتَ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'التسبيح بعدد خلق الله',
          'content': 'سُبْحَانَ اللهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ',
          'repetition': '3 مرات',
        },
        {
          'title': 'طلب رضا الله',
          'content': 'رَضِيتُ بِاللهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صلى الله عليه وسلم نَبِيًّا وَرَسُولًا',
          'repetition': '3 مرات',
        },
        {
          'title': 'التهليل',
          'content': 'لَا إِلَهَ إِلاَّ اللهُ وَحدَهُ لا شَرِيكَ لَهُ، لَهُ المُلكُ وَلَهُ الحَمدُ وَهُوَ عَلَى كُلِّ شَيءٍ قَدِيرٌ',
          'repetition': '10 مرات',
        },
        {
          'title': 'طلب الحسنة في الدنيا والآخرة',
          'content': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          'repetition': '3 مرات',
        },
        {
          'title': 'الدعاء للوالدين',
          'content': 'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَابُ',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'طلب الحفظ للأهل',
          'content': 'اللَّهُمَّ احفظ أهلي ومالي وولدي من بين يديهم ومن خلفهم وعن أيمانهم وعن شمائلهم ومن فوقهم ومن تحتهم',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'التوكل على الله',
          'content': 'حَسْبِيَ اللهُ لا إله إلا هو عليه توكلت وهو رب العرش العظيم',
          'repetition': '7 مرات',
        },
        {
          'title': 'ذكر الله عند النوم',
          'content': 'اللهم إني أمسيت أشهدك، وأشهد حملة عرشك، وملائكتك، وجميع خلقك، أنك أنت الله لا إله إلا أنت وحدك لا شريك لك، وأن محمداً عبدك ورسولك',
          'repetition': '4 مرات',
        },
        {
          'title': 'الاستعاذة من عذاب القبر',
          'content': 'اللهم إني أعوذ بك من عذاب القبر، ومن عذاب جهنم، ومن فتنة المحيا والممات، ومن شر فتنة المسيح الدجال',
          'repetition': 'مرة واحدة',
        },
        {
          'title': 'التسبيح قبل النوم مطول',
          'content': 'سبحان الله وبحمده',
          'repetition': '100 مرة',
        },
        {
          'title': 'دعاء الخوف في الليل',
          'content': 'لا إله إلا الله الواحد القهار، رب السماوات والأرض وما بينهما العزيز الغفار',
          'repetition': '3 مرات',
        },
        {
          'title': 'الاستغفار للمؤمنين',
          'content': 'ربنا اغفر لنا ولإخواننا الذين سبقونا بالإيمان ولا تجعل في قلوبنا غلاً للذين آمنوا ربنا إنك رؤوف رحيم',
          'repetition': 'مرة واحدة',
        },
      ];
    } else {
      return [
        {
          'title': '1. Sleep Supplication',
          'content': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          'transliteration': 'Bismika Allahumma amootu wa ahya',
          'translation': 'In Your name, O Allah, I die and I live.',
          'repetition': 'Once',
        },
        {
          'title': 'Glorification of Allah',
          'content': 'سُبْحَانَ اللهِ',
          'transliteration': 'Subhanallah',
          'translation': 'Glory be to Allah',
          'repetition': '33 times',
        },
        {
          'title': 'Praise of Allah',
          'content': 'الْحَمْدُ لِلَّهِ',
          'transliteration': 'Alhamdulillah',
          'translation': 'All praise is due to Allah',
          'repetition': '33 times',
        },
        {
          'title': 'Magnification of Allah',
          'content': 'اللهُ أَكْبَرُ',
          'transliteration': 'Allahu Akbar',
          'translation': 'Allah is the Greatest',
          'repetition': '34 times',
        },
        {
          'title': 'Complete Submission to Allah',
          'content': 'اللَّهُمَّ أَسْلَمْتُ وَجْهِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لاَ مَلْجَأَ وَلاَ مَنْجَا مِنْكَ إِلَّا إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ، وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ',
          'transliteration': 'Allahumma aslamtu wajhi ilayk, wa fawwadtu amri ilayk, wa alja\'tu dhahri ilayk, raghbatan wa rahbatan ilayk, la malja\'a wa la manja minka illa ilayk, amantu bikitabika-lladhi anzalta, wa binabiyyika-lladhi arsalta',
          'translation': 'O Allah, I submit my face to You, entrust my affairs to You, turn my back to You in hope and fear of You. There is no refuge or escape from You except to You. I believe in Your Book which You revealed and Your Prophet whom You sent.',
          'repetition': 'Once',
        },
        {
          'title': 'Prayer When Laying Down',
          'content': 'باسمك ربي وضعت جنبي، وبك أرفعه، فإن أمسكت نفسي فارحمها، وإن أرسلتها فاحفظها بما تحفظ به عبادك الصالحين',
          'transliteration': 'Bismika Rabbi wada\'tu janbi, wa bika arfa\'uhu, fa in amsakta nafsi farhamha, wa in arsaltaha fahfadh-ha bima tahfadhu bihi \'ibadaka-s-salihin',
          'translation': 'In Your name, my Lord, I lay down my side, and by You I raise it up. If You take my soul, then have mercy on it, and if You release it, then protect it with what You protect Your righteous servants.',
          'repetition': 'Once',
        },
        {
          'title': 'Seeking Forgiveness',
          'content': 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
          'transliteration': 'Astaghfirullah al-\'Adhim, alladhi la ilaha illa Huwa, al-Hayyu al-Qayyumu, wa atubu ilayh',
          'translation': 'I seek forgiveness from Allah the Magnificent, there is no deity except Him, the Ever-Living, the Self-Sustaining, and I repent to Him.',
          'repetition': '3 times',
        },
        {
          'title': 'Blessings Upon the Prophet',
          'content': 'اللهم صل على محمد وعلى آل محمد، كما صليت على إبراهيم وعلى آل إبراهيم، إنك حميد مجيد',
          'transliteration': 'Allahumma salli \'ala Muhammad wa \'ala ali Muhammad, kama sallayta \'ala Ibrahim wa \'ala ali Ibrahim, innaka Hamidun Majid',
          'translation': 'O Allah, send blessings upon Muhammad and upon the family of Muhammad, as You sent blessings upon Ibrahim and upon the family of Ibrahim. Truly, You are Praiseworthy and Glorious.',
          'repetition': '10 times',
        },
        {
          'title': 'Surah Al-Mulk',
          'content': 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ \nتَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ... (كاملة)',
          'transliteration': 'Bismillahir Rahmanir Rahim. Tabaraka alladhi biyadihil mulku wahuwa \'ala kulli shay\'in qadir... (complete surah)',
          'translation': 'In the name of Allah, the Most Gracious, the Most Merciful. Blessed is He in whose hand is dominion, and He is over all things competent... (complete chapter)',
          'repetition': 'Once',
        },
        {
          'title': 'Remembrance Before Sleep',
          'content': 'بِسْمِ اللهِ وَضَعْتُ جَنْبِي وَاللهُمَّ اغْفِرْ لِي ذَنْبِي وَأَخْسِئْ شَيْطَانِي وَفُكَّ رِهَانِي وَاجْعَلْنِي فِي النَّدِيِّ الأَعْلَى',
          'transliteration': 'Bismillahi wada\'tu janbi, Allahumma-ghfir li dhanbi, wa akhsi\' shaytani, wa fukka rihani, waj\'alni fin-nadiyyil a\'la',
          'translation': 'In the name of Allah I lie down, O Allah forgive my sins, ward off my devil, free me from my pledge, and place me in the highest assembly.',
          'repetition': 'Once',
        },
        {
          'title': 'Ayatul Kursi',
          'content':
              'اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلاَ يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاء وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ',
          'translation':
              'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.',
          'repetition': 'Once',
        },
        {
          'title': 'The Three Quls',
          'content':
              'قُلْ هُوَ اللَّهُ أَحَدٌ، اللَّهُ الصَّمَدُ، لَمْ يَلِدْ وَلَمْ يُولَدْ، وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ.\n\nقُلْ أَعُوذُ بِرَبِّ الْفَلَقِ، مِن شَرِّ مَا خَلَقَ، وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ، وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ، وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ.\n\nقُلْ أَعُوذُ بِرَبِّ النَّاسِ، مَلِكِ النَّاسِ، إِلَهِ النَّاسِ، مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ، الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ، مِنَ الْجِنَّةِ وَ النَّاسِ.',
          'translation':
              'Say, "He is Allah, [who is] One, Allah, the Eternal Refuge. He neither begets nor is born, Nor is there to Him any equivalent."\n\nSay, "I seek refuge in the Lord of daybreak, From the evil of that which He created, And from the evil of darkness when it settles, And from the evil of the blowers in knots, And from the evil of an envier when he envies."\n\nSay, "I seek refuge in the Lord of mankind, The Sovereign of mankind, The God of mankind, From the evil of the retreating whisperer - Who whispers [evil] into the breasts of mankind - From among the jinn and mankind."',
          'repetition': 'Once',
        },
        {
          'title': 'Another Sleep Supplication',
          'content':
              'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لَا مَلْجَأَ وَلَا مَنْجَا مِنْكَ إِلَّا إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ، وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ',
          'transliteration':
              'Allahumma aslamtu nafsi ilayka, wa fawwadtu amri ilayka, wa wajjahtu wajhi ilayka, wa alja\'tu dhahri ilayka, raghbatan wa rahbatan ilayka, la malja\'a wa la manja minka illa ilayka, amantu bikitabika-lladhi anzalta, wa binabiyyika-lladhi arsalta',
          'translation':
              'O Allah, I submit myself to You, entrust my affairs to You, turn my face to You, and lay my back against You in hope and fear of You. There is no refuge or escape from You except to You. I believe in Your Book which You revealed and Your Prophet whom You sent.',
          'repetition': 'Once',
        },
        {
          'title': 'Protection from Evil',
          'content': 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
          'transliteration': 'A\'udhu bikalimati-llahit-tammati min sharri ma khalaq',
          'translation': 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
          'repetition': '3 times',
        },
        {
          'title': 'Bedtime Supplication',
          'content': 'اللهم قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
          'transliteration': 'Allahumma qini \'adhabaka yawma tab\'athu \'ibadak',
          'translation': 'O Allah, protect me from Your punishment on the Day when You resurrect Your servants.',
          'repetition': '3 times',
        },
        {
          'title': 'Remembrance Before Going to Bed',
          'content': 'اللَّهُمَّ بِاسْمِكَ أَمُوتُ وَأَحْيَا',
          'transliteration': 'Allahumma bismika amutu wa ahya',
          'translation': 'O Allah, in Your name I die and I live.',
          'repetition': 'Once',
        },
        {
          'title': 'Reciting Surah Al-Kafirun',
          'content': 'قُلْ يَا أَيُّهَا الْكَافِرُونَ... (كاملة)',
          'transliteration': 'Qul ya ayyuhal kafirun... (complete surah)',
          'translation': 'Say, "O disbelievers..." (complete chapter)',
          'repetition': 'Once',
        },
        {
          'title': 'Night Remembrance',
          'content': 'لا إله إلا الله وحده لا شريك له، له الملك، وله الحمد، وهو على كل شيء قدير',
          'transliteration': 'La ilaha illallah wahdahu la sharika lah, lahul-mulku wa lahul-hamd, wa huwa \'ala kulli shay\'in qadir',
          'translation': 'There is no deity worthy of worship except Allah alone, without partner. To Him belongs all sovereignty and praise, and He is over all things competent.',
          'repetition': '100 times',
        },
        {
          'title': 'Praise Before Sleep',
          'content': 'الحمد لله الذي أطعمنا وسقانا، وكفانا، وآوانا، فكم ممن لا كافي له ولا مؤوي',
          'transliteration': 'Alhamdulillahil-ladhi at\'amana wa saqana, wa kafana, wa awana, fakam mimman la kafiya lahu wa la mu\'wi',
          'translation': 'All praise is for Allah, Who has fed us and given us drink, and Who is sufficient for us and has sheltered us, for how many have none to suffice them or shelter them.',
          'repetition': 'Once',
        },
        {
          'title': 'Protection from Insomnia',
          'content': 'اللهم رب السماوات السبع وما أظلت، ورب الأرضين وما أقلت، ورب الشياطين وما أضلت، كن لي جارا من شر خلقك كلهم جميعا أن يفرط علي أحد منهم أو أن يبغي علي، عز جارك، وجل ثناؤك، ولا إله غيرك، ولا إله إلا أنت',
          'transliteration': 'Allahumma rabbas-samawatis-sab\'i wa ma adhallat, wa rabbal-aradina wa ma aqallat, wa rabbash-shayateeni wa ma adallat, kun li jaran min sharri khalqika kullihim jami\'a, an yafruta \'alayya ahadun minhum aw an yabghiya \'alayya, \'azza jaruka, wa jalla thana\'uka, wa la ilaha ghayruka, wa la ilaha illa ant',
          'translation': 'O Allah, Lord of the seven heavens and all they overshadow, Lord of the earths and all they uphold, Lord of the devils and all they lead astray, be my protector from the evil of all Your creation, lest any of them harm me or transgress against me. Mighty is Your protection, exalted is Your praise. There is no god other than You; there is no god but You.',
          'repetition': 'Once',
        },
        {
          'title': 'Glorifying Allah before Sleep',
          'content': 'سبحان الله عدد ما خلق، سبحان الله ملء ما خلق، سبحان الله عدد ما في السماوات والأرض، سبحان الله ملء ما في السماوات والأرض، سبحان الله عدد ما أحصى كتابه، سبحان الله ملء ما أحصى كتابه',
          'transliteration': 'Subhanallahi \'adada ma khalaq, subhanallahi mil\'a ma khalaq, subhanallahi \'adada ma fis-samawati wal-ardi, subhanallahi mil\'a ma fis-samawati wal-ardi, subhanallahi \'adada ma ahsa kitabuh, subhanallahi mil\'a ma ahsa kitabuh',
          'translation': 'Glory be to Allah by the number of what He has created, glory be to Allah by the fullness of what He has created, glory be to Allah by the number of what is in the heavens and the earth, glory be to Allah by the fullness of what is in the heavens and the earth, glory be to Allah by the number of what His Book has enumerated, glory be to Allah by the fullness of what His Book has enumerated.',
          'repetition': 'Once',
        },
        {
          'title': 'Protection from Night Fears',
          'content': 'أعوذ بكلمات الله التامات التي لا يجاوزهن بر ولا فاجر من شر ما خلق وذرأ وبرأ، ومن شر ما ينزل من السماء، ومن شر ما يعرج فيها، ومن شر ما ذرأ في الأرض، ومن شر ما يخرج منها، ومن شر فتن الليل والنهار، ومن شر كل طارق إلا طارقا يطرق بخير يا رحمن',
          'transliteration': 'A\'udhu bikalimatillahit-tammati allati la yujawizuhunna barrun wa la fajirun min sharri ma khalaqa wa dhara\'a wa bara\'a, wa min sharri ma yanzilu minas-sama\'i, wa min sharri ma ya\'ruju fiha, wa min sharri ma dhara\'a fil-ardi, wa min sharri ma yakhruju minha, wa min sharri fitanil-layli wan-nahari, wa min sharri kulli tariqin illa tariqan yatruqu bikhayrin ya rahman',
          'translation': 'I seek refuge in Allah\'s perfect words which neither the righteous nor the unrighteous may surpass, from the evil of what He created, made, and originated, from the evil of what descends from the sky, from the evil of what ascends into it, from the evil of what He scattered in the earth, from the evil of what emerges from it, from the evil of the trials of night and day, and from the evil of every visitor at night except one that brings good, O Most Merciful.',
          'repetition': 'Once',
        },
        {
          'title': 'Shield Against All Fears',
          'content': 'بِسْمِ اللهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
          'transliteration': 'Bismillahil-ladhi la yadurru ma\'a ismihi shay\'un fil-ardi wa la fis-sama\'i wa huwas-sami\'ul-\'alim',
          'translation': 'In the name of Allah, with whose name nothing can harm on earth or in heaven, and He is the All-Hearing, the All-Knowing.',
          'repetition': '3 times',
        },
        {
          'title': 'Last Verses of Surah Al-Baqarah',
          'content': 'آمَنَ الرَّسُولُ بِمَا أُنْزِلَ إِلَيْهِ مِنْ رَبِّهِ وَالْمُؤْمِنُونَ... (الآيتين الأخيرتين من سورة البقرة)',
          'transliteration': 'Amanar-rasulu bima unzila ilayhi mir-rabbihi wal-mu\'minun... (the last two verses of Surah Al-Baqarah)',
          'translation': 'The Messenger has believed in what was revealed to him from his Lord, and the believers... (the last two verses of Surah Al-Baqarah)',
          'repetition': 'Once',
        },
        {
          'title': 'Gratitude at Night',
          'content': 'اللَّهُمَّ لَكَ الْحَمْدُ أَنْتَ كَسَوْتَنِيهِ، أَسْأَلُكَ مِنْ خَيْرِهِ وَخَيْرِ مَا صُنِعَ لَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّهِ وَشَرِّ مَا صُنِعَ لَهُ',
          'transliteration': 'Allahumma lakal-hamdu anta kasawtanihi, as\'aluka min khayrihi wa khayri ma suni\'a lahu, wa a\'udhu bika min sharrihi wa sharri ma suni\'a lahu',
          'translation': 'O Allah, all praise is due to You. You have clothed me with this. I ask You for its goodness and the goodness for which it was made, and I seek Your protection from its evil and the evil for which it was made.',
          'repetition': 'Once',
        },
        {
          'title': 'Protection for Family',
          'content': 'اللَّهُمَّ احفظ أهلي ومالي وولدي من بين يديهم ومن خلفهم وعن أيمانهم وعن شمائلهم ومن فوقهم ومن تحتهم',
          'transliteration': 'Allahumma-hfadh ahli wa mali wa waladi min bayni aydihim wa min khalfihim wa \'an aymanihim wa \'an shama\'ilihim wa min fawqihim wa min tahtihim',
          'translation': 'O Allah, protect my family, my wealth, and my children from what is before them, behind them, on their right, on their left, above them and below them.',
          'repetition': 'Once',
        },
        {
          'title': 'Trust in Allah',
          'content': 'حَسْبِيَ اللهُ لا إله إلا هو عليه توكلت وهو رب العرش العظيم',
          'transliteration': 'Hasbiyallahu la ilaha illa huwa \'alayhi tawakkaltu wa huwa rabbul-\'arshil-\'adhim',
          'translation': 'Allah is sufficient for me. There is no deity except Him. Upon Him I rely, and He is the Lord of the Great Throne.',
          'repetition': '7 times',
        },
        {
          'title': 'Nighttime Testimony',
          'content': 'اللهم إني أمسيت أشهدك، وأشهد حملة عرشك، وملائكتك، وجميع خلقك، أنك أنت الله لا إله إلا أنت وحدك لا شريك لك، وأن محمداً عبدك ورسولك',
          'transliteration': 'Allahumma inni amsaytu ush-hiduka, wa ush-hidu hamalata \'arshika, wa mala\'ikataka, wa jami\'a khalqika, annaka antallahu la ilaha illa anta wahdaka la sharika laka, wa anna Muhammadan \'abduka wa rasuluka',
          'translation': 'O Allah, I have reached evening and call upon You, and the bearers of Your throne, Your angels and all of Your creation to witness that You are Allah, none has the right to be worshipped except You alone, without partner, and that Muhammad is Your slave and Your Messenger.',
          'repetition': '4 times',
        },
        {
          'title': 'Seeking Refuge from Grave Punishment',
          'content': 'اللهم إني أعوذ بك من عذاب القبر، ومن عذاب جهنم، ومن فتنة المحيا والممات، ومن شر فتنة المسيح الدجال',
          'transliteration': 'Allahumma inni a\'udhu bika min \'adhabil-qabri, wa min \'adhabi jahannama, wa min fitnatil-mahya wal-mamati, wa min sharri fitnatil-masihid-dajjal',
          'translation': 'O Allah, I seek refuge in You from the punishment of the grave, from the punishment of Hellfire, from the trials of life and death, and from the evil of the trial of the false messiah.',
          'repetition': 'Once',
        },
        {
          'title': 'Extended Glorification Before Sleep',
          'content': 'سبحان الله وبحمده',
          'transliteration': 'Subhanallahi wa bihamdihi',
          'translation': 'Glory be to Allah and praise Him.',
          'repetition': '100 times',
        },
        {
          'title': 'Nighttime Fear Supplication',
          'content': 'لا إله إلا الله الواحد القهار، رب السماوات والأرض وما بينهما العزيز الغفار',
          'transliteration': 'La ilaha illallahul-wahidul-qahhar, rabbus-samawati wal-ardi wa ma baynahuma al-\'azizul-ghaffar',
          'translation': 'There is no deity except Allah, the One, the Prevailing, Lord of the heavens and the earth and what is between them, the Exalted in Might, the Perpetual Forgiver.',
          'repetition': '3 times',
        },
        {
          'title': 'Forgiveness for Believers',
          'content': 'ربنا اغفر لنا ولإخواننا الذين سبقونا بالإيمان ولا تجعل في قلوبنا غلاً للذين آمنوا ربنا إنك رؤوف رحيم',
          'transliteration': 'Rabbana-ghfir lana wa li-ikhwaninal-ladhina sabaquna bil-imani wa la taj\'al fi qulubina ghillan lil-ladhina amanu rabbana innaka ra\'ufur-rahim',
          'translation': 'Our Lord, forgive us and our brothers who preceded us in faith and put not in our hearts hatred toward those who have believed. Our Lord, indeed You are Kind and Merciful.',
          'repetition': 'Once',
        },
      ];
    }
  }
}
