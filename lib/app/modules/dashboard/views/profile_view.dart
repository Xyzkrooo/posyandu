import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends GetView {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://ui-avatars.com/api/?name=Petugas&background=random',
                ),
              ),
              const SizedBox(height: 16),

              // User Name
              const Text(
                'Petugas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Petugas Posyandu',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),

              // Profile Menu Items
              _buildProfileMenuItem(
                icon: Icons.person_outline,
                title: 'Edit Profil',
                onTap: () {},
              ),

              _buildProfileMenuItem(
                icon: Icons.settings_outlined,
                title: 'Pengaturan',
                onTap: () {},
              ),
              _buildProfileMenuItem(
                icon: Icons.help_outline,
                title: 'Bantuan',
                onTap: () {},
              ),
              const SizedBox(height: 32),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add logout logic here
                    Get.defaultDialog(
                      title: 'Logout',
                      middleText: 'Apakah anda yakin ingin keluar?',
                      textConfirm: 'Ya',
                      textCancel: 'Batal',
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        // Add logout action here
                        Get.offAllNamed('/login');
                      },
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }




  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Profil Saya'),
  //       centerTitle: true,
  //     ),
  //     body: Obx(() {
  //       final profile = controller.profileResponse.value?.user;

  //       if (profile == null) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       return SingleChildScrollView(
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             children: [
  //               // Avatar
  //               CircleAvatar(
  //                 radius: 50,
  //                 backgroundImage: NetworkImage(
  //                   'https://ui-avatars.com/api/?name=${profile.username ?? "User"}&background=random',
  //                 ),
  //               ),
  //               const SizedBox(height: 16),

  //               // Nama
  //               Text(
  //                 profile.nama ?? 'Nama tidak ditemukan',
  //                 style: const TextStyle(
  //                     fontSize: 24, fontWeight: FontWeight.bold),
  //               ),

  //               // Username
  //               Text(
  //                 profile.username ?? 'Username tidak ditemukan',
  //                 style: const TextStyle(fontSize: 16, color: Colors.grey),
  //               ),

  //               const SizedBox(height: 32),

  //               // Menu Items
  //               _buildProfileMenuItem(
  //                 icon: Icons.person_outline,
  //                 title: 'Edit Profil',
  //                 onTap: () {},
  //               ),
  //               _buildProfileMenuItem(
  //                 icon: Icons.settings_outlined,
  //                 title: 'Pengaturan',
  //                 onTap: () {},
  //               ),
  //               _buildProfileMenuItem(
  //                 icon: Icons.help_outline,
  //                 title: 'Bantuan',
  //                 onTap: () {},
  //               ),

  //               const SizedBox(height: 32),

  //               // Logout Button
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton.icon(
  //                   onPressed: () {
  //                     Get.defaultDialog(
  //                       title: 'Logout',
  //                       middleText: 'Apakah Anda yakin ingin keluar?',
  //                       textConfirm: 'Ya',
  //                       textCancel: 'Batal',
  //                       confirmTextColor: Colors.white,
  //                       onConfirm: () {
  //                         controller.logOut();
  //                       },
  //                     );
  //                   },
  //                   icon: const Icon(Icons.logout, color: Colors.red),
  //                   label: const Text(
  //                     'Logout',
  //                     style: TextStyle(fontSize: 16, color: Colors.red),
  //                   ),
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.red.shade50,
  //                     padding: const EdgeInsets.symmetric(vertical: 12),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     }),
  //   );
  // }

  // Widget _buildProfileMenuItem({
  //   required IconData icon,
  //   required String title,
  //   required VoidCallback onTap,
  // }) {
  //   return ListTile(
  //     leading: Icon(icon),
  //     title: Text(title),
  //     trailing: const Icon(Icons.chevron_right),
  //     onTap: onTap,
  //   );
  // }
}
