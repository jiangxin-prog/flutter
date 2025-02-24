import 'package:get/get.dart';
import '../binding/binding.dart';
import '../middleware/TokenMiddleWare.dart';

import '../pages/tabs.dart';
import '../pages/user/login.dart';
import '../pages/user/userAgree.dart';
import '../pages/user/privacyPolicy.dart';

class AppPage {
  static final routes = [
    //首页
    GetPage(name: "/", page: () => Tabs()),
    //登录页面
    GetPage(
      name: "/login",
      page: () => LoginPage(),
    ),
    //用户协议页面
    GetPage(
      name: "/userAgree",
      page: () => UserAgreePage(),
      binding: AllControllerBinding(),
      middlewares: [
        TokenMiddleWare(),
      ],
    ),
    //隐私政策
    GetPage(
      name: "/privacyPolicy",
      page: () => PrivacyPolicyPage(),
      binding: AllControllerBinding(),
      middlewares: [
        TokenMiddleWare(),
      ],
    ),

    // GetPage(
    //   name: "/form",
    //   page: () => const FormPage(),
    //   //当有跳转到form时候会自动去binding实例化ShopControllerBinding
    //   binding: AllControllerBinding(),
    //   middlewares: [
    //     //这里面可以设置多个中间件
    //     TokenMiddleWare(),
    //   ],
    // ),
    // GetPage(
    //   name: "/search",
    //   binding: Search2ControllerBinding(),
    //   page: () => const SearchPage(),
    // ),
  ];
}
