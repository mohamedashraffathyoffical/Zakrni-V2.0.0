import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class GovernorateDropdown extends StatelessWidget {
  final String selectedGovernorate;
  final Function(String) onChanged;
  final List<String> governorates;

  const GovernorateDropdown({
    super.key,
    required this.selectedGovernorate,
    required this.onChanged,
    required this.governorates,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    
    // Make sure we have a valid selected governorate
    final validSelectedGovernorate = governorates.contains(selectedGovernorate) 
        ? selectedGovernorate 
        : governorates.first;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations.selectGovernorate,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: validSelectedGovernorate,
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              items: governorates.asMap().entries.map((entry) {
                final String governorate = entry.value;
                final String displayName = isArabic 
                    ? governorate 
                    : _getTranslatedName(governorate, appLocalizations);
                
                return DropdownMenuItem<String>(
                  value: governorate,
                  child: Text(displayName),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to translate governorate names
  String _getTranslatedName(String arabicName, AppLocalizations localizations) {
    switch (arabicName) {
      case 'القاهرة': return localizations.cairo;
      case 'الإسكندرية': return localizations.alexandria;
      case 'الجيزة': return localizations.giza;
      case 'شرم الشيخ': return localizations.sharmElSheikh;
      case 'الأقصر': return localizations.luxor;
      case 'أسوان': return localizations.aswan;
      case 'بورسعيد': return localizations.portSaid;
      case 'السويس': return localizations.suez;
      case 'المنصورة': return localizations.mansoura;
      case 'طنطا': return localizations.tanta;
      case 'الشرقية': return localizations.sharqia;
      case 'الإسماعيلية': return localizations.ismailia;
      case 'الغردقة': return localizations.hurghada;
      case 'دمياط': return localizations.damietta;
      case 'بني سويف': return localizations.beniSuef;
      case 'المنيا': return localizations.minya;
      case 'سوهاج': return localizations.sohag;
      case 'قنا': return localizations.qena;
      case 'مرسى مطروح': return localizations.mersaMatruh;
      default: return arabicName;
    }
  }
}
