import 'package:daraz_clone/feature/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/splash';

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      transition: Transition.leftToRight,
    ),
  ];
}
