import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/reset_counters_service.dart';
import '../services/notification_service.dart';

class DhikrCounterButton extends StatefulWidget {
  final int totalCount;
  final int index;
  final String dhikrTitle;
  final Function(int) onComplete;
  
  const DhikrCounterButton({
    super.key,
    required this.totalCount,
    required this.index,
    required this.dhikrTitle,
    required this.onComplete,
  });

  @override
  State<DhikrCounterButton> createState() => _DhikrCounterButtonState();
}

class _DhikrCounterButtonState extends State<DhikrCounterButton> {
  int _currentCount = 0;
  bool _isCompleted = false;
  bool _showResetButton = true;
  final String _prefsPrefix = 'dhikr_counter_';

  @override
  void initState() {
    super.initState();
    _loadSavedCount();
    _loadResetButtonPreference();
    
    // Listen for reset notifications
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.addListener('counters_reset', _handleReset);
    });
  }
  
  @override
  void dispose() {
    NotificationService.removeListener('counters_reset', _handleReset);
    super.dispose();
  }
  
  void _handleReset() {
    _loadSavedCount();
  }
  
  Future<void> _loadResetButtonPreference() async {
    final showResetButton = await ResetCountersService.getShowIndividualResetButtons();
    if (mounted) {
      setState(() {
        _showResetButton = showResetButton;
      });
    }
  }

  Future<void> _loadSavedCount() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_prefsPrefix}${widget.dhikrTitle}_${widget.index}';
    
    setState(() {
      _currentCount = prefs.getInt(key) ?? 0;
      _isCompleted = _currentCount >= widget.totalCount;
    });
  }

  Future<void> _saveCount() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_prefsPrefix}${widget.dhikrTitle}_${widget.index}';
    await prefs.setInt(key, _currentCount);
  }

  void _incrementCount() {
    if (_currentCount < widget.totalCount) {
      setState(() {
        _currentCount++;
        _isCompleted = _currentCount >= widget.totalCount;
      });
      
      _saveCount();
      
      if (_isCompleted) {
        widget.onComplete(_currentCount);
      }
    }
  }

  void _resetCount() {
    setState(() {
      _currentCount = 0;
      _isCompleted = false;
    });
    _saveCount();
    
    // Notify other dhikr widgets about this individual reset
    // This helps keep UI consistent across the app
    NotificationService.notify('counter_${widget.dhikrTitle}_${widget.index}_reset');
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.totalCount > 0 ? _currentCount / widget.totalCount : 0.0;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onLongPress: _resetCount,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3.0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isCompleted 
                      ? Colors.green 
                      : Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isCompleted 
                    ? Colors.green 
                    : Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: _incrementCount,
                  customBorder: const CircleBorder(),
                  child: Center(
                    child: Text(
                      '$_currentCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showResetButton) ...[  // Only show reset button if preference is enabled
          const SizedBox(width: 8),  // Add spacing between counter and reset button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _resetCount,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.refresh,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
