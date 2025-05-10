import 'package:flutter/material.dart';
import '../services/reset_counters_service.dart';

/// A widget that shows a global reset button in the AppBar of Azkar pages
class GlobalResetButton extends StatefulWidget {
  final Function? onResetCompleted;
  
  const GlobalResetButton({
    super.key,
    this.onResetCompleted,
  });

  @override
  State<GlobalResetButton> createState() => _GlobalResetButtonState();
}

class _GlobalResetButtonState extends State<GlobalResetButton> {
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _loadButtonPreference();
  }

  Future<void> _loadButtonPreference() async {
    final showButton = await ResetCountersService.getShowGlobalResetButton();
    if (mounted) {
      setState(() {
        _showButton = showButton;
      });
    }
  }

  Future<void> _showResetConfirmationDialog() async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    
    // Since the app might not have been regenerated with new localizations yet, use hardcoded strings
    final confirmationText = isArabic
        ? 'هل أنت متأكد أنك تريد إعادة تعيين جميع العدادات؟'
        : 'Are you sure you want to reset all counters?';
    
    final yesText = isArabic ? 'نعم' : 'Yes';
    final noText = isArabic ? 'لا' : 'No';
    final resetDoneText = isArabic 
        ? 'تم إعادة تعيين جميع العدادات'
        : 'All counters have been reset';
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(confirmationText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(noText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(yesText),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ResetCountersService.resetAllCounters();
      
      if (widget.onResetCompleted != null) {
        widget.onResetCompleted!();
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resetDoneText),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_showButton) {
      return const SizedBox.shrink();
    }
    
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final tooltipText = isArabic ? 'إعادة تعيين الكل' : 'Reset All';
    
    return IconButton(
      icon: const Icon(Icons.refresh),
      tooltip: tooltipText,
      onPressed: _showResetConfirmationDialog,
    );
  }
}
