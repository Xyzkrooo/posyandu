import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Obx(() => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AppBar(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/logo_posyandu.jpeg'),
                  ),
                  title: const Text(
                    "POSYANDU",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  actions: [
                    Obx(() {
                      final user = controller.profileResponse.value?.user;
                      final avatarUrl = (user?.foto != null &&
                              user!.foto!.isNotEmpty)
                          ? user.foto!
                          : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user?.nama ?? 'User')}&background=random';

                      return PopupMenuButton<String>(
                        offset: const Offset(0, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        icon: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue.shade300,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage(avatarUrl),
                          ),
                        ),
                        onSelected: (value) {
                          if (value == 'profile') {
                            Get.toNamed('/profile');
                          } else if (value == 'logout') {
                            controller.logOut();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'profile',
                            child: Row(
                              children: [
                                Icon(Icons.person, color: Colors.blue.shade700),
                                const SizedBox(width: 12),
                                const Text('Profil'),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: Colors.red.shade700),
                                const SizedBox(width: 12),
                                const Text('Logout'),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
          body: Navigator(
            key: Get.nestedKey(1),
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) =>
                    controller.pages[controller.selectedIndex.value],
              );
            },
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_rounded, 'Beranda', 0, controller),
                _buildNavItem(Icons.help_outline_rounded, 'FAQ', 1, controller),
                _buildNavItem(Icons.support_agent_rounded, 'CS', 2, controller),
              ],
            ),
          ),
        ));
  }

  Widget _buildNavItem(IconData icon, String label, int index, DashboardController controller) {
    final isSelected = controller.selectedIndex.value == index;
    
    return GestureDetector(
      onTap: () {
        controller.changeIndex(index);
        Get.nestedKey(1)!.currentState!.pushReplacement(
          MaterialPageRoute(builder: (_) => controller.pages[index]),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12, 
          vertical: 8
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
              size: isSelected ? 26 : 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}