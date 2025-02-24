import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TokenMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    print(route);
    // 你有一个方法来检查用户是否已登录
    // bool isLoggedIn = checkUserLoggedIn() as bool;
    // // 如果用户未登录且当前路由不是登录页面，则重定向到登录页面
    // if (!isLoggedIn && route != "/login") {
    //   return const RouteSettings(name: "/login");
    // }
    //跳转到以前路由(没做任何操作)
    return null;
  }

  // Future<bool> checkUserLoggedIn() async {
  //   // 这里实现你的登录检查逻辑，比如检查 token 是否存在
  //   // 这只是一个示例，具体实现取决于你的应用逻辑
  //   var userinfo = await Hive.openBox('userinfo');

  //   String? token = userinfo.get('token');
  //   print(token);
  //   if (token == null) {
  //     return false; // 用户未登录
  //   } else {
  //     return true; // 用户已经登录
  //   }
  // }
}
