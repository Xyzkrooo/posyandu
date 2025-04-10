import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class JadwalView extends StatefulWidget {
  const JadwalView({super.key});

  @override
  _JadwalViewState createState() => _JadwalViewState();
}

class _JadwalViewState extends State<JadwalView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jadwal Posyandu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                // Contoh aksi ketika tanggal dipilih
                Get.snackbar(
                  "Tanggal Dipilih",
                  "Kamu memilih tanggal: ${selectedDay.toLocal()}",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.blueAccent,
                  colorText: Colors.white,
                );
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: true,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                "Pilih tanggal untuk melihat jadwal Posyandu.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
