import 'package:flutter/material.dart';
import '../../common/request.dart';
import 'package:photo_view/photo_view_gallery.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final ApiService apiService = ApiService();
  ScrollController _scrollController = ScrollController(); //listview的控制器

  List _list = [];
  int _page = 1;
  bool isLoading = false; //是否正在加载数据

  @override
  void initState() {
    super.initState();
    this._getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 20) {
        print('滑动到了最底部');
        _getData();
      }
    });
  }

  _getData() async {
    var response = await apiService.postRequest('/user/list', {'page': _page});
    print('Response: $response');

    var result = response['data']['list'];

    print(result);
    setState(() {
      this._list.addAll(result);
      this._page++;
    });
  }

  /**
   * 加载更多时显示的组件,给用户提示
   */
  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '加载中...',
              style: TextStyle(fontSize: 16.0),
            ),
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    print('执行刷新');
    // this._getData();
    await Future.delayed(Duration(seconds: 3), () {
      print('refresh');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0), // 设置 AppBar 的高度
          child: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/beijing.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 16, // 调整按钮的垂直位置
                    right: 16, // 调整按钮的水平位置
                    child: IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        // 在这里添加按钮点击的处理逻辑
                        print('按钮被点击');
                      },
                    ),
                  ),
                ],
              ),
            ),
            title: Text("点击分享，分享人体现，您将得到10%的分润哦！"),
          ),
        ),
        body: this._list.length > 0
            ? RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                    itemCount: this._list.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      if (index == this._list.length - 1) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(this._list[index]["nickname"],
                                  maxLines: 1),
                              // onTap: () {
                              //   Navigator.pushNamed(context, '/newsContent');
                              // },
                            ),
                            Divider(),
                            _getMoreWidget()
                          ],
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(this._list[index]["nickname"],
                                  maxLines: 1),
                              // onTap: () {
                              //   Navigator.pushNamed(context, '/newsContent');
                              // },
                            ),
                            Divider()
                          ],
                        );
                      }
                    }))
            : _getMoreWidget());
  }
}

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset('assets/images/beijing.jpg',
              width: 50, height: 50), // 替换为你的北京图片路径
          SizedBox(width: 10),
          Text("请求数据 Dio Demo"),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            // 在这里添加按钮点击的处理逻辑
            print('按钮被点击');
          },
        ),
      ],
    );
  }
}
