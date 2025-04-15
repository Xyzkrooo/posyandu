import 'package:get/get.dart';

import '../modules/anak/bindings/anak_binding.dart';
import '../modules/anak/views/anak_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/imunisasi/bindings/imunisasi_binding.dart';
import '../modules/imunisasi/views/imunisasi_view.dart';
import '../modules/jadwal/bindings/jadwal_binding.dart';
import '../modules/jadwal/views/jadwal_view.dart';
import '../modules/layanan/bindings/layanan_binding.dart';
import '../modules/layanan/views/layanan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/riwayat_pemeriksaan/bindings/riwayat_pemeriksaan_binding.dart';
import '../modules/riwayat_pemeriksaan/views/riwayat_pemeriksaan_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT_PEMERIKSAAN,
      page: () => const RiwayatPemeriksaanView(),
      binding: RiwayatPemeriksaanBinding(),
    ),
    GetPage(
      name: _Paths.JADWAL,
      page: () => const JadwalView(),
      binding: JadwalBinding(),
    ),
    GetPage(
      name: _Paths.IMUNISASI,
      page: () => const ImunisasiView(),
      binding: ImunisasiBinding(),
    ),
    GetPage(
      name: _Paths.ANAK,
      page: () => const AnakView(),
      binding: AnakBinding(),
    ),
    GetPage(
      name: _Paths.LAYANAN,
      page: () => const LayananView(),
      binding: LayananBinding(),
    ),
  ];
}
