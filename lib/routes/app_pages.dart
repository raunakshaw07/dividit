import 'package:dividit/components/home/user_info.dart';
import 'package:dividit/pages/home_page.dart';
import 'package:dividit/pages/login.dart';
import 'package:dividit/pages/sign_up.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.login, page: () => Login()),
    GetPage(name: AppRoutes.signUp, page: () => SignUp()),
    GetPage(name: AppRoutes.userInfo, page: () => UserInfo()),
    GetPage(name: AppRoutes.home, page: () => HomePage()),
  ];
}
