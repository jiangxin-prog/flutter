import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../tabs.dart';
import 'package:get/get.dart';
import '../../common/request.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Dialog {
  static void showAutoDismissSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3), // 设置显示时长
      behavior: SnackBarBehavior.floating, // 使SnackBar浮动
      margin: const EdgeInsets.fromLTRB(10, 50, 10, 0), // 设置顶部边距
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService apiService = ApiService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void postData() async {
    // 显示加载指示器
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      print(usernameController.text);
      print(passwordController.text);
      var response = await apiService.postRequest('/user/login', {
        'account': usernameController.text,
        'password': passwordController.text,
      });
      print('Response: $response'); // 处理返回的数据

      if (response['code'] == 1) {
        // 登录成功
        var userInfo = response['data']['userinfo'];

        //用户信息存到本地
        var box = await Hive.openBox('userinfo');
        box.put('id', userInfo['id']);
        box.put('username', userInfo['username']);
        box.put('nickname', userInfo['nickname']);
        box.put('mobile', userInfo['mobile']);
        box.put('avatar', userInfo['avatar']);
        box.put('score', userInfo['score']);
        box.put('token', userInfo['token']);
        box.put('user_id', userInfo['user_id']);
        box.put('createtime', userInfo['createtime']);
        box.put('expiretime', userInfo['expiretime']);
        box.put('expires_in', userInfo['expires_in']);
        //去首页
        Navigator.of(context).pop(); // 关闭加载指示器

        //Get.offNamedUntil('/tabs', (route) => false); // 移除所有路由
        // Get.toNamed('/tabs', arguments: {'index': 1});

        //GetPage(name: '/tabs', page: () => Tabs(index: 1));
        //Get.toNamed("/registerSecond");
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => Tabs(index: 2)),
        // );

        //GetPage(name: '/', page: () => Tabs(index: 1));
        // //命名路由跳转
        // Navigator.pushNamed(context, "/registerThird");
        // //替换路由跳转
        Navigator.of(context).pushReplacementNamed("/");
        //Get.offNamed('/tabs', arguments: {'index': 1});
        // 这里可以继续处理登录成功后的逻辑
      } else {
        // 显示错误信息
        Get.snackbar("", "用户名或密码错误!");
        //Dialog.showAutoDismissSnackBar(context, "用户名或密码错误!");
      }
    } catch (e) {
      print('Error: $e');
      Dialog.showAutoDismissSnackBar(context, "服务请求失败!");
    } finally {
      Navigator.of(context).pop(); // 关闭加载指示器
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '欢迎回来',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: '用户名',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '密码',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  postData(); // 调用 postData 方法
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                ),
                child: const Text('登录'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 微信登录逻辑
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child: const Text('使用微信登录'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.toNamed("/registerSecond");
                },
                child: const Text('没有账号？注册'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
