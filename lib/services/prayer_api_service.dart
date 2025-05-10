import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_time.dart';
import '../l10n/app_localizations.dart';

class PrayerApiService {
  // Using Al-Adhan API for prayer times
  static const String baseUrl = 'https://api.aladhan.com/v1/timingsByCity';
  
  // Map of Egyptian governorates with their coordinates
  static final Map<String, Map<String, dynamic>> egyptGovernorates = {
    'القاهرة': {'city': 'Cairo', 'country': 'Egypt'},
    'الإسكندرية': {'city': 'Alexandria', 'country': 'Egypt'},
    'الجيزة': {'city': 'Giza', 'country': 'Egypt'},
    'شرم الشيخ': {'city': 'Sharm El Sheikh', 'country': 'Egypt'},
    'الأقصر': {'city': 'Luxor', 'country': 'Egypt'},
    'أسوان': {'city': 'Aswan', 'country': 'Egypt'},
    'بورسعيد': {'city': 'Port Said', 'country': 'Egypt'},
    'السويس': {'city': 'Suez', 'country': 'Egypt'},
    'المنصورة': {'city': 'Mansoura', 'country': 'Egypt'},
    'طنطا': {'city': 'Tanta', 'country': 'Egypt'},
    'الإسماعيلية': {'city': 'Ismailia', 'country': 'Egypt'},
    'الغردقة': {'city': 'Hurghada', 'country': 'Egypt'},
    'دمياط': {'city': 'Damietta', 'country': 'Egypt'},
    'بني سويف': {'city': 'Beni Suef', 'country': 'Egypt'},
    'المنيا': {'city': 'Minya', 'country': 'Egypt'},
    'سوهاج': {'city': 'Sohag', 'country': 'Egypt'},
    'قنا': {'city': 'Qena', 'country': 'Egypt'},
    'مرسى مطروح': {'city': 'Mersa Matruh', 'country': 'Egypt'},
    'الشرقية': {'city': 'Sharqia', 'country': 'Egypt'},
  };

  // Get prayer times for a specific governorate
  Future<DailyPrayers> getPrayerTimes(String governorate) async {
    try {
      // Ensure we're using the Arabic governorate name for the map lookup
      // This handles the case where an English name is passed after language switching
      String arabicGovernorate = governorate;
      if (!egyptGovernorates.containsKey(governorate)) {
        // If the governorate is not found in the map keys (which are Arabic),
        // it might be the English name, so try to find the corresponding Arabic name
        arabicGovernorate = getArabicGovernorateFromTranslation(governorate);
      }
      
      final location = egyptGovernorates[arabicGovernorate] ?? egyptGovernorates['القاهرة']!;
      
      // Simple API call with method=5 for Egyptian General Authority of Survey
      final response = await http.get(Uri.parse(
        '$baseUrl?city=${location['city']}&country=${location['country']}&method=5'
      ));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API Response: ${data['data']['timings']}'); // Debug print
        return DailyPrayers.fromJson(data['data']);
      } else {
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching prayer times: $e'); // Debug print
      throw Exception('Error fetching prayer times: $e');
    }
  }

  // Get list of available governorates
  List<String> getAvailableGovernorates() {
    return egyptGovernorates.keys.toList();
  }
  
  // Get translated governorate list based on current locale
  List<String> getTranslatedGovernorates(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    
    if (isArabic) {
      // Return the Arabic names directly
      return getAvailableGovernorates();
    } else {
      // Return the English translation of the governorates
      return getAvailableGovernorates().map((governorateAr) {
        return _getGovernorateNameTranslated(governorateAr, appLocalizations);
      }).toList();
    }
  }
  
  // Get translated governorate name
  String _getGovernorateNameTranslated(String arabicName, AppLocalizations localizations) {
    // Map Arabic governorate names to their translation keys
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
      // Add translations for other governorates as needed
      default: return arabicName;
    }
  }
  
  // Get Arabic governorate name from English translation
  String getArabicGovernorateFromTranslation(String translatedName) {
    // Find the Arabic key by matching the city name in the values
    for (var entry in egyptGovernorates.entries) {
      if (entry.value['city'].toString().toLowerCase() == translatedName.toLowerCase() ||
          entry.key == translatedName) {
        return entry.key;
      }
    }
    // Default to Cairo if not found
    return 'القاهرة';
  }
}
