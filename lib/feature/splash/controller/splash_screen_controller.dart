import 'package:daraz_clone/core/nav_bar/view/navbar_screen.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2));

    {
      Get.offAll(() => NavbarScreen());
    }
  }
}
