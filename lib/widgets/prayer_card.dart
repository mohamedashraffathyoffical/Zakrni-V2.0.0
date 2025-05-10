import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class PrayerCard extends StatelessWidget {
  final String title;
  final String prayerName;
  final String timeRemaining;
  final String timeRemainingLabel;

  const PrayerCard({
    super.key,
    required this.title,
    required this.prayerName,
    required this.timeRemaining,
    required this.timeRemainingLabel,
  });

  @override
  Widget build(BuildContext context) {
    final parts = timeRemaining.split(':');
    final hours = parts.isNotEmpty ? parts[0] : '00';
    final minutes = parts.length > 1 ? parts[1] : '00';
    final seconds = parts.length > 2 ? parts[2] : '00';
    
    final appLanguage = Provider.of<AppLanguage>(context);
    final isArabic = appLanguage.appLocale.languageCode == 'ar';
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              prayerName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              timeRemainingLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: isArabic
                  ? [
                      // For Arabic, display in reverse order (seconds:minutes:hours)
                      _buildTimeUnit(context, seconds, 'ثانية'),
                      const SizedBox(width: 8),
                      _buildTimeUnit(context, minutes, 'دقيقة'),
                      const SizedBox(width: 8),
                      _buildTimeUnit(context, hours, 'ساعة'),
                    ]
                  : [
                      // For English, display in standard order (hours:minutes:seconds)
                      _buildTimeUnit(context, hours, 'hours'),
                      const SizedBox(width: 8),
                      _buildTimeUnit(context, minutes, 'minutes'),
                      const SizedBox(width: 8),
                      _buildTimeUnit(context, seconds, 'seconds'),
                    ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnit(BuildContext context, String value, String unit) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(unit),
      ],
    );
  }
}
