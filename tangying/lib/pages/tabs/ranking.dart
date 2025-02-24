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
  ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _list = [];
  int _index = 0;
  int _total = 0;
  int _page = 1;
  //bool isLoading = false;
  bool isLoadingMore = false; // 添加标志位

  @override
  void initState() {
    super.initState();
    this._getData(1);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 20 &&
          !isLoadingMore) { // 添加判断标志位的条件
        print('滑动到了最底部');
        _getData(2);
      }
    });
  }

  _getData(where) async {
    print("where");
    print(where);

    print("_total");
    print(_total);
    print("_index");
    print(_index);
    // 是下拉请求 并且 当前条数 = 总条数 - 1
    if (where == 2 && _index == _total - 1) {
      print("数据全部加载完毕");
      // 已经都加载完毕了，不做任何请求
    } else {
      isLoadingMore = true; // 开始加载时设置标志位为 true
      var response = await apiService.postRequest(
          '/user/list', {'page': _page});
      // print('Response: $response');
      if (response['code'] == 1) {
        dynamic result = response['data']['list'];
        // 总条数
        _total = response['data']['total'];

        print('result type: ${result.runtimeType}');
        setState(() {
          List<Map<String, dynamic>> newList =
          (result as List)
              .asMap()
              .entries
              .map((entry) {
            // print(entry);
            int index = entry.key;
            _index++;
            print(index);
            Map<String, dynamic> item = entry.value;
            return {
              'rank': _index,
              'avatar': item['avatar'],
              'nickname': item['nickname'],
              'score': item['score'],
            };
          }).toList();
          _list.addAll(newList);
          _page++;
        });
      }
      isLoadingMore = false; // 加载完成后设置标志位为 false
    }
  }

  // 当没有数据时候
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

  // 上拉显示效果，仅仅为了好看
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
        preferredSize: Size.fromHeight(120.0),
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
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: () {
                        print('去分享被点击');
                      },
                      child: const Text(
                        "去分享",
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "点击去分享，分享人提现\n",
                  style: TextStyle(fontSize: 16),
                ),
                TextSpan(
                  text: "您将得到",
                  style: TextStyle(fontSize: 16),
                ),
                TextSpan(
                  text: "10%",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "的分润哦！",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
      body: this._list.length > 0
          ? RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: this._list.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            Map<String, dynamic> item = _list[index];
            return Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.zero,
                    child: switch (item['rank']) {
                      1 => const Icon(Icons.star, color: Colors.yellow), // 模拟金牌
                      2 => const Icon(Icons.star_half, color: Colors.grey), // 模拟银牌
                      3 => const Icon(Icons.star_border, color: Colors.brown), // 模拟铜牌
                      _ => Text('${item['rank']}'),
                    },
                  ),
                  title: Row(
                    children: [
                      item['avatar']!= null &&
                          item['avatar'].startsWith('http')
                          ? CircleAvatar(
                        backgroundImage:
                        NetworkImage(item['avatar']),
                      )
                          : const CircleAvatar(
                        backgroundImage:
                        AssetImage('images/people/default_people.jpg'),
                      ),
                      const SizedBox(width: 4),
                      Text(item['nickname']),
                    ],
                  ),
                  trailing: Text('积分: ${item['score']}'),
                ),
                const Divider(),
              ],
            );
          },
        ),
      )
          : _getMoreWidget(),
    );
  }
}