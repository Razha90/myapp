import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'schedule_service.dart';
import 'schedule_model.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  final Random _random = Random();
  DateTime _nextScheduleDay = DateTime.now();

  final List<String> _courseNames = [
    'Matematika',
    'Fisika',
    'Kimia',
    'Biologi',
    'Sejarah',
    'Geografi',
    'Ekonomi',
    'Sosiologi',
    'Bahasa Indonesia',
    'Bahasa Inggris',
    'Seni Budaya',
    'Pendidikan Jasmani',
    'Informatika',
    'Agama',
    'Pancasila',
    'Kewarganegaraan',
  ];

  String _generateRandomTime() {
    final int hour = _random.nextInt(10) + 7; // 07:00 to 16:00
    final int minute = _random.nextInt(2) * 30; // 00 or 30
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final scheduleService = Provider.of<ScheduleService>(context);
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(now);
    final String currentDay = DateFormat('EEEE', 'id_ID').format(now);
    final List<Course> todayCourses = scheduleService.getTodaySchedule(
      currentDay,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Jadwal Hari Ini
            Center(
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jadwal Hari Ini',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16.0),
                      if (todayCourses.isEmpty)
                        const Text('Tidak ada mata kuliah hari ini.')
                      else
                        ...todayCourses.map(
                          (course) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              '${course.time} - ${course.name}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Daftar Jadwal
            Text(
              'Daftar Jadwal',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            if (scheduleService.schedules.isEmpty)
              const Center(child: Text('Belum ada jadwal yang ditambahkan.'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: scheduleService.schedules.length,
                itemBuilder: (context, index) {
                  final schedule = scheduleService.schedules[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        schedule.day,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      children: schedule.courses
                          .map(
                            (course) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    course.time,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Text(
                                      course.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final String scheduleDay = DateFormat(
            'EEEE',
            'id_ID',
          ).format(_nextScheduleDay);

          final int numberOfCourses = _random.nextInt(4) + 5; // 5 to 8 courses
          List<Course> randomCourses = [];
          for (int i = 0; i < numberOfCourses; i++) {
            randomCourses.add(
              Course(
                name: _courseNames[_random.nextInt(_courseNames.length)],
                time: _generateRandomTime(),
              ),
            );
          }

          final newSchedule = Schedule(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            day: scheduleDay,
            courses: randomCourses,
          );
          scheduleService.addSchedule(newSchedule);

          setState(() {
            _nextScheduleDay = _nextScheduleDay.add(const Duration(days: 1));
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
