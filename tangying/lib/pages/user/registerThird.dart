import 'package:flutter/material.dart';
import '../tabs.dart';
import 'package:get/get.dart';

class RegisterThirdPage extends StatefulWidget {
  const RegisterThirdPage({super.key});

  @override
  State<RegisterThirdPage> createState() => _RegisterThirdPageState();
}

class _RegisterThirdPageState extends State<RegisterThirdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("注册第三步"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("注册第三步"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                //返回到跟组件页面
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (BuildContext context) {
                //   return Tabs();
                // }), (route) => false);
                Get.offAll(Tabs(index: 4));
              },
              child: const Text("完成注册"),
            )
          ],
        ),
      ),
    );
  }
}
