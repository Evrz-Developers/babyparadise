import 'package:get/get.dart';

class UserController extends GetxController {
  String userRole = '';
  String userId = '';
  String userName = '';
  String userEmail = '';

  void setUserDetails(
      {String? role, String? id, required String name, required String email}) {
    userId = id ?? '';
    userRole = role ?? '';
    userName = name;
    userEmail = email;
    update();
  }

  static UserController get to => Get.find();
}
