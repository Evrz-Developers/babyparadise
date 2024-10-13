import 'package:get/get.dart';

class UserController extends GetxController {
  bool isLoggedIn = false;
  String userRole = '';
  String userId = '';
  String userName = '';
  String userEmail = '';

  void setUserDetails(
      {bool? isLoggedIn,
      String? role,
      String? id,
      String? name,
      String? email}) {
    this.isLoggedIn = isLoggedIn ?? false;
    userId = id ?? '';
    userRole = role ?? '';
    userName = name ?? '';
    userEmail = email ?? '';
    update();
  }

  static UserController get to => Get.find();
}
