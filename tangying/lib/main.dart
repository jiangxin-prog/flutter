import 'package:flutter/material.dart';
import './routers/routers.dart';
import 'package:get/get.dart';
import './binding/binding.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // 初始化
  // 检查用户登录状态
  bool isLoggedIn = await checkUserLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, //去除右上角debug图
      title: 'Flutter Demo',
      initialBinding: AllControllerBinding(), //全局绑定GetController
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //设置全局页面标题居中显示
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      //home: Tabs(),
      //初始化路由
      initialRoute: '/', // 设置初始路由
      //加载路由
      // onGenerateRoute: onGenerateRoute,
      defaultTransition: Transition.rightToLeft, //可以设置全部默认ios效果（还有其他效果点一下自己试试）
      getPages: AppPage.routes,
    );
  }
}

Future<bool> checkUserLoggedIn() async {
  // 这里实现你的登录检查逻辑，比如检查 token 是否存在
  // 这只是一个示例，具体实现取决于你的应用逻辑
  var userinfo = await Hive.openBox('userinfo');

  String? token = userinfo.get('token');
  print(token);
  if (token == null) {
    return false; // 用户未登录
  } else {
    return true; // 用户已经登录
  }
}
