import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/anak_controller.dart';
import 'package:flutter/services.dart';

class AnakView extends GetView<AnakController> {
  const AnakView({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Updated color scheme with primary color 0xFF2D7D9A
    final primaryColor = Color(0xFF2D7D9A);
    final secondaryColor = Color(0xFF5AAFCA);
    final accentColor = Color(0xFFB5E1EE);
    final backgroundColor = Color(0xFFF5F9FF);
    final girlColor = Color(0xFFF48FB1);
    final boyColor = Color(0xFF81D4FA);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Data Anak',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => controller.refreshAnak(),
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh data',
          )
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerLoading(primaryColor);
        }

        if (controller.anakList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.child_care,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16),
                Text(
                  "Tidak ada data anak",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Silakan hubungi admin untuk menambahkan data anak",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return DefaultTabController(
          length: controller.anakList.length,
          child: Column(
            children: [
              // Decorative wave header
              Container(
                height: 30,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              
              // Tab indicator/header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "Pilih Anak",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              
              // Custom Tab Bar
              Container(
                height: 70,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: TabBar(
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: primaryColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.all(3),
                  labelPadding: EdgeInsets.symmetric(horizontal: 8),
                  indicator: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  tabs: controller.anakList.map((anak) {
                    // Determine gender-based color
                    final isGirl = anak.jenisKelamin?.toLowerCase() == 'perempuan';
                    final genderColor = isGirl ? girlColor : boyColor;
                    final genderIcon = isGirl ? Icons.face_3 : Icons.face_6;
                    
                    return Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              backgroundColor: genderColor.withOpacity(0.2),
                              child: Icon(
                                genderIcon,
                                color: genderColor,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              anak.namaAnak ?? 'Anak',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Tab Bar View
              Expanded(
                child: TabBarView(
                  children: controller.anakList.map((anak) {
                    // Determine gender-based color
                    final isGirl = anak.jenisKelamin?.toLowerCase() == 'perempuan';
                    final genderColor = isGirl ? girlColor : boyColor;
                    final genderGradient = isGirl 
                      ? [Color(0xFFF8BBD0), Color(0xFFF48FB1)]
                      : [Color(0xFFB3E5FC), Color(0xFF81D4FA)];
                    
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Profile Card
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 4,
                            shadowColor: Colors.black26,
                            child: Column(
                              children: [
                                // Header with name & avatar
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: genderGradient,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          isGirl ? Icons.face_3 : Icons.face_6,
                                          size: 40,
                                          color: genderColor,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              anak.namaAnak ?? 'Nama Anak',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black12,
                                                    blurRadius: 2,
                                                    offset: Offset(1, 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              anak.jenisKelamin ?? '-',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.9),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Basic Info
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      _buildInfoItem(
                                        icon: Icons.badge_outlined,
                                        label: 'NIK',
                                        value: anak.nikAnak ?? '-',
                                        color: primaryColor,
                                      ),
                                      _buildInfoItem(
                                        icon: Icons.cake_outlined,
                                        label: 'Tanggal Lahir',
                                        value: anak.tanggalLahir ?? '-',
                                        color: primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 16),
                          
                          // Growth Card
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 4,
                            shadowColor: Colors.black26,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.monitor_weight_outlined,
                                        color: primaryColor,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Pertumbuhan",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                Divider(height: 1),
                                
                                // Growth metrics displayed as cards
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildGrowthCard(
                                              icon: Icons.fitness_center,
                                              title: "Berat Badan",
                                              value: "${anak.beratBadan ?? '-'} kg",
                                              color: primaryColor,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: _buildGrowthCard(
                                              icon: Icons.height,
                                              title: "Tinggi Badan",
                                              value: "${anak.tinggiBadan ?? '-'} cm",
                                              color: secondaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildGrowthCard(
                                              icon: Icons.face,
                                              title: "Lingkar Kepala",
                                              value: "${anak.lingkarKepala ?? '-'} cm",
                                              color: accentColor,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: _buildGrowthCard(
                                              icon: Icons.accessibility_new,
                                              title: "Lingkar Lengan",
                                              value: "${anak.lingkarLengan ?? '-'} cm",
                                              color: genderColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 16),
                          
                          // Update button
                          ElevatedButton.icon(
                            onPressed: () {
                              // Implement update action
                              Get.snackbar(
                                'Info',
                                'Fitur update data belum tersedia',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: primaryColor,
                                colorText: Colors.white,
                              );
                            },
                            icon: Icon(Icons.edit),
                            label: Text('Perbarui Data'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 3,
                            ),
                          ),
                          
                          SizedBox(height: 20),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }),
      // Floating action button has been removed as requested
    );
  }
  
  // Shimmer loading widget
  Widget _buildShimmerLoading(Color primaryColor) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Decorative wave header
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          
          // Tab indicator/header shimmer
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          
          // Tab bar shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 12),
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          // Profile card shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Growth card shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Button shimmer
          Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 160,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildGrowthCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color.withAlpha(220),
            ),
          ),
        ],
      ),
    );
  }
}