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
                    child: Image.asset('assets/logo.png'),
                  ),
                  title: const Text(
                    "POSYANDU",
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    Obx(() {
                      final user = controller.profileResponse.value?.user;
                      final avatarUrl = (user?.foto != null &&
                              user!.foto!.isNotEmpty)
                          ? user.foto!
                          : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user?.nama ?? 'User')}&background=random';

                      return PopupMenuButton<String>(
                        icon: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                        onSelected: (value) {
                          if (value == 'profile') {
                            Get.toNamed('/profile');
                          } else if (value == 'logout') {
                            controller.logOut();
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                              value: 'profile', child: Text('Profil')),
                          PopupMenuItem(value: 'logout', child: Text('Logout')),
                        ],
                      );
                    }),
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
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.selectedIndex.value,
            onTap: (index) {
              controller.changeIndex(index);
              Get.nestedKey(1)!.currentState!.pushReplacement(
                    MaterialPageRoute(builder: (_) => controller.pages[index]),
                  );
            },
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: _navItem(Icons.home, 0, controller),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: _navItem(Icons.article, 1, controller),
                label: 'Artikel',
              ),
              BottomNavigationBarItem(
                icon: _navItem(Icons.help_outline, 2, controller),
                label: 'FAQ',
              ),
              BottomNavigationBarItem(
                icon: _navItem(Icons.support_agent, 3, controller),
                label: 'CS',
              ),
            ],
          ),
        ));
  }

  Widget _navItem(IconData icon, int index, DashboardController controller) {
    final isSelected = controller.selectedIndex.value == index;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.grey,
      ),
    );
  }
}
