import 'package:get/get.dart';

class ProfileController extends GetxController {
  var userName = "Khukan Miah".obs;
  var userEmail = "khukannub99@gmail.com".obs;

  var profileImage = "https://i.pravatar.cc/150?img=3".obs;
  void updateName(String name) {
    userName.value = name;
  }
}
