import 'package:flutter/material.dart';
import './tabs/home.dart';
import './tabs/history.dart';
import './tabs/user.dart';
import './tabs/ranking.dart';
import '../../common/request.dart';

class Tabs extends StatefulWidget {
  final int index;
  Tabs({super.key, this.index = 0});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  //默认开始加载哪个页面
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  // ignore: unused_field
  final List<Widget> _pages = [
    HomePage(),
    HistoryPage(),
    RankingPage(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1, //阴影调整
        backgroundColor: Colors.red,
        title: const Text("Flutter App"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: UserAccountsDrawerHeader(
                    accountName: const Text("李四"),
                    accountEmail: const Text("xxxqq.com"),
                    //otherAccountsPictures加载其他图片
                    otherAccountsPictures: [
                      Image.network(
                          "https://www.itying.com/images/flutter/1.png"),
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://www.itying.com/images/flutter/2.png"),
                      ),
                      Image.network(
                          "https://www.itying.com/images/flutter/3.png"),
                    ],
                    //用户头像
                    currentAccountPicture: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://www.itying.com/images/flutter/3.png"),
                    ),
                    //背景图片
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://www.itying.com/images/flutter/2.png",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const ListTile(
              //leading: Icon(Icons.people), 显示图标
              //CircleAvatar让图标显示圆形
              leading: CircleAvatar(
                child: Icon(Icons.people),
              ),
              title: Text("个人中心"),
            ),
            const Divider(),
            const ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.settings),
              ),
              title: Text("系统设置"),
            ),
            Divider(),
          ],
        ),
      ),
      endDrawer: const Drawer(
        child: Text("右侧侧边栏"),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.red, //选中颜色
        iconSize: 35, //配置底部菜单大小
        //点击菜单设置选中哪一个
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, //底部有4个或4个以上的菜单需要配置这个
        //点击菜单触发方法
        onTap: (index) {
          //注意 setState（这参数是没有的）
          setState(() {
            _currentIndex = index;
          } as VoidCallback);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "首页",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "历史",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "排行",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "我的",
          ),
        ],
      ),

      //配置图标位置调整
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
