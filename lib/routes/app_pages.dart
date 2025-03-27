

import 'package:app_clase_juan/presentation/pages/tarea_list_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/',
      page: () => TareaListPage(),
    )
  ];
}