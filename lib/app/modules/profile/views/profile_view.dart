import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(), // atau Navigator.pop(context)
        ),
        title: const Text('Profil Saya'),
        centerTitle: true,
      ),
      body: Obx(() {
        final profile = controller.profileResponse.value?.user;

        if (profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final avatarUrl = (profile.foto != null && profile.foto!.isNotEmpty)
            ? profile.foto!
            : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(profile.nama ?? 'User')}&background=random';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Avatar + Nama
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.nama ?? 'Nama tidak tersedia',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.role?.capitalize ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Informasi Pengguna
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Pengguna',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Email', profile.email),
                      _buildInfoRow('No. Telp', profile.noTelp),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Menu Pengaturan
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildProfileMenuItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profil',
                      onTap: () {},
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Ubah Password',
                      onTap: () {},
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.help_outline,
                      title: 'Bantuan',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Logout',
                      middleText: 'Apakah Anda yakin ingin keluar?',
                      textConfirm: 'Ya',
                      textCancel: 'Batal',
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        controller.logOut();
                      },
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
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

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(':'),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(value ?? '-'),
          ),
        ],
      ),
    );
  }
}
