import 'package:flutter/material.dart';
import '../../tools/KeepAliveWrapper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        //PreferredSize 可以配置appBar的高度
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          elevation: 0.5, //阴影调整
          backgroundColor: Colors.white, //背景颜色
          title: SizedBox(
            //通过SizedBox 修改TabBar的高度
            height: 30,
            child: TabBar(
              isScrollable: true,
              indicatorColor: Colors.red, //上面选项卡底部指示器的颜色
              labelColor: Colors.red, //选中颜色
              unselectedLabelColor: Colors.black, //上面选显卡lable未选中颜色
              indicatorSize: TabBarIndicatorSize.label, //设置选中底部线跟文字（lable）等宽
              controller: _tabController,
              tabs: const [
                Tab(
                  child: Text("关注"),
                ),
                Tab(
                  child: Text("热门"),
                ),
                Tab(
                  child: Text("关注"),
                ),
                Tab(
                  child: Text("视频"),
                ),
                Tab(
                  child: Text("娱乐"),
                ),
                Tab(
                  child: Text("篮球"),
                ),
                Tab(
                  child: Text("电脑"),
                ),
                Tab(
                  child: Text("手机"),
                ),
              ],
            ),
          ),
          //centerTitle: true, //标题居中
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          //自定义缓存组件 （包裹在要缓存组件的外层就实现了）
          KeepAliveWrapper(
            keepAlive: true,
            child: ListView(
              children: const [
                ListTile(
                  title: Text("我是关注列表1"),
                ),
                ListTile(
                  title: Text("我是关注列表222"),
                ),
                ListTile(
                  title: Text("我是关注列表333"),
                ),
                ListTile(
                  title: Text("我是关注列表44"),
                ),
                ListTile(
                  title: Text("我是关注列表5551"),
                ),
                ListTile(
                  title: Text("我是关注列666表1"),
                ),
                ListTile(
                  title: Text("我是关注列777表1"),
                ),
                ListTile(
                  title: Text("我是关注列888表1"),
                ),
                ListTile(
                  title: Text("我是关注列999表1"),
                ),
                ListTile(
                  title: Text("1010101"),
                ),
                ListTile(
                  title: Text("我是关注列表122"),
                ),
                ListTile(
                  title: Text("444"),
                ),
                ListTile(
                  title: Text("555"),
                ),
                ListTile(
                  title: Text("我是关注列666表1"),
                ),
                ListTile(
                  title: Text("我是关注777列999表1"),
                ),
                ListTile(
                  title: Text("1010safdasfadf101"),
                ),
                ListTile(
                  title: Text("我是关注列888表122"),
                ),
              ],
            ),
          ),
          const Text("我是热门"),
          const Text("我是关注"),
          const Text("视频"),
          const Text("娱乐"),
          const Text("篮球"),
          const Text("我是电脑"),
          const Text("我是手机"),
        ],
      ),
    );
  }
}
