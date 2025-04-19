import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/jadwal_controller.dart';
import 'package:intl/intl.dart';

class JadwalView extends GetView<JadwalController> {
  const JadwalView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Updated primary color to 0xFF0F66CD
    final primaryColor = Color(0xFF0F66CD);
    final secondaryColor = Color(0xFF4485D9);
    final accentColor = Color(0xFF68A9F0);
    final backgroundColor = Color(0xFFF6FAFF);
    final cardColor = Color(0xFFE6F0FA);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Jadwal Posyandu",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => controller.refreshJadwal(),
            tooltip: 'Refresh jadwal',
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerLoading(primaryColor);
        }

        return Column(
          children: [
            // Calendar Header with Date Range Selector
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Date display
                  Obx(() => Text(
                        DateFormat('MMMM yyyy')
                            .format(controller.selectedDate.value),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )),
                  SizedBox(height: 12),

                  // Filter buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2030),
                              initialDateRange: DateTimeRange(
                                start: DateTime.now()
                                    .subtract(const Duration(days: 7)),
                                end: DateTime.now(),
                              ),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: primaryColor,
                                      onPrimary: Colors.white,
                                      surface: Colors.white,
                                      onSurface: Colors.black87,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              controller.filterByDateRange(
                                  picked.start, picked.end);
                            }
                          },
                          icon: const Icon(Icons.filter_alt, size: 18),
                          label: const Text("Filter Tanggal"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryColor,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      if (controller.filteredList.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            controller.filteredList.clear();
                          },
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text("Hapus Filter"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: Colors.redAccent,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),

            // Calendar
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: controller.selectedDate.value,
                  selectedDayPredicate: (day) =>
                      isSameDay(controller.selectedDate.value, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    controller.selectedDate.value = selectedDay;
                    // Add haptic feedback
                    HapticFeedback.lightImpact();
                  },
                  eventLoader: (day) {
                    return controller.jadwalList.where((item) {
                      final itemDate =
                          DateTime.tryParse(item.tanggalKegiatan ?? '');
                      if (itemDate == null) return false;
                      return isSameDay(itemDate, day);
                    }).toList();
                  },
                  headerVisible: false, // We have a custom header
                  daysOfWeekHeight: 40,
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    todayDecoration: BoxDecoration(
                      color: accentColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    weekendTextStyle: TextStyle(color: Colors.redAccent),
                    outsideTextStyle:
                        TextStyle(color: Colors.grey.withOpacity(0.5)),
                    markersMaxCount: 3,
                    markerDecoration: BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    markerSize: 6,
                    markersAlignment: Alignment.bottomCenter,
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return SizedBox();

                      return Positioned(
                        bottom: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            shape: BoxShape.circle,
                          ),
                          width: 8,
                          height: 8,
                        ),
                      );
                    },
                    dowBuilder: (context, day) {
                      final text = DateFormat.E().format(day);

                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: [DateTime.saturday, DateTime.sunday]
                                    .contains(day.weekday)
                                ? Colors.redAccent
                                : primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    decoration: BoxDecoration(
                      color: cardColor,
                    ),
                  ),
                ),
              ),
            ),

            // Selected date indicator
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Obx(() => Text(
                          "Kegiatan ${DateFormat('d MMMM yyyy').format(controller.selectedDate.value)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        )),
                  ),
                  Spacer(),
                  if (controller.filteredList.isNotEmpty)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange.shade300),
                      ),
                      child: Text(
                        "Mode Filter",
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Jadwal List
            Expanded(
              child: Obx(() {
                final list = controller.filteredList.isNotEmpty
                    ? controller.filteredList
                    : controller.jadwalHariIni;

                if (list.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy,
                          size: 100, color: Colors.grey.shade300),

                      const SizedBox(height: 16),
                      Text(
                        controller.filteredList.isNotEmpty
                            ? "Tidak ada kegiatan dalam rentang ini"
                            : "Tidak ada kegiatan di tanggal ini",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => controller.refreshJadwal(),
                        icon: Icon(Icons.refresh, color: primaryColor),
                        label: Text(
                          "Refresh Jadwal",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  );
                }

                return AnimatedList(
                  initialItemCount: list.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index, animation) {
                    final item = list[index];
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildJadwalCard(item, primaryColor, cardColor),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          // Scroll to today's date
          controller.selectedDate.value = DateTime.now();
        },
        child: Icon(Icons.today),
      ),
    );
  }

  // New shimmer loading effect
  Widget _buildShimmerLoading(Color primaryColor) {
    return Column(
      children: [
        // Shimmer header
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
        ),
        
        // Shimmer calendar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        
        // Shimmer date indicator
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 30,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        
        // Shimmer jadwal list
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJadwalCard(dynamic item, Color primaryColor, Color cardColor) {
    return Card(
      color: cardColor,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue.shade100),  // Changed from teal to blue to match new color theme
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.event_note, color: primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.namaKegiatan ?? '-',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildInfoItem(
                        icon: Icons.date_range,
                        label: "Tanggal",
                        value: item.tanggalKegiatan ?? '-',
                        color: primaryColor,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoItem(
                        icon: Icons.access_time,
                        label: "Waktu",
                        value: "${item.waktuMulai} - ${item.waktuSelesai}",
                        color: primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Deskripsi:",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.deskripsi ?? '-',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: color),
                SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}