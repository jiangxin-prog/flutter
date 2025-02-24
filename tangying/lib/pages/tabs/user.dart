import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../common/request.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../user/userAgree.dart';
import 'package:get/get.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ApiService apiService = ApiService();
  String avatarUrl = ''; // 存储头像 URL
  String username = ''; // 存储用户名
  String score = '00'; // 存储分数
  String money = '00'; // 存储金额

  // ignore: prefer_typing_uninitialized_variables

  Future<void> _loadUserInfo() async {
    try {
      var userinfo = await Hive.openBox('userinfo');
      setState(() {
        username = userinfo.get('username', defaultValue: '默认用户名');

        var base64Svg = userinfo.get('avatar',
            defaultValue: "https://www.itying.com/images/flutter/1.png");
        avatarUrl = (base64Svg != null && base64Svg.isNotEmpty)
            ? utf8.decode(base64.decode(base64Svg.split(',')[1]))
            : "https://www.itying.com/images/flutter/1.png"; // 默认图片
      });
    } catch (e) {
      print('请求 _loadUserInfo          出错：$e');
    }
  }

  Future<void> _loadCoinsAmounts() async {
    try {
      var response = await apiService.getRequest('/user/scoreAndMoney');
      print('Response: $response'); // 处理返回的数据

      if (response['code'] == 1) {
        var scoreAndMoneyInfo = response['data']['scoreAndMoneyInfo'];
        setState(() {
          score = scoreAndMoneyInfo['score'].toString(); // 假设 score 是字段名
          money = scoreAndMoneyInfo['money'].toString(); // 假设 money 是字段名
          print('Score: $score, Money: $money');
        });
      } else {
        print('请求 scoreAndMoney 失败，响应码：${response['code']}');
      }
    } catch (e) {
      print('请求 scoreAndMoney 出错：$e');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.wait([_loadCoinsAmounts(), _loadUserInfo()]).then((_) {
      setState(() {
        print('异步操作完成，更新状态');
      });
    });
  }

  Future<bool> _alertDialog(String message) async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示信息"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("确认"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("取消"),
            ),
          ],
        );
      },
    );
    print(result);
    // ignore: void_checks
    return result;
  }

  //注销用户
  void destroy() async {
    if (await _alertDialog("您确认要注销吗?")) {
      //   print("注销成功!");
      var userinfo = await Hive.openBox('userinfo');
      String? token = userinfo.get('token');
      print(token);
      var response =
          await apiService.postRequest('/user/destroy', {'token': token});
      print('Response: $response'); // 处理返回的数据
      // 清除用户数据
      await userinfo.clear(); // 清除用户数据
      Navigator.pushNamed(context, "/login");
    }
  }

  //退出登录
  void loginOut() async {
    if (await _alertDialog("您确认要退出吗?")) {
      print("退出成功!");

      // 清除用户数据
      var userinfo = await Hive.openBox('userinfo');
      await userinfo.clear(); // 清除用户数据
      Navigator.pushNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Score in build: $score, Money in build: $money');
    return Container(
      color: Colors.grey[200], // 设置背景色
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // 包裹在 Container 中以添加背景颜色
          Container(
            // decoration: BoxDecoration(
            //   color: const Color.fromARGB(255, 132, 192, 218), // 设置背景颜色为蓝灰色
            // ),
            height: 120, // 设置高度
            padding: const EdgeInsets.only(left: 20), // 设置左边距
            // alignment: Alignment.centerLeft, // 内容左对齐
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://www.itying.com/images/flutter/2.png",
                ),
                fit: BoxFit.cover, // 设置图片填充方式为铺满
              ),
            ),

            child: Row(
              //          mainAxisAlignment: MainAxisAlignment.start, // 主要轴方向的对齐
              crossAxisAlignment: CrossAxisAlignment.center, // 交叉轴方向的对齐
              children: <Widget>[
                ClipOval(
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: avatarUrl.isNotEmpty
                        ? SvgPicture.string(avatarUrl, fit: BoxFit.cover)
                        : Image.network(
                            "https://www.itying.com/images/flutter/1.png",
                            fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Text(
                        username,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text("微信名: $username", style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Card(
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            elevation: 20, // 设置卡片的海拔
            // margin: const EdgeInsets.all(10),
            // child: Column(
            //   children: [
            //     ListTile(
            //       title: const Text("张三"),
            //       subtitle: const Text("一步一脚印"),
            //     ),
            //   ],
            // ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 左侧：金币
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 28,
                      color: Colors.yellow[800],
                    ), // 金币图标
                    const SizedBox(width: 8),
                    const Text(
                      '金币',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      score,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                // 右侧：钱包
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 28,
                      color: Colors.green,
                    ), // 钱包图标
                    SizedBox(width: 8),
                    Text(
                      '钱包',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4),
                    Text(
                      money,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(
              Icons.photo_album,
              color: Colors.amber,
            ),
            title: Text("招募海报"),
            trailing: Icon(Icons.chevron_right_sharp),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(
              Icons.add_to_home_screen,
              color: Colors.green,
            ),
            title: Text("分享微信好友"),
            trailing: Icon(Icons.chevron_right_sharp),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(
              Icons.camera,
              color: Colors.green,
            ),
            title: Text("分享朋友圈"),
            trailing: Icon(Icons.chevron_right_sharp),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(
              Icons.group_add,
              color: Colors.amber,
            ),
            title: Text("我的团员"),
            trailing: Icon(Icons.chevron_right_sharp),
          ),
          const Divider(), //就是一根线
          const ListTile(
            leading: Icon(
              Icons.people,
              color: Colors.lightGreen,
            ),
            title: Text("在线客服"),
            trailing: Icon(Icons.chevron_right_sharp),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.library_books,
              color: Colors.blue,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    //Navigator.of(context).pushReplacementNamed("/userAgree");
                    //Get.toNamed("/userAgree");
                    Navigator.pushNamed(context, '/userAgree');
                  },
                  child: const Text("用户协议"),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right_sharp),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.admin_panel_settings,
              color: Colors.blue,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/privacyPolicy');
                  },
                  child: const Text("隐私政策"),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right_sharp),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.restore_from_trash,
              color: Colors.red,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: destroy,
                  child: const Text("账号注销"),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right_sharp),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.settings_power,
              color: Color.fromARGB(255, 245, 127, 23),
            ),
            //title: Text("退出登录"),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: loginOut,
                  child: const Text("退出登录"),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right_sharp),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
