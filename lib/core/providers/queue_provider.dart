import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/manager/data/models/manager_models.dart';

class QueueProvider extends ChangeNotifier {
  QueueProvider() {
    _initQueue();
  }

  int _currentPosition = 3;
  int _estimatedWaitMinutes = 18;
  String _activeTicketId = 'A-14';
  String _salonName = 'Luxe Cut Studio';
  String _serviceName = 'Haircut & Beard Styling';
  String _stylistName = 'Elena Rostova';
  QueueStatus _ticketStatus = QueueStatus.waiting;

  Timer? _countdownTimer;

  int get currentPosition => _currentPosition;
  int get estimatedWaitMinutes => _estimatedWaitMinutes;
  String get activeTicketId => _activeTicketId;
  String get salonName => _salonName;
  String get serviceName => _serviceName;
  String get stylistName => _stylistName;
  QueueStatus get ticketStatus => _ticketStatus;

  Future<void> _initQueue() async {
    final prefs = await SharedPreferences.getInstance();
    _currentPosition = prefs.getInt('queue_pos') ?? 3;
    _estimatedWaitMinutes = prefs.getInt('queue_wait') ?? 18;
    notifyListeners();

    _startLiveSimulation();
  }

  void _startLiveSimulation() {
    _countdownTimer?.cancel();
    // Simulate real-time queue progress every 45 seconds
    _countdownTimer = Timer.periodic(const Duration(seconds: 45), (timer) {
      if (_currentPosition > 1) {
        _currentPosition--;
        _estimatedWaitMinutes = (_estimatedWaitMinutes - 6).clamp(2, 60);
        _saveToPrefs();
        notifyListeners();
      } else if (_currentPosition == 1 && _ticketStatus == QueueStatus.waiting) {
        _ticketStatus = QueueStatus.inService;
        _estimatedWaitMinutes = 0;
        _saveToPrefs();
        notifyListeners();
      }
    });
  }

  void joinQueue({
    required String salon,
    required String service,
    required String stylist,
    required String ticketId,
    required int waitMinutes,
    required int position,
  }) {
    _salonName = salon;
    _serviceName = service;
    _stylistName = stylist;
    _activeTicketId = ticketId;
    _estimatedWaitMinutes = waitMinutes;
    _currentPosition = position;
    _ticketStatus = QueueStatus.waiting;

    _saveToPrefs();
    _startLiveSimulation();
    notifyListeners();
  }

  void markCompleted() {
    _ticketStatus = QueueStatus.completed;
    _currentPosition = 0;
    _estimatedWaitMinutes = 0;
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('queue_pos', _currentPosition);
    await prefs.setInt('queue_wait', _estimatedWaitMinutes);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
