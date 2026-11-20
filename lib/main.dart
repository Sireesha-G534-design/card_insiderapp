import 'package:card_insiderapp/Go_router/app_routing.dart';
import 'package:card_insiderapp/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final designSize = width < 600
            ? const Size(390, 844) // Mobile
            : width < 1024
            ? const Size(768, 1024) // Tablet
            : const Size(1440, 900); // Desktop / Web

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: router,
            );
          },
        );
      },
    );
  }
}
