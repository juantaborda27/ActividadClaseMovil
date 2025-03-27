import 'package:app_clase_juan/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TAREA APP JUANCHO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)
      ),
      initialRoute: '/',
      getPages: AppPages.routes,
    );
  }
}