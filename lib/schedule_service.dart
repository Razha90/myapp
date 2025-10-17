import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'schedule_model.dart';

class ScheduleService extends ChangeNotifier {
  static const String _schedulesKey = 'schedules';
  List<Schedule> _schedules = [];

  List<Schedule> get schedules => _schedules;

  ScheduleService() {
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final String? schedulesString = prefs.getString(_schedulesKey);
    if (schedulesString != null) {
      final List<dynamic> scheduleListJson = json.decode(schedulesString);
      _schedules = scheduleListJson.map((json) => Schedule.fromJson(json)).toList();
    }
    notifyListeners();
  }

  Future<void> addSchedule(Schedule newSchedule) async {
    _schedules.add(newSchedule);
    await _saveSchedules();
    notifyListeners();
  }

  Future<void> _saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final String schedulesString = json.encode(_schedules.map((s) => s.toJson()).toList());
    await prefs.setString(_schedulesKey, schedulesString);
  }

  List<Course> getTodaySchedule(String currentDay) {
    final todaySchedule = _schedules.where((s) => s.day.toLowerCase() == currentDay.toLowerCase()).toList();
    if (todaySchedule.isNotEmpty) {
      return todaySchedule.first.courses;
    }
    return [];
  }
}